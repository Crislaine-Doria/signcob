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

abstract class ChatConversation implements _i1.SerializableModel {
  ChatConversation._({
    this.id,
    required this.title,
    this.legalClientId,
    required this.createdAt,
  });

  factory ChatConversation({
    int? id,
    required String title,
    int? legalClientId,
    required DateTime createdAt,
  }) = _ChatConversationImpl;

  factory ChatConversation.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatConversation(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      legalClientId: jsonSerialization['legalClientId'] as int?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String title;

  int? legalClientId;

  DateTime createdAt;

  /// Returns a shallow copy of this [ChatConversation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatConversation copyWith({
    int? id,
    String? title,
    int? legalClientId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChatConversation',
      if (id != null) 'id': id,
      'title': title,
      if (legalClientId != null) 'legalClientId': legalClientId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChatConversationImpl extends ChatConversation {
  _ChatConversationImpl({
    int? id,
    required String title,
    int? legalClientId,
    required DateTime createdAt,
  }) : super._(
         id: id,
         title: title,
         legalClientId: legalClientId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ChatConversation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatConversation copyWith({
    Object? id = _Undefined,
    String? title,
    Object? legalClientId = _Undefined,
    DateTime? createdAt,
  }) {
    return ChatConversation(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      legalClientId: legalClientId is int? ? legalClientId : this.legalClientId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
