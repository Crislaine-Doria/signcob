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

abstract class ChatParticipant
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = ChatParticipantTable();

  static const db = ChatParticipantRepository._();

  @override
  int? id;

  int conversationId;

  String authUserId;

  DateTime createdAt;

  DateTime? removedAt;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChatParticipant',
      if (id != null) 'id': id,
      'conversationId': conversationId,
      'authUserId': authUserId,
      'createdAt': createdAt.toJson(),
      if (removedAt != null) 'removedAt': removedAt?.toJson(),
    };
  }

  static ChatParticipantInclude include() {
    return ChatParticipantInclude._();
  }

  static ChatParticipantIncludeList includeList({
    _i1.WhereExpressionBuilder<ChatParticipantTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChatParticipantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChatParticipantTable>? orderByList,
    ChatParticipantInclude? include,
  }) {
    return ChatParticipantIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChatParticipant.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ChatParticipant.t),
      include: include,
    );
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

class ChatParticipantUpdateTable extends _i1.UpdateTable<ChatParticipantTable> {
  ChatParticipantUpdateTable(super.table);

  _i1.ColumnValue<int, int> conversationId(int value) => _i1.ColumnValue(
    table.conversationId,
    value,
  );

  _i1.ColumnValue<String, String> authUserId(String value) => _i1.ColumnValue(
    table.authUserId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> removedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.removedAt,
        value,
      );
}

class ChatParticipantTable extends _i1.Table<int?> {
  ChatParticipantTable({super.tableRelation})
    : super(tableName: 'chat_participant') {
    updateTable = ChatParticipantUpdateTable(this);
    conversationId = _i1.ColumnInt(
      'conversationId',
      this,
    );
    authUserId = _i1.ColumnString(
      'authUserId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    removedAt = _i1.ColumnDateTime(
      'removedAt',
      this,
    );
  }

  late final ChatParticipantUpdateTable updateTable;

  late final _i1.ColumnInt conversationId;

  late final _i1.ColumnString authUserId;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime removedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    conversationId,
    authUserId,
    createdAt,
    removedAt,
  ];
}

class ChatParticipantInclude extends _i1.IncludeObject {
  ChatParticipantInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ChatParticipant.t;
}

class ChatParticipantIncludeList extends _i1.IncludeList {
  ChatParticipantIncludeList._({
    _i1.WhereExpressionBuilder<ChatParticipantTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ChatParticipant.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ChatParticipant.t;
}

class ChatParticipantRepository {
  const ChatParticipantRepository._();

  /// Returns a list of [ChatParticipant]s matching the given query parameters.
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
  Future<List<ChatParticipant>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChatParticipantTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChatParticipantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChatParticipantTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ChatParticipant>(
      where: where?.call(ChatParticipant.t),
      orderBy: orderBy?.call(ChatParticipant.t),
      orderByList: orderByList?.call(ChatParticipant.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ChatParticipant] matching the given query parameters.
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
  Future<ChatParticipant?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChatParticipantTable>? where,
    int? offset,
    _i1.OrderByBuilder<ChatParticipantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChatParticipantTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ChatParticipant>(
      where: where?.call(ChatParticipant.t),
      orderBy: orderBy?.call(ChatParticipant.t),
      orderByList: orderByList?.call(ChatParticipant.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ChatParticipant] by its [id] or null if no such row exists.
  Future<ChatParticipant?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ChatParticipant>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ChatParticipant]s in the list and returns the inserted rows.
  ///
  /// The returned [ChatParticipant]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ChatParticipant>> insert(
    _i1.Session session,
    List<ChatParticipant> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ChatParticipant>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ChatParticipant] and returns the inserted row.
  ///
  /// The returned [ChatParticipant] will have its `id` field set.
  Future<ChatParticipant> insertRow(
    _i1.Session session,
    ChatParticipant row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ChatParticipant>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ChatParticipant]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ChatParticipant>> update(
    _i1.Session session,
    List<ChatParticipant> rows, {
    _i1.ColumnSelections<ChatParticipantTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ChatParticipant>(
      rows,
      columns: columns?.call(ChatParticipant.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChatParticipant]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ChatParticipant> updateRow(
    _i1.Session session,
    ChatParticipant row, {
    _i1.ColumnSelections<ChatParticipantTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ChatParticipant>(
      row,
      columns: columns?.call(ChatParticipant.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChatParticipant] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ChatParticipant?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ChatParticipantUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ChatParticipant>(
      id,
      columnValues: columnValues(ChatParticipant.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ChatParticipant]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ChatParticipant>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ChatParticipantUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ChatParticipantTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChatParticipantTable>? orderBy,
    _i1.OrderByListBuilder<ChatParticipantTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ChatParticipant>(
      columnValues: columnValues(ChatParticipant.t.updateTable),
      where: where(ChatParticipant.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChatParticipant.t),
      orderByList: orderByList?.call(ChatParticipant.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ChatParticipant]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ChatParticipant>> delete(
    _i1.Session session,
    List<ChatParticipant> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ChatParticipant>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ChatParticipant].
  Future<ChatParticipant> deleteRow(
    _i1.Session session,
    ChatParticipant row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ChatParticipant>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ChatParticipant>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ChatParticipantTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ChatParticipant>(
      where: where(ChatParticipant.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChatParticipantTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ChatParticipant>(
      where: where?.call(ChatParticipant.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
