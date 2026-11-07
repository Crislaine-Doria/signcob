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

abstract class BillingPayment implements _i1.SerializableModel {
  BillingPayment._({
    required this.id,
    required this.providerPaymentId,
    required this.amountCents,
    required this.dueDate,
    this.installmentNumber,
    required this.status,
    this.confirmedAt,
    this.receivedAt,
    this.invoiceUrl,
  });

  factory BillingPayment({
    required int id,
    required String providerPaymentId,
    required int amountCents,
    required String dueDate,
    int? installmentNumber,
    required _i2.BillingStatus status,
    DateTime? confirmedAt,
    DateTime? receivedAt,
    String? invoiceUrl,
  }) = _BillingPaymentImpl;

  factory BillingPayment.fromJson(Map<String, dynamic> jsonSerialization) {
    return BillingPayment(
      id: jsonSerialization['id'] as int,
      providerPaymentId: jsonSerialization['providerPaymentId'] as String,
      amountCents: jsonSerialization['amountCents'] as int,
      dueDate: jsonSerialization['dueDate'] as String,
      installmentNumber: jsonSerialization['installmentNumber'] as int?,
      status: _i2.BillingStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      confirmedAt: jsonSerialization['confirmedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['confirmedAt'],
            ),
      receivedAt: jsonSerialization['receivedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['receivedAt']),
      invoiceUrl: jsonSerialization['invoiceUrl'] as String?,
    );
  }

  int id;

  String providerPaymentId;

  int amountCents;

  String dueDate;

  int? installmentNumber;

  _i2.BillingStatus status;

  DateTime? confirmedAt;

  DateTime? receivedAt;

  String? invoiceUrl;

  /// Returns a shallow copy of this [BillingPayment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BillingPayment copyWith({
    int? id,
    String? providerPaymentId,
    int? amountCents,
    String? dueDate,
    int? installmentNumber,
    _i2.BillingStatus? status,
    DateTime? confirmedAt,
    DateTime? receivedAt,
    String? invoiceUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BillingPayment',
      'id': id,
      'providerPaymentId': providerPaymentId,
      'amountCents': amountCents,
      'dueDate': dueDate,
      if (installmentNumber != null) 'installmentNumber': installmentNumber,
      'status': status.toJson(),
      if (confirmedAt != null) 'confirmedAt': confirmedAt?.toJson(),
      if (receivedAt != null) 'receivedAt': receivedAt?.toJson(),
      if (invoiceUrl != null) 'invoiceUrl': invoiceUrl,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BillingPaymentImpl extends BillingPayment {
  _BillingPaymentImpl({
    required int id,
    required String providerPaymentId,
    required int amountCents,
    required String dueDate,
    int? installmentNumber,
    required _i2.BillingStatus status,
    DateTime? confirmedAt,
    DateTime? receivedAt,
    String? invoiceUrl,
  }) : super._(
         id: id,
         providerPaymentId: providerPaymentId,
         amountCents: amountCents,
         dueDate: dueDate,
         installmentNumber: installmentNumber,
         status: status,
         confirmedAt: confirmedAt,
         receivedAt: receivedAt,
         invoiceUrl: invoiceUrl,
       );

  /// Returns a shallow copy of this [BillingPayment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BillingPayment copyWith({
    int? id,
    String? providerPaymentId,
    int? amountCents,
    String? dueDate,
    Object? installmentNumber = _Undefined,
    _i2.BillingStatus? status,
    Object? confirmedAt = _Undefined,
    Object? receivedAt = _Undefined,
    Object? invoiceUrl = _Undefined,
  }) {
    return BillingPayment(
      id: id ?? this.id,
      providerPaymentId: providerPaymentId ?? this.providerPaymentId,
      amountCents: amountCents ?? this.amountCents,
      dueDate: dueDate ?? this.dueDate,
      installmentNumber: installmentNumber is int?
          ? installmentNumber
          : this.installmentNumber,
      status: status ?? this.status,
      confirmedAt: confirmedAt is DateTime? ? confirmedAt : this.confirmedAt,
      receivedAt: receivedAt is DateTime? ? receivedAt : this.receivedAt,
      invoiceUrl: invoiceUrl is String? ? invoiceUrl : this.invoiceUrl,
    );
  }
}
