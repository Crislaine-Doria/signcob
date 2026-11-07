// ignore_for_file: experimental_member_use

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

class ChatEndpoint extends Endpoint {
  static const maxPageSize = 50;
  static const maxMessageLength = 4000;
  static const maxTitleLength = 120;
  static final _titleControls = RegExp(r'[\x00-\x1f\x7f]');
  static final _uuid = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
    caseSensitive: false,
  );
  static const _capabilities = <String>[
    'chat.partner',
    'chat.lawyer',
    'chat.support',
    'chat.client',
  ];

  @override
  bool get requireLogin => true;

  String _identity(Session session) => UuidValue.withValidation(
    session.authenticated!.userIdentifier,
  ).toString().toLowerCase();

  Never _deny() => throw AccessDeniedException(message: 'Chat indisponível');

  Future<AuthUserModel?> _account(
    Session session,
    String identity,
    Transaction transaction,
  ) async {
    try {
      return await AuthServices.instance.authUsers.get(
        session,
        authUserId: UuidValue.withValidation(identity),
        transaction: transaction,
      );
    } on AuthUserNotFoundException {
      return null;
    }
  }

  Future<Set<String>> _currentCapabilities(
    Session session,
    Transaction transaction,
  ) async {
    final authentication = session.authenticated!;
    final user = await _account(session, _identity(session), transaction);
    if (user == null || user.blocked) _deny();
    final token = authentication.scopes.map((scope) => scope.name).toSet();
    final current = user.scopes.map((scope) => scope.name).toSet();
    final granted = _capabilities
        .where(
          (capability) =>
              token.contains(capability) && current.contains(capability),
        )
        .toSet();
    if (granted.isEmpty) _deny();
    return granted;
  }

  void _validatePage(int offset, int limit) {
    if (offset < 0 || limit < 1 || limit > maxPageSize) {
      throw ArgumentError('Página inválida');
    }
  }

  bool _canCreateForAnyClient(Set<String> capabilities) {
    if (capabilities.contains('chat.partner')) return true;
    if (capabilities.contains('chat.lawyer')) return false;
    _deny();
  }

  Future<List<ChatClientOption>> listCreationClients(
    Session session,
    int offset,
    int limit,
  ) async {
    _validatePage(offset, limit);
    return session.db.transaction(
      (transaction) async {
        final capabilities = await _currentCapabilities(session, transaction);
        final global = _canCreateForAnyClient(capabilities);
        final identity = _identity(session);
        final clients = await LegalClient.db.find(
          session,
          where: global
              ? null
              : (table) => table.assignedLawyerId.equals(identity),
          orderBy: (table) => table.id,
          offset: offset,
          limit: limit,
          transaction: transaction,
        );
        return clients
            .map(
              (client) => ChatClientOption(
                legalClientId: client.id!,
                name: client.name,
              ),
            )
            .toList();
      },
      settings: const TransactionSettings(
        isolationLevel: IsolationLevel.repeatableRead,
      ),
    );
  }

  Future<ChatConversation> createConversation(
    Session session,
    int legalClientId,
    String title,
    String requestId,
  ) async {
    final normalized = title.trim();
    if (normalized.isEmpty ||
        normalized.length > maxTitleLength ||
        _titleControls.hasMatch(normalized)) {
      throw ArgumentError('Título inválido');
    }
    if (requestId.length != 36 || !_uuid.hasMatch(requestId)) {
      throw ArgumentError('Identificador de solicitação inválido');
    }
    return session.db.transaction((transaction) async {
      final identity = _identity(session);
      final capabilities = await _currentCapabilities(session, transaction);
      final partner = _canCreateForAnyClient(capabilities);
      final client = await _lockClient(session, legalClientId, transaction);
      if (client == null || (!partner && client.assignedLawyerId != identity)) {
        _deny();
      }

      final request = requestId.toLowerCase();
      await session.db.unsafeQuery(
        'INSERT INTO chat_conversation '
        '("legalClientId", title, "createdAt", "createdByAuthUserId", '
        '"creationRequestId") VALUES (@client, @title, @created, @actor, @request) '
        'ON CONFLICT ("createdByAuthUserId", "creationRequestId") DO NOTHING',
        parameters: QueryParameters.named({
          'client': legalClientId,
          'title': normalized,
          'created': DateTime.now().toUtc(),
          'actor': identity,
          'request': request,
        }),
        transaction: transaction,
      );
      final conversation = (await ChatConversation.db.findFirstRow(
        session,
        where: (table) =>
            table.createdByAuthUserId.equals(identity) &
            table.creationRequestId.equals(request),
        transaction: transaction,
      ))!;
      final participant = await _participant(
        session,
        conversation.id!,
        identity,
        transaction,
      );
      if (participant?.removedAt != null) _deny();
      if (conversation.legalClientId != legalClientId ||
          conversation.title != normalized) {
        throw ArgumentError('Identificador de solicitação já utilizado');
      }
      return conversation;
    });
  }

  Future<ChatParticipant> addParticipant(
    Session session,
    int conversationId,
    String authUserId,
  ) => session.db.transaction((transaction) async {
    final (manager, client) = await _requireManager(
      session,
      conversationId,
      transaction,
    );
    final identity = _targetIdentity(authUserId);
    final target = await _account(session, identity, transaction);
    if (target == null || target.blocked) _deny();

    final scopes = target.scopeNames;
    final owner =
        client.ownerAuthUserId == identity && scopes.contains('chat.client');
    final assignedLawyer =
        client.assignedLawyerId == identity && scopes.contains('chat.lawyer');
    final partner = scopes.contains('chat.partner');
    final eligible = switch (manager) {
      _Manager.partner =>
        owner || assignedLawyer || partner || scopes.contains('chat.support'),
      _Manager.lawyer =>
        !partner &&
            (owner || assignedLawyer || scopes.contains('chat.support')),
      _Manager.support => owner && !partner && !assignedLawyer,
    };
    if (!eligible) _deny();

    final existing = await _participant(
      session,
      conversationId,
      identity,
      transaction,
    );
    if (existing?.removedAt != null) _deny();
    if (existing != null) return existing;
    return ChatParticipant.db.insertRow(
      session,
      ChatParticipant(
        conversationId: conversationId,
        authUserId: identity,
        createdAt: DateTime.now().toUtc(),
      ),
      transaction: transaction,
    );
  });

  Future<void> removeParticipant(
    Session session,
    int conversationId,
    String authUserId,
  ) => session.db.transaction((transaction) async {
    final (manager, client) = await _requireManager(
      session,
      conversationId,
      transaction,
    );
    final identity = _targetIdentity(authUserId);
    if (manager != _Manager.partner && identity != _identity(session)) {
      final target = await _account(session, identity, transaction);
      final scopes = target?.scopeNames ?? const <String>{};
      if (scopes.contains('chat.partner')) _deny();
      if (manager == _Manager.support &&
          (client.ownerAuthUserId != identity ||
              client.assignedLawyerId == identity)) {
        _deny();
      }
    }
    final participant = await _participant(
      session,
      conversationId,
      identity,
      transaction,
    );
    if (participant == null) _deny();
    if (participant.removedAt != null) return;
    await ChatParticipant.db.updateRow(
      session,
      participant.copyWith(removedAt: DateTime.now().toUtc()),
      transaction: transaction,
    );
  });

  Future<List<ChatParticipant>> listParticipants(
    Session session,
    int conversationId,
    int offset,
    int limit,
  ) async {
    _validatePage(offset, limit);
    return session.db.transaction((transaction) async {
      await _requireConversationAccess(session, conversationId, transaction);
      return ChatParticipant.db.find(
        session,
        where: (table) =>
            table.conversationId.equals(conversationId) &
            table.removedAt.equals(null),
        orderByList: (table) => [
          Order(column: table.createdAt, orderDescending: true),
          Order(column: table.id, orderDescending: true),
        ],
        offset: offset,
        limit: limit,
        transaction: transaction,
      );
    });
  }

  String _targetIdentity(String authUserId) {
    if (authUserId.length != 36 || !_uuid.hasMatch(authUserId)) _deny();
    return authUserId.toLowerCase();
  }

  Future<(_Manager, LegalClient)> _requireManager(
    Session session,
    int conversationId,
    Transaction transaction, {
    bool exclusive = true,
  }) async {
    final conversation = await _lockConversation(
      session,
      conversationId,
      transaction,
      exclusive: exclusive,
    );
    final capabilities = await _currentCapabilities(session, transaction);
    final identity = _identity(session);
    final clientId = conversation.legalClientId;
    if (clientId == null) _deny();
    final client = await _lockClient(session, clientId, transaction);
    if (client == null) _deny();
    final participant = await _participant(
      session,
      conversationId,
      identity,
      transaction,
    );
    if (participant?.removedAt != null) _deny();
    if (capabilities.contains('chat.partner')) {
      return (_Manager.partner, client);
    }
    if (capabilities.contains('chat.lawyer') &&
        client.assignedLawyerId == identity) {
      return (_Manager.lawyer, client);
    }
    if (capabilities.contains('chat.support') && participant != null) {
      return (_Manager.support, client);
    }
    _deny();
  }

  Future<LegalClient?> _lockClient(
    Session session,
    int clientId,
    Transaction transaction,
  ) async {
    final rows = await session.db.unsafeQuery(
      'SELECT id FROM legal_client WHERE id = @id FOR SHARE',
      parameters: QueryParameters.named({'id': clientId}),
      transaction: transaction,
    );
    if (rows.isEmpty) return null;
    return LegalClient.db.findById(session, clientId, transaction: transaction);
  }

  Future<ChatConversation> _lockConversation(
    Session session,
    int conversationId,
    Transaction transaction, {
    bool exclusive = false,
  }) async {
    // Membership mutations exclude concurrent reads and sends on this conversation.
    final lock = exclusive ? 'UPDATE' : 'SHARE';
    final rows = await session.db.unsafeQuery(
      'SELECT id FROM chat_conversation WHERE id = @id FOR $lock',
      parameters: QueryParameters.named({'id': conversationId}),
      transaction: transaction,
    );
    if (rows.isEmpty) _deny();
    return (await ChatConversation.db.findById(
      session,
      conversationId,
      transaction: transaction,
    ))!;
  }

  Future<ChatParticipant?> _participant(
    Session session,
    int conversationId,
    String identity,
    Transaction transaction,
  ) => ChatParticipant.db.findFirstRow(
    session,
    where: (table) =>
        table.conversationId.equals(conversationId) &
        table.authUserId.equals(identity),
    transaction: transaction,
  );

  Future<List<ChatConversation>> listConversations(
    Session session,
    int offset,
    int limit,
  ) async {
    _validatePage(offset, limit);
    return session.db.transaction(
      (transaction) async {
        final capabilities = await _currentCapabilities(session, transaction);
        final identity = _identity(session);
        final predicates = <String>[];
        if (capabilities.contains('chat.partner')) predicates.add('TRUE');
        if (capabilities.contains('chat.lawyer')) {
          predicates.add('lc."assignedLawyerId" = @identity');
        }
        if (capabilities.contains('chat.support')) {
          predicates.add(
            'EXISTS (SELECT 1 FROM chat_participant p '
            'WHERE p."conversationId" = c.id '
            'AND p."authUserId" = @identity AND p."removedAt" IS NULL)',
          );
        }
        if (capabilities.contains('chat.client')) {
          predicates.add(
            '(lc."ownerAuthUserId" = @identity AND EXISTS ('
            'SELECT 1 FROM chat_participant p '
            'WHERE p."conversationId" = c.id '
            'AND p."authUserId" = @identity AND p."removedAt" IS NULL))',
          );
        }
        final predicate = predicates.map((value) => '($value)').join(' OR ');
        final result = await session.db.unsafeQuery(
          'SELECT c.id FROM chat_conversation c '
          'LEFT JOIN legal_client lc ON lc.id = c."legalClientId" '
          'WHERE ($predicate) AND NOT EXISTS ('
          'SELECT 1 FROM chat_participant removed '
          'WHERE removed."conversationId" = c.id '
          'AND removed."authUserId" = @identity AND removed."removedAt" IS NOT NULL) '
          'ORDER BY c."createdAt" DESC, c.id DESC '
          'LIMIT @limit OFFSET @offset',
          parameters: QueryParameters.named({
            'identity': identity,
            'limit': limit,
            'offset': offset,
          }),
          transaction: transaction,
        );
        final ids = result.map((row) => row.single as int).toSet();
        if (ids.isEmpty) return [];
        return ChatConversation.db.find(
          session,
          where: (table) => table.id.inSet(ids),
          orderByList: (table) => [
            Order(column: table.createdAt, orderDescending: true),
            Order(column: table.id, orderDescending: true),
          ],
          transaction: transaction,
        );
      },
      settings: const TransactionSettings(
        isolationLevel: IsolationLevel.repeatableRead,
      ),
    );
  }

  Future<void> _requireConversationAccess(
    Session session,
    int conversationId,
    Transaction transaction,
  ) async {
    final conversation = await _lockConversation(
      session,
      conversationId,
      transaction,
    );
    final capabilities = await _currentCapabilities(session, transaction);
    final identity = _identity(session);
    final participant = await _participant(
      session,
      conversationId,
      identity,
      transaction,
    );
    if (participant?.removedAt != null) _deny();
    if (capabilities.contains('chat.partner')) return;
    if (participant != null && capabilities.contains('chat.support')) return;
    final clientId = conversation.legalClientId;
    if (clientId != null) {
      final client = await _lockClient(session, clientId, transaction);
      if (capabilities.contains('chat.lawyer') &&
          client?.assignedLawyerId == identity) {
        return;
      }
      if (participant != null &&
          capabilities.contains('chat.client') &&
          client?.ownerAuthUserId == identity) {
        return;
      }
    }
    _deny();
  }

  Future<List<ChatMessage>> listMessages(
    Session session,
    int conversationId,
    int offset,
    int limit,
  ) async {
    _validatePage(offset, limit);
    return session.db.transaction((transaction) async {
      await _requireConversationAccess(session, conversationId, transaction);
      return ChatMessage.db.find(
        session,
        where: (table) => table.conversationId.equals(conversationId),
        limit: limit,
        offset: offset,
        orderByList: (table) => [
          Order(column: table.createdAt, orderDescending: true),
          Order(column: table.id, orderDescending: true),
        ],
        transaction: transaction,
      );
    });
  }

  Future<ChatMessage> sendMessage(
    Session session,
    int conversationId,
    String content,
  ) async {
    final normalized = content.trim();
    if (normalized.isEmpty || normalized.length > maxMessageLength) {
      throw ArgumentError('Mensagem inválida');
    }
    return session.db.transaction((transaction) async {
      await _requireConversationAccess(
        session,
        conversationId,
        transaction,
      );
      return ChatMessage.db.insertRow(
        session,
        ChatMessage(
          conversationId: conversationId,
          authorAuthUserId: _identity(session),
          content: normalized,
          createdAt: DateTime.now().toUtc(),
        ),
        transaction: transaction,
      );
    });
  }
}

enum _Manager { partner, lawyer, support }
