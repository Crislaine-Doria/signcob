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

abstract class BillingNegotiationOption implements _i1.SerializableModel {
  BillingNegotiationOption._({
    required this.id,
    required this.title,
    required this.amountCents,
  });

  factory BillingNegotiationOption({
    required int id,
    required String title,
    required int amountCents,
  }) = _BillingNegotiationOptionImpl;

  factory BillingNegotiationOption.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return BillingNegotiationOption(
      id: jsonSerialization['id'] as int,
      title: jsonSerialization['title'] as String,
      amountCents: jsonSerialization['amountCents'] as int,
    );
  }

  int id;

  String title;

  int amountCents;

  /// Returns a shallow copy of this [BillingNegotiationOption]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BillingNegotiationOption copyWith({
    int? id,
    String? title,
    int? amountCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BillingNegotiationOption',
      'id': id,
      'title': title,
      'amountCents': amountCents,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _BillingNegotiationOptionImpl extends BillingNegotiationOption {
  _BillingNegotiationOptionImpl({
    required int id,
    required String title,
    required int amountCents,
  }) : super._(
         id: id,
         title: title,
         amountCents: amountCents,
       );

  /// Returns a shallow copy of this [BillingNegotiationOption]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BillingNegotiationOption copyWith({
    int? id,
    String? title,
    int? amountCents,
  }) {
    return BillingNegotiationOption(
      id: id ?? this.id,
      title: title ?? this.title,
      amountCents: amountCents ?? this.amountCents,
    );
  }
}
