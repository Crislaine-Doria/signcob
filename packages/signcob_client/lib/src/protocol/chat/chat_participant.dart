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

abstract class ChatParticipant implements _i1.SerializableModel {
  ChatParticipant._({
    this.id,
    required this.conversationId,
    required this.authUserId,
    required this.createdAt,
    this.removedAt,
  });

  factory ChatParticipant({
    int? id,
    required int conversationId,
    required String authUserId,
    required DateTime createdAt,
    DateTime? removedAt,
  }) = _ChatParticipantImpl;

  factory ChatParticipant.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatParticipant(
      id: jsonSerialization['id'] as int?,
      conversationId: jsonSerialization['conversationId'] as int,
      authUserId: jsonSerialization['authUserId'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      removedAt: jsonSerialization['removedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['removedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int conversationId;

  String authUserId;

  DateTime createdAt;

  DateTime? removedAt;

  /// Returns a shallow copy of this [ChatParticipant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatParticipant copyWith({
    int? id,
    int? conversationId,
    String? authUserId,
    DateTime? createdAt,
    DateTime? removedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChatParticipant',
      if (id != null) 'id': id,
      'conversationId': conversationId,
      'authUserId': authUserId,
      'createdAt': createdAt.toJson(),
      if (removedAt != null) 'removedAt': removedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChatParticipantImpl extends ChatParticipant {
  _ChatParticipantImpl({
    int? id,
    required int conversationId,
    required String authUserId,
    required DateTime createdAt,
    DateTime? removedAt,
  }) : super._(
         id: id,
         conversationId: conversationId,
         authUserId: authUserId,
         createdAt: createdAt,
         removedAt: removedAt,
       );

  /// Returns a shallow copy of this [ChatParticipant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatParticipant copyWith({
    Object? id = _Undefined,
    int? conversationId,
    String? authUserId,
    DateTime? createdAt,
    Object? removedAt = _Undefined,
  }) {
    return ChatParticipant(
      id: id is int? ? id : this.id,
      conversationId: conversationId ?? this.conversationId,
      authUserId: authUserId ?? this.authUserId,
      createdAt: createdAt ?? this.createdAt,
      removedAt: removedAt is DateTime? ? removedAt : this.removedAt,
    );
  }
}
