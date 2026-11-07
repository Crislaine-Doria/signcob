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
import 'billing/billing_client_option.dart' as _i5;
import 'billing/billing_create_request.dart' as _i6;
import 'billing/billing_customer_link.dart' as _i7;
import 'billing/billing_cycle.dart' as _i8;
import 'billing/billing_exception.dart' as _i9;
import 'billing/billing_flow.dart' as _i10;
import 'billing/billing_method.dart' as _i11;
import 'billing/billing_negotiation_option.dart' as _i12;
import 'billing/billing_payment.dart' as _i13;
import 'billing/billing_status.dart' as _i14;
import 'cases/datajud_exception.dart' as _i15;
import 'cases/legal_case.dart' as _i16;
import 'chat/chat_client_option.dart' as _i17;
import 'chat/chat_conversation.dart' as _i18;
import 'chat/chat_message.dart' as _i19;
import 'chat/chat_participant.dart' as _i20;
import 'contact/contact_message.dart' as _i21;
import 'content/public_article.dart' as _i22;
import 'content/public_partner.dart' as _i23;
import 'greetings/greeting.dart' as _i24;
import 'greetings/user.dart' as _i25;
import 'legal/legal_client.dart' as _i26;
import 'negotiations/negotiation.dart' as _i27;
import 'negotiations/negotiation_event.dart' as _i28;
import 'package:signcob_client/src/protocol/access/managed_user.dart' as _i29;
import 'package:signcob_client/src/protocol/billing/billing_charge.dart'
    as _i30;
import 'package:signcob_client/src/protocol/billing/billing_client_option.dart'
    as _i31;
import 'package:signcob_client/src/protocol/billing/billing_negotiation_option.dart'
    as _i32;
import 'package:signcob_client/src/protocol/cases/legal_case.dart' as _i33;
import 'package:signcob_client/src/protocol/chat/chat_client_option.dart'
    as _i34;
import 'package:signcob_client/src/protocol/chat/chat_participant.dart' as _i35;
import 'package:signcob_client/src/protocol/chat/chat_conversation.dart'
    as _i36;
import 'package:signcob_client/src/protocol/chat/chat_message.dart' as _i37;
import 'package:signcob_client/src/protocol/contact/contact_message.dart'
    as _i38;
import 'package:signcob_client/src/protocol/content/public_article.dart'
    as _i39;
import 'package:signcob_client/src/protocol/content/public_partner.dart'
    as _i40;
import 'package:signcob_client/src/protocol/legal/legal_client.dart' as _i41;
import 'package:signcob_client/src/protocol/negotiations/negotiation.dart'
    as _i42;
import 'package:signcob_client/src/protocol/negotiations/negotiation_event.dart'
    as _i43;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i44;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i45;
export 'access/access_denied_exception.dart';
export 'access/managed_user.dart';
export 'billing/billing_charge.dart';
export 'billing/billing_client_option.dart';
export 'billing/billing_create_request.dart';
export 'billing/billing_customer_link.dart';
export 'billing/billing_cycle.dart';
export 'billing/billing_exception.dart';
export 'billing/billing_flow.dart';
export 'billing/billing_method.dart';
export 'billing/billing_negotiation_option.dart';
export 'billing/billing_payment.dart';
export 'billing/billing_status.dart';
export 'cases/datajud_exception.dart';
export 'cases/legal_case.dart';
export 'chat/chat_client_option.dart';
export 'chat/chat_conversation.dart';
export 'chat/chat_message.dart';
export 'chat/chat_participant.dart';
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
    if (t == _i5.BillingClientOption) {
      return _i5.BillingClientOption.fromJson(data) as T;
    }
    if (t == _i6.BillingCreateRequest) {
      return _i6.BillingCreateRequest.fromJson(data) as T;
    }
    if (t == _i7.BillingCustomerLink) {
      return _i7.BillingCustomerLink.fromJson(data) as T;
    }
    if (t == _i8.BillingCycle) {
      return _i8.BillingCycle.fromJson(data) as T;
    }
    if (t == _i9.BillingException) {
      return _i9.BillingException.fromJson(data) as T;
    }
    if (t == _i10.BillingFlow) {
      return _i10.BillingFlow.fromJson(data) as T;
    }
    if (t == _i11.BillingMethod) {
      return _i11.BillingMethod.fromJson(data) as T;
    }
    if (t == _i12.BillingNegotiationOption) {
      return _i12.BillingNegotiationOption.fromJson(data) as T;
    }
    if (t == _i13.BillingPayment) {
      return _i13.BillingPayment.fromJson(data) as T;
    }
    if (t == _i14.BillingStatus) {
      return _i14.BillingStatus.fromJson(data) as T;
    }
    if (t == _i15.DataJudException) {
      return _i15.DataJudException.fromJson(data) as T;
    }
    if (t == _i16.LegalCase) {
      return _i16.LegalCase.fromJson(data) as T;
    }
    if (t == _i17.ChatClientOption) {
      return _i17.ChatClientOption.fromJson(data) as T;
    }
    if (t == _i18.ChatConversation) {
      return _i18.ChatConversation.fromJson(data) as T;
    }
    if (t == _i19.ChatMessage) {
      return _i19.ChatMessage.fromJson(data) as T;
    }
    if (t == _i20.ChatParticipant) {
      return _i20.ChatParticipant.fromJson(data) as T;
    }
    if (t == _i21.ContactMessage) {
      return _i21.ContactMessage.fromJson(data) as T;
    }
    if (t == _i22.PublicArticle) {
      return _i22.PublicArticle.fromJson(data) as T;
    }
    if (t == _i23.PublicPartner) {
      return _i23.PublicPartner.fromJson(data) as T;
    }
    if (t == _i24.Greeting) {
      return _i24.Greeting.fromJson(data) as T;
    }
    if (t == _i25.User) {
      return _i25.User.fromJson(data) as T;
    }
    if (t == _i26.LegalClient) {
      return _i26.LegalClient.fromJson(data) as T;
    }
    if (t == _i27.Negotiation) {
      return _i27.Negotiation.fromJson(data) as T;
    }
    if (t == _i28.NegotiationEvent) {
      return _i28.NegotiationEvent.fromJson(data) as T;
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
    if (t == _i1.getType<_i5.BillingClientOption?>()) {
      return (data != null ? _i5.BillingClientOption.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.BillingCreateRequest?>()) {
      return (data != null ? _i6.BillingCreateRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.BillingCustomerLink?>()) {
      return (data != null ? _i7.BillingCustomerLink.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.BillingCycle?>()) {
      return (data != null ? _i8.BillingCycle.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.BillingException?>()) {
      return (data != null ? _i9.BillingException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.BillingFlow?>()) {
      return (data != null ? _i10.BillingFlow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.BillingMethod?>()) {
      return (data != null ? _i11.BillingMethod.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.BillingNegotiationOption?>()) {
      return (data != null
              ? _i12.BillingNegotiationOption.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i13.BillingPayment?>()) {
      return (data != null ? _i13.BillingPayment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.BillingStatus?>()) {
      return (data != null ? _i14.BillingStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.DataJudException?>()) {
      return (data != null ? _i15.DataJudException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.LegalCase?>()) {
      return (data != null ? _i16.LegalCase.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.ChatClientOption?>()) {
      return (data != null ? _i17.ChatClientOption.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.ChatConversation?>()) {
      return (data != null ? _i18.ChatConversation.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.ChatMessage?>()) {
      return (data != null ? _i19.ChatMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.ChatParticipant?>()) {
      return (data != null ? _i20.ChatParticipant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.ContactMessage?>()) {
      return (data != null ? _i21.ContactMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.PublicArticle?>()) {
      return (data != null ? _i22.PublicArticle.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.PublicPartner?>()) {
      return (data != null ? _i23.PublicPartner.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.Greeting?>()) {
      return (data != null ? _i24.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.User?>()) {
      return (data != null ? _i25.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.LegalClient?>()) {
      return (data != null ? _i26.LegalClient.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.Negotiation?>()) {
      return (data != null ? _i27.Negotiation.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.NegotiationEvent?>()) {
      return (data != null ? _i28.NegotiationEvent.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i13.BillingPayment>) {
      return (data as List)
              .map((e) => deserialize<_i13.BillingPayment>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i13.BillingPayment>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i13.BillingPayment>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i29.ManagedUser>) {
      return (data as List)
              .map((e) => deserialize<_i29.ManagedUser>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i30.BillingCharge>) {
      return (data as List)
              .map((e) => deserialize<_i30.BillingCharge>(e))
              .toList()
          as T;
    }
    if (t == List<_i31.BillingClientOption>) {
      return (data as List)
              .map((e) => deserialize<_i31.BillingClientOption>(e))
              .toList()
          as T;
    }
    if (t == List<_i32.BillingNegotiationOption>) {
      return (data as List)
              .map((e) => deserialize<_i32.BillingNegotiationOption>(e))
              .toList()
          as T;
    }
    if (t == List<_i33.LegalCase>) {
      return (data as List).map((e) => deserialize<_i33.LegalCase>(e)).toList()
          as T;
    }
    if (t == List<_i34.ChatClientOption>) {
      return (data as List)
              .map((e) => deserialize<_i34.ChatClientOption>(e))
              .toList()
          as T;
    }
    if (t == List<_i35.ChatParticipant>) {
      return (data as List)
              .map((e) => deserialize<_i35.ChatParticipant>(e))
              .toList()
          as T;
    }
    if (t == List<_i36.ChatConversation>) {
      return (data as List)
              .map((e) => deserialize<_i36.ChatConversation>(e))
              .toList()
          as T;
    }
    if (t == List<_i37.ChatMessage>) {
      return (data as List)
              .map((e) => deserialize<_i37.ChatMessage>(e))
              .toList()
          as T;
    }
    if (t == List<_i38.ContactMessage>) {
      return (data as List)
              .map((e) => deserialize<_i38.ContactMessage>(e))
              .toList()
          as T;
    }
    if (t == List<_i39.PublicArticle>) {
      return (data as List)
              .map((e) => deserialize<_i39.PublicArticle>(e))
              .toList()
          as T;
    }
    if (t == List<_i40.PublicPartner>) {
      return (data as List)
              .map((e) => deserialize<_i40.PublicPartner>(e))
              .toList()
          as T;
    }
    if (t == List<_i41.LegalClient>) {
      return (data as List)
              .map((e) => deserialize<_i41.LegalClient>(e))
              .toList()
          as T;
    }
    if (t == List<_i42.Negotiation>) {
      return (data as List)
              .map((e) => deserialize<_i42.Negotiation>(e))
              .toList()
          as T;
    }
    if (t == List<_i43.NegotiationEvent>) {
      return (data as List)
              .map((e) => deserialize<_i43.NegotiationEvent>(e))
              .toList()
          as T;
    }
    try {
      return _i44.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i45.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.AccessDeniedException => 'AccessDeniedException',
      _i3.ManagedUser => 'ManagedUser',
      _i4.BillingCharge => 'BillingCharge',
      _i5.BillingClientOption => 'BillingClientOption',
      _i6.BillingCreateRequest => 'BillingCreateRequest',
      _i7.BillingCustomerLink => 'BillingCustomerLink',
      _i8.BillingCycle => 'BillingCycle',
      _i9.BillingException => 'BillingException',
      _i10.BillingFlow => 'BillingFlow',
      _i11.BillingMethod => 'BillingMethod',
      _i12.BillingNegotiationOption => 'BillingNegotiationOption',
      _i13.BillingPayment => 'BillingPayment',
      _i14.BillingStatus => 'BillingStatus',
      _i15.DataJudException => 'DataJudException',
      _i16.LegalCase => 'LegalCase',
      _i17.ChatClientOption => 'ChatClientOption',
      _i18.ChatConversation => 'ChatConversation',
      _i19.ChatMessage => 'ChatMessage',
      _i20.ChatParticipant => 'ChatParticipant',
      _i21.ContactMessage => 'ContactMessage',
      _i22.PublicArticle => 'PublicArticle',
      _i23.PublicPartner => 'PublicPartner',
      _i24.Greeting => 'Greeting',
      _i25.User => 'User',
      _i26.LegalClient => 'LegalClient',
      _i27.Negotiation => 'Negotiation',
      _i28.NegotiationEvent => 'NegotiationEvent',
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
      case _i5.BillingClientOption():
        return 'BillingClientOption';
      case _i6.BillingCreateRequest():
        return 'BillingCreateRequest';
      case _i7.BillingCustomerLink():
        return 'BillingCustomerLink';
      case _i8.BillingCycle():
        return 'BillingCycle';
      case _i9.BillingException():
        return 'BillingException';
      case _i10.BillingFlow():
        return 'BillingFlow';
      case _i11.BillingMethod():
        return 'BillingMethod';
      case _i12.BillingNegotiationOption():
        return 'BillingNegotiationOption';
      case _i13.BillingPayment():
        return 'BillingPayment';
      case _i14.BillingStatus():
        return 'BillingStatus';
      case _i15.DataJudException():
        return 'DataJudException';
      case _i16.LegalCase():
        return 'LegalCase';
      case _i17.ChatClientOption():
        return 'ChatClientOption';
      case _i18.ChatConversation():
        return 'ChatConversation';
      case _i19.ChatMessage():
        return 'ChatMessage';
      case _i20.ChatParticipant():
        return 'ChatParticipant';
      case _i21.ContactMessage():
        return 'ContactMessage';
      case _i22.PublicArticle():
        return 'PublicArticle';
      case _i23.PublicPartner():
        return 'PublicPartner';
      case _i24.Greeting():
        return 'Greeting';
      case _i25.User():
        return 'User';
      case _i26.LegalClient():
        return 'LegalClient';
      case _i27.Negotiation():
        return 'Negotiation';
      case _i28.NegotiationEvent():
        return 'NegotiationEvent';
    }
    className = _i44.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i45.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'BillingClientOption') {
      return deserialize<_i5.BillingClientOption>(data['data']);
    }
    if (dataClassName == 'BillingCreateRequest') {
      return deserialize<_i6.BillingCreateRequest>(data['data']);
    }
    if (dataClassName == 'BillingCustomerLink') {
      return deserialize<_i7.BillingCustomerLink>(data['data']);
    }
    if (dataClassName == 'BillingCycle') {
      return deserialize<_i8.BillingCycle>(data['data']);
    }
    if (dataClassName == 'BillingException') {
      return deserialize<_i9.BillingException>(data['data']);
    }
    if (dataClassName == 'BillingFlow') {
      return deserialize<_i10.BillingFlow>(data['data']);
    }
    if (dataClassName == 'BillingMethod') {
      return deserialize<_i11.BillingMethod>(data['data']);
    }
    if (dataClassName == 'BillingNegotiationOption') {
      return deserialize<_i12.BillingNegotiationOption>(data['data']);
    }
    if (dataClassName == 'BillingPayment') {
      return deserialize<_i13.BillingPayment>(data['data']);
    }
    if (dataClassName == 'BillingStatus') {
      return deserialize<_i14.BillingStatus>(data['data']);
    }
    if (dataClassName == 'DataJudException') {
      return deserialize<_i15.DataJudException>(data['data']);
    }
    if (dataClassName == 'LegalCase') {
      return deserialize<_i16.LegalCase>(data['data']);
    }
    if (dataClassName == 'ChatClientOption') {
      return deserialize<_i17.ChatClientOption>(data['data']);
    }
    if (dataClassName == 'ChatConversation') {
      return deserialize<_i18.ChatConversation>(data['data']);
    }
    if (dataClassName == 'ChatMessage') {
      return deserialize<_i19.ChatMessage>(data['data']);
    }
    if (dataClassName == 'ChatParticipant') {
      return deserialize<_i20.ChatParticipant>(data['data']);
    }
    if (dataClassName == 'ContactMessage') {
      return deserialize<_i21.ContactMessage>(data['data']);
    }
    if (dataClassName == 'PublicArticle') {
      return deserialize<_i22.PublicArticle>(data['data']);
    }
    if (dataClassName == 'PublicPartner') {
      return deserialize<_i23.PublicPartner>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i24.Greeting>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i25.User>(data['data']);
    }
    if (dataClassName == 'LegalClient') {
      return deserialize<_i26.LegalClient>(data['data']);
    }
    if (dataClassName == 'Negotiation') {
      return deserialize<_i27.Negotiation>(data['data']);
    }
    if (dataClassName == 'NegotiationEvent') {
      return deserialize<_i28.NegotiationEvent>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i44.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i45.Protocol().deserializeByClassName(data);
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
      return _i44.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i45.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
