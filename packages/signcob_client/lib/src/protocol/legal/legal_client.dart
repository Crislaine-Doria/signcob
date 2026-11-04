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

abstract class LegalClient implements _i1.SerializableModel {
  LegalClient._({
    this.id,
    required this.name,
    this.email,
    this.phone,
    this.document,
    this.assignedLawyerId,
    this.ownerAuthUserId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LegalClient({
    int? id,
    required String name,
    String? email,
    String? phone,
    String? document,
    String? assignedLawyerId,
    String? ownerAuthUserId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _LegalClientImpl;

  factory LegalClient.fromJson(Map<String, dynamic> jsonSerialization) {
    return LegalClient(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String?,
      phone: jsonSerialization['phone'] as String?,
      document: jsonSerialization['document'] as String?,
      assignedLawyerId: jsonSerialization['assignedLawyerId'] as String?,
      ownerAuthUserId: jsonSerialization['ownerAuthUserId'] as String?,
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

  String? email;

  String? phone;

  String? document;

  String? assignedLawyerId;

  String? ownerAuthUserId;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [LegalClient]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LegalClient copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? document,
    String? assignedLawyerId,
    String? ownerAuthUserId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LegalClient',
      if (id != null) 'id': id,
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (document != null) 'document': document,
      if (assignedLawyerId != null) 'assignedLawyerId': assignedLawyerId,
      if (ownerAuthUserId != null) 'ownerAuthUserId': ownerAuthUserId,
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

class _LegalClientImpl extends LegalClient {
  _LegalClientImpl({
    int? id,
    required String name,
    String? email,
    String? phone,
    String? document,
    String? assignedLawyerId,
    String? ownerAuthUserId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         name: name,
         email: email,
         phone: phone,
         document: document,
         assignedLawyerId: assignedLawyerId,
         ownerAuthUserId: ownerAuthUserId,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [LegalClient]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LegalClient copyWith({
    Object? id = _Undefined,
    String? name,
    Object? email = _Undefined,
    Object? phone = _Undefined,
    Object? document = _Undefined,
    Object? assignedLawyerId = _Undefined,
    Object? ownerAuthUserId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LegalClient(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      email: email is String? ? email : this.email,
      phone: phone is String? ? phone : this.phone,
      document: document is String? ? document : this.document,
      assignedLawyerId: assignedLawyerId is String?
          ? assignedLawyerId
          : this.assignedLawyerId,
      ownerAuthUserId: ownerAuthUserId is String?
          ? ownerAuthUserId
          : this.ownerAuthUserId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
