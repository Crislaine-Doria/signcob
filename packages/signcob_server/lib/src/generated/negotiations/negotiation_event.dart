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

abstract class NegotiationEvent
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  NegotiationEvent._({
    this.id,
    required this.negotiationId,
    this.fromStatus,
    required this.toStatus,
    required this.occurredAt,
    required this.actorAuthUserId,
    this.note,
  });

  factory NegotiationEvent({
    int? id,
    required int negotiationId,
    String? fromStatus,
    required String toStatus,
    required DateTime occurredAt,
    required String actorAuthUserId,
    String? note,
  }) = _NegotiationEventImpl;

  factory NegotiationEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return NegotiationEvent(
      id: jsonSerialization['id'] as int?,
      negotiationId: jsonSerialization['negotiationId'] as int,
      fromStatus: jsonSerialization['fromStatus'] as String?,
      toStatus: jsonSerialization['toStatus'] as String,
      occurredAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['occurredAt'],
      ),
      actorAuthUserId: jsonSerialization['actorAuthUserId'] as String,
      note: jsonSerialization['note'] as String?,
    );
  }

  static final t = NegotiationEventTable();

  static const db = NegotiationEventRepository._();

  @override
  int? id;

  int negotiationId;

  String? fromStatus;

  String toStatus;

  DateTime occurredAt;

  String actorAuthUserId;

  String? note;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [NegotiationEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NegotiationEvent copyWith({
    int? id,
    int? negotiationId,
    String? fromStatus,
    String? toStatus,
    DateTime? occurredAt,
    String? actorAuthUserId,
    String? note,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NegotiationEvent',
      if (id != null) 'id': id,
      'negotiationId': negotiationId,
      if (fromStatus != null) 'fromStatus': fromStatus,
      'toStatus': toStatus,
      'occurredAt': occurredAt.toJson(),
      'actorAuthUserId': actorAuthUserId,
      if (note != null) 'note': note,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NegotiationEvent',
      if (id != null) 'id': id,
      'negotiationId': negotiationId,
      if (fromStatus != null) 'fromStatus': fromStatus,
      'toStatus': toStatus,
      'occurredAt': occurredAt.toJson(),
      'actorAuthUserId': actorAuthUserId,
      if (note != null) 'note': note,
    };
  }

  static NegotiationEventInclude include() {
    return NegotiationEventInclude._();
  }

  static NegotiationEventIncludeList includeList({
    _i1.WhereExpressionBuilder<NegotiationEventTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NegotiationEventTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NegotiationEventTable>? orderByList,
    NegotiationEventInclude? include,
  }) {
    return NegotiationEventIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NegotiationEvent.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(NegotiationEvent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NegotiationEventImpl extends NegotiationEvent {
  _NegotiationEventImpl({
    int? id,
    required int negotiationId,
    String? fromStatus,
    required String toStatus,
    required DateTime occurredAt,
    required String actorAuthUserId,
    String? note,
  }) : super._(
         id: id,
         negotiationId: negotiationId,
         fromStatus: fromStatus,
         toStatus: toStatus,
         occurredAt: occurredAt,
         actorAuthUserId: actorAuthUserId,
         note: note,
       );

  /// Returns a shallow copy of this [NegotiationEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NegotiationEvent copyWith({
    Object? id = _Undefined,
    int? negotiationId,
    Object? fromStatus = _Undefined,
    String? toStatus,
    DateTime? occurredAt,
    String? actorAuthUserId,
    Object? note = _Undefined,
  }) {
    return NegotiationEvent(
      id: id is int? ? id : this.id,
      negotiationId: negotiationId ?? this.negotiationId,
      fromStatus: fromStatus is String? ? fromStatus : this.fromStatus,
      toStatus: toStatus ?? this.toStatus,
      occurredAt: occurredAt ?? this.occurredAt,
      actorAuthUserId: actorAuthUserId ?? this.actorAuthUserId,
      note: note is String? ? note : this.note,
    );
  }
}

class NegotiationEventUpdateTable
    extends _i1.UpdateTable<NegotiationEventTable> {
  NegotiationEventUpdateTable(super.table);

  _i1.ColumnValue<int, int> negotiationId(int value) => _i1.ColumnValue(
    table.negotiationId,
    value,
  );

  _i1.ColumnValue<String, String> fromStatus(String? value) => _i1.ColumnValue(
    table.fromStatus,
    value,
  );

  _i1.ColumnValue<String, String> toStatus(String value) => _i1.ColumnValue(
    table.toStatus,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> occurredAt(DateTime value) =>
      _i1.ColumnValue(
        table.occurredAt,
        value,
      );

  _i1.ColumnValue<String, String> actorAuthUserId(String value) =>
      _i1.ColumnValue(
        table.actorAuthUserId,
        value,
      );

  _i1.ColumnValue<String, String> note(String? value) => _i1.ColumnValue(
    table.note,
    value,
  );
}

class NegotiationEventTable extends _i1.Table<int?> {
  NegotiationEventTable({super.tableRelation})
    : super(tableName: 'negotiation_event') {
    updateTable = NegotiationEventUpdateTable(this);
    negotiationId = _i1.ColumnInt(
      'negotiationId',
      this,
    );
    fromStatus = _i1.ColumnString(
      'fromStatus',
      this,
    );
    toStatus = _i1.ColumnString(
      'toStatus',
      this,
    );
    occurredAt = _i1.ColumnDateTime(
      'occurredAt',
      this,
    );
    actorAuthUserId = _i1.ColumnString(
      'actorAuthUserId',
      this,
    );
    note = _i1.ColumnString(
      'note',
      this,
    );
  }

  late final NegotiationEventUpdateTable updateTable;

  late final _i1.ColumnInt negotiationId;

  late final _i1.ColumnString fromStatus;

  late final _i1.ColumnString toStatus;

  late final _i1.ColumnDateTime occurredAt;

  late final _i1.ColumnString actorAuthUserId;

  late final _i1.ColumnString note;

  @override
  List<_i1.Column> get columns => [
    id,
    negotiationId,
    fromStatus,
    toStatus,
    occurredAt,
    actorAuthUserId,
    note,
  ];
}

class NegotiationEventInclude extends _i1.IncludeObject {
  NegotiationEventInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => NegotiationEvent.t;
}

class NegotiationEventIncludeList extends _i1.IncludeList {
  NegotiationEventIncludeList._({
    _i1.WhereExpressionBuilder<NegotiationEventTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NegotiationEvent.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => NegotiationEvent.t;
}

class NegotiationEventRepository {
  const NegotiationEventRepository._();

  /// Returns a list of [NegotiationEvent]s matching the given query parameters.
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
  Future<List<NegotiationEvent>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NegotiationEventTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NegotiationEventTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NegotiationEventTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<NegotiationEvent>(
      where: where?.call(NegotiationEvent.t),
      orderBy: orderBy?.call(NegotiationEvent.t),
      orderByList: orderByList?.call(NegotiationEvent.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [NegotiationEvent] matching the given query parameters.
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
  Future<NegotiationEvent?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NegotiationEventTable>? where,
    int? offset,
    _i1.OrderByBuilder<NegotiationEventTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NegotiationEventTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<NegotiationEvent>(
      where: where?.call(NegotiationEvent.t),
      orderBy: orderBy?.call(NegotiationEvent.t),
      orderByList: orderByList?.call(NegotiationEvent.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [NegotiationEvent] by its [id] or null if no such row exists.
  Future<NegotiationEvent?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<NegotiationEvent>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [NegotiationEvent]s in the list and returns the inserted rows.
  ///
  /// The returned [NegotiationEvent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<NegotiationEvent>> insert(
    _i1.Session session,
    List<NegotiationEvent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<NegotiationEvent>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [NegotiationEvent] and returns the inserted row.
  ///
  /// The returned [NegotiationEvent] will have its `id` field set.
  Future<NegotiationEvent> insertRow(
    _i1.Session session,
    NegotiationEvent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<NegotiationEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [NegotiationEvent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<NegotiationEvent>> update(
    _i1.Session session,
    List<NegotiationEvent> rows, {
    _i1.ColumnSelections<NegotiationEventTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<NegotiationEvent>(
      rows,
      columns: columns?.call(NegotiationEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NegotiationEvent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NegotiationEvent> updateRow(
    _i1.Session session,
    NegotiationEvent row, {
    _i1.ColumnSelections<NegotiationEventTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<NegotiationEvent>(
      row,
      columns: columns?.call(NegotiationEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NegotiationEvent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NegotiationEvent?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<NegotiationEventUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<NegotiationEvent>(
      id,
      columnValues: columnValues(NegotiationEvent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NegotiationEvent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<NegotiationEvent>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<NegotiationEventUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<NegotiationEventTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NegotiationEventTable>? orderBy,
    _i1.OrderByListBuilder<NegotiationEventTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<NegotiationEvent>(
      columnValues: columnValues(NegotiationEvent.t.updateTable),
      where: where(NegotiationEvent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NegotiationEvent.t),
      orderByList: orderByList?.call(NegotiationEvent.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [NegotiationEvent]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<NegotiationEvent>> delete(
    _i1.Session session,
    List<NegotiationEvent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<NegotiationEvent>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [NegotiationEvent].
  Future<NegotiationEvent> deleteRow(
    _i1.Session session,
    NegotiationEvent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NegotiationEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<NegotiationEvent>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<NegotiationEventTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<NegotiationEvent>(
      where: where(NegotiationEvent.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NegotiationEventTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<NegotiationEvent>(
      where: where?.call(NegotiationEvent.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
