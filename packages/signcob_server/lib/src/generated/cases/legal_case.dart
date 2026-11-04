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

abstract class LegalCase
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  LegalCase._({
    this.id,
    required this.legalClientId,
    required this.number,
    required this.tribunal,
    this.className,
    this.courtName,
    this.lastSyncedAt,
    this.syncError,
    required this.movementsJson,
  });

  factory LegalCase({
    int? id,
    required int legalClientId,
    required String number,
    required String tribunal,
    String? className,
    String? courtName,
    DateTime? lastSyncedAt,
    String? syncError,
    required String movementsJson,
  }) = _LegalCaseImpl;

  factory LegalCase.fromJson(Map<String, dynamic> jsonSerialization) {
    return LegalCase(
      id: jsonSerialization['id'] as int?,
      legalClientId: jsonSerialization['legalClientId'] as int,
      number: jsonSerialization['number'] as String,
      tribunal: jsonSerialization['tribunal'] as String,
      className: jsonSerialization['className'] as String?,
      courtName: jsonSerialization['courtName'] as String?,
      lastSyncedAt: jsonSerialization['lastSyncedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastSyncedAt'],
            ),
      syncError: jsonSerialization['syncError'] as String?,
      movementsJson: jsonSerialization['movementsJson'] as String,
    );
  }

  static final t = LegalCaseTable();

  static const db = LegalCaseRepository._();

  @override
  int? id;

  int legalClientId;

  String number;

  String tribunal;

  String? className;

  String? courtName;

  DateTime? lastSyncedAt;

  String? syncError;

  String movementsJson;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [LegalCase]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LegalCase copyWith({
    int? id,
    int? legalClientId,
    String? number,
    String? tribunal,
    String? className,
    String? courtName,
    DateTime? lastSyncedAt,
    String? syncError,
    String? movementsJson,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LegalCase',
      if (id != null) 'id': id,
      'legalClientId': legalClientId,
      'number': number,
      'tribunal': tribunal,
      if (className != null) 'className': className,
      if (courtName != null) 'courtName': courtName,
      if (lastSyncedAt != null) 'lastSyncedAt': lastSyncedAt?.toJson(),
      if (syncError != null) 'syncError': syncError,
      'movementsJson': movementsJson,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LegalCase',
      if (id != null) 'id': id,
      'legalClientId': legalClientId,
      'number': number,
      'tribunal': tribunal,
      if (className != null) 'className': className,
      if (courtName != null) 'courtName': courtName,
      if (lastSyncedAt != null) 'lastSyncedAt': lastSyncedAt?.toJson(),
      if (syncError != null) 'syncError': syncError,
      'movementsJson': movementsJson,
    };
  }

  static LegalCaseInclude include() {
    return LegalCaseInclude._();
  }

  static LegalCaseIncludeList includeList({
    _i1.WhereExpressionBuilder<LegalCaseTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LegalCaseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LegalCaseTable>? orderByList,
    LegalCaseInclude? include,
  }) {
    return LegalCaseIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LegalCase.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(LegalCase.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LegalCaseImpl extends LegalCase {
  _LegalCaseImpl({
    int? id,
    required int legalClientId,
    required String number,
    required String tribunal,
    String? className,
    String? courtName,
    DateTime? lastSyncedAt,
    String? syncError,
    required String movementsJson,
  }) : super._(
         id: id,
         legalClientId: legalClientId,
         number: number,
         tribunal: tribunal,
         className: className,
         courtName: courtName,
         lastSyncedAt: lastSyncedAt,
         syncError: syncError,
         movementsJson: movementsJson,
       );

  /// Returns a shallow copy of this [LegalCase]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LegalCase copyWith({
    Object? id = _Undefined,
    int? legalClientId,
    String? number,
    String? tribunal,
    Object? className = _Undefined,
    Object? courtName = _Undefined,
    Object? lastSyncedAt = _Undefined,
    Object? syncError = _Undefined,
    String? movementsJson,
  }) {
    return LegalCase(
      id: id is int? ? id : this.id,
      legalClientId: legalClientId ?? this.legalClientId,
      number: number ?? this.number,
      tribunal: tribunal ?? this.tribunal,
      className: className is String? ? className : this.className,
      courtName: courtName is String? ? courtName : this.courtName,
      lastSyncedAt: lastSyncedAt is DateTime?
          ? lastSyncedAt
          : this.lastSyncedAt,
      syncError: syncError is String? ? syncError : this.syncError,
      movementsJson: movementsJson ?? this.movementsJson,
    );
  }
}

class LegalCaseUpdateTable extends _i1.UpdateTable<LegalCaseTable> {
  LegalCaseUpdateTable(super.table);

  _i1.ColumnValue<int, int> legalClientId(int value) => _i1.ColumnValue(
    table.legalClientId,
    value,
  );

  _i1.ColumnValue<String, String> number(String value) => _i1.ColumnValue(
    table.number,
    value,
  );

  _i1.ColumnValue<String, String> tribunal(String value) => _i1.ColumnValue(
    table.tribunal,
    value,
  );

  _i1.ColumnValue<String, String> className(String? value) => _i1.ColumnValue(
    table.className,
    value,
  );

  _i1.ColumnValue<String, String> courtName(String? value) => _i1.ColumnValue(
    table.courtName,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> lastSyncedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.lastSyncedAt,
        value,
      );

  _i1.ColumnValue<String, String> syncError(String? value) => _i1.ColumnValue(
    table.syncError,
    value,
  );

  _i1.ColumnValue<String, String> movementsJson(String value) =>
      _i1.ColumnValue(
        table.movementsJson,
        value,
      );
}

class LegalCaseTable extends _i1.Table<int?> {
  LegalCaseTable({super.tableRelation}) : super(tableName: 'legal_case') {
    updateTable = LegalCaseUpdateTable(this);
    legalClientId = _i1.ColumnInt(
      'legalClientId',
      this,
    );
    number = _i1.ColumnString(
      'number',
      this,
    );
    tribunal = _i1.ColumnString(
      'tribunal',
      this,
    );
    className = _i1.ColumnString(
      'className',
      this,
    );
    courtName = _i1.ColumnString(
      'courtName',
      this,
    );
    lastSyncedAt = _i1.ColumnDateTime(
      'lastSyncedAt',
      this,
    );
    syncError = _i1.ColumnString(
      'syncError',
      this,
    );
    movementsJson = _i1.ColumnString(
      'movementsJson',
      this,
    );
  }

  late final LegalCaseUpdateTable updateTable;

  late final _i1.ColumnInt legalClientId;

  late final _i1.ColumnString number;

  late final _i1.ColumnString tribunal;

  late final _i1.ColumnString className;

  late final _i1.ColumnString courtName;

  late final _i1.ColumnDateTime lastSyncedAt;

  late final _i1.ColumnString syncError;

  late final _i1.ColumnString movementsJson;

  @override
  List<_i1.Column> get columns => [
    id,
    legalClientId,
    number,
    tribunal,
    className,
    courtName,
    lastSyncedAt,
    syncError,
    movementsJson,
  ];
}

class LegalCaseInclude extends _i1.IncludeObject {
  LegalCaseInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => LegalCase.t;
}

class LegalCaseIncludeList extends _i1.IncludeList {
  LegalCaseIncludeList._({
    _i1.WhereExpressionBuilder<LegalCaseTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LegalCase.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => LegalCase.t;
}

class LegalCaseRepository {
  const LegalCaseRepository._();

  /// Returns a list of [LegalCase]s matching the given query parameters.
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
  Future<List<LegalCase>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LegalCaseTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LegalCaseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LegalCaseTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<LegalCase>(
      where: where?.call(LegalCase.t),
      orderBy: orderBy?.call(LegalCase.t),
      orderByList: orderByList?.call(LegalCase.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [LegalCase] matching the given query parameters.
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
  Future<LegalCase?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LegalCaseTable>? where,
    int? offset,
    _i1.OrderByBuilder<LegalCaseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LegalCaseTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<LegalCase>(
      where: where?.call(LegalCase.t),
      orderBy: orderBy?.call(LegalCase.t),
      orderByList: orderByList?.call(LegalCase.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [LegalCase] by its [id] or null if no such row exists.
  Future<LegalCase?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<LegalCase>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [LegalCase]s in the list and returns the inserted rows.
  ///
  /// The returned [LegalCase]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<LegalCase>> insert(
    _i1.Session session,
    List<LegalCase> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<LegalCase>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [LegalCase] and returns the inserted row.
  ///
  /// The returned [LegalCase] will have its `id` field set.
  Future<LegalCase> insertRow(
    _i1.Session session,
    LegalCase row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<LegalCase>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [LegalCase]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<LegalCase>> update(
    _i1.Session session,
    List<LegalCase> rows, {
    _i1.ColumnSelections<LegalCaseTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<LegalCase>(
      rows,
      columns: columns?.call(LegalCase.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LegalCase]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LegalCase> updateRow(
    _i1.Session session,
    LegalCase row, {
    _i1.ColumnSelections<LegalCaseTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<LegalCase>(
      row,
      columns: columns?.call(LegalCase.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LegalCase] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LegalCase?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<LegalCaseUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<LegalCase>(
      id,
      columnValues: columnValues(LegalCase.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LegalCase]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<LegalCase>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<LegalCaseUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<LegalCaseTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LegalCaseTable>? orderBy,
    _i1.OrderByListBuilder<LegalCaseTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<LegalCase>(
      columnValues: columnValues(LegalCase.t.updateTable),
      where: where(LegalCase.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LegalCase.t),
      orderByList: orderByList?.call(LegalCase.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [LegalCase]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<LegalCase>> delete(
    _i1.Session session,
    List<LegalCase> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<LegalCase>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [LegalCase].
  Future<LegalCase> deleteRow(
    _i1.Session session,
    LegalCase row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LegalCase>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<LegalCase>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<LegalCaseTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<LegalCase>(
      where: where(LegalCase.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LegalCaseTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<LegalCase>(
      where: where?.call(LegalCase.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
