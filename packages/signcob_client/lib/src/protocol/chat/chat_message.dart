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

abstract class ChatMessage implements _i1.SerializableModel {
  ChatMessage._({
    this.id,
    required this.conversationId,
    required this.authorAuthUserId,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessage({
    int? id,
    required int conversationId,
    required String authorAuthUserId,
    required String content,
    required DateTime createdAt,
  }) = _ChatMessageImpl;

  factory ChatMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatMessage(
      id: jsonSerialization['id'] as int?,
      conversationId: jsonSerialization['conversationId'] as int,
      authorAuthUserId: jsonSerialization['authorAuthUserId'] as String,
      content: jsonSerialization['content'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int conversationId;

  String authorAuthUserId;

  String content;

  DateTime createdAt;

  /// Returns a shallow copy of this [ChatMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatMessage copyWith({
    int? id,
    int? conversationId,
    String? authorAuthUserId,
    String? content,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChatMessage',
      if (id != null) 'id': id,
      'conversationId': conversationId,
      'authorAuthUserId': authorAuthUserId,
      'content': content,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChatMessageImpl extends ChatMessage {
  _ChatMessageImpl({
    int? id,
    required int conversationId,
    required String authorAuthUserId,
    required String content,
    required DateTime createdAt,
  }) : super._(
         id: id,
         conversationId: conversationId,
         authorAuthUserId: authorAuthUserId,
         content: content,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ChatMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatMessage copyWith({
    Object? id = _Undefined,
    int? conversationId,
    String? authorAuthUserId,
    String? content,
    DateTime? createdAt,
  }) {
    return ChatMessage(
      id: id is int? ? id : this.id,
      conversationId: conversationId ?? this.conversationId,
      authorAuthUserId: authorAuthUserId ?? this.authorAuthUserId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
