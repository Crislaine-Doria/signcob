import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import '../access/current_permission.dart';
import '../generated/protocol.dart';
import 'datajud_client.dart';

class CaseRecordEndpoint extends Endpoint {
  CaseRecordEndpoint({DataJudClient? dataJudClient})
    : _dataJudClient = dataJudClient ?? DataJudClient();

  final DataJudClient _dataJudClient;

  @override
  bool get requireLogin => true;

  Future<void> _authorize(Session session, String scope) async {
    if (!(session.authenticated?.scopes.contains(Scope(scope)) ?? false)) {
      throw AccessDeniedException(message: 'Acesso negado');
    }
    await requireCurrentPermission(session, scope);
  }

  String _identity(Session session) => UuidValue.withValidation(
    session.authenticated!.userIdentifier,
  ).toString().toLowerCase();
  Future<bool> _manager(Session session) async {
    if (!session.authenticated!.scopes.contains(const Scope('users.manage'))) {
      return false;
    }
    final user = await AuthServices.instance.authUsers.get(
      session,
      authUserId: UuidValue.withValidation(_identity(session)),
    );
    return !user.blocked && user.scopes.contains(const Scope('users.manage'));
  }

  Future<LegalClient> _client(
    Session session,
    int id, {
    required bool write,
  }) async {
    final client = await LegalClient.db.findById(session, id);
    if (client == null) {
      throw AccessDeniedException(
        message: 'Processo indisponível para esta conta',
      );
    }
    if (!await _manager(session) &&
        client.assignedLawyerId != _identity(session) &&
        (write || client.ownerAuthUserId != _identity(session))) {
      throw AccessDeniedException(
        message: 'Processo indisponível para esta conta',
      );
    }
    return client;
  }

  Future<List<LegalCase>> list(Session session, int offset) async {
    await _authorize(session, 'cases.read');
    if (offset < 0) throw ArgumentError('Página inválida');
    final manager = await _manager(session);
    final clients = manager
        ? <LegalClient>[]
        : await LegalClient.db.find(
            session,
            where: (t) =>
                t.assignedLawyerId.equals(_identity(session)) |
                t.ownerAuthUserId.equals(_identity(session)),
          );
    if (!manager && clients.isEmpty) return [];
    return LegalCase.db.find(
      session,
      where: manager
          ? null
          : (t) => t.legalClientId.inSet(clients.map((c) => c.id!).toSet()),
      limit: 25,
      offset: offset,
      orderByList: (t) => [Order(column: t.number), Order(column: t.id)],
    );
  }

  Future<LegalCase> importFromDataJud(
    Session session,
    int clientId,
    String tribunal,
    String number,
  ) async {
    await _authorize(session, 'cases.read');
    await _authorize(session, 'cases.write');
    await _client(session, clientId, write: true);
    final normalized = DataJudClient.normalizeNumber(number);
    if (!DataJudClient.tribunals.contains(tribunal)) {
      throw ArgumentError('Tribunal não suportado');
    }
    final existing = await LegalCase.db.findFirstRow(
      session,
      where: (t) => t.tribunal.equals(tribunal) & t.number.equals(normalized),
    );
    if (existing != null) {
      await _client(session, existing.legalClientId, write: true);
      if (existing.legalClientId != clientId) {
        throw DataJudException(
          message: 'Processo já vinculado a outro cadastro.',
        );
      }
      return _sync(session, existing);
    }
    final source = await _dataJudClient.fetch(tribunal, normalized);
    return LegalCase.db.insertRow(
      session,
      _apply(
        LegalCase(
          legalClientId: clientId,
          number: normalized,
          tribunal: tribunal,
          movementsJson: '[]',
        ),
        source,
      ),
    );
  }

  Future<LegalCase> sync(Session session, int id) async {
    await _authorize(session, 'cases.read');
    await _authorize(session, 'cases.write');
    final existing = await LegalCase.db.findById(session, id);
    if (existing == null) {
      throw AccessDeniedException(
        message: 'Processo indisponível para esta conta',
      );
    }
    await _client(session, existing.legalClientId, write: true);
    return _sync(session, existing);
  }

  Future<LegalCase> _sync(Session session, LegalCase record) async {
    try {
      final source = await _dataJudClient.fetch(
        record.tribunal,
        record.number,
      );
      return await LegalCase.db.updateRow(session, _apply(record, source));
    } on DataJudException catch (error) {
      await LegalCase.db.updateRow(
        session,
        record.copyWith(syncError: error.message),
      );
      rethrow;
    }
  }

  LegalCase _apply(LegalCase record, Map<String, dynamic> source) {
    final movements =
        (source['movimentos'] as List? ?? [])
            .whereType<Map>()
            .map(
              (m) => {
                'code': m['codigo'],
                'name': m['nome']?.toString(),
                'date': m['dataHora']?.toString(),
              },
            )
            .toList()
          ..sort(
            (a, b) => (b['date']?.toString() ?? '').compareTo(
              a['date']?.toString() ?? '',
            ),
          );
    return record.copyWith(
      className: (source['classe'] as Map?)?['nome']?.toString(),
      courtName: (source['orgaoJulgador'] as Map?)?['nome']?.toString(),
      movementsJson: jsonEncode(movements),
      lastSyncedAt: DateTime.now().toUtc(),
      syncError: null,
    );
  }
}
