/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i3;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i4;
import 'access/access_denied_exception.dart' as _i5;
import 'access/managed_user.dart' as _i6;
import 'cases/datajud_exception.dart' as _i7;
import 'cases/legal_case.dart' as _i8;
import 'contact/contact_message.dart' as _i9;
import 'content/public_article.dart' as _i10;
import 'content/public_partner.dart' as _i11;
import 'greetings/greeting.dart' as _i12;
import 'greetings/user.dart' as _i13;
import 'legal/legal_client.dart' as _i14;
import 'negotiations/negotiation.dart' as _i15;
import 'negotiations/negotiation_event.dart' as _i16;
import 'package:signcob_server/src/generated/access/managed_user.dart' as _i17;
import 'package:signcob_server/src/generated/cases/legal_case.dart' as _i18;
import 'package:signcob_server/src/generated/contact/contact_message.dart'
    as _i19;
import 'package:signcob_server/src/generated/content/public_article.dart'
    as _i20;
import 'package:signcob_server/src/generated/content/public_partner.dart'
    as _i21;
import 'package:signcob_server/src/generated/legal/legal_client.dart' as _i22;
import 'package:signcob_server/src/generated/negotiations/negotiation.dart'
    as _i23;
import 'package:signcob_server/src/generated/negotiations/negotiation_event.dart'
    as _i24;
export 'access/access_denied_exception.dart';
export 'access/managed_user.dart';
export 'cases/datajud_exception.dart';
export 'cases/legal_case.dart';
export 'contact/contact_message.dart';
export 'content/public_article.dart';
export 'content/public_partner.dart';
export 'greetings/greeting.dart';
export 'greetings/user.dart';
export 'legal/legal_client.dart';
export 'negotiations/negotiation.dart';
export 'negotiations/negotiation_event.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'contact_message',
      dartName: 'ContactMessage',
      schema: 'public',
      module: 'signcob',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'contact_message_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'message',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'contact_message_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'greeting',
      dartName: 'Greeting',
      schema: 'public',
      module: 'signcob',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'greeting_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'message',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'author',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'timestamp',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'greeting_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'legal_case',
      dartName: 'LegalCase',
      schema: 'public',
      module: 'signcob',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'legal_case_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'legalClientId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'number',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'tribunal',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'className',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'courtName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'lastSyncedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'syncError',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'movementsJson',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'legal_case_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'legal_case_tribunal_number_unique',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'tribunal',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'number',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'legal_client',
      dartName: 'LegalClient',
      schema: 'public',
      module: 'signcob',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'legal_client_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'phone',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'document',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'assignedLawyerId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'ownerAuthUserId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'legal_client_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'negotiation',
      dartName: 'Negotiation',
      schema: 'public',
      module: 'signcob',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'negotiation_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'legalClientId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'kind',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'amountCents',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'negotiation_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'negotiation_event',
      dartName: 'NegotiationEvent',
      schema: 'public',
      module: 'signcob',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'negotiation_event_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'negotiationId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'fromStatus',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'toStatus',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'occurredAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'actorAuthUserId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'note',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'negotiation_event_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'public_article',
      dartName: 'PublicArticle',
      schema: 'public',
      module: 'signcob',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'public_article_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'summary',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'body',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'externalUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'published',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'public_article_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'public_partner',
      dartName: 'PublicPartner',
      schema: 'public',
      module: 'signcob',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'public_partner_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'website',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'active',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'public_partner_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'users',
      dartName: 'User',
      schema: 'public',
      module: 'signcob',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'users_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'password',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'users_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i5.AccessDeniedException) {
      return _i5.AccessDeniedException.fromJson(data) as T;
    }
    if (t == _i6.ManagedUser) {
      return _i6.ManagedUser.fromJson(data) as T;
    }
    if (t == _i7.DataJudException) {
      return _i7.DataJudException.fromJson(data) as T;
    }
    if (t == _i8.LegalCase) {
      return _i8.LegalCase.fromJson(data) as T;
    }
    if (t == _i9.ContactMessage) {
      return _i9.ContactMessage.fromJson(data) as T;
    }
    if (t == _i10.PublicArticle) {
      return _i10.PublicArticle.fromJson(data) as T;
    }
    if (t == _i11.PublicPartner) {
      return _i11.PublicPartner.fromJson(data) as T;
    }
    if (t == _i12.Greeting) {
      return _i12.Greeting.fromJson(data) as T;
    }
    if (t == _i13.User) {
      return _i13.User.fromJson(data) as T;
    }
    if (t == _i14.LegalClient) {
      return _i14.LegalClient.fromJson(data) as T;
    }
    if (t == _i15.Negotiation) {
      return _i15.Negotiation.fromJson(data) as T;
    }
    if (t == _i16.NegotiationEvent) {
      return _i16.NegotiationEvent.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.AccessDeniedException?>()) {
      return (data != null ? _i5.AccessDeniedException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.ManagedUser?>()) {
      return (data != null ? _i6.ManagedUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.DataJudException?>()) {
      return (data != null ? _i7.DataJudException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.LegalCase?>()) {
      return (data != null ? _i8.LegalCase.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.ContactMessage?>()) {
      return (data != null ? _i9.ContactMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.PublicArticle?>()) {
      return (data != null ? _i10.PublicArticle.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.PublicPartner?>()) {
      return (data != null ? _i11.PublicPartner.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.Greeting?>()) {
      return (data != null ? _i12.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.User?>()) {
      return (data != null ? _i13.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.LegalClient?>()) {
      return (data != null ? _i14.LegalClient.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.Negotiation?>()) {
      return (data != null ? _i15.Negotiation.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.NegotiationEvent?>()) {
      return (data != null ? _i16.NegotiationEvent.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i17.ManagedUser>) {
      return (data as List)
              .map((e) => deserialize<_i17.ManagedUser>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i18.LegalCase>) {
      return (data as List).map((e) => deserialize<_i18.LegalCase>(e)).toList()
          as T;
    }
    if (t == List<_i19.ContactMessage>) {
      return (data as List)
              .map((e) => deserialize<_i19.ContactMessage>(e))
              .toList()
          as T;
    }
    if (t == List<_i20.PublicArticle>) {
      return (data as List)
              .map((e) => deserialize<_i20.PublicArticle>(e))
              .toList()
          as T;
    }
    if (t == List<_i21.PublicPartner>) {
      return (data as List)
              .map((e) => deserialize<_i21.PublicPartner>(e))
              .toList()
          as T;
    }
    if (t == List<_i22.LegalClient>) {
      return (data as List)
              .map((e) => deserialize<_i22.LegalClient>(e))
              .toList()
          as T;
    }
    if (t == List<_i23.Negotiation>) {
      return (data as List)
              .map((e) => deserialize<_i23.Negotiation>(e))
              .toList()
          as T;
    }
    if (t == List<_i24.NegotiationEvent>) {
      return (data as List)
              .map((e) => deserialize<_i24.NegotiationEvent>(e))
              .toList()
          as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i5.AccessDeniedException => 'AccessDeniedException',
      _i6.ManagedUser => 'ManagedUser',
      _i7.DataJudException => 'DataJudException',
      _i8.LegalCase => 'LegalCase',
      _i9.ContactMessage => 'ContactMessage',
      _i10.PublicArticle => 'PublicArticle',
      _i11.PublicPartner => 'PublicPartner',
      _i12.Greeting => 'Greeting',
      _i13.User => 'User',
      _i14.LegalClient => 'LegalClient',
      _i15.Negotiation => 'Negotiation',
      _i16.NegotiationEvent => 'NegotiationEvent',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('signcob.', '');
    }

    switch (data) {
      case _i5.AccessDeniedException():
        return 'AccessDeniedException';
      case _i6.ManagedUser():
        return 'ManagedUser';
      case _i7.DataJudException():
        return 'DataJudException';
      case _i8.LegalCase():
        return 'LegalCase';
      case _i9.ContactMessage():
        return 'ContactMessage';
      case _i10.PublicArticle():
        return 'PublicArticle';
      case _i11.PublicPartner():
        return 'PublicPartner';
      case _i12.Greeting():
        return 'Greeting';
      case _i13.User():
        return 'User';
      case _i14.LegalClient():
        return 'LegalClient';
      case _i15.Negotiation():
        return 'Negotiation';
      case _i16.NegotiationEvent():
        return 'NegotiationEvent';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AccessDeniedException') {
      return deserialize<_i5.AccessDeniedException>(data['data']);
    }
    if (dataClassName == 'ManagedUser') {
      return deserialize<_i6.ManagedUser>(data['data']);
    }
    if (dataClassName == 'DataJudException') {
      return deserialize<_i7.DataJudException>(data['data']);
    }
    if (dataClassName == 'LegalCase') {
      return deserialize<_i8.LegalCase>(data['data']);
    }
    if (dataClassName == 'ContactMessage') {
      return deserialize<_i9.ContactMessage>(data['data']);
    }
    if (dataClassName == 'PublicArticle') {
      return deserialize<_i10.PublicArticle>(data['data']);
    }
    if (dataClassName == 'PublicPartner') {
      return deserialize<_i11.PublicPartner>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i12.Greeting>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i13.User>(data['data']);
    }
    if (dataClassName == 'LegalClient') {
      return deserialize<_i14.LegalClient>(data['data']);
    }
    if (dataClassName == 'Negotiation') {
      return deserialize<_i15.Negotiation>(data['data']);
    }
    if (dataClassName == 'NegotiationEvent') {
      return deserialize<_i16.NegotiationEvent>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i4.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i8.LegalCase:
        return _i8.LegalCase.t;
      case _i9.ContactMessage:
        return _i9.ContactMessage.t;
      case _i10.PublicArticle:
        return _i10.PublicArticle.t;
      case _i11.PublicPartner:
        return _i11.PublicPartner.t;
      case _i12.Greeting:
        return _i12.Greeting.t;
      case _i13.User:
        return _i13.User.t;
      case _i14.LegalClient:
        return _i14.LegalClient.t;
      case _i15.Negotiation:
        return _i15.Negotiation.t;
      case _i16.NegotiationEvent:
        return _i16.NegotiationEvent.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'signcob';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i4.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
