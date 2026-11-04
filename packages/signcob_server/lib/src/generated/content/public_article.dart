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

abstract class PublicArticle
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = PublicArticleTable();

  static const db = PublicArticleRepository._();

  @override
  int? id;

  String title;

  String summary;

  String body;

  String? externalUrl;

  bool published;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static PublicArticleInclude include() {
    return PublicArticleInclude._();
  }

  static PublicArticleIncludeList includeList({
    _i1.WhereExpressionBuilder<PublicArticleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PublicArticleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PublicArticleTable>? orderByList,
    PublicArticleInclude? include,
  }) {
    return PublicArticleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PublicArticle.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PublicArticle.t),
      include: include,
    );
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

class PublicArticleUpdateTable extends _i1.UpdateTable<PublicArticleTable> {
  PublicArticleUpdateTable(super.table);

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> summary(String value) => _i1.ColumnValue(
    table.summary,
    value,
  );

  _i1.ColumnValue<String, String> body(String value) => _i1.ColumnValue(
    table.body,
    value,
  );

  _i1.ColumnValue<String, String> externalUrl(String? value) => _i1.ColumnValue(
    table.externalUrl,
    value,
  );

  _i1.ColumnValue<bool, bool> published(bool value) => _i1.ColumnValue(
    table.published,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class PublicArticleTable extends _i1.Table<int?> {
  PublicArticleTable({super.tableRelation})
    : super(tableName: 'public_article') {
    updateTable = PublicArticleUpdateTable(this);
    title = _i1.ColumnString(
      'title',
      this,
    );
    summary = _i1.ColumnString(
      'summary',
      this,
    );
    body = _i1.ColumnString(
      'body',
      this,
    );
    externalUrl = _i1.ColumnString(
      'externalUrl',
      this,
    );
    published = _i1.ColumnBool(
      'published',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final PublicArticleUpdateTable updateTable;

  late final _i1.ColumnString title;

  late final _i1.ColumnString summary;

  late final _i1.ColumnString body;

  late final _i1.ColumnString externalUrl;

  late final _i1.ColumnBool published;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    title,
    summary,
    body,
    externalUrl,
    published,
    createdAt,
    updatedAt,
  ];
}

class PublicArticleInclude extends _i1.IncludeObject {
  PublicArticleInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PublicArticle.t;
}

class PublicArticleIncludeList extends _i1.IncludeList {
  PublicArticleIncludeList._({
    _i1.WhereExpressionBuilder<PublicArticleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PublicArticle.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PublicArticle.t;
}

class PublicArticleRepository {
  const PublicArticleRepository._();

  /// Returns a list of [PublicArticle]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<PublicArticle>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PublicArticleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PublicArticleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PublicArticleTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<PublicArticle>(
      where: where?.call(PublicArticle.t),
      orderBy: orderBy?.call(PublicArticle.t),
      orderByList: orderByList?.call(PublicArticle.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [PublicArticle] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<PublicArticle?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PublicArticleTable>? where,
    int? offset,
    _i1.OrderByBuilder<PublicArticleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PublicArticleTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<PublicArticle>(
      where: where?.call(PublicArticle.t),
      orderBy: orderBy?.call(PublicArticle.t),
      orderByList: orderByList?.call(PublicArticle.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [PublicArticle] by its [id] or null if no such row exists.
  Future<PublicArticle?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<PublicArticle>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [PublicArticle]s in the list and returns the inserted rows.
  ///
  /// The returned [PublicArticle]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PublicArticle>> insert(
    _i1.Session session,
    List<PublicArticle> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PublicArticle>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PublicArticle] and returns the inserted row.
  ///
  /// The returned [PublicArticle] will have its `id` field set.
  Future<PublicArticle> insertRow(
    _i1.Session session,
    PublicArticle row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PublicArticle>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PublicArticle]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PublicArticle>> update(
    _i1.Session session,
    List<PublicArticle> rows, {
    _i1.ColumnSelections<PublicArticleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PublicArticle>(
      rows,
      columns: columns?.call(PublicArticle.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PublicArticle]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PublicArticle> updateRow(
    _i1.Session session,
    PublicArticle row, {
    _i1.ColumnSelections<PublicArticleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PublicArticle>(
      row,
      columns: columns?.call(PublicArticle.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PublicArticle] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PublicArticle?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PublicArticleUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PublicArticle>(
      id,
      columnValues: columnValues(PublicArticle.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PublicArticle]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PublicArticle>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PublicArticleUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<PublicArticleTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PublicArticleTable>? orderBy,
    _i1.OrderByListBuilder<PublicArticleTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PublicArticle>(
      columnValues: columnValues(PublicArticle.t.updateTable),
      where: where(PublicArticle.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PublicArticle.t),
      orderByList: orderByList?.call(PublicArticle.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PublicArticle]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PublicArticle>> delete(
    _i1.Session session,
    List<PublicArticle> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PublicArticle>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PublicArticle].
  Future<PublicArticle> deleteRow(
    _i1.Session session,
    PublicArticle row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PublicArticle>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PublicArticle>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PublicArticleTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PublicArticle>(
      where: where(PublicArticle.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PublicArticleTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PublicArticle>(
      where: where?.call(PublicArticle.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
