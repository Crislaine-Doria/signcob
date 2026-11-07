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
import '../billing/billing_method.dart' as _i2;
import '../billing/billing_flow.dart' as _i3;
import '../billing/billing_cycle.dart' as _i4;

abstract class BillingCreateRequest implements _i1.SerializableModel {
  BillingCreateRequest._({
    required this.clientId,
    this.negotiationId,
    required this.kind,
    required this.method,
    required this.flow,
    required this.amountCents,
    required this.dueDate,
    required this.idempotencyKey,
    this.installmentCount,
    this.cycle,
  });

  factory BillingCreateRequest({
    required int clientId,
    int? negotiationId,
    required String kind,
    required _i2.BillingMethod method,
    required _i3.BillingFlow flow,
    required int amountCents,
    required String dueDate,
    required String idempotencyKey,
    int? installmentCount,
    _i4.BillingCycle? cycle,
  }) = _BillingCreateRequestImpl;

  factory BillingCreateRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return BillingCreateRequest(
      clientId: jsonSerialization['clientId'] as int,
      negotiationId: jsonSerialization['negotiationId'] as int?,
      kind: jsonSerialization['kind'] as String,
      method: _i2.BillingMethod.fromJson(
        (jsonSerialization['method'] as String),
      ),
      flow: _i3.BillingFlow.fromJson((jsonSerialization['flow'] as String)),
      amountCents: jsonSerialization['amountCents'] as int,
      dueDate: jsonSerialization['dueDate'] as String,
      idempotencyKey: jsonSerialization['idempotencyKey'] as String,
      installmentCount: jsonSerialization['installmentCount'] as int?,
      cycle: jsonSerialization['cycle'] == null
          ? null
          : _i4.BillingCycle.fromJson((jsonSerialization['cycle'] as String)),
    );
  }

  int clientId;

  int? negotiationId;

  String kind;

  _i2.BillingMethod method;

  _i3.BillingFlow flow;

  int amountCents;

  String dueDate;

  String idempotencyKey;

  int? installmentCount;

  _i4.BillingCycle? cycle;

  /// Returns a shallow copy of this [BillingCreateRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BillingCreateRequest copyWith({
    int? clientId,
    int? negotiationId,
    String? kind,
    _i2.BillingMethod? method,
    _i3.BillingFlow? flow,
    int? amountCents,
    String? dueDate,
    String? idempotencyKey,
    int? installmentCount,
    _i4.BillingCycle? cycle,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BillingCreateRequest',
      'clientId': clientId,
      if (negotiationId != null) 'negotiationId': negotiationId,
      'kind': kind,
      'method': method.toJson(),
      'flow': flow.toJson(),
      'amountCents': amountCents,
      'dueDate': dueDate,
      'idempotencyKey': idempotencyKey,
      if (installmentCount != null) 'installmentCount': installmentCount,
      if (cycle != null) 'cycle': cycle?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BillingCreateRequestImpl extends BillingCreateRequest {
  _BillingCreateRequestImpl({
    required int clientId,
    int? negotiationId,
    required String kind,
    required _i2.BillingMethod method,
    required _i3.BillingFlow flow,
    required int amountCents,
    required String dueDate,
    required String idempotencyKey,
    int? installmentCount,
    _i4.BillingCycle? cycle,
  }) : super._(
         clientId: clientId,
         negotiationId: negotiationId,
         kind: kind,
         method: method,
         flow: flow,
         amountCents: amountCents,
         dueDate: dueDate,
         idempotencyKey: idempotencyKey,
         installmentCount: installmentCount,
         cycle: cycle,
       );

  /// Returns a shallow copy of this [BillingCreateRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BillingCreateRequest copyWith({
    int? clientId,
    Object? negotiationId = _Undefined,
    String? kind,
    _i2.BillingMethod? method,
    _i3.BillingFlow? flow,
    int? amountCents,
    String? dueDate,
    String? idempotencyKey,
    Object? installmentCount = _Undefined,
    Object? cycle = _Undefined,
  }) {
    return BillingCreateRequest(
      clientId: clientId ?? this.clientId,
      negotiationId: negotiationId is int? ? negotiationId : this.negotiationId,
      kind: kind ?? this.kind,
      method: method ?? this.method,
      flow: flow ?? this.flow,
      amountCents: amountCents ?? this.amountCents,
      dueDate: dueDate ?? this.dueDate,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      installmentCount: installmentCount is int?
          ? installmentCount
          : this.installmentCount,
      cycle: cycle is _i4.BillingCycle? ? cycle : this.cycle,
    );
  }
}
