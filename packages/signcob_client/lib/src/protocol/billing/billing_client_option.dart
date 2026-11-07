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

abstract class BillingClientOption implements _i1.SerializableModel {
  BillingClientOption._({
    required this.id,
    required this.name,
    required this.readyForBilling,
  });

  factory BillingClientOption({
    required int id,
    required String name,
    required bool readyForBilling,
  }) = _BillingClientOptionImpl;

  factory BillingClientOption.fromJson(Map<String, dynamic> jsonSerialization) {
    return BillingClientOption(
      id: jsonSerialization['id'] as int,
      name: jsonSerialization['name'] as String,
      readyForBilling: jsonSerialization['readyForBilling'] as bool,
    );
  }

  int id;

  String name;

  bool readyForBilling;

  /// Returns a shallow copy of this [BillingClientOption]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BillingClientOption copyWith({
    int? id,
    String? name,
    bool? readyForBilling,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BillingClientOption',
      'id': id,
      'name': name,
      'readyForBilling': readyForBilling,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _BillingClientOptionImpl extends BillingClientOption {
  _BillingClientOptionImpl({
    required int id,
    required String name,
    required bool readyForBilling,
  }) : super._(
         id: id,
         name: name,
         readyForBilling: readyForBilling,
       );

  /// Returns a shallow copy of this [BillingClientOption]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BillingClientOption copyWith({
    int? id,
    String? name,
    bool? readyForBilling,
  }) {
    return BillingClientOption(
      id: id ?? this.id,
      name: name ?? this.name,
      readyForBilling: readyForBilling ?? this.readyForBilling,
    );
  }
}
