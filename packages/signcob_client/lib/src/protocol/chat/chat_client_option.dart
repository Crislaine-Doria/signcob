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

abstract class ChatClientOption implements _i1.SerializableModel {
  ChatClientOption._({
    required this.legalClientId,
    required this.name,
  });

  factory ChatClientOption({
    required int legalClientId,
    required String name,
  }) = _ChatClientOptionImpl;

  factory ChatClientOption.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatClientOption(
      legalClientId: jsonSerialization['legalClientId'] as int,
      name: jsonSerialization['name'] as String,
    );
  }

  int legalClientId;

  String name;

  /// Returns a shallow copy of this [ChatClientOption]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatClientOption copyWith({
    int? legalClientId,
    String? name,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChatClientOption',
      'legalClientId': legalClientId,
      'name': name,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ChatClientOptionImpl extends ChatClientOption {
  _ChatClientOptionImpl({
    required int legalClientId,
    required String name,
  }) : super._(
         legalClientId: legalClientId,
         name: name,
       );

  /// Returns a shallow copy of this [ChatClientOption]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatClientOption copyWith({
    int? legalClientId,
    String? name,
  }) {
    return ChatClientOption(
      legalClientId: legalClientId ?? this.legalClientId,
      name: name ?? this.name,
    );
  }
}
