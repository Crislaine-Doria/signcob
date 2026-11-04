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

abstract class Negotiation
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Negotiation._({
    this.id,
    required this.legalClientId,
    required this.kind,
    required this.title,
    required this.amountCents,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Negotiation({
    int? id,
    required int legalClientId,
    required String kind,
    required String title,
    required int amountCents,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _NegotiationImpl;

  factory Negotiation.fromJson(Map<String, dynamic> jsonSerialization) {
    return Negotiation(
      id: jsonSerialization['id'] as int?,
      legalClientId: jsonSerialization['legalClientId'] as int,
      kind: jsonSerialization['kind'] as String,
      title: jsonSerialization['title'] as String,
      amountCents: jsonSerialization['amountCents'] as int,
      status: jsonSerialization['status'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = NegotiationTable();

  static const db = NegotiationRepository._();

  @override
  int? id;

  int legalClientId;

  String kind;

  String title;

  int amountCents;

  String status;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Negotiation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Negotiation copyWith({
    int? id,
    int? legalClientId,
    String? kind,
    String? title,
    int? amountCents,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Negotiation',
      if (id != null) 'id': id,
      'legalClientId': legalClientId,
      'kind': kind,
      'title': title,
      'amountCents': amountCents,
      'status': status,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Negotiation',
      if (id != null) 'id': id,
      'legalClientId': legalClientId,
      'kind': kind,
      'title': title,
      'amountCents': amountCents,
      'status': status,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static NegotiationInclude include() {
    return NegotiationInclude._();
  }

  static NegotiationIncludeList includeList({
    _i1.WhereExpressionBuilder<NegotiationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NegotiationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NegotiationTable>? orderByList,
    NegotiationInclude? include,
  }) {
    return NegotiationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Negotiation.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Negotiation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NegotiationImpl extends Negotiation {
  _NegotiationImpl({
    int? id,
    required int legalClientId,
    required String kind,
    required String title,
    required int amountCents,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         legalClientId: legalClientId,
         kind: kind,
         title: title,
         amountCents: amountCents,
         status: status,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Negotiation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Negotiation copyWith({
    Object? id = _Undefined,
    int? legalClientId,
    String? kind,
    String? title,
    int? amountCents,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Negotiation(
      id: id is int? ? id : this.id,
      legalClientId: legalClientId ?? this.legalClientId,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      amountCents: amountCents ?? this.amountCents,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NegotiationUpdateTable extends _i1.UpdateTable<NegotiationTable> {
  NegotiationUpdateTable(super.table);

  _i1.ColumnValue<int, int> legalClientId(int value) => _i1.ColumnValue(
    table.legalClientId,
    value,
  );

  _i1.ColumnValue<String, String> kind(String value) => _i1.ColumnValue(
    table.kind,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<int, int> amountCents(int value) => _i1.ColumnValue(
    table.amountCents,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
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

class NegotiationTable extends _i1.Table<int?> {
  NegotiationTable({super.tableRelation}) : super(tableName: 'negotiation') {
    updateTable = NegotiationUpdateTable(this);
    legalClientId = _i1.ColumnInt(
      'legalClientId',
      this,
    );
    kind = _i1.ColumnString(
      'kind',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    amountCents = _i1.ColumnInt(
      'amountCents',
      this,
    );
    status = _i1.ColumnString(
      'status',
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

  late final NegotiationUpdateTable updateTable;

  late final _i1.ColumnInt legalClientId;

  late final _i1.ColumnString kind;

  late final _i1.ColumnString title;

  late final _i1.ColumnInt amountCents;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    legalClientId,
    kind,
    title,
    amountCents,
    status,
    createdAt,
    updatedAt,
  ];
}

class NegotiationInclude extends _i1.IncludeObject {
  NegotiationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Negotiation.t;
}

class NegotiationIncludeList extends _i1.IncludeList {
  NegotiationIncludeList._({
    _i1.WhereExpressionBuilder<NegotiationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Negotiation.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Negotiation.t;
}

class NegotiationRepository {
  const NegotiationRepository._();

  /// Returns a list of [Negotiation]s matching the given query parameters.
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
  Future<List<Negotiation>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NegotiationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NegotiationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NegotiationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Negotiation>(
      where: where?.call(Negotiation.t),
      orderBy: orderBy?.call(Negotiation.t),
      orderByList: orderByList?.call(Negotiation.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Negotiation] matching the given query parameters.
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
  Future<Negotiation?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NegotiationTable>? where,
    int? offset,
    _i1.OrderByBuilder<NegotiationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NegotiationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Negotiation>(
      where: where?.call(Negotiation.t),
      orderBy: orderBy?.call(Negotiation.t),
      orderByList: orderByList?.call(Negotiation.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Negotiation] by its [id] or null if no such row exists.
  Future<Negotiation?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Negotiation>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Negotiation]s in the list and returns the inserted rows.
  ///
  /// The returned [Negotiation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Negotiation>> insert(
    _i1.Session session,
    List<Negotiation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Negotiation>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Negotiation] and returns the inserted row.
  ///
  /// The returned [Negotiation] will have its `id` field set.
  Future<Negotiation> insertRow(
    _i1.Session session,
    Negotiation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Negotiation>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Negotiation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Negotiation>> update(
    _i1.Session session,
    List<Negotiation> rows, {
    _i1.ColumnSelections<NegotiationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Negotiation>(
      rows,
      columns: columns?.call(Negotiation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Negotiation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Negotiation> updateRow(
    _i1.Session session,
    Negotiation row, {
    _i1.ColumnSelections<NegotiationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Negotiation>(
      row,
      columns: columns?.call(Negotiation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Negotiation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Negotiation?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<NegotiationUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Negotiation>(
      id,
      columnValues: columnValues(Negotiation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Negotiation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Negotiation>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<NegotiationUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<NegotiationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NegotiationTable>? orderBy,
    _i1.OrderByListBuilder<NegotiationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Negotiation>(
      columnValues: columnValues(Negotiation.t.updateTable),
      where: where(Negotiation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Negotiation.t),
      orderByList: orderByList?.call(Negotiation.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Negotiation]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Negotiation>> delete(
    _i1.Session session,
    List<Negotiation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Negotiation>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Negotiation].
  Future<Negotiation> deleteRow(
    _i1.Session session,
    Negotiation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Negotiation>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Negotiation>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<NegotiationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Negotiation>(
      where: where(Negotiation.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NegotiationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Negotiation>(
      where: where?.call(Negotiation.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
