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

abstract class PublicPartner
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PublicPartner._({
    this.id,
    required this.name,
    required this.description,
    required this.website,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PublicPartner({
    int? id,
    required String name,
    required String description,
    required String website,
    required bool active,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PublicPartnerImpl;

  factory PublicPartner.fromJson(Map<String, dynamic> jsonSerialization) {
    return PublicPartner(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      website: jsonSerialization['website'] as String,
      active: jsonSerialization['active'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = PublicPartnerTable();

  static const db = PublicPartnerRepository._();

  @override
  int? id;

  String name;

  String description;

  String website;

  bool active;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PublicPartner]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PublicPartner copyWith({
    int? id,
    String? name,
    String? description,
    String? website,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PublicPartner',
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'website': website,
      'active': active,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PublicPartner',
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'website': website,
      'active': active,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static PublicPartnerInclude include() {
    return PublicPartnerInclude._();
  }

  static PublicPartnerIncludeList includeList({
    _i1.WhereExpressionBuilder<PublicPartnerTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PublicPartnerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PublicPartnerTable>? orderByList,
    PublicPartnerInclude? include,
  }) {
    return PublicPartnerIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PublicPartner.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PublicPartner.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PublicPartnerImpl extends PublicPartner {
  _PublicPartnerImpl({
    int? id,
    required String name,
    required String description,
    required String website,
    required bool active,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         name: name,
         description: description,
         website: website,
         active: active,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [PublicPartner]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PublicPartner copyWith({
    Object? id = _Undefined,
    String? name,
    String? description,
    String? website,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PublicPartner(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      website: website ?? this.website,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class PublicPartnerUpdateTable extends _i1.UpdateTable<PublicPartnerTable> {
  PublicPartnerUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> website(String value) => _i1.ColumnValue(
    table.website,
    value,
  );

  _i1.ColumnValue<bool, bool> active(bool value) => _i1.ColumnValue(
    table.active,
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

class PublicPartnerTable extends _i1.Table<int?> {
  PublicPartnerTable({super.tableRelation})
    : super(tableName: 'public_partner') {
    updateTable = PublicPartnerUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    website = _i1.ColumnString(
      'website',
      this,
    );
    active = _i1.ColumnBool(
      'active',
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

  late final PublicPartnerUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  late final _i1.ColumnString website;

  late final _i1.ColumnBool active;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    description,
    website,
    active,
    createdAt,
    updatedAt,
  ];
}

class PublicPartnerInclude extends _i1.IncludeObject {
  PublicPartnerInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PublicPartner.t;
}

class PublicPartnerIncludeList extends _i1.IncludeList {
  PublicPartnerIncludeList._({
    _i1.WhereExpressionBuilder<PublicPartnerTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PublicPartner.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PublicPartner.t;
}

class PublicPartnerRepository {
  const PublicPartnerRepository._();

  /// Returns a list of [PublicPartner]s matching the given query parameters.
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
  Future<List<PublicPartner>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PublicPartnerTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PublicPartnerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PublicPartnerTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<PublicPartner>(
      where: where?.call(PublicPartner.t),
      orderBy: orderBy?.call(PublicPartner.t),
      orderByList: orderByList?.call(PublicPartner.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [PublicPartner] matching the given query parameters.
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
  Future<PublicPartner?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PublicPartnerTable>? where,
    int? offset,
    _i1.OrderByBuilder<PublicPartnerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PublicPartnerTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<PublicPartner>(
      where: where?.call(PublicPartner.t),
      orderBy: orderBy?.call(PublicPartner.t),
      orderByList: orderByList?.call(PublicPartner.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [PublicPartner] by its [id] or null if no such row exists.
  Future<PublicPartner?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<PublicPartner>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [PublicPartner]s in the list and returns the inserted rows.
  ///
  /// The returned [PublicPartner]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PublicPartner>> insert(
    _i1.Session session,
    List<PublicPartner> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PublicPartner>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PublicPartner] and returns the inserted row.
  ///
  /// The returned [PublicPartner] will have its `id` field set.
  Future<PublicPartner> insertRow(
    _i1.Session session,
    PublicPartner row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PublicPartner>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PublicPartner]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PublicPartner>> update(
    _i1.Session session,
    List<PublicPartner> rows, {
    _i1.ColumnSelections<PublicPartnerTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PublicPartner>(
      rows,
      columns: columns?.call(PublicPartner.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PublicPartner]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PublicPartner> updateRow(
    _i1.Session session,
    PublicPartner row, {
    _i1.ColumnSelections<PublicPartnerTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PublicPartner>(
      row,
      columns: columns?.call(PublicPartner.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PublicPartner] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PublicPartner?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PublicPartnerUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PublicPartner>(
      id,
      columnValues: columnValues(PublicPartner.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PublicPartner]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PublicPartner>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PublicPartnerUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<PublicPartnerTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PublicPartnerTable>? orderBy,
    _i1.OrderByListBuilder<PublicPartnerTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PublicPartner>(
      columnValues: columnValues(PublicPartner.t.updateTable),
      where: where(PublicPartner.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PublicPartner.t),
      orderByList: orderByList?.call(PublicPartner.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PublicPartner]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PublicPartner>> delete(
    _i1.Session session,
    List<PublicPartner> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PublicPartner>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PublicPartner].
  Future<PublicPartner> deleteRow(
    _i1.Session session,
    PublicPartner row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PublicPartner>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PublicPartner>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PublicPartnerTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PublicPartner>(
      where: where(PublicPartner.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PublicPartnerTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PublicPartner>(
      where: where?.call(PublicPartner.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
