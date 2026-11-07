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

abstract class ChatConversation
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ChatConversation._({
    this.id,
    required this.title,
    this.legalClientId,
    required this.createdAt,
    this.createdByAuthUserId,
    this.creationRequestId,
  });

  factory ChatConversation({
    int? id,
    required String title,
    int? legalClientId,
    required DateTime createdAt,
    String? createdByAuthUserId,
    String? creationRequestId,
  }) = _ChatConversationImpl;

  factory ChatConversation.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatConversation(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      legalClientId: jsonSerialization['legalClientId'] as int?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      createdByAuthUserId: jsonSerialization['createdByAuthUserId'] as String?,
      creationRequestId: jsonSerialization['creationRequestId'] as String?,
    );
  }

  static final t = ChatConversationTable();

  static const db = ChatConversationRepository._();

  @override
  int? id;

  String title;

  int? legalClientId;

  DateTime createdAt;

  String? createdByAuthUserId;

  String? creationRequestId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ChatConversation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatConversation copyWith({
    int? id,
    String? title,
    int? legalClientId,
    DateTime? createdAt,
    String? createdByAuthUserId,
    String? creationRequestId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChatConversation',
      if (id != null) 'id': id,
      'title': title,
      if (legalClientId != null) 'legalClientId': legalClientId,
      'createdAt': createdAt.toJson(),
      if (createdByAuthUserId != null)
        'createdByAuthUserId': createdByAuthUserId,
      if (creationRequestId != null) 'creationRequestId': creationRequestId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChatConversation',
      if (id != null) 'id': id,
      'title': title,
      if (legalClientId != null) 'legalClientId': legalClientId,
      'createdAt': createdAt.toJson(),
    };
  }

  static ChatConversationInclude include() {
    return ChatConversationInclude._();
  }

  static ChatConversationIncludeList includeList({
    _i1.WhereExpressionBuilder<ChatConversationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChatConversationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChatConversationTable>? orderByList,
    ChatConversationInclude? include,
  }) {
    return ChatConversationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChatConversation.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ChatConversation.t),
      include: include,
    );
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
    String? createdByAuthUserId,
    String? creationRequestId,
  }) : super._(
         id: id,
         title: title,
         legalClientId: legalClientId,
         createdAt: createdAt,
         createdByAuthUserId: createdByAuthUserId,
         creationRequestId: creationRequestId,
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
    Object? createdByAuthUserId = _Undefined,
    Object? creationRequestId = _Undefined,
  }) {
    return ChatConversation(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      legalClientId: legalClientId is int? ? legalClientId : this.legalClientId,
      createdAt: createdAt ?? this.createdAt,
      createdByAuthUserId: createdByAuthUserId is String?
          ? createdByAuthUserId
          : this.createdByAuthUserId,
      creationRequestId: creationRequestId is String?
          ? creationRequestId
          : this.creationRequestId,
    );
  }
}

class ChatConversationUpdateTable
    extends _i1.UpdateTable<ChatConversationTable> {
  ChatConversationUpdateTable(super.table);

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<int, int> legalClientId(int? value) => _i1.ColumnValue(
    table.legalClientId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<String, String> createdByAuthUserId(String? value) =>
      _i1.ColumnValue(
        table.createdByAuthUserId,
        value,
      );

  _i1.ColumnValue<String, String> creationRequestId(String? value) =>
      _i1.ColumnValue(
        table.creationRequestId,
        value,
      );
}

class ChatConversationTable extends _i1.Table<int?> {
  ChatConversationTable({super.tableRelation})
    : super(tableName: 'chat_conversation') {
    updateTable = ChatConversationUpdateTable(this);
    title = _i1.ColumnString(
      'title',
      this,
    );
    legalClientId = _i1.ColumnInt(
      'legalClientId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    createdByAuthUserId = _i1.ColumnString(
      'createdByAuthUserId',
      this,
    );
    creationRequestId = _i1.ColumnString(
      'creationRequestId',
      this,
    );
  }

  late final ChatConversationUpdateTable updateTable;

  late final _i1.ColumnString title;

  late final _i1.ColumnInt legalClientId;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnString createdByAuthUserId;

  late final _i1.ColumnString creationRequestId;

  @override
  List<_i1.Column> get columns => [
    id,
    title,
    legalClientId,
    createdAt,
    createdByAuthUserId,
    creationRequestId,
  ];
}

class ChatConversationInclude extends _i1.IncludeObject {
  ChatConversationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ChatConversation.t;
}

class ChatConversationIncludeList extends _i1.IncludeList {
  ChatConversationIncludeList._({
    _i1.WhereExpressionBuilder<ChatConversationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ChatConversation.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ChatConversation.t;
}

class ChatConversationRepository {
  const ChatConversationRepository._();

  /// Returns a list of [ChatConversation]s matching the given query parameters.
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
  Future<List<ChatConversation>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChatConversationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChatConversationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChatConversationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ChatConversation>(
      where: where?.call(ChatConversation.t),
      orderBy: orderBy?.call(ChatConversation.t),
      orderByList: orderByList?.call(ChatConversation.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ChatConversation] matching the given query parameters.
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
  Future<ChatConversation?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChatConversationTable>? where,
    int? offset,
    _i1.OrderByBuilder<ChatConversationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChatConversationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ChatConversation>(
      where: where?.call(ChatConversation.t),
      orderBy: orderBy?.call(ChatConversation.t),
      orderByList: orderByList?.call(ChatConversation.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ChatConversation] by its [id] or null if no such row exists.
  Future<ChatConversation?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ChatConversation>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ChatConversation]s in the list and returns the inserted rows.
  ///
  /// The returned [ChatConversation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ChatConversation>> insert(
    _i1.Session session,
    List<ChatConversation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ChatConversation>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ChatConversation] and returns the inserted row.
  ///
  /// The returned [ChatConversation] will have its `id` field set.
  Future<ChatConversation> insertRow(
    _i1.Session session,
    ChatConversation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ChatConversation>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ChatConversation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ChatConversation>> update(
    _i1.Session session,
    List<ChatConversation> rows, {
    _i1.ColumnSelections<ChatConversationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ChatConversation>(
      rows,
      columns: columns?.call(ChatConversation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChatConversation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ChatConversation> updateRow(
    _i1.Session session,
    ChatConversation row, {
    _i1.ColumnSelections<ChatConversationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ChatConversation>(
      row,
      columns: columns?.call(ChatConversation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChatConversation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ChatConversation?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ChatConversationUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ChatConversation>(
      id,
      columnValues: columnValues(ChatConversation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ChatConversation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ChatConversation>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ChatConversationUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ChatConversationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChatConversationTable>? orderBy,
    _i1.OrderByListBuilder<ChatConversationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ChatConversation>(
      columnValues: columnValues(ChatConversation.t.updateTable),
      where: where(ChatConversation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChatConversation.t),
      orderByList: orderByList?.call(ChatConversation.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ChatConversation]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ChatConversation>> delete(
    _i1.Session session,
    List<ChatConversation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ChatConversation>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ChatConversation].
  Future<ChatConversation> deleteRow(
    _i1.Session session,
    ChatConversation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ChatConversation>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ChatConversation>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ChatConversationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ChatConversation>(
      where: where(ChatConversation.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChatConversationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ChatConversation>(
      where: where?.call(ChatConversation.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
