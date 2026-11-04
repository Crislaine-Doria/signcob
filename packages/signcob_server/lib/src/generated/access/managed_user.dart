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
import 'package:signcob_server/src/generated/protocol.dart' as _i2;

abstract class ManagedUser
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ManagedUser._({
    required this.userId,
    this.email,
    required this.permissions,
  });

  factory ManagedUser({
    required String userId,
    String? email,
    required List<String> permissions,
  }) = _ManagedUserImpl;

  factory ManagedUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return ManagedUser(
      userId: jsonSerialization['userId'] as String,
      email: jsonSerialization['email'] as String?,
      permissions: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['permissions'],
      ),
    );
  }

  String userId;

  String? email;

  List<String> permissions;

  /// Returns a shallow copy of this [ManagedUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ManagedUser copyWith({
    String? userId,
    String? email,
    List<String>? permissions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ManagedUser',
      'userId': userId,
      if (email != null) 'email': email,
      'permissions': permissions.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ManagedUser',
      'userId': userId,
      if (email != null) 'email': email,
      'permissions': permissions.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ManagedUserImpl extends ManagedUser {
  _ManagedUserImpl({
    required String userId,
    String? email,
    required List<String> permissions,
  }) : super._(
         userId: userId,
         email: email,
         permissions: permissions,
       );

  /// Returns a shallow copy of this [ManagedUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ManagedUser copyWith({
    String? userId,
    Object? email = _Undefined,
    List<String>? permissions,
  }) {
    return ManagedUser(
      userId: userId ?? this.userId,
      email: email is String? ? email : this.email,
      permissions: permissions ?? this.permissions.map((e0) => e0).toList(),
    );
  }
}
