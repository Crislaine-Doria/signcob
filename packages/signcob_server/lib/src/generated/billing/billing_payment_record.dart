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

abstract class BillingPaymentRecord
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  BillingPaymentRecord._({
    this.id,
    required this.chargeId,
    required this.environment,
    required this.accountId,
    required this.providerId,
    required this.amountCents,
    required this.dueDate,
    this.installmentNumber,
    required this.status,
    this.confirmedAt,
    this.receivedAt,
    this.invoiceUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BillingPaymentRecord({
    int? id,
    required int chargeId,
    required String environment,
    required String accountId,
    required String providerId,
    required int amountCents,
    required String dueDate,
    int? installmentNumber,
    required _i2.BillingStatus status,
    DateTime? confirmedAt,
    DateTime? receivedAt,
    String? invoiceUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _BillingPaymentRecordImpl;

  factory BillingPaymentRecord.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return BillingPaymentRecord(
      id: jsonSerialization['id'] as int?,
      chargeId: jsonSerialization['chargeId'] as int,
      environment: jsonSerialization['environment'] as String,
      accountId: jsonSerialization['accountId'] as String,
      providerId: jsonSerialization['providerId'] as String,
      amountCents: jsonSerialization['amountCents'] as int,
      dueDate: jsonSerialization['dueDate'] as String,
      installmentNumber: jsonSerialization['installmentNumber'] as int?,
      status: _i2.BillingStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      confirmedAt: jsonSerialization['confirmedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['confirmedAt'],
            ),
      receivedAt: jsonSerialization['receivedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['receivedAt']),
      invoiceUrl: jsonSerialization['invoiceUrl'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = BillingPaymentRecordTable();

  static const db = BillingPaymentRecordRepository._();

  @override
  int? id;

  int chargeId;

  String environment;

  String accountId;

  String providerId;

  int amountCents;

  String dueDate;

  int? installmentNumber;

  _i2.BillingStatus status;

  DateTime? confirmedAt;

  DateTime? receivedAt;

  String? invoiceUrl;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [BillingPaymentRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BillingPaymentRecord copyWith({
    int? id,
    int? chargeId,
    String? environment,
    String? accountId,
    String? providerId,
    int? amountCents,
    String? dueDate,
    int? installmentNumber,
    _i2.BillingStatus? status,
    DateTime? confirmedAt,
    DateTime? receivedAt,
    String? invoiceUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BillingPaymentRecord',
      if (id != null) 'id': id,
      'chargeId': chargeId,
      'environment': environment,
      'accountId': accountId,
      'providerId': providerId,
      'amountCents': amountCents,
      'dueDate': dueDate,
      if (installmentNumber != null) 'installmentNumber': installmentNumber,
      'status': status.toJson(),
      if (confirmedAt != null) 'confirmedAt': confirmedAt?.toJson(),
      if (receivedAt != null) 'receivedAt': receivedAt?.toJson(),
      if (invoiceUrl != null) 'invoiceUrl': invoiceUrl,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static BillingPaymentRecordInclude include() {
    return BillingPaymentRecordInclude._();
  }

  static BillingPaymentRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<BillingPaymentRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BillingPaymentRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BillingPaymentRecordTable>? orderByList,
    BillingPaymentRecordInclude? include,
  }) {
    return BillingPaymentRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BillingPaymentRecord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BillingPaymentRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BillingPaymentRecordImpl extends BillingPaymentRecord {
  _BillingPaymentRecordImpl({
    int? id,
    required int chargeId,
    required String environment,
    required String accountId,
    required String providerId,
    required int amountCents,
    required String dueDate,
    int? installmentNumber,
    required _i2.BillingStatus status,
    DateTime? confirmedAt,
    DateTime? receivedAt,
    String? invoiceUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         chargeId: chargeId,
         environment: environment,
         accountId: accountId,
         providerId: providerId,
         amountCents: amountCents,
         dueDate: dueDate,
         installmentNumber: installmentNumber,
         status: status,
         confirmedAt: confirmedAt,
         receivedAt: receivedAt,
         invoiceUrl: invoiceUrl,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [BillingPaymentRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BillingPaymentRecord copyWith({
    Object? id = _Undefined,
    int? chargeId,
    String? environment,
    String? accountId,
    String? providerId,
    int? amountCents,
    String? dueDate,
    Object? installmentNumber = _Undefined,
    _i2.BillingStatus? status,
    Object? confirmedAt = _Undefined,
    Object? receivedAt = _Undefined,
    Object? invoiceUrl = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BillingPaymentRecord(
      id: id is int? ? id : this.id,
      chargeId: chargeId ?? this.chargeId,
      environment: environment ?? this.environment,
      accountId: accountId ?? this.accountId,
      providerId: providerId ?? this.providerId,
      amountCents: amountCents ?? this.amountCents,
      dueDate: dueDate ?? this.dueDate,
      installmentNumber: installmentNumber is int?
          ? installmentNumber
          : this.installmentNumber,
      status: status ?? this.status,
      confirmedAt: confirmedAt is DateTime? ? confirmedAt : this.confirmedAt,
      receivedAt: receivedAt is DateTime? ? receivedAt : this.receivedAt,
      invoiceUrl: invoiceUrl is String? ? invoiceUrl : this.invoiceUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class BillingPaymentRecordUpdateTable
    extends _i1.UpdateTable<BillingPaymentRecordTable> {
  BillingPaymentRecordUpdateTable(super.table);

  _i1.ColumnValue<int, int> chargeId(int value) => _i1.ColumnValue(
    table.chargeId,
    value,
  );

  _i1.ColumnValue<String, String> environment(String value) => _i1.ColumnValue(
    table.environment,
    value,
  );

  _i1.ColumnValue<String, String> accountId(String value) => _i1.ColumnValue(
    table.accountId,
    value,
  );

  _i1.ColumnValue<String, String> providerId(String value) => _i1.ColumnValue(
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

  _i1.ColumnValue<int, int> installmentNumber(int? value) => _i1.ColumnValue(
    table.installmentNumber,
    value,
  );

  _i1.ColumnValue<_i2.BillingStatus, _i2.BillingStatus> status(
    _i2.BillingStatus value,
  ) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> confirmedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.confirmedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> receivedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.receivedAt,
        value,
      );

  _i1.ColumnValue<String, String> invoiceUrl(String? value) => _i1.ColumnValue(
    table.invoiceUrl,
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

class BillingPaymentRecordTable extends _i1.Table<int?> {
  BillingPaymentRecordTable({super.tableRelation})
    : super(tableName: 'billing_payment') {
    updateTable = BillingPaymentRecordUpdateTable(this);
    chargeId = _i1.ColumnInt(
      'chargeId',
      this,
    );
    environment = _i1.ColumnString(
      'environment',
      this,
    );
    accountId = _i1.ColumnString(
      'accountId',
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
    installmentNumber = _i1.ColumnInt(
      'installmentNumber',
      this,
    );
    status = _i1.ColumnEnum(
      'status',
      this,
      _i1.EnumSerialization.byName,
    );
    confirmedAt = _i1.ColumnDateTime(
      'confirmedAt',
      this,
    );
    receivedAt = _i1.ColumnDateTime(
      'receivedAt',
      this,
    );
    invoiceUrl = _i1.ColumnString(
      'invoiceUrl',
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

  late final BillingPaymentRecordUpdateTable updateTable;

  late final _i1.ColumnInt chargeId;

  late final _i1.ColumnString environment;

  late final _i1.ColumnString accountId;

  late final _i1.ColumnString providerId;

  late final _i1.ColumnInt amountCents;

  late final _i1.ColumnString dueDate;

  late final _i1.ColumnInt installmentNumber;

  late final _i1.ColumnEnum<_i2.BillingStatus> status;

  late final _i1.ColumnDateTime confirmedAt;

  late final _i1.ColumnDateTime receivedAt;

  late final _i1.ColumnString invoiceUrl;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    chargeId,
    environment,
    accountId,
    providerId,
    amountCents,
    dueDate,
    installmentNumber,
    status,
    confirmedAt,
    receivedAt,
    invoiceUrl,
    createdAt,
    updatedAt,
  ];
}

class BillingPaymentRecordInclude extends _i1.IncludeObject {
  BillingPaymentRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => BillingPaymentRecord.t;
}

class BillingPaymentRecordIncludeList extends _i1.IncludeList {
  BillingPaymentRecordIncludeList._({
    _i1.WhereExpressionBuilder<BillingPaymentRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BillingPaymentRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => BillingPaymentRecord.t;
}

class BillingPaymentRecordRepository {
  const BillingPaymentRecordRepository._();

  /// Returns a list of [BillingPaymentRecord]s matching the given query parameters.
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
  Future<List<BillingPaymentRecord>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BillingPaymentRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BillingPaymentRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BillingPaymentRecordTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<BillingPaymentRecord>(
      where: where?.call(BillingPaymentRecord.t),
      orderBy: orderBy?.call(BillingPaymentRecord.t),
      orderByList: orderByList?.call(BillingPaymentRecord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [BillingPaymentRecord] matching the given query parameters.
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
  Future<BillingPaymentRecord?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BillingPaymentRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<BillingPaymentRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BillingPaymentRecordTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<BillingPaymentRecord>(
      where: where?.call(BillingPaymentRecord.t),
      orderBy: orderBy?.call(BillingPaymentRecord.t),
      orderByList: orderByList?.call(BillingPaymentRecord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [BillingPaymentRecord] by its [id] or null if no such row exists.
  Future<BillingPaymentRecord?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<BillingPaymentRecord>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [BillingPaymentRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [BillingPaymentRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<BillingPaymentRecord>> insert(
    _i1.Session session,
    List<BillingPaymentRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<BillingPaymentRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [BillingPaymentRecord] and returns the inserted row.
  ///
  /// The returned [BillingPaymentRecord] will have its `id` field set.
  Future<BillingPaymentRecord> insertRow(
    _i1.Session session,
    BillingPaymentRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BillingPaymentRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BillingPaymentRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BillingPaymentRecord>> update(
    _i1.Session session,
    List<BillingPaymentRecord> rows, {
    _i1.ColumnSelections<BillingPaymentRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BillingPaymentRecord>(
      rows,
      columns: columns?.call(BillingPaymentRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BillingPaymentRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BillingPaymentRecord> updateRow(
    _i1.Session session,
    BillingPaymentRecord row, {
    _i1.ColumnSelections<BillingPaymentRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BillingPaymentRecord>(
      row,
      columns: columns?.call(BillingPaymentRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BillingPaymentRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BillingPaymentRecord?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<BillingPaymentRecordUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<BillingPaymentRecord>(
      id,
      columnValues: columnValues(BillingPaymentRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BillingPaymentRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<BillingPaymentRecord>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<BillingPaymentRecordUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<BillingPaymentRecordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BillingPaymentRecordTable>? orderBy,
    _i1.OrderByListBuilder<BillingPaymentRecordTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<BillingPaymentRecord>(
      columnValues: columnValues(BillingPaymentRecord.t.updateTable),
      where: where(BillingPaymentRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BillingPaymentRecord.t),
      orderByList: orderByList?.call(BillingPaymentRecord.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [BillingPaymentRecord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BillingPaymentRecord>> delete(
    _i1.Session session,
    List<BillingPaymentRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BillingPaymentRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BillingPaymentRecord].
  Future<BillingPaymentRecord> deleteRow(
    _i1.Session session,
    BillingPaymentRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BillingPaymentRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BillingPaymentRecord>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BillingPaymentRecordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BillingPaymentRecord>(
      where: where(BillingPaymentRecord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BillingPaymentRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BillingPaymentRecord>(
      where: where?.call(BillingPaymentRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
