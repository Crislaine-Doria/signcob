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

abstract class BillingCustomerRecord
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  BillingCustomerRecord._({
    this.id,
    required this.environment,
    required this.accountId,
    required this.legalClientId,
    required this.document,
    required this.externalReference,
    this.providerCustomerId,
    required this.state,
    required this.createAttempted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BillingCustomerRecord({
    int? id,
    required String environment,
    required String accountId,
    required int legalClientId,
    required String document,
    required String externalReference,
    String? providerCustomerId,
    required String state,
    required bool createAttempted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _BillingCustomerRecordImpl;

  factory BillingCustomerRecord.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return BillingCustomerRecord(
      id: jsonSerialization['id'] as int?,
      environment: jsonSerialization['environment'] as String,
      accountId: jsonSerialization['accountId'] as String,
      legalClientId: jsonSerialization['legalClientId'] as int,
      document: jsonSerialization['document'] as String,
      externalReference: jsonSerialization['externalReference'] as String,
      providerCustomerId: jsonSerialization['providerCustomerId'] as String?,
      state: jsonSerialization['state'] as String,
      createAttempted: jsonSerialization['createAttempted'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = BillingCustomerRecordTable();

  static const db = BillingCustomerRecordRepository._();

  @override
  int? id;

  String environment;

  String accountId;

  int legalClientId;

  String document;

  String externalReference;

  String? providerCustomerId;

  String state;

  bool createAttempted;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [BillingCustomerRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BillingCustomerRecord copyWith({
    int? id,
    String? environment,
    String? accountId,
    int? legalClientId,
    String? document,
    String? externalReference,
    String? providerCustomerId,
    String? state,
    bool? createAttempted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BillingCustomerRecord',
      if (id != null) 'id': id,
      'environment': environment,
      'accountId': accountId,
      'legalClientId': legalClientId,
      'document': document,
      'externalReference': externalReference,
      if (providerCustomerId != null) 'providerCustomerId': providerCustomerId,
      'state': state,
      'createAttempted': createAttempted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static BillingCustomerRecordInclude include() {
    return BillingCustomerRecordInclude._();
  }

  static BillingCustomerRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<BillingCustomerRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BillingCustomerRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BillingCustomerRecordTable>? orderByList,
    BillingCustomerRecordInclude? include,
  }) {
    return BillingCustomerRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BillingCustomerRecord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BillingCustomerRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BillingCustomerRecordImpl extends BillingCustomerRecord {
  _BillingCustomerRecordImpl({
    int? id,
    required String environment,
    required String accountId,
    required int legalClientId,
    required String document,
    required String externalReference,
    String? providerCustomerId,
    required String state,
    required bool createAttempted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         environment: environment,
         accountId: accountId,
         legalClientId: legalClientId,
         document: document,
         externalReference: externalReference,
         providerCustomerId: providerCustomerId,
         state: state,
         createAttempted: createAttempted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [BillingCustomerRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BillingCustomerRecord copyWith({
    Object? id = _Undefined,
    String? environment,
    String? accountId,
    int? legalClientId,
    String? document,
    String? externalReference,
    Object? providerCustomerId = _Undefined,
    String? state,
    bool? createAttempted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BillingCustomerRecord(
      id: id is int? ? id : this.id,
      environment: environment ?? this.environment,
      accountId: accountId ?? this.accountId,
      legalClientId: legalClientId ?? this.legalClientId,
      document: document ?? this.document,
      externalReference: externalReference ?? this.externalReference,
      providerCustomerId: providerCustomerId is String?
          ? providerCustomerId
          : this.providerCustomerId,
      state: state ?? this.state,
      createAttempted: createAttempted ?? this.createAttempted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class BillingCustomerRecordUpdateTable
    extends _i1.UpdateTable<BillingCustomerRecordTable> {
  BillingCustomerRecordUpdateTable(super.table);

  _i1.ColumnValue<String, String> environment(String value) => _i1.ColumnValue(
    table.environment,
    value,
  );

  _i1.ColumnValue<String, String> accountId(String value) => _i1.ColumnValue(
    table.accountId,
    value,
  );

  _i1.ColumnValue<int, int> legalClientId(int value) => _i1.ColumnValue(
    table.legalClientId,
    value,
  );

  _i1.ColumnValue<String, String> document(String value) => _i1.ColumnValue(
    table.document,
    value,
  );

  _i1.ColumnValue<String, String> externalReference(String value) =>
      _i1.ColumnValue(
        table.externalReference,
        value,
      );

  _i1.ColumnValue<String, String> providerCustomerId(String? value) =>
      _i1.ColumnValue(
        table.providerCustomerId,
        value,
      );

  _i1.ColumnValue<String, String> state(String value) => _i1.ColumnValue(
    table.state,
    value,
  );

  _i1.ColumnValue<bool, bool> createAttempted(bool value) => _i1.ColumnValue(
    table.createAttempted,
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

class BillingCustomerRecordTable extends _i1.Table<int?> {
  BillingCustomerRecordTable({super.tableRelation})
    : super(tableName: 'billing_customer') {
    updateTable = BillingCustomerRecordUpdateTable(this);
    environment = _i1.ColumnString(
      'environment',
      this,
    );
    accountId = _i1.ColumnString(
      'accountId',
      this,
    );
    legalClientId = _i1.ColumnInt(
      'legalClientId',
      this,
    );
    document = _i1.ColumnString(
      'document',
      this,
    );
    externalReference = _i1.ColumnString(
      'externalReference',
      this,
    );
    providerCustomerId = _i1.ColumnString(
      'providerCustomerId',
      this,
    );
    state = _i1.ColumnString(
      'state',
      this,
    );
    createAttempted = _i1.ColumnBool(
      'createAttempted',
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

  late final BillingCustomerRecordUpdateTable updateTable;

  late final _i1.ColumnString environment;

  late final _i1.ColumnString accountId;

  late final _i1.ColumnInt legalClientId;

  late final _i1.ColumnString document;

  late final _i1.ColumnString externalReference;

  late final _i1.ColumnString providerCustomerId;

  late final _i1.ColumnString state;

  late final _i1.ColumnBool createAttempted;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    environment,
    accountId,
    legalClientId,
    document,
    externalReference,
    providerCustomerId,
    state,
    createAttempted,
    createdAt,
    updatedAt,
  ];
}

class BillingCustomerRecordInclude extends _i1.IncludeObject {
  BillingCustomerRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => BillingCustomerRecord.t;
}

class BillingCustomerRecordIncludeList extends _i1.IncludeList {
  BillingCustomerRecordIncludeList._({
    _i1.WhereExpressionBuilder<BillingCustomerRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BillingCustomerRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => BillingCustomerRecord.t;
}

class BillingCustomerRecordRepository {
  const BillingCustomerRecordRepository._();

  /// Returns a list of [BillingCustomerRecord]s matching the given query parameters.
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
  Future<List<BillingCustomerRecord>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BillingCustomerRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BillingCustomerRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BillingCustomerRecordTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<BillingCustomerRecord>(
      where: where?.call(BillingCustomerRecord.t),
      orderBy: orderBy?.call(BillingCustomerRecord.t),
      orderByList: orderByList?.call(BillingCustomerRecord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [BillingCustomerRecord] matching the given query parameters.
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
  Future<BillingCustomerRecord?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BillingCustomerRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<BillingCustomerRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BillingCustomerRecordTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<BillingCustomerRecord>(
      where: where?.call(BillingCustomerRecord.t),
      orderBy: orderBy?.call(BillingCustomerRecord.t),
      orderByList: orderByList?.call(BillingCustomerRecord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [BillingCustomerRecord] by its [id] or null if no such row exists.
  Future<BillingCustomerRecord?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<BillingCustomerRecord>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [BillingCustomerRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [BillingCustomerRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<BillingCustomerRecord>> insert(
    _i1.Session session,
    List<BillingCustomerRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<BillingCustomerRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [BillingCustomerRecord] and returns the inserted row.
  ///
  /// The returned [BillingCustomerRecord] will have its `id` field set.
  Future<BillingCustomerRecord> insertRow(
    _i1.Session session,
    BillingCustomerRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BillingCustomerRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BillingCustomerRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BillingCustomerRecord>> update(
    _i1.Session session,
    List<BillingCustomerRecord> rows, {
    _i1.ColumnSelections<BillingCustomerRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BillingCustomerRecord>(
      rows,
      columns: columns?.call(BillingCustomerRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BillingCustomerRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BillingCustomerRecord> updateRow(
    _i1.Session session,
    BillingCustomerRecord row, {
    _i1.ColumnSelections<BillingCustomerRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BillingCustomerRecord>(
      row,
      columns: columns?.call(BillingCustomerRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BillingCustomerRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BillingCustomerRecord?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<BillingCustomerRecordUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<BillingCustomerRecord>(
      id,
      columnValues: columnValues(BillingCustomerRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BillingCustomerRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<BillingCustomerRecord>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<BillingCustomerRecordUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<BillingCustomerRecordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BillingCustomerRecordTable>? orderBy,
    _i1.OrderByListBuilder<BillingCustomerRecordTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<BillingCustomerRecord>(
      columnValues: columnValues(BillingCustomerRecord.t.updateTable),
      where: where(BillingCustomerRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BillingCustomerRecord.t),
      orderByList: orderByList?.call(BillingCustomerRecord.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [BillingCustomerRecord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BillingCustomerRecord>> delete(
    _i1.Session session,
    List<BillingCustomerRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BillingCustomerRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BillingCustomerRecord].
  Future<BillingCustomerRecord> deleteRow(
    _i1.Session session,
    BillingCustomerRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BillingCustomerRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BillingCustomerRecord>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BillingCustomerRecordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BillingCustomerRecord>(
      where: where(BillingCustomerRecord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BillingCustomerRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BillingCustomerRecord>(
      where: where?.call(BillingCustomerRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
