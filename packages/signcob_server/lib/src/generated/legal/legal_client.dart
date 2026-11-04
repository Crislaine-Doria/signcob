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

abstract class LegalClient
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  LegalClient._({
    this.id,
    required this.name,
    this.email,
    this.phone,
    this.document,
    this.assignedLawyerId,
    this.ownerAuthUserId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LegalClient({
    int? id,
    required String name,
    String? email,
    String? phone,
    String? document,
    String? assignedLawyerId,
    String? ownerAuthUserId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _LegalClientImpl;

  factory LegalClient.fromJson(Map<String, dynamic> jsonSerialization) {
    return LegalClient(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String?,
      phone: jsonSerialization['phone'] as String?,
      document: jsonSerialization['document'] as String?,
      assignedLawyerId: jsonSerialization['assignedLawyerId'] as String?,
      ownerAuthUserId: jsonSerialization['ownerAuthUserId'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = LegalClientTable();

  static const db = LegalClientRepository._();

  @override
  int? id;

  String name;

  String? email;

  String? phone;

  String? document;

  String? assignedLawyerId;

  String? ownerAuthUserId;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [LegalClient]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LegalClient copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? document,
    String? assignedLawyerId,
    String? ownerAuthUserId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LegalClient',
      if (id != null) 'id': id,
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (document != null) 'document': document,
      if (assignedLawyerId != null) 'assignedLawyerId': assignedLawyerId,
      if (ownerAuthUserId != null) 'ownerAuthUserId': ownerAuthUserId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LegalClient',
      if (id != null) 'id': id,
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (document != null) 'document': document,
      if (assignedLawyerId != null) 'assignedLawyerId': assignedLawyerId,
      if (ownerAuthUserId != null) 'ownerAuthUserId': ownerAuthUserId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static LegalClientInclude include() {
    return LegalClientInclude._();
  }

  static LegalClientIncludeList includeList({
    _i1.WhereExpressionBuilder<LegalClientTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LegalClientTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LegalClientTable>? orderByList,
    LegalClientInclude? include,
  }) {
    return LegalClientIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LegalClient.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(LegalClient.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LegalClientImpl extends LegalClient {
  _LegalClientImpl({
    int? id,
    required String name,
    String? email,
    String? phone,
    String? document,
    String? assignedLawyerId,
    String? ownerAuthUserId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         name: name,
         email: email,
         phone: phone,
         document: document,
         assignedLawyerId: assignedLawyerId,
         ownerAuthUserId: ownerAuthUserId,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [LegalClient]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LegalClient copyWith({
    Object? id = _Undefined,
    String? name,
    Object? email = _Undefined,
    Object? phone = _Undefined,
    Object? document = _Undefined,
    Object? assignedLawyerId = _Undefined,
    Object? ownerAuthUserId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LegalClient(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      email: email is String? ? email : this.email,
      phone: phone is String? ? phone : this.phone,
      document: document is String? ? document : this.document,
      assignedLawyerId: assignedLawyerId is String?
          ? assignedLawyerId
          : this.assignedLawyerId,
      ownerAuthUserId: ownerAuthUserId is String?
          ? ownerAuthUserId
          : this.ownerAuthUserId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class LegalClientUpdateTable extends _i1.UpdateTable<LegalClientTable> {
  LegalClientUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> email(String? value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<String, String> phone(String? value) => _i1.ColumnValue(
    table.phone,
    value,
  );

  _i1.ColumnValue<String, String> document(String? value) => _i1.ColumnValue(
    table.document,
    value,
  );

  _i1.ColumnValue<String, String> assignedLawyerId(String? value) =>
      _i1.ColumnValue(
        table.assignedLawyerId,
        value,
      );

  _i1.ColumnValue<String, String> ownerAuthUserId(String? value) =>
      _i1.ColumnValue(
        table.ownerAuthUserId,
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

class LegalClientTable extends _i1.Table<int?> {
  LegalClientTable({super.tableRelation}) : super(tableName: 'legal_client') {
    updateTable = LegalClientUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    phone = _i1.ColumnString(
      'phone',
      this,
    );
    document = _i1.ColumnString(
      'document',
      this,
    );
    assignedLawyerId = _i1.ColumnString(
      'assignedLawyerId',
      this,
    );
    ownerAuthUserId = _i1.ColumnString(
      'ownerAuthUserId',
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

  late final LegalClientUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString email;

  late final _i1.ColumnString phone;

  late final _i1.ColumnString document;

  late final _i1.ColumnString assignedLawyerId;

  late final _i1.ColumnString ownerAuthUserId;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    email,
    phone,
    document,
    assignedLawyerId,
    ownerAuthUserId,
    createdAt,
    updatedAt,
  ];
}

class LegalClientInclude extends _i1.IncludeObject {
  LegalClientInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => LegalClient.t;
}

class LegalClientIncludeList extends _i1.IncludeList {
  LegalClientIncludeList._({
    _i1.WhereExpressionBuilder<LegalClientTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LegalClient.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => LegalClient.t;
}

class LegalClientRepository {
  const LegalClientRepository._();

  /// Returns a list of [LegalClient]s matching the given query parameters.
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
  Future<List<LegalClient>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LegalClientTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LegalClientTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LegalClientTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<LegalClient>(
      where: where?.call(LegalClient.t),
      orderBy: orderBy?.call(LegalClient.t),
      orderByList: orderByList?.call(LegalClient.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [LegalClient] matching the given query parameters.
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
  Future<LegalClient?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LegalClientTable>? where,
    int? offset,
    _i1.OrderByBuilder<LegalClientTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LegalClientTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<LegalClient>(
      where: where?.call(LegalClient.t),
      orderBy: orderBy?.call(LegalClient.t),
      orderByList: orderByList?.call(LegalClient.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [LegalClient] by its [id] or null if no such row exists.
  Future<LegalClient?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<LegalClient>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [LegalClient]s in the list and returns the inserted rows.
  ///
  /// The returned [LegalClient]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<LegalClient>> insert(
    _i1.Session session,
    List<LegalClient> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<LegalClient>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [LegalClient] and returns the inserted row.
  ///
  /// The returned [LegalClient] will have its `id` field set.
  Future<LegalClient> insertRow(
    _i1.Session session,
    LegalClient row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<LegalClient>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [LegalClient]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<LegalClient>> update(
    _i1.Session session,
    List<LegalClient> rows, {
    _i1.ColumnSelections<LegalClientTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<LegalClient>(
      rows,
      columns: columns?.call(LegalClient.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LegalClient]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LegalClient> updateRow(
    _i1.Session session,
    LegalClient row, {
    _i1.ColumnSelections<LegalClientTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<LegalClient>(
      row,
      columns: columns?.call(LegalClient.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LegalClient] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LegalClient?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<LegalClientUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<LegalClient>(
      id,
      columnValues: columnValues(LegalClient.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LegalClient]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<LegalClient>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<LegalClientUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<LegalClientTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LegalClientTable>? orderBy,
    _i1.OrderByListBuilder<LegalClientTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<LegalClient>(
      columnValues: columnValues(LegalClient.t.updateTable),
      where: where(LegalClient.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LegalClient.t),
      orderByList: orderByList?.call(LegalClient.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [LegalClient]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<LegalClient>> delete(
    _i1.Session session,
    List<LegalClient> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<LegalClient>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [LegalClient].
  Future<LegalClient> deleteRow(
    _i1.Session session,
    LegalClient row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LegalClient>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<LegalClient>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<LegalClientTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<LegalClient>(
      where: where(LegalClient.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LegalClientTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<LegalClient>(
      where: where?.call(LegalClient.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
