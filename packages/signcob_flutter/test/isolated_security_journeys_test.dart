import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
// The generated login method returns this auth package's exception type.
// ignore: depend_on_referenced_packages
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    show EmailAccountLoginException, EmailAccountLoginExceptionReason;
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:signcob_client/signcob_client.dart';

import 'support/isolated_e2e_fixture.dart';

const _enabled = bool.fromEnvironment('SIGNCOB_ISOLATED_E2E');
const _dataJudUnavailable =
    'Não foi possível consultar o DataJud. Tente novamente.';

Matcher _httpStatus(int code) => isA<ServerpodClientException>().having(
  (error) => error.statusCode,
  'HTTP status',
  code,
);

Matcher _dataJudError(String message) => isA<DataJudException>().having(
  (error) => error.message,
  'message',
  message,
);

class _MemoryStorage implements ClientAuthSuccessStorage {
  AuthSuccess? value;
  @override
  Future<AuthSuccess?> get() async => value;
  @override
  Future<void> set(AuthSuccess? newValue) async => value = newValue;
}

void main() {
  group('HTTP isolado: autorização e DataJud controlado', () {
    late Map<String, dynamic> manifest;
    late Map<String, dynamic> users;
    late Client manager;
    final clients = <Client>[];
    HttpOverrides? previousOverrides;

    Future<Client> clientFor(String? role) async {
      final client = Client(manifest['apiUrl'] as String)
        ..authSessionManager = FlutterAuthSessionManager(
          storage: _MemoryStorage(),
        );
      clients.add(client);
      await client.auth.initialize();
      if (role != null) {
        final user = users[role] as Map<String, dynamic>;
        final auth = await client.emailIdp.login(
          email: user['email'] as String,
          password: user['password'] as String,
        );
        await client.auth.updateSignedInUser(auth);
      }
      return client;
    }

    String id(String role) => (users[role] as Map)['userId'] as String;
    String number(int suffix) => suffix.toString().padLeft(20, '0');

    // Do not let an unexpected successful login print its JWT in a matcher.
    Future<void> loginAttempt(
      Client client,
      String email,
      String password,
    ) async {
      await client.emailIdp.login(email: email, password: password);
    }

    final denied = anyOf(isA<AccessDeniedException>(), _httpStatus(403));

    Future<void> expectDenied(Future<Object?> Function() operation) async {
      await expectLater(operation(), throwsA(denied));
    }

    // The runner serializes the two files. A snapshot detects unexpected edits
    // as well as new rows, with all synthetic records fitting in a single page.
    Future<List<Object>> snapshot() async => [
      (await manager.contactAdmin.list(0)).map((row) => row.toJson()).toList(),
      (await manager.accessAdmin.list(0)).map((row) => row.toJson()).toList(),
      (await manager.legalClient.list(0)).map((row) => row.toJson()).toList(),
      (await manager.caseRecord.list(0)).map((row) => row.toJson()).toList(),
      (await manager.negotiation.list(
        0,
        'debt',
      )).map((row) => row.toJson()).toList(),
      (await manager.negotiation.list(
        0,
        'fees',
      )).map((row) => row.toJson()).toList(),
      (await manager.content.adminArticles(
        0,
      )).map((row) => row.toJson()).toList(),
      (await manager.content.adminPartners(
        0,
      )).map((row) => row.toJson()).toList(),
    ];

    List<Future<Object?> Function()> protectedOperations(
      Client client,
      int clientId,
      int caseId,
      int negotiationId,
    ) => [
      () => client.contactAdmin.list(0),
      () => client.accessAdmin.list(0),
      () => client.accessAdmin.setPermissions(id('lawyerB'), []),
      () => client.legalClient.list(0),
      () => client.legalClient.create('Não pode persistir', null, null, null),
      () => client.legalClient.update(
        clientId,
        'Não pode editar',
        null,
        null,
        null,
      ),
      () => client.legalClient.assign(clientId, id('lawyerB')),
      () => client.legalClient.bindOwner(clientId, id('owner')),
      () => client.caseRecord.list(0),
      // Use a successful transport response so a missing guard could write.
      () => client.caseRecord.importFromDataJud(clientId, 'tjpr', number(21)),
      () => client.caseRecord.sync(caseId),
      () => client.negotiation.list(0, 'debt'),
      () => client.negotiation.list(0, 'fees'),
      () => client.negotiation.create(clientId, 'debt', 'Não pode criar', 100),
      () => client.negotiation.transition(negotiationId, 'proposed', null),
      () => client.negotiation.history(negotiationId),
      () => client.content.adminArticles(0),
      () => client.content.adminPartners(0),
      () => client.content.saveArticle(
        null,
        'Não pode',
        'Resumo',
        'Texto',
        null,
        true,
      ),
      () => client.content.savePartner(
        null,
        'Não pode',
        'Texto',
        'https://example.invalid',
        true,
      ),
    ];

    setUpAll(() async {
      previousOverrides = HttpOverrides.current;
      HttpOverrides.global = null;
      manifest = loadIsolatedE2eFixture();
      users = manifest['users'] as Map<String, dynamic>;
      manager = await clientFor('manager');
    });

    tearDownAll(() async {
      try {
        await Future.wait(
          clients.map((client) async {
            try {
              if (client.auth.isAuthenticated) {
                await client.auth.signOutDevice();
              }
            } finally {
              client.close();
            }
          }),
        );
      } finally {
        HttpOverrides.global = previousOverrides;
      }
    });

    test('sessão anônima e credenciais inválidas não obtêm acesso', () async {
      final anonymous = await clientFor(null);
      await expectLater(
        anonymous.contactAdmin.list(0),
        throwsA(_httpStatus(401)),
      );
      await expectLater(
        loginAttempt(
          anonymous,
          (users['manager'] as Map)['email'] as String,
          'synthetic-incorrect-password',
        ),
        throwsA(
          isA<EmailAccountLoginException>().having(
            (error) => error.reason,
            'reason',
            EmailAccountLoginExceptionReason.invalidCredentials,
          ),
        ),
      );
      expect(anonymous.auth.isAuthenticated, isFalse);
      final blocked = users['blocked'] as Map<String, dynamic>;
      await expectLater(
        loginAttempt(
          anonymous,
          blocked['email'] as String,
          blocked['password'] as String,
        ),
        throwsA(isA<AuthUserBlockedException>()),
      );
      expect(anonymous.auth.isAuthenticated, isFalse);
    });

    test(
      'atribuição e vínculo delimitam clientes, negociações e processos',
      () async {
        final a = await clientFor('lawyerA');
        final b = await clientFor('lawyerB');
        final owner = await clientFor('owner');
        final row = await a.legalClient.create(
          'E2E atribuição jurídica',
          null,
          null,
          null,
        );
        final negotiation = await a.negotiation.create(
          row.id!,
          'debt',
          'Dívida privada E2E',
          12345,
        );
        final record = await a.caseRecord.importFromDataJud(
          row.id!,
          'trf4',
          number(1),
        );
        expect(
          (await a.legalClient.list(0)).any((c) => c.id == row.id),
          isTrue,
        );
        expect(
          (await b.legalClient.list(0)).any((c) => c.id == row.id),
          isFalse,
        );
        expect(
          (await b.caseRecord.list(0)).any((c) => c.id == record.id),
          isFalse,
        );
        expect(
          (await b.negotiation.list(
            0,
            'debt',
          )).any((n) => n.id == negotiation.id),
          isFalse,
        );
        final before = await snapshot();
        await expectDenied(
          () => b.legalClient.update(row.id!, 'Invasão', null, null, null),
        );
        await expectDenied(() => b.caseRecord.sync(record.id!));
        await expectDenied(() => b.negotiation.history(negotiation.id!));
        await expectDenied(
          () => b.negotiation.transition(negotiation.id!, 'proposed', null),
        );
        await expectDenied(
          () => b.negotiation.create(row.id!, 'fees', 'Invasão', 100),
        );
        await expectDenied(() => b.legalClient.assign(row.id!, id('lawyerB')));
        expect(await snapshot(), before);
        expect(
          (await owner.caseRecord.list(0)).any((c) => c.id == record.id),
          isFalse,
        );
        await manager.legalClient.bindOwner(row.id!, id('owner'));
        expect(
          (await owner.caseRecord.list(0)).any((c) => c.id == record.id),
          isTrue,
        );
        await expectDenied(() => owner.caseRecord.sync(record.id!));
        await expectDenied(() => owner.legalClient.list(0));
        await expectDenied(() => owner.negotiation.list(0, 'debt'));
        await manager.legalClient.bindOwner(row.id!, null);
        expect(
          (await owner.caseRecord.list(0)).any((c) => c.id == record.id),
          isFalse,
        );
        await manager.legalClient.assign(row.id!, id('lawyerB'));
        expect(
          (await a.legalClient.list(0)).any((c) => c.id == row.id),
          isFalse,
        );
        await expectDenied(() => a.negotiation.history(negotiation.id!));
        expect(
          (await b.legalClient.list(0)).singleWhere((c) => c.id == row.id).name,
          row.name,
        );
        expect((await b.negotiation.history(negotiation.id!)).length, 1);
        expect(
          (await b.caseRecord.list(0)).any((c) => c.id == record.id),
          isTrue,
        );
      },
    );

    test(
      'DataJud controlado importa, sincroniza e preserva dados após falha',
      () async {
        final row = await manager.legalClient.create(
          'E2E processo controlado',
          null,
          null,
          null,
        );
        final record = await manager.caseRecord.importFromDataJud(
          row.id!,
          'tjpr',
          number(11),
        );
        expect(record.className, 'Classe sintética 1');
        expect(record.lastSyncedAt, isNotNull);
        final updated = await manager.caseRecord.sync(record.id!);
        expect(updated.className, 'Classe sintética 2');
        expect(updated.movementsJson, contains('Movimento sintético 2'));
        await expectLater(
          manager.caseRecord.sync(record.id!),
          throwsA(_dataJudError(_dataJudUnavailable)),
        );
        final failed = (await manager.caseRecord.list(
          0,
        )).singleWhere((c) => c.id == record.id);
        expect(failed.className, updated.className);
        expect(failed.movementsJson, updated.movementsJson);
        expect(failed.lastSyncedAt, updated.lastSyncedAt);
        expect(failed.syncError, _dataJudUnavailable);
        final before = await snapshot();
        const importFailures = {
          12: _dataJudUnavailable,
          13: 'Resposta inválida do DataJud.',
          14: 'Resposta do DataJud com tribunal inconsistente.',
          15: 'Processo não encontrado nos dados públicos do DataJud.',
        };
        for (final failure in importFailures.entries) {
          await expectLater(
            manager.caseRecord.importFromDataJud(
              row.id!,
              'tjpr',
              number(failure.key),
            ),
            throwsA(_dataJudError(failure.value)),
          );
        }
        expect(await snapshot(), before);
        final other = await manager.legalClient.create(
          'E2E vínculo incompatível',
          null,
          null,
          null,
        );
        await expectLater(
          manager.caseRecord.importFromDataJud(other.id!, 'tjpr', number(11)),
          throwsA(_dataJudError('Processo já vinculado a outro cadastro.')),
        );
        final recovered = await manager.caseRecord.sync(record.id!);
        expect(recovered.legalClientId, row.id);
        expect(recovered.className, 'Classe sintética 4');
        expect(recovered.syncError, isNull);
        final persisted = (await manager.caseRecord.list(
          0,
        )).singleWhere((c) => c.id == record.id);
        expect(persisted.toJson(), recovered.toJson());
      },
    );

    test(
      'validações HTTP rejeitam escritas inválidas sem mudar dados',
      () async {
        final row = await manager.legalClient.create(
          'E2E validação',
          null,
          null,
          null,
        );
        final negotiation = await manager.negotiation.create(
          row.id!,
          'fees',
          'Honorários válidos',
          55000,
        );
        final before = await snapshot();
        final history = await manager.negotiation.history(negotiation.id!);
        final anonymous = await clientFor(null);
        final invalid = <Future<Object?> Function()>[
          () => anonymous.contact.submit(
            'Contato inválido',
            'sem-email',
            'Mensagem',
          ),
          () => manager.legalClient.create(' ', null, null, null),
          () => manager.legalClient.update(
            row.id!,
            'Válido',
            'sem-email',
            null,
            null,
          ),
          () => manager.negotiation.create(row.id!, 'debt', 'Inválido', 0),
          () => manager.negotiation.create(row.id!, 'other', 'Inválido', 100),
          () =>
              manager.negotiation.transition(negotiation.id!, 'accepted', null),
          () => manager.content.saveArticle(
            null,
            '',
            'Resumo',
            'Texto',
            null,
            true,
          ),
          () => manager.content.saveArticle(
            null,
            'Inválido',
            'Resumo',
            '',
            null,
            true,
          ),
          () => manager.content.savePartner(
            null,
            'Inválido',
            'Texto',
            'javascript:alert(1)',
            true,
          ),
          () =>
              manager.caseRecord.importFromDataJud(row.id!, 'other', number(1)),
          () => manager.caseRecord.importFromDataJud(row.id!, 'tjpr', '123'),
          () => manager.accessAdmin.setPermissions(id('lawyerA'), ['unknown']),
          () => manager.legalClient.assign(row.id!, id('blocked')),
          () => manager.legalClient.bindOwner(row.id!, id('blocked')),
        ];
        for (final operation in invalid) {
          // Serverpod 3.2.3 maps the current endpoints' ArgumentErrors to 500.
          // Keep that wire behavior visible and verify the persisted snapshot.
          await expectLater(operation(), throwsA(_httpStatus(500)));
        }
        expect(await snapshot(), before);
        expect(
          (await manager.negotiation.history(
            negotiation.id!,
          )).map((e) => e.toJson()),
          history.map((e) => e.toJson()),
        );
      },
    );

    test(
      'sem escopos, revogado e bloqueado negam vinte operações com JWT real',
      () async {
        final row = await manager.legalClient.create(
          'E2E matriz de negação',
          null,
          null,
          null,
        );
        final record = await manager.caseRecord.importFromDataJud(
          row.id!,
          'trt9',
          number(1),
        );
        final negotiation = await manager.negotiation.create(
          row.id!,
          'debt',
          'Dívida matriz',
          1000,
        );
        final noScopes = await clientFor('noScopes');
        final revoked = await clientFor('revoked');
        // Successful reads prove the same session had access before revocation.
        await revoked.contactAdmin.list(0);
        expect(
          (await revoked.caseRecord.list(0)).any((c) => c.id == record.id),
          isTrue,
        );
        final priorToken = revoked.auth.authInfo?.token;
        expect(priorToken != null, isTrue);
        await manager.accessAdmin.setPermissions(id('revoked'), []);
        expect(
          (await manager.accessAdmin.list(
            0,
          )).singleWhere((user) => user.userId == id('revoked')).permissions,
          isEmpty,
        );
        final blocked = await clientFor(null);
        final blockedAuth = (users['blocked'] as Map)['authSuccess'];
        if (blockedAuth is! Map<String, dynamic>) {
          throw StateError(
            'Fixture bloqueada deve conter JWT emitido antes do bloqueio.',
          );
        }
        await blocked.auth.updateSignedInUser(
          AuthSuccess.fromJson(blockedAuth),
        );
        final before = await snapshot();
        final history = await manager.negotiation.history(negotiation.id!);
        final permissionDenied = isA<AccessDeniedException>().having(
          (error) => error.message,
          'message',
          'Acesso negado',
        );
        for (final (role, client) in [
          ('sem escopos', noScopes),
          ('revogado', revoked),
          ('bloqueado', blocked),
        ]) {
          final operations = protectedOperations(
            client,
            row.id!,
            record.id!,
            negotiation.id!,
          );
          expect(operations.length, 20);
          for (final (index, operation) in operations.indexed) {
            // The first three endpoints use Serverpod's requiredScopes. The
            // remaining operations must fail their own permission check.
            await expectLater(
              operation(),
              throwsA(
                client == noScopes && index < 3
                    ? _httpStatus(403)
                    : permissionDenied,
              ),
              reason: '$role, operação ${index + 1}',
            );
          }
        }
        // Compare the JWT without exposing it in matcher output.
        expect(revoked.auth.authInfo?.token == priorToken, isTrue);
        expect(await snapshot(), before);
        expect(
          (await manager.negotiation.history(
            negotiation.id!,
          )).map((e) => e.toJson()),
          history.map((e) => e.toJson()),
        );
      },
    );
  }, skip: !_enabled);
}
