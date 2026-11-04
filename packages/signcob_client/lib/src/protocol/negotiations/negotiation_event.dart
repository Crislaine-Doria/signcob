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

abstract class NegotiationEvent implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int negotiationId;

  String? fromStatus;

  String toStatus;

  DateTime occurredAt;

  String actorAuthUserId;

  String? note;

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
