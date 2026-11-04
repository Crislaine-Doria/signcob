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

abstract class ContactMessage
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ContactMessage._({
    this.id,
    required this.name,
    required this.email,
    required this.message,
    required this.createdAt,
  });

  factory ContactMessage({
    int? id,
    required String name,
    required String email,
    required String message,
    required DateTime createdAt,
  }) = _ContactMessageImpl;

  factory ContactMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return ContactMessage(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String,
      message: jsonSerialization['message'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = ContactMessageTable();

  static const db = ContactMessageRepository._();

  @override
  int? id;

  String name;

  String email;

  String message;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ContactMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ContactMessage copyWith({
    int? id,
    String? name,
    String? email,
    String? message,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ContactMessage',
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'message': message,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ContactMessage',
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'message': message,
      'createdAt': createdAt.toJson(),
    };
  }

  static ContactMessageInclude include() {
    return ContactMessageInclude._();
  }

  static ContactMessageIncludeList includeList({
    _i1.WhereExpressionBuilder<ContactMessageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ContactMessageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ContactMessageTable>? orderByList,
    ContactMessageInclude? include,
  }) {
    return ContactMessageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ContactMessage.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ContactMessage.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ContactMessageImpl extends ContactMessage {
  _ContactMessageImpl({
    int? id,
    required String name,
    required String email,
    required String message,
    required DateTime createdAt,
  }) : super._(
         id: id,
         name: name,
         email: email,
         message: message,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ContactMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ContactMessage copyWith({
    Object? id = _Undefined,
    String? name,
    String? email,
    String? message,
    DateTime? createdAt,
  }) {
    return ContactMessage(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ContactMessageUpdateTable extends _i1.UpdateTable<ContactMessageTable> {
  ContactMessageUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> email(String value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<String, String> message(String value) => _i1.ColumnValue(
    table.message,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class ContactMessageTable extends _i1.Table<int?> {
  ContactMessageTable({super.tableRelation})
    : super(tableName: 'contact_message') {
    updateTable = ContactMessageUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    message = _i1.ColumnString(
      'message',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final ContactMessageUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString email;

  late final _i1.ColumnString message;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    email,
    message,
    createdAt,
  ];
}

class ContactMessageInclude extends _i1.IncludeObject {
  ContactMessageInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ContactMessage.t;
}

class ContactMessageIncludeList extends _i1.IncludeList {
  ContactMessageIncludeList._({
    _i1.WhereExpressionBuilder<ContactMessageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ContactMessage.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ContactMessage.t;
}

class ContactMessageRepository {
  const ContactMessageRepository._();

  /// Returns a list of [ContactMessage]s matching the given query parameters.
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
  Future<List<ContactMessage>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ContactMessageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ContactMessageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ContactMessageTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ContactMessage>(
      where: where?.call(ContactMessage.t),
      orderBy: orderBy?.call(ContactMessage.t),
      orderByList: orderByList?.call(ContactMessage.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ContactMessage] matching the given query parameters.
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
  Future<ContactMessage?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ContactMessageTable>? where,
    int? offset,
    _i1.OrderByBuilder<ContactMessageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ContactMessageTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ContactMessage>(
      where: where?.call(ContactMessage.t),
      orderBy: orderBy?.call(ContactMessage.t),
      orderByList: orderByList?.call(ContactMessage.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ContactMessage] by its [id] or null if no such row exists.
  Future<ContactMessage?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ContactMessage>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ContactMessage]s in the list and returns the inserted rows.
  ///
  /// The returned [ContactMessage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ContactMessage>> insert(
    _i1.Session session,
    List<ContactMessage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ContactMessage>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ContactMessage] and returns the inserted row.
  ///
  /// The returned [ContactMessage] will have its `id` field set.
  Future<ContactMessage> insertRow(
    _i1.Session session,
    ContactMessage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ContactMessage>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ContactMessage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ContactMessage>> update(
    _i1.Session session,
    List<ContactMessage> rows, {
    _i1.ColumnSelections<ContactMessageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ContactMessage>(
      rows,
      columns: columns?.call(ContactMessage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ContactMessage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ContactMessage> updateRow(
    _i1.Session session,
    ContactMessage row, {
    _i1.ColumnSelections<ContactMessageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ContactMessage>(
      row,
      columns: columns?.call(ContactMessage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ContactMessage] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ContactMessage?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ContactMessageUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ContactMessage>(
      id,
      columnValues: columnValues(ContactMessage.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ContactMessage]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ContactMessage>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ContactMessageUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ContactMessageTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ContactMessageTable>? orderBy,
    _i1.OrderByListBuilder<ContactMessageTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ContactMessage>(
      columnValues: columnValues(ContactMessage.t.updateTable),
      where: where(ContactMessage.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ContactMessage.t),
      orderByList: orderByList?.call(ContactMessage.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ContactMessage]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ContactMessage>> delete(
    _i1.Session session,
    List<ContactMessage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ContactMessage>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ContactMessage].
  Future<ContactMessage> deleteRow(
    _i1.Session session,
    ContactMessage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ContactMessage>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ContactMessage>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ContactMessageTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ContactMessage>(
      where: where(ContactMessage.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ContactMessageTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ContactMessage>(
      where: where?.call(ContactMessage.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
