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

abstract class PublicArticle implements _i1.SerializableModel {
  PublicArticle._({
    this.id,
    required this.title,
    required this.summary,
    required this.body,
    this.externalUrl,
    required this.published,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PublicArticle({
    int? id,
    required String title,
    required String summary,
    required String body,
    String? externalUrl,
    required bool published,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PublicArticleImpl;

  factory PublicArticle.fromJson(Map<String, dynamic> jsonSerialization) {
    return PublicArticle(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      summary: jsonSerialization['summary'] as String,
      body: jsonSerialization['body'] as String,
      externalUrl: jsonSerialization['externalUrl'] as String?,
      published: jsonSerialization['published'] as bool,
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

  String title;

  String summary;

  String body;

  String? externalUrl;

  bool published;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [PublicArticle]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PublicArticle copyWith({
    int? id,
    String? title,
    String? summary,
    String? body,
    String? externalUrl,
    bool? published,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PublicArticle',
      if (id != null) 'id': id,
      'title': title,
      'summary': summary,
      'body': body,
      if (externalUrl != null) 'externalUrl': externalUrl,
      'published': published,
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

class _PublicArticleImpl extends PublicArticle {
  _PublicArticleImpl({
    int? id,
    required String title,
    required String summary,
    required String body,
    String? externalUrl,
    required bool published,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         title: title,
         summary: summary,
         body: body,
         externalUrl: externalUrl,
         published: published,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [PublicArticle]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PublicArticle copyWith({
    Object? id = _Undefined,
    String? title,
    String? summary,
    String? body,
    Object? externalUrl = _Undefined,
    bool? published,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PublicArticle(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      body: body ?? this.body,
      externalUrl: externalUrl is String? ? externalUrl : this.externalUrl,
      published: published ?? this.published,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
