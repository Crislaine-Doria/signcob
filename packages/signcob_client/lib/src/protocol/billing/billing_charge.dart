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
  }) : super._(
         id: id,
         legalClientId: legalClientId,
         negotiationId: negotiationId,
         amountCents: amountCents,
         dueDate: dueDate,
         status: status,
         createdAt: createdAt,
         updatedAt: updatedAt,
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
    );
  }
}
