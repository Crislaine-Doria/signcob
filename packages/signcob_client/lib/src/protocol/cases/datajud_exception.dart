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

abstract class DataJudException
    implements _i1.SerializableException, _i1.SerializableModel {
  DataJudException._({required this.message});

  factory DataJudException({required String message}) = _DataJudExceptionImpl;

  factory DataJudException.fromJson(Map<String, dynamic> jsonSerialization) {
    return DataJudException(message: jsonSerialization['message'] as String);
  }

  String message;

  /// Returns a shallow copy of this [DataJudException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DataJudException copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DataJudException',
      'message': message,
    };
  }

  @override
  String toString() {
    return 'DataJudException(message: $message)';
  }
}

class _DataJudExceptionImpl extends DataJudException {
  _DataJudExceptionImpl({required String message}) : super._(message: message);

  /// Returns a shallow copy of this [DataJudException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DataJudException copyWith({String? message}) {
    return DataJudException(message: message ?? this.message);
  }
}
