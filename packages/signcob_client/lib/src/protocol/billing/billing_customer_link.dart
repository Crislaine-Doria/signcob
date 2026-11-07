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

abstract class BillingCustomerLink implements _i1.SerializableModel {
  BillingCustomerLink._({
    required this.clientId,
    required this.state,
  });

  factory BillingCustomerLink({
    required int clientId,
    required String state,
  }) = _BillingCustomerLinkImpl;

  factory BillingCustomerLink.fromJson(Map<String, dynamic> jsonSerialization) {
    return BillingCustomerLink(
      clientId: jsonSerialization['clientId'] as int,
      state: jsonSerialization['state'] as String,
    );
  }

  int clientId;

  String state;

  /// Returns a shallow copy of this [BillingCustomerLink]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BillingCustomerLink copyWith({
    int? clientId,
    String? state,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BillingCustomerLink',
      'clientId': clientId,
      'state': state,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _BillingCustomerLinkImpl extends BillingCustomerLink {
  _BillingCustomerLinkImpl({
    required int clientId,
    required String state,
  }) : super._(
         clientId: clientId,
         state: state,
       );

  /// Returns a shallow copy of this [BillingCustomerLink]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BillingCustomerLink copyWith({
    int? clientId,
    String? state,
  }) {
    return BillingCustomerLink(
      clientId: clientId ?? this.clientId,
      state: state ?? this.state,
    );
  }
}
