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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class LegalCase implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int legalClientId;

  String number;

  String tribunal;

  String? className;

  String? courtName;

  DateTime? lastSyncedAt;

  String? syncError;

  String movementsJson;

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
