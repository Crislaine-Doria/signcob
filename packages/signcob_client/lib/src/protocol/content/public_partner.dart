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

abstract class PublicPartner implements _i1.SerializableModel {
  PublicPartner._({
    this.id,
    required this.name,
    required this.description,
    required this.website,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PublicPartner({
    int? id,
    required String name,
    required String description,
    required String website,
    required bool active,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PublicPartnerImpl;

  factory PublicPartner.fromJson(Map<String, dynamic> jsonSerialization) {
    return PublicPartner(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      website: jsonSerialization['website'] as String,
      active: jsonSerialization['active'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String description;

  String website;

  bool active;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [PublicPartner]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PublicPartner copyWith({
    int? id,
    String? name,
    String? description,
    String? website,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PublicPartner',
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'website': website,
      'active': active,
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

class _PublicPartnerImpl extends PublicPartner {
  _PublicPartnerImpl({
    int? id,
    required String name,
    required String description,
    required String website,
    required bool active,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         name: name,
         description: description,
         website: website,
         active: active,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [PublicPartner]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PublicPartner copyWith({
    Object? id = _Undefined,
    String? name,
    String? description,
    String? website,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PublicPartner(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      website: website ?? this.website,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
