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
import 'billing/billing_charge.dart' as _i7;
import 'billing/billing_charge_record.dart' as _i8;
import 'billing/billing_client_option.dart' as _i9;
import 'billing/billing_create_request.dart' as _i10;
import 'billing/billing_customer_link.dart' as _i11;
import 'billing/billing_customer_record.dart' as _i12;
import 'billing/billing_cycle.dart' as _i13;
import 'billing/billing_exception.dart' as _i14;
import 'billing/billing_flow.dart' as _i15;
import 'billing/billing_method.dart' as _i16;
import 'billing/billing_negotiation_option.dart' as _i17;
import 'billing/billing_payment.dart' as _i18;
import 'billing/billing_payment_record.dart' as _i19;
import 'billing/billing_status.dart' as _i20;
import 'cases/datajud_exception.dart' as _i21;
import 'cases/legal_case.dart' as _i22;
import 'chat/chat_client_option.dart' as _i23;
import 'chat/chat_conversation.dart' as _i24;
import 'chat/chat_message.dart' as _i25;
import 'chat/chat_participant.dart' as _i26;
import 'contact/contact_message.dart' as _i27;
import 'content/public_article.dart' as _i28;
import 'content/public_partner.dart' as _i29;
import 'greetings/greeting.dart' as _i30;
import 'greetings/user.dart' as _i31;
import 'legal/legal_client.dart' as _i32;
import 'negotiations/negotiation.dart' as _i33;
import 'negotiations/negotiation_event.dart' as _i34;
import 'package:signcob_server/src/generated/access/managed_user.dart' as _i35;
import 'package:signcob_server/src/generated/billing/billing_charge.dart'
    as _i36;
import 'package:signcob_server/src/generated/billing/billing_client_option.dart'
    as _i37;
import 'package:signcob_server/src/generated/billing/billing_negotiation_option.dart'
    as _i38;
import 'package:signcob_server/src/generated/cases/legal_case.dart' as _i39;
import 'package:signcob_server/src/generated/chat/chat_client_option.dart'
    as _i40;
import 'package:signcob_server/src/generated/chat/chat_participant.dart'
    as _i41;
import 'package:signcob_server/src/generated/chat/chat_conversation.dart'
    as _i42;
import 'package:signcob_server/src/generated/chat/chat_message.dart' as _i43;
import 'package:signcob_server/src/generated/contact/contact_message.dart'
    as _i44;
import 'package:signcob_server/src/generated/content/public_article.dart'
    as _i45;
import 'package:signcob_server/src/generated/content/public_partner.dart'
    as _i46;
import 'package:signcob_server/src/generated/legal/legal_client.dart' as _i47;
import 'package:signcob_server/src/generated/negotiations/negotiation.dart'
    as _i48;
import 'package:signcob_server/src/generated/negotiations/negotiation_event.dart'
    as _i49;
export 'access/access_denied_exception.dart';
export 'access/managed_user.dart';
export 'billing/billing_charge.dart';
export 'billing/billing_charge_record.dart';
export 'billing/billing_client_option.dart';
export 'billing/billing_create_request.dart';
export 'billing/billing_customer_link.dart';
export 'billing/billing_customer_record.dart';
export 'billing/billing_cycle.dart';
export 'billing/billing_exception.dart';
export 'billing/billing_flow.dart';
export 'billing/billing_method.dart';
export 'billing/billing_negotiation_option.dart';
export 'billing/billing_payment.dart';
export 'billing/billing_payment_record.dart';
export 'billing/billing_status.dart';
export 'cases/datajud_exception.dart';
export 'cases/legal_case.dart';
export 'chat/chat_client_option.dart';
export 'chat/chat_conversation.dart';
export 'chat/chat_message.dart';
export 'chat/chat_participant.dart';
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
      name: 'billing_charge',
      dartName: 'BillingChargeRecord',
      schema: 'public',
      module: 'signcob',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'billing_charge_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'legalClientId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'negotiationId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'idempotencyKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'providerId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'amountCents',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'dueDate',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:BillingStatus',
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
        _i2.ColumnDefinition(
          name: 'environment',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'accountId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'kind',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'method',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:BillingMethod?',
        ),
        _i2.ColumnDefinition(
          name: 'flow',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:BillingFlow?',
        ),
        _i2.ColumnDefinition(
          name: 'installmentCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'cycle',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:BillingCycle?',
        ),
        _i2.ColumnDefinition(
          name: 'providerCustomerId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'externalReference',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'providerGroupId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'creationState',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createAttempted',
          columnType: _i2.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _i2.ColumnDefinition(
          name: 'subscriptionStatus',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'billing_charge_fk_0',
          columns: ['legalClientId'],
          referenceTable: 'legal_client',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'billing_charge_fk_1',
          columns: ['negotiationId'],
          referenceTable: 'negotiation',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'billing_charge_pkey',
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
          indexName: 'billing_charge_client_key_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'legalClientId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'idempotencyKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'billing_charge_provider_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'providerId',
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
      name: 'billing_customer',
      dartName: 'BillingCustomerRecord',
      schema: 'public',
      module: 'signcob',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'billing_customer_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'environment',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'accountId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'legalClientId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'document',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'externalReference',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'providerCustomerId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'state',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createAttempted',
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
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'billing_customer_fk_0',
          columns: ['legalClientId'],
          referenceTable: 'legal_client',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'billing_customer_pkey',
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
          indexName: 'billing_customer_client_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'environment',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'accountId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'legalClientId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'billing_customer_document_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'environment',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'accountId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'document',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'billing_customer_provider_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'environment',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'accountId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'providerCustomerId',
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
      name: 'billing_payment',
      dartName: 'BillingPaymentRecord',
      schema: 'public',
      module: 'signcob',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'billing_payment_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'chargeId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'environment',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'accountId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'providerId',
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
          name: 'dueDate',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'installmentNumber',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:BillingStatus',
        ),
        _i2.ColumnDefinition(
          name: 'confirmedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'receivedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'invoiceUrl',
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
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'billing_payment_fk_0',
          columns: ['chargeId'],
          referenceTable: 'billing_charge',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'billing_payment_pkey',
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
          indexName: 'billing_payment_provider_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'environment',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'accountId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'providerId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'billing_payment_charge_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'chargeId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'chat_conversation',
      dartName: 'ChatConversation',
      schema: 'public',
      module: 'signcob',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'chat_conversation_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'legalClientId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'createdByAuthUserId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'creationRequestId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'chat_conversation_fk_0',
          columns: ['legalClientId'],
          referenceTable: 'legal_client',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'chat_conversation_pkey',
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
          indexName: 'chat_conversation_created_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'chat_conversation_creation_request_unique',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'createdByAuthUserId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'creationRequestId',
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
      name: 'chat_message',
      dartName: 'ChatMessage',
      schema: 'public',
      module: 'signcob',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'chat_message_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'conversationId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'authorAuthUserId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'content',
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
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'chat_message_fk_0',
          columns: ['conversationId'],
          referenceTable: 'chat_conversation',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'chat_message_pkey',
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
          indexName: 'chat_message_conversation_page_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'conversationId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'chat_participant',
      dartName: 'ChatParticipant',
      schema: 'public',
      module: 'signcob',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'chat_participant_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'conversationId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'authUserId',
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
          name: 'removedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'chat_participant_fk_0',
          columns: ['conversationId'],
          referenceTable: 'chat_conversation',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'chat_participant_pkey',
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
          indexName: 'chat_participant_conversation_user_unique',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'conversationId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'chat_participant_user_active_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'removedAt',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'conversationId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
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
    if (t == _i7.BillingCharge) {
      return _i7.BillingCharge.fromJson(data) as T;
    }
    if (t == _i8.BillingChargeRecord) {
      return _i8.BillingChargeRecord.fromJson(data) as T;
    }
    if (t == _i9.BillingClientOption) {
      return _i9.BillingClientOption.fromJson(data) as T;
    }
    if (t == _i10.BillingCreateRequest) {
      return _i10.BillingCreateRequest.fromJson(data) as T;
    }
    if (t == _i11.BillingCustomerLink) {
      return _i11.BillingCustomerLink.fromJson(data) as T;
    }
    if (t == _i12.BillingCustomerRecord) {
      return _i12.BillingCustomerRecord.fromJson(data) as T;
    }
    if (t == _i13.BillingCycle) {
      return _i13.BillingCycle.fromJson(data) as T;
    }
    if (t == _i14.BillingException) {
      return _i14.BillingException.fromJson(data) as T;
    }
    if (t == _i15.BillingFlow) {
      return _i15.BillingFlow.fromJson(data) as T;
    }
    if (t == _i16.BillingMethod) {
      return _i16.BillingMethod.fromJson(data) as T;
    }
    if (t == _i17.BillingNegotiationOption) {
      return _i17.BillingNegotiationOption.fromJson(data) as T;
    }
    if (t == _i18.BillingPayment) {
      return _i18.BillingPayment.fromJson(data) as T;
    }
    if (t == _i19.BillingPaymentRecord) {
      return _i19.BillingPaymentRecord.fromJson(data) as T;
    }
    if (t == _i20.BillingStatus) {
      return _i20.BillingStatus.fromJson(data) as T;
    }
    if (t == _i21.DataJudException) {
      return _i21.DataJudException.fromJson(data) as T;
    }
    if (t == _i22.LegalCase) {
      return _i22.LegalCase.fromJson(data) as T;
    }
    if (t == _i23.ChatClientOption) {
      return _i23.ChatClientOption.fromJson(data) as T;
    }
    if (t == _i24.ChatConversation) {
      return _i24.ChatConversation.fromJson(data) as T;
    }
    if (t == _i25.ChatMessage) {
      return _i25.ChatMessage.fromJson(data) as T;
    }
    if (t == _i26.ChatParticipant) {
      return _i26.ChatParticipant.fromJson(data) as T;
    }
    if (t == _i27.ContactMessage) {
      return _i27.ContactMessage.fromJson(data) as T;
    }
    if (t == _i28.PublicArticle) {
      return _i28.PublicArticle.fromJson(data) as T;
    }
    if (t == _i29.PublicPartner) {
      return _i29.PublicPartner.fromJson(data) as T;
    }
    if (t == _i30.Greeting) {
      return _i30.Greeting.fromJson(data) as T;
    }
    if (t == _i31.User) {
      return _i31.User.fromJson(data) as T;
    }
    if (t == _i32.LegalClient) {
      return _i32.LegalClient.fromJson(data) as T;
    }
    if (t == _i33.Negotiation) {
      return _i33.Negotiation.fromJson(data) as T;
    }
    if (t == _i34.NegotiationEvent) {
      return _i34.NegotiationEvent.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.AccessDeniedException?>()) {
      return (data != null ? _i5.AccessDeniedException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.ManagedUser?>()) {
      return (data != null ? _i6.ManagedUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.BillingCharge?>()) {
      return (data != null ? _i7.BillingCharge.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.BillingChargeRecord?>()) {
      return (data != null ? _i8.BillingChargeRecord.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i9.BillingClientOption?>()) {
      return (data != null ? _i9.BillingClientOption.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.BillingCreateRequest?>()) {
      return (data != null ? _i10.BillingCreateRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.BillingCustomerLink?>()) {
      return (data != null ? _i11.BillingCustomerLink.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.BillingCustomerRecord?>()) {
      return (data != null ? _i12.BillingCustomerRecord.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i13.BillingCycle?>()) {
      return (data != null ? _i13.BillingCycle.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.BillingException?>()) {
      return (data != null ? _i14.BillingException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.BillingFlow?>()) {
      return (data != null ? _i15.BillingFlow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.BillingMethod?>()) {
      return (data != null ? _i16.BillingMethod.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.BillingNegotiationOption?>()) {
      return (data != null
              ? _i17.BillingNegotiationOption.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i18.BillingPayment?>()) {
      return (data != null ? _i18.BillingPayment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.BillingPaymentRecord?>()) {
      return (data != null ? _i19.BillingPaymentRecord.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i20.BillingStatus?>()) {
      return (data != null ? _i20.BillingStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.DataJudException?>()) {
      return (data != null ? _i21.DataJudException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.LegalCase?>()) {
      return (data != null ? _i22.LegalCase.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.ChatClientOption?>()) {
      return (data != null ? _i23.ChatClientOption.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.ChatConversation?>()) {
      return (data != null ? _i24.ChatConversation.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.ChatMessage?>()) {
      return (data != null ? _i25.ChatMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.ChatParticipant?>()) {
      return (data != null ? _i26.ChatParticipant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.ContactMessage?>()) {
      return (data != null ? _i27.ContactMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.PublicArticle?>()) {
      return (data != null ? _i28.PublicArticle.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.PublicPartner?>()) {
      return (data != null ? _i29.PublicPartner.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.Greeting?>()) {
      return (data != null ? _i30.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.User?>()) {
      return (data != null ? _i31.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.LegalClient?>()) {
      return (data != null ? _i32.LegalClient.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.Negotiation?>()) {
      return (data != null ? _i33.Negotiation.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.NegotiationEvent?>()) {
      return (data != null ? _i34.NegotiationEvent.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i18.BillingPayment>) {
      return (data as List)
              .map((e) => deserialize<_i18.BillingPayment>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i18.BillingPayment>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i18.BillingPayment>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i35.ManagedUser>) {
      return (data as List)
              .map((e) => deserialize<_i35.ManagedUser>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i36.BillingCharge>) {
      return (data as List)
              .map((e) => deserialize<_i36.BillingCharge>(e))
              .toList()
          as T;
    }
    if (t == List<_i37.BillingClientOption>) {
      return (data as List)
              .map((e) => deserialize<_i37.BillingClientOption>(e))
              .toList()
          as T;
    }
    if (t == List<_i38.BillingNegotiationOption>) {
      return (data as List)
              .map((e) => deserialize<_i38.BillingNegotiationOption>(e))
              .toList()
          as T;
    }
    if (t == List<_i39.LegalCase>) {
      return (data as List).map((e) => deserialize<_i39.LegalCase>(e)).toList()
          as T;
    }
    if (t == List<_i40.ChatClientOption>) {
      return (data as List)
              .map((e) => deserialize<_i40.ChatClientOption>(e))
              .toList()
          as T;
    }
    if (t == List<_i41.ChatParticipant>) {
      return (data as List)
              .map((e) => deserialize<_i41.ChatParticipant>(e))
              .toList()
          as T;
    }
    if (t == List<_i42.ChatConversation>) {
      return (data as List)
              .map((e) => deserialize<_i42.ChatConversation>(e))
              .toList()
          as T;
    }
    if (t == List<_i43.ChatMessage>) {
      return (data as List)
              .map((e) => deserialize<_i43.ChatMessage>(e))
              .toList()
          as T;
    }
    if (t == List<_i44.ContactMessage>) {
      return (data as List)
              .map((e) => deserialize<_i44.ContactMessage>(e))
              .toList()
          as T;
    }
    if (t == List<_i45.PublicArticle>) {
      return (data as List)
              .map((e) => deserialize<_i45.PublicArticle>(e))
              .toList()
          as T;
    }
    if (t == List<_i46.PublicPartner>) {
      return (data as List)
              .map((e) => deserialize<_i46.PublicPartner>(e))
              .toList()
          as T;
    }
    if (t == List<_i47.LegalClient>) {
      return (data as List)
              .map((e) => deserialize<_i47.LegalClient>(e))
              .toList()
          as T;
    }
    if (t == List<_i48.Negotiation>) {
      return (data as List)
              .map((e) => deserialize<_i48.Negotiation>(e))
              .toList()
          as T;
    }
    if (t == List<_i49.NegotiationEvent>) {
      return (data as List)
              .map((e) => deserialize<_i49.NegotiationEvent>(e))
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
      _i7.BillingCharge => 'BillingCharge',
      _i8.BillingChargeRecord => 'BillingChargeRecord',
      _i9.BillingClientOption => 'BillingClientOption',
      _i10.BillingCreateRequest => 'BillingCreateRequest',
      _i11.BillingCustomerLink => 'BillingCustomerLink',
      _i12.BillingCustomerRecord => 'BillingCustomerRecord',
      _i13.BillingCycle => 'BillingCycle',
      _i14.BillingException => 'BillingException',
      _i15.BillingFlow => 'BillingFlow',
      _i16.BillingMethod => 'BillingMethod',
      _i17.BillingNegotiationOption => 'BillingNegotiationOption',
      _i18.BillingPayment => 'BillingPayment',
      _i19.BillingPaymentRecord => 'BillingPaymentRecord',
      _i20.BillingStatus => 'BillingStatus',
      _i21.DataJudException => 'DataJudException',
      _i22.LegalCase => 'LegalCase',
      _i23.ChatClientOption => 'ChatClientOption',
      _i24.ChatConversation => 'ChatConversation',
      _i25.ChatMessage => 'ChatMessage',
      _i26.ChatParticipant => 'ChatParticipant',
      _i27.ContactMessage => 'ContactMessage',
      _i28.PublicArticle => 'PublicArticle',
      _i29.PublicPartner => 'PublicPartner',
      _i30.Greeting => 'Greeting',
      _i31.User => 'User',
      _i32.LegalClient => 'LegalClient',
      _i33.Negotiation => 'Negotiation',
      _i34.NegotiationEvent => 'NegotiationEvent',
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
      case _i7.BillingCharge():
        return 'BillingCharge';
      case _i8.BillingChargeRecord():
        return 'BillingChargeRecord';
      case _i9.BillingClientOption():
        return 'BillingClientOption';
      case _i10.BillingCreateRequest():
        return 'BillingCreateRequest';
      case _i11.BillingCustomerLink():
        return 'BillingCustomerLink';
      case _i12.BillingCustomerRecord():
        return 'BillingCustomerRecord';
      case _i13.BillingCycle():
        return 'BillingCycle';
      case _i14.BillingException():
        return 'BillingException';
      case _i15.BillingFlow():
        return 'BillingFlow';
      case _i16.BillingMethod():
        return 'BillingMethod';
      case _i17.BillingNegotiationOption():
        return 'BillingNegotiationOption';
      case _i18.BillingPayment():
        return 'BillingPayment';
      case _i19.BillingPaymentRecord():
        return 'BillingPaymentRecord';
      case _i20.BillingStatus():
        return 'BillingStatus';
      case _i21.DataJudException():
        return 'DataJudException';
      case _i22.LegalCase():
        return 'LegalCase';
      case _i23.ChatClientOption():
        return 'ChatClientOption';
      case _i24.ChatConversation():
        return 'ChatConversation';
      case _i25.ChatMessage():
        return 'ChatMessage';
      case _i26.ChatParticipant():
        return 'ChatParticipant';
      case _i27.ContactMessage():
        return 'ContactMessage';
      case _i28.PublicArticle():
        return 'PublicArticle';
      case _i29.PublicPartner():
        return 'PublicPartner';
      case _i30.Greeting():
        return 'Greeting';
      case _i31.User():
        return 'User';
      case _i32.LegalClient():
        return 'LegalClient';
      case _i33.Negotiation():
        return 'Negotiation';
      case _i34.NegotiationEvent():
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
    if (dataClassName == 'BillingCharge') {
      return deserialize<_i7.BillingCharge>(data['data']);
    }
    if (dataClassName == 'BillingChargeRecord') {
      return deserialize<_i8.BillingChargeRecord>(data['data']);
    }
    if (dataClassName == 'BillingClientOption') {
      return deserialize<_i9.BillingClientOption>(data['data']);
    }
    if (dataClassName == 'BillingCreateRequest') {
      return deserialize<_i10.BillingCreateRequest>(data['data']);
    }
    if (dataClassName == 'BillingCustomerLink') {
      return deserialize<_i11.BillingCustomerLink>(data['data']);
    }
    if (dataClassName == 'BillingCustomerRecord') {
      return deserialize<_i12.BillingCustomerRecord>(data['data']);
    }
    if (dataClassName == 'BillingCycle') {
      return deserialize<_i13.BillingCycle>(data['data']);
    }
    if (dataClassName == 'BillingException') {
      return deserialize<_i14.BillingException>(data['data']);
    }
    if (dataClassName == 'BillingFlow') {
      return deserialize<_i15.BillingFlow>(data['data']);
    }
    if (dataClassName == 'BillingMethod') {
      return deserialize<_i16.BillingMethod>(data['data']);
    }
    if (dataClassName == 'BillingNegotiationOption') {
      return deserialize<_i17.BillingNegotiationOption>(data['data']);
    }
    if (dataClassName == 'BillingPayment') {
      return deserialize<_i18.BillingPayment>(data['data']);
    }
    if (dataClassName == 'BillingPaymentRecord') {
      return deserialize<_i19.BillingPaymentRecord>(data['data']);
    }
    if (dataClassName == 'BillingStatus') {
      return deserialize<_i20.BillingStatus>(data['data']);
    }
    if (dataClassName == 'DataJudException') {
      return deserialize<_i21.DataJudException>(data['data']);
    }
    if (dataClassName == 'LegalCase') {
      return deserialize<_i22.LegalCase>(data['data']);
    }
    if (dataClassName == 'ChatClientOption') {
      return deserialize<_i23.ChatClientOption>(data['data']);
    }
    if (dataClassName == 'ChatConversation') {
      return deserialize<_i24.ChatConversation>(data['data']);
    }
    if (dataClassName == 'ChatMessage') {
      return deserialize<_i25.ChatMessage>(data['data']);
    }
    if (dataClassName == 'ChatParticipant') {
      return deserialize<_i26.ChatParticipant>(data['data']);
    }
    if (dataClassName == 'ContactMessage') {
      return deserialize<_i27.ContactMessage>(data['data']);
    }
    if (dataClassName == 'PublicArticle') {
      return deserialize<_i28.PublicArticle>(data['data']);
    }
    if (dataClassName == 'PublicPartner') {
      return deserialize<_i29.PublicPartner>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i30.Greeting>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i31.User>(data['data']);
    }
    if (dataClassName == 'LegalClient') {
      return deserialize<_i32.LegalClient>(data['data']);
    }
    if (dataClassName == 'Negotiation') {
      return deserialize<_i33.Negotiation>(data['data']);
    }
    if (dataClassName == 'NegotiationEvent') {
      return deserialize<_i34.NegotiationEvent>(data['data']);
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
      case _i8.BillingChargeRecord:
        return _i8.BillingChargeRecord.t;
      case _i12.BillingCustomerRecord:
        return _i12.BillingCustomerRecord.t;
      case _i19.BillingPaymentRecord:
        return _i19.BillingPaymentRecord.t;
      case _i22.LegalCase:
        return _i22.LegalCase.t;
      case _i24.ChatConversation:
        return _i24.ChatConversation.t;
      case _i25.ChatMessage:
        return _i25.ChatMessage.t;
      case _i26.ChatParticipant:
        return _i26.ChatParticipant.t;
      case _i27.ContactMessage:
        return _i27.ContactMessage.t;
      case _i28.PublicArticle:
        return _i28.PublicArticle.t;
      case _i29.PublicPartner:
        return _i29.PublicPartner.t;
      case _i30.Greeting:
        return _i30.Greeting.t;
      case _i31.User:
        return _i31.User.t;
      case _i32.LegalClient:
        return _i32.LegalClient.t;
      case _i33.Negotiation:
        return _i33.Negotiation.t;
      case _i34.NegotiationEvent:
        return _i34.NegotiationEvent.t;
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
