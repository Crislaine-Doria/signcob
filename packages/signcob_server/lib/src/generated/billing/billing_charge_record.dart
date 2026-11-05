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
import '../billing/billing_status.dart' as _i2;

abstract class BillingChargeRecord
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  BillingChargeRecord._({
    this.id,
    required this.legalClientId,
    this.negotiationId,
    required this.idempotencyKey,
    this.providerId,
    required this.amountCents,
    required this.dueDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BillingChargeRecord({
    int? id,
    required int legalClientId,
    int? negotiationId,
    required String idempotencyKey,
    String? providerId,
    required int amountCents,
    required String dueDate,
    required _i2.BillingStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _BillingChargeRecordImpl;

  factory BillingChargeRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return BillingChargeRecord(
      id: jsonSerialization['id'] as int?,
      legalClientId: jsonSerialization['legalClientId'] as int,
      negotiationId: jsonSerialization['negotiationId'] as int?,
      idempotencyKey: jsonSerialization['idempotencyKey'] as String,
      providerId: jsonSerialization['providerId'] as String?,
      amountCents: jsonSerialization['amountCents'] as int,
      dueDate: jsonSerialization['dueDate'] as String,
      status: _i2.BillingStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = BillingChargeRecordTable();

  static const db = BillingChargeRecordRepository._();

  @override
  int? id;

  int legalClientId;

  int? negotiationId;

  String idempotencyKey;

  String? providerId;

  int amountCents;

  String dueDate;

  _i2.BillingStatus status;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [BillingChargeRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BillingChargeRecord copyWith({
    int? id,
    int? legalClientId,
    int? negotiationId,
    String? idempotencyKey,
    String? providerId,
    int? amountCents,
    String? dueDate,
    _i2.BillingStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BillingChargeRecord',
      if (id != null) 'id': id,
      'legalClientId': legalClientId,
      if (negotiationId != null) 'negotiationId': negotiationId,
      'idempotencyKey': idempotencyKey,
      if (providerId != null) 'providerId': providerId,
      'amountCents': amountCents,
      'dueDate': dueDate,
      'status': status.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static BillingChargeRecordInclude include() {
    return BillingChargeRecordInclude._();
  }

  static BillingChargeRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<BillingChargeRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BillingChargeRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BillingChargeRecordTable>? orderByList,
    BillingChargeRecordInclude? include,
  }) {
    return BillingChargeRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BillingChargeRecord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BillingChargeRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BillingChargeRecordImpl extends BillingChargeRecord {
  _BillingChargeRecordImpl({
    int? id,
    required int legalClientId,
    int? negotiationId,
    required String idempotencyKey,
    String? providerId,
    required int amountCents,
    required String dueDate,
    required _i2.BillingStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         legalClientId: legalClientId,
         negotiationId: negotiationId,
         idempotencyKey: idempotencyKey,
         providerId: providerId,
         amountCents: amountCents,
         dueDate: dueDate,
         status: status,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [BillingChargeRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BillingChargeRecord copyWith({
    Object? id = _Undefined,
    int? legalClientId,
    Object? negotiationId = _Undefined,
    String? idempotencyKey,
    Object? providerId = _Undefined,
    int? amountCents,
    String? dueDate,
    _i2.BillingStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BillingChargeRecord(
      id: id is int? ? id : this.id,
      legalClientId: legalClientId ?? this.legalClientId,
      negotiationId: negotiationId is int? ? negotiationId : this.negotiationId,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      providerId: providerId is String? ? providerId : this.providerId,
      amountCents: amountCents ?? this.amountCents,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class BillingChargeRecordUpdateTable
    extends _i1.UpdateTable<BillingChargeRecordTable> {
  BillingChargeRecordUpdateTable(super.table);

  _i1.ColumnValue<int, int> legalClientId(int value) => _i1.ColumnValue(
    table.legalClientId,
    value,
  );

  _i1.ColumnValue<int, int> negotiationId(int? value) => _i1.ColumnValue(
    table.negotiationId,
    value,
  );

  _i1.ColumnValue<String, String> idempotencyKey(String value) =>
      _i1.ColumnValue(
        table.idempotencyKey,
        value,
      );

  _i1.ColumnValue<String, String> providerId(String? value) => _i1.ColumnValue(
    table.providerId,
    value,
  );

  _i1.ColumnValue<int, int> amountCents(int value) => _i1.ColumnValue(
    table.amountCents,
    value,
  );

  _i1.ColumnValue<String, String> dueDate(String value) => _i1.ColumnValue(
    table.dueDate,
    value,
  );

  _i1.ColumnValue<_i2.BillingStatus, _i2.BillingStatus> status(
    _i2.BillingStatus value,
  ) => _i1.ColumnValue(
    table.status,
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

class BillingChargeRecordTable extends _i1.Table<int?> {
  BillingChargeRecordTable({super.tableRelation})
    : super(tableName: 'billing_charge') {
    updateTable = BillingChargeRecordUpdateTable(this);
    legalClientId = _i1.ColumnInt(
      'legalClientId',
      this,
    );
    negotiationId = _i1.ColumnInt(
      'negotiationId',
      this,
    );
    idempotencyKey = _i1.ColumnString(
      'idempotencyKey',
      this,
    );
    providerId = _i1.ColumnString(
      'providerId',
      this,
    );
    amountCents = _i1.ColumnInt(
      'amountCents',
      this,
    );
    dueDate = _i1.ColumnString(
      'dueDate',
      this,
    );
    status = _i1.ColumnEnum(
      'status',
      this,
      _i1.EnumSerialization.byName,
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

  late final BillingChargeRecordUpdateTable updateTable;

  late final _i1.ColumnInt legalClientId;

  late final _i1.ColumnInt negotiationId;

  late final _i1.ColumnString idempotencyKey;

  late final _i1.ColumnString providerId;

  late final _i1.ColumnInt amountCents;

  late final _i1.ColumnString dueDate;

  late final _i1.ColumnEnum<_i2.BillingStatus> status;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    legalClientId,
    negotiationId,
    idempotencyKey,
    providerId,
    amountCents,
    dueDate,
    status,
    createdAt,
    updatedAt,
  ];
}

class BillingChargeRecordInclude extends _i1.IncludeObject {
  BillingChargeRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => BillingChargeRecord.t;
}

class BillingChargeRecordIncludeList extends _i1.IncludeList {
  BillingChargeRecordIncludeList._({
    _i1.WhereExpressionBuilder<BillingChargeRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BillingChargeRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => BillingChargeRecord.t;
}

class BillingChargeRecordRepository {
  const BillingChargeRecordRepository._();

  /// Returns a list of [BillingChargeRecord]s matching the given query parameters.
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
  Future<List<BillingChargeRecord>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BillingChargeRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BillingChargeRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BillingChargeRecordTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<BillingChargeRecord>(
      where: where?.call(BillingChargeRecord.t),
      orderBy: orderBy?.call(BillingChargeRecord.t),
      orderByList: orderByList?.call(BillingChargeRecord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [BillingChargeRecord] matching the given query parameters.
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
  Future<BillingChargeRecord?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BillingChargeRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<BillingChargeRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BillingChargeRecordTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<BillingChargeRecord>(
      where: where?.call(BillingChargeRecord.t),
      orderBy: orderBy?.call(BillingChargeRecord.t),
      orderByList: orderByList?.call(BillingChargeRecord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [BillingChargeRecord] by its [id] or null if no such row exists.
  Future<BillingChargeRecord?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<BillingChargeRecord>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [BillingChargeRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [BillingChargeRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<BillingChargeRecord>> insert(
    _i1.Session session,
    List<BillingChargeRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<BillingChargeRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [BillingChargeRecord] and returns the inserted row.
  ///
  /// The returned [BillingChargeRecord] will have its `id` field set.
  Future<BillingChargeRecord> insertRow(
    _i1.Session session,
    BillingChargeRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BillingChargeRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BillingChargeRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BillingChargeRecord>> update(
    _i1.Session session,
    List<BillingChargeRecord> rows, {
    _i1.ColumnSelections<BillingChargeRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BillingChargeRecord>(
      rows,
      columns: columns?.call(BillingChargeRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BillingChargeRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BillingChargeRecord> updateRow(
    _i1.Session session,
    BillingChargeRecord row, {
    _i1.ColumnSelections<BillingChargeRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BillingChargeRecord>(
      row,
      columns: columns?.call(BillingChargeRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BillingChargeRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BillingChargeRecord?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<BillingChargeRecordUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<BillingChargeRecord>(
      id,
      columnValues: columnValues(BillingChargeRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BillingChargeRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<BillingChargeRecord>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<BillingChargeRecordUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<BillingChargeRecordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BillingChargeRecordTable>? orderBy,
    _i1.OrderByListBuilder<BillingChargeRecordTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<BillingChargeRecord>(
      columnValues: columnValues(BillingChargeRecord.t.updateTable),
      where: where(BillingChargeRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BillingChargeRecord.t),
      orderByList: orderByList?.call(BillingChargeRecord.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [BillingChargeRecord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BillingChargeRecord>> delete(
    _i1.Session session,
    List<BillingChargeRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BillingChargeRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BillingChargeRecord].
  Future<BillingChargeRecord> deleteRow(
    _i1.Session session,
    BillingChargeRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BillingChargeRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BillingChargeRecord>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BillingChargeRecordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BillingChargeRecord>(
      where: where(BillingChargeRecord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BillingChargeRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BillingChargeRecord>(
      where: where?.call(BillingChargeRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
