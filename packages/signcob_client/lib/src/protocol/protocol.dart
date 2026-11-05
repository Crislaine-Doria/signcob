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
import 'access/access_denied_exception.dart' as _i2;
import 'access/managed_user.dart' as _i3;
import 'billing/billing_charge.dart' as _i4;
import 'billing/billing_exception.dart' as _i5;
import 'billing/billing_status.dart' as _i6;
import 'cases/datajud_exception.dart' as _i7;
import 'cases/legal_case.dart' as _i8;
import 'contact/contact_message.dart' as _i9;
import 'content/public_article.dart' as _i10;
import 'content/public_partner.dart' as _i11;
import 'greetings/greeting.dart' as _i12;
import 'greetings/user.dart' as _i13;
import 'legal/legal_client.dart' as _i14;
import 'negotiations/negotiation.dart' as _i15;
import 'negotiations/negotiation_event.dart' as _i16;
import 'package:signcob_client/src/protocol/access/managed_user.dart' as _i17;
import 'package:signcob_client/src/protocol/cases/legal_case.dart' as _i18;
import 'package:signcob_client/src/protocol/contact/contact_message.dart'
    as _i19;
import 'package:signcob_client/src/protocol/content/public_article.dart'
    as _i20;
import 'package:signcob_client/src/protocol/content/public_partner.dart'
    as _i21;
import 'package:signcob_client/src/protocol/legal/legal_client.dart' as _i22;
import 'package:signcob_client/src/protocol/negotiations/negotiation.dart'
    as _i23;
import 'package:signcob_client/src/protocol/negotiations/negotiation_event.dart'
    as _i24;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i25;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i26;
export 'access/access_denied_exception.dart';
export 'access/managed_user.dart';
export 'billing/billing_charge.dart';
export 'billing/billing_exception.dart';
export 'billing/billing_status.dart';
export 'cases/datajud_exception.dart';
export 'cases/legal_case.dart';
export 'contact/contact_message.dart';
export 'content/public_article.dart';
export 'content/public_partner.dart';
export 'greetings/greeting.dart';
export 'greetings/user.dart';
export 'legal/legal_client.dart';
export 'negotiations/negotiation.dart';
export 'negotiations/negotiation_event.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.AccessDeniedException) {
      return _i2.AccessDeniedException.fromJson(data) as T;
    }
    if (t == _i3.ManagedUser) {
      return _i3.ManagedUser.fromJson(data) as T;
    }
    if (t == _i4.BillingCharge) {
      return _i4.BillingCharge.fromJson(data) as T;
    }
    if (t == _i5.BillingException) {
      return _i5.BillingException.fromJson(data) as T;
    }
    if (t == _i6.BillingStatus) {
      return _i6.BillingStatus.fromJson(data) as T;
    }
    if (t == _i7.DataJudException) {
      return _i7.DataJudException.fromJson(data) as T;
    }
    if (t == _i8.LegalCase) {
      return _i8.LegalCase.fromJson(data) as T;
    }
    if (t == _i9.ContactMessage) {
      return _i9.ContactMessage.fromJson(data) as T;
    }
    if (t == _i10.PublicArticle) {
      return _i10.PublicArticle.fromJson(data) as T;
    }
    if (t == _i11.PublicPartner) {
      return _i11.PublicPartner.fromJson(data) as T;
    }
    if (t == _i12.Greeting) {
      return _i12.Greeting.fromJson(data) as T;
    }
    if (t == _i13.User) {
      return _i13.User.fromJson(data) as T;
    }
    if (t == _i14.LegalClient) {
      return _i14.LegalClient.fromJson(data) as T;
    }
    if (t == _i15.Negotiation) {
      return _i15.Negotiation.fromJson(data) as T;
    }
    if (t == _i16.NegotiationEvent) {
      return _i16.NegotiationEvent.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AccessDeniedException?>()) {
      return (data != null ? _i2.AccessDeniedException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i3.ManagedUser?>()) {
      return (data != null ? _i3.ManagedUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.BillingCharge?>()) {
      return (data != null ? _i4.BillingCharge.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.BillingException?>()) {
      return (data != null ? _i5.BillingException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.BillingStatus?>()) {
      return (data != null ? _i6.BillingStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.DataJudException?>()) {
      return (data != null ? _i7.DataJudException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.LegalCase?>()) {
      return (data != null ? _i8.LegalCase.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.ContactMessage?>()) {
      return (data != null ? _i9.ContactMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.PublicArticle?>()) {
      return (data != null ? _i10.PublicArticle.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.PublicPartner?>()) {
      return (data != null ? _i11.PublicPartner.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.Greeting?>()) {
      return (data != null ? _i12.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.User?>()) {
      return (data != null ? _i13.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.LegalClient?>()) {
      return (data != null ? _i14.LegalClient.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.Negotiation?>()) {
      return (data != null ? _i15.Negotiation.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.NegotiationEvent?>()) {
      return (data != null ? _i16.NegotiationEvent.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i17.ManagedUser>) {
      return (data as List)
              .map((e) => deserialize<_i17.ManagedUser>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i18.LegalCase>) {
      return (data as List).map((e) => deserialize<_i18.LegalCase>(e)).toList()
          as T;
    }
    if (t == List<_i19.ContactMessage>) {
      return (data as List)
              .map((e) => deserialize<_i19.ContactMessage>(e))
              .toList()
          as T;
    }
    if (t == List<_i20.PublicArticle>) {
      return (data as List)
              .map((e) => deserialize<_i20.PublicArticle>(e))
              .toList()
          as T;
    }
    if (t == List<_i21.PublicPartner>) {
      return (data as List)
              .map((e) => deserialize<_i21.PublicPartner>(e))
              .toList()
          as T;
    }
    if (t == List<_i22.LegalClient>) {
      return (data as List)
              .map((e) => deserialize<_i22.LegalClient>(e))
              .toList()
          as T;
    }
    if (t == List<_i23.Negotiation>) {
      return (data as List)
              .map((e) => deserialize<_i23.Negotiation>(e))
              .toList()
          as T;
    }
    if (t == List<_i24.NegotiationEvent>) {
      return (data as List)
              .map((e) => deserialize<_i24.NegotiationEvent>(e))
              .toList()
          as T;
    }
    try {
      return _i25.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i26.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.AccessDeniedException => 'AccessDeniedException',
      _i3.ManagedUser => 'ManagedUser',
      _i4.BillingCharge => 'BillingCharge',
      _i5.BillingException => 'BillingException',
      _i6.BillingStatus => 'BillingStatus',
      _i7.DataJudException => 'DataJudException',
      _i8.LegalCase => 'LegalCase',
      _i9.ContactMessage => 'ContactMessage',
      _i10.PublicArticle => 'PublicArticle',
      _i11.PublicPartner => 'PublicPartner',
      _i12.Greeting => 'Greeting',
      _i13.User => 'User',
      _i14.LegalClient => 'LegalClient',
      _i15.Negotiation => 'Negotiation',
      _i16.NegotiationEvent => 'NegotiationEvent',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('signcob.', '');
    }

    switch (data) {
      case _i2.AccessDeniedException():
        return 'AccessDeniedException';
      case _i3.ManagedUser():
        return 'ManagedUser';
      case _i4.BillingCharge():
        return 'BillingCharge';
      case _i5.BillingException():
        return 'BillingException';
      case _i6.BillingStatus():
        return 'BillingStatus';
      case _i7.DataJudException():
        return 'DataJudException';
      case _i8.LegalCase():
        return 'LegalCase';
      case _i9.ContactMessage():
        return 'ContactMessage';
      case _i10.PublicArticle():
        return 'PublicArticle';
      case _i11.PublicPartner():
        return 'PublicPartner';
      case _i12.Greeting():
        return 'Greeting';
      case _i13.User():
        return 'User';
      case _i14.LegalClient():
        return 'LegalClient';
      case _i15.Negotiation():
        return 'Negotiation';
      case _i16.NegotiationEvent():
        return 'NegotiationEvent';
    }
    className = _i25.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i26.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AccessDeniedException') {
      return deserialize<_i2.AccessDeniedException>(data['data']);
    }
    if (dataClassName == 'ManagedUser') {
      return deserialize<_i3.ManagedUser>(data['data']);
    }
    if (dataClassName == 'BillingCharge') {
      return deserialize<_i4.BillingCharge>(data['data']);
    }
    if (dataClassName == 'BillingException') {
      return deserialize<_i5.BillingException>(data['data']);
    }
    if (dataClassName == 'BillingStatus') {
      return deserialize<_i6.BillingStatus>(data['data']);
    }
    if (dataClassName == 'DataJudException') {
      return deserialize<_i7.DataJudException>(data['data']);
    }
    if (dataClassName == 'LegalCase') {
      return deserialize<_i8.LegalCase>(data['data']);
    }
    if (dataClassName == 'ContactMessage') {
      return deserialize<_i9.ContactMessage>(data['data']);
    }
    if (dataClassName == 'PublicArticle') {
      return deserialize<_i10.PublicArticle>(data['data']);
    }
    if (dataClassName == 'PublicPartner') {
      return deserialize<_i11.PublicPartner>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i12.Greeting>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i13.User>(data['data']);
    }
    if (dataClassName == 'LegalClient') {
      return deserialize<_i14.LegalClient>(data['data']);
    }
    if (dataClassName == 'Negotiation') {
      return deserialize<_i15.Negotiation>(data['data']);
    }
    if (dataClassName == 'NegotiationEvent') {
      return deserialize<_i16.NegotiationEvent>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i25.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i26.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i25.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i26.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
