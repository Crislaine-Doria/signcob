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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../billing/billing_status.dart' as _i2;
import '../billing/billing_method.dart' as _i3;
import '../billing/billing_flow.dart' as _i4;
import '../billing/billing_cycle.dart' as _i5;
import '../billing/billing_payment.dart' as _i6;
import 'package:signcob_client/src/protocol/protocol.dart' as _i7;

abstract class BillingCharge implements _i1.SerializableModel {
  BillingCharge._({
    required this.id,
    required this.legalClientId,
    this.negotiationId,
    required this.amountCents,
    required this.dueDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.idempotencyKey,
    this.kind,
    this.method,
    this.flow,
    this.installmentCount,
    this.cycle,
    this.providerGroupId,
    this.creationState,
    this.subscriptionStatus,
    this.payments,
    this.clientName,
  });

  factory BillingCharge({
    required int id,
    required int legalClientId,
    int? negotiationId,
    required int amountCents,
    required String dueDate,
    required _i2.BillingStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? idempotencyKey,
    String? kind,
    _i3.BillingMethod? method,
    _i4.BillingFlow? flow,
    int? installmentCount,
    _i5.BillingCycle? cycle,
    String? providerGroupId,
    String? creationState,
    String? subscriptionStatus,
    List<_i6.BillingPayment>? payments,
    String? clientName,
  }) = _BillingChargeImpl;

  factory BillingCharge.fromJson(Map<String, dynamic> jsonSerialization) {
    return BillingCharge(
      id: jsonSerialization['id'] as int,
      legalClientId: jsonSerialization['legalClientId'] as int,
      negotiationId: jsonSerialization['negotiationId'] as int?,
      amountCents: jsonSerialization['amountCents'] as int,
      dueDate: jsonSerialization['dueDate'] as String,
      status: _i2.BillingStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      idempotencyKey: jsonSerialization['idempotencyKey'] as String?,
      kind: jsonSerialization['kind'] as String?,
      method: jsonSerialization['method'] == null
          ? null
          : _i3.BillingMethod.fromJson((jsonSerialization['method'] as String)),
      flow: jsonSerialization['flow'] == null
          ? null
          : _i4.BillingFlow.fromJson((jsonSerialization['flow'] as String)),
      installmentCount: jsonSerialization['installmentCount'] as int?,
      cycle: jsonSerialization['cycle'] == null
          ? null
          : _i5.BillingCycle.fromJson((jsonSerialization['cycle'] as String)),
      providerGroupId: jsonSerialization['providerGroupId'] as String?,
      creationState: jsonSerialization['creationState'] as String?,
      subscriptionStatus: jsonSerialization['subscriptionStatus'] as String?,
      payments: jsonSerialization['payments'] == null
          ? null
          : _i7.Protocol().deserialize<List<_i6.BillingPayment>>(
              jsonSerialization['payments'],
            ),
      clientName: jsonSerialization['clientName'] as String?,
    );
  }

  int id;

  int legalClientId;

  int? negotiationId;

  int amountCents;

  String dueDate;

  _i2.BillingStatus status;

  DateTime createdAt;

  DateTime updatedAt;

  String? idempotencyKey;

  String? kind;

  _i3.BillingMethod? method;

  _i4.BillingFlow? flow;

  int? installmentCount;

  _i5.BillingCycle? cycle;

  String? providerGroupId;

  String? creationState;

  String? subscriptionStatus;

  List<_i6.BillingPayment>? payments;

  String? clientName;

  /// Returns a shallow copy of this [BillingCharge]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BillingCharge copyWith({
    int? id,
    int? legalClientId,
    int? negotiationId,
    int? amountCents,
    String? dueDate,
    _i2.BillingStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? idempotencyKey,
    String? kind,
    _i3.BillingMethod? method,
    _i4.BillingFlow? flow,
    int? installmentCount,
    _i5.BillingCycle? cycle,
    String? providerGroupId,
    String? creationState,
    String? subscriptionStatus,
    List<_i6.BillingPayment>? payments,
    String? clientName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BillingCharge',
      'id': id,
      'legalClientId': legalClientId,
      if (negotiationId != null) 'negotiationId': negotiationId,
      'amountCents': amountCents,
      'dueDate': dueDate,
      'status': status.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (idempotencyKey != null) 'idempotencyKey': idempotencyKey,
      if (kind != null) 'kind': kind,
      if (method != null) 'method': method?.toJson(),
      if (flow != null) 'flow': flow?.toJson(),
      if (installmentCount != null) 'installmentCount': installmentCount,
      if (cycle != null) 'cycle': cycle?.toJson(),
      if (providerGroupId != null) 'providerGroupId': providerGroupId,
      if (creationState != null) 'creationState': creationState,
      if (subscriptionStatus != null) 'subscriptionStatus': subscriptionStatus,
      if (payments != null)
        'payments': payments?.toJson(valueToJson: (v) => v.toJson()),
      if (clientName != null) 'clientName': clientName,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BillingChargeImpl extends BillingCharge {
  _BillingChargeImpl({
    required int id,
    required int legalClientId,
    int? negotiationId,
    required int amountCents,
    required String dueDate,
    required _i2.BillingStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? idempotencyKey,
    String? kind,
    _i3.BillingMethod? method,
    _i4.BillingFlow? flow,
    int? installmentCount,
    _i5.BillingCycle? cycle,
    String? providerGroupId,
    String? creationState,
    String? subscriptionStatus,
    List<_i6.BillingPayment>? payments,
    String? clientName,
  }) : super._(
         id: id,
         legalClientId: legalClientId,
         negotiationId: negotiationId,
         amountCents: amountCents,
         dueDate: dueDate,
         status: status,
         createdAt: createdAt,
         updatedAt: updatedAt,
         idempotencyKey: idempotencyKey,
         kind: kind,
         method: method,
         flow: flow,
         installmentCount: installmentCount,
         cycle: cycle,
         providerGroupId: providerGroupId,
         creationState: creationState,
         subscriptionStatus: subscriptionStatus,
         payments: payments,
         clientName: clientName,
       );

  /// Returns a shallow copy of this [BillingCharge]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BillingCharge copyWith({
    int? id,
    int? legalClientId,
    Object? negotiationId = _Undefined,
    int? amountCents,
    String? dueDate,
    _i2.BillingStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? idempotencyKey = _Undefined,
    Object? kind = _Undefined,
    Object? method = _Undefined,
    Object? flow = _Undefined,
    Object? installmentCount = _Undefined,
    Object? cycle = _Undefined,
    Object? providerGroupId = _Undefined,
    Object? creationState = _Undefined,
    Object? subscriptionStatus = _Undefined,
    Object? payments = _Undefined,
    Object? clientName = _Undefined,
  }) {
    return BillingCharge(
      id: id ?? this.id,
      legalClientId: legalClientId ?? this.legalClientId,
      negotiationId: negotiationId is int? ? negotiationId : this.negotiationId,
      amountCents: amountCents ?? this.amountCents,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      idempotencyKey: idempotencyKey is String?
          ? idempotencyKey
          : this.idempotencyKey,
      kind: kind is String? ? kind : this.kind,
      method: method is _i3.BillingMethod? ? method : this.method,
      flow: flow is _i4.BillingFlow? ? flow : this.flow,
      installmentCount: installmentCount is int?
          ? installmentCount
          : this.installmentCount,
      cycle: cycle is _i5.BillingCycle? ? cycle : this.cycle,
      providerGroupId: providerGroupId is String?
          ? providerGroupId
          : this.providerGroupId,
      creationState: creationState is String?
          ? creationState
          : this.creationState,
      subscriptionStatus: subscriptionStatus is String?
          ? subscriptionStatus
          : this.subscriptionStatus,
      payments: payments is List<_i6.BillingPayment>?
          ? payments
          : this.payments?.map((e0) => e0.copyWith()).toList(),
      clientName: clientName is String? ? clientName : this.clientName,
    );
  }
}
