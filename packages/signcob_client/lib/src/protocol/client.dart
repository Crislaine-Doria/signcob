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
import 'dart:async' as _i2;
import 'package:signcob_client/src/protocol/access/managed_user.dart' as _i3;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i4;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i5;
import 'package:signcob_client/src/protocol/billing/billing_charge.dart' as _i6;
import 'package:signcob_client/src/protocol/billing/billing_create_request.dart'
    as _i7;
import 'package:signcob_client/src/protocol/billing/billing_customer_link.dart'
    as _i8;
import 'package:signcob_client/src/protocol/billing/billing_client_option.dart'
    as _i9;
import 'package:signcob_client/src/protocol/billing/billing_negotiation_option.dart'
    as _i10;
import 'package:signcob_client/src/protocol/cases/legal_case.dart' as _i11;
import 'package:signcob_client/src/protocol/chat/chat_client_option.dart'
    as _i12;
import 'package:signcob_client/src/protocol/chat/chat_conversation.dart'
    as _i13;
import 'package:signcob_client/src/protocol/chat/chat_participant.dart' as _i14;
import 'package:signcob_client/src/protocol/chat/chat_message.dart' as _i15;
import 'package:signcob_client/src/protocol/contact/contact_message.dart'
    as _i16;
import 'package:signcob_client/src/protocol/content/public_article.dart'
    as _i17;
import 'package:signcob_client/src/protocol/content/public_partner.dart'
    as _i18;
import 'package:signcob_client/src/protocol/greetings/greeting.dart' as _i19;
import 'package:signcob_client/src/protocol/legal/legal_client.dart' as _i20;
import 'package:signcob_client/src/protocol/negotiations/negotiation.dart'
    as _i21;
import 'package:signcob_client/src/protocol/negotiations/negotiation_event.dart'
    as _i22;
import 'protocol.dart' as _i23;

/// {@category Endpoint}
class EndpointAccessAdmin extends _i1.EndpointRef {
  EndpointAccessAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'accessAdmin';

  _i2.Future<List<_i3.ManagedUser>> list(int offset) =>
      caller.callServerEndpoint<List<_i3.ManagedUser>>(
        'accessAdmin',
        'list',
        {'offset': offset},
      );

  _i2.Future<void> setPermissions(
    String userId,
    List<String> permissions,
  ) => caller.callServerEndpoint<void>(
    'accessAdmin',
    'setPermissions',
    {
      'userId': userId,
      'permissions': permissions,
    },
  );
}

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _i4.EndpointEmailIdpBase {
  EndpointEmailIdp(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i2.Future<_i5.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i5.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i2.Future<_i1.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i2.Future<String> verifyRegistrationCode({
    required _i1.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i2.Future<_i5.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i5.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i2.Future<_i1.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i2.Future<String> verifyPasswordResetCode({
    required _i1.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i2.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i5.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i2.Future<_i5.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i5.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// {@category Endpoint}
class EndpointBilling extends _i1.EndpointRef {
  EndpointBilling(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'billing';

  _i2.Future<_i6.BillingCharge> create(_i7.BillingCreateRequest request) =>
      caller.callServerEndpoint<_i6.BillingCharge>(
        'billing',
        'create',
        {'request': request},
      );

  _i2.Future<_i6.BillingCharge> get(int id) =>
      caller.callServerEndpoint<_i6.BillingCharge>(
        'billing',
        'get',
        {'id': id},
      );

  _i2.Future<List<_i6.BillingCharge>> list(
    String kind,
    int offset,
  ) => caller.callServerEndpoint<List<_i6.BillingCharge>>(
    'billing',
    'list',
    {
      'kind': kind,
      'offset': offset,
    },
  );

  _i2.Future<_i6.BillingCharge?> findIntent(
    int clientId,
    String idempotencyKey,
  ) => caller.callServerEndpoint<_i6.BillingCharge?>(
    'billing',
    'findIntent',
    {
      'clientId': clientId,
      'idempotencyKey': idempotencyKey,
    },
  );

  _i2.Future<_i6.BillingCharge> refresh(int id) =>
      caller.callServerEndpoint<_i6.BillingCharge>(
        'billing',
        'refresh',
        {'id': id},
      );

  _i2.Future<_i8.BillingCustomerLink> resolveCustomer(int clientId) =>
      caller.callServerEndpoint<_i8.BillingCustomerLink>(
        'billing',
        'resolveCustomer',
        {'clientId': clientId},
      );

  _i2.Future<_i8.BillingCustomerLink> reconcileCustomer(int clientId) =>
      caller.callServerEndpoint<_i8.BillingCustomerLink>(
        'billing',
        'reconcileCustomer',
        {'clientId': clientId},
      );

  _i2.Future<List<_i9.BillingClientOption>> listClients(
    String query,
    int offset,
  ) => caller.callServerEndpoint<List<_i9.BillingClientOption>>(
    'billing',
    'listClients',
    {
      'query': query,
      'offset': offset,
    },
  );

  _i2.Future<List<_i10.BillingNegotiationOption>> listNegotiations(
    int clientId,
    String kind,
  ) => caller.callServerEndpoint<List<_i10.BillingNegotiationOption>>(
    'billing',
    'listNegotiations',
    {
      'clientId': clientId,
      'kind': kind,
    },
  );
}

/// {@category Endpoint}
class EndpointCaseRecord extends _i1.EndpointRef {
  EndpointCaseRecord(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'caseRecord';

  _i2.Future<List<_i11.LegalCase>> list(int offset) =>
      caller.callServerEndpoint<List<_i11.LegalCase>>(
        'caseRecord',
        'list',
        {'offset': offset},
      );

  _i2.Future<_i11.LegalCase> importFromDataJud(
    int clientId,
    String tribunal,
    String number,
  ) => caller.callServerEndpoint<_i11.LegalCase>(
    'caseRecord',
    'importFromDataJud',
    {
      'clientId': clientId,
      'tribunal': tribunal,
      'number': number,
    },
  );

  _i2.Future<_i11.LegalCase> sync(int id) =>
      caller.callServerEndpoint<_i11.LegalCase>(
        'caseRecord',
        'sync',
        {'id': id},
      );
}

/// {@category Endpoint}
class EndpointChat extends _i1.EndpointRef {
  EndpointChat(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'chat';

  _i2.Future<List<_i12.ChatClientOption>> listCreationClients(
    int offset,
    int limit,
  ) => caller.callServerEndpoint<List<_i12.ChatClientOption>>(
    'chat',
    'listCreationClients',
    {
      'offset': offset,
      'limit': limit,
    },
  );

  _i2.Future<_i13.ChatConversation> createConversation(
    int legalClientId,
    String title,
    String requestId,
  ) => caller.callServerEndpoint<_i13.ChatConversation>(
    'chat',
    'createConversation',
    {
      'legalClientId': legalClientId,
      'title': title,
      'requestId': requestId,
    },
  );

  _i2.Future<_i14.ChatParticipant> addParticipant(
    int conversationId,
    String authUserId,
  ) => caller.callServerEndpoint<_i14.ChatParticipant>(
    'chat',
    'addParticipant',
    {
      'conversationId': conversationId,
      'authUserId': authUserId,
    },
  );

  _i2.Future<void> removeParticipant(
    int conversationId,
    String authUserId,
  ) => caller.callServerEndpoint<void>(
    'chat',
    'removeParticipant',
    {
      'conversationId': conversationId,
      'authUserId': authUserId,
    },
  );

  _i2.Future<List<_i14.ChatParticipant>> listParticipants(
    int conversationId,
    int offset,
    int limit,
  ) => caller.callServerEndpoint<List<_i14.ChatParticipant>>(
    'chat',
    'listParticipants',
    {
      'conversationId': conversationId,
      'offset': offset,
      'limit': limit,
    },
  );

  _i2.Future<List<_i13.ChatConversation>> listConversations(
    int offset,
    int limit,
  ) => caller.callServerEndpoint<List<_i13.ChatConversation>>(
    'chat',
    'listConversations',
    {
      'offset': offset,
      'limit': limit,
    },
  );

  _i2.Future<List<_i15.ChatMessage>> listMessages(
    int conversationId,
    int offset,
    int limit,
  ) => caller.callServerEndpoint<List<_i15.ChatMessage>>(
    'chat',
    'listMessages',
    {
      'conversationId': conversationId,
      'offset': offset,
      'limit': limit,
    },
  );

  _i2.Future<_i15.ChatMessage> sendMessage(
    int conversationId,
    String content,
  ) => caller.callServerEndpoint<_i15.ChatMessage>(
    'chat',
    'sendMessage',
    {
      'conversationId': conversationId,
      'content': content,
    },
  );
}

/// Contact inbox available only to explicitly authorized operators.
/// {@category Endpoint}
class EndpointContactAdmin extends _i1.EndpointRef {
  EndpointContactAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'contactAdmin';

  _i2.Future<List<_i16.ContactMessage>> list(int offset) =>
      caller.callServerEndpoint<List<_i16.ContactMessage>>(
        'contactAdmin',
        'list',
        {'offset': offset},
      );
}

/// Receives contact requests without exposing stored messages publicly.
/// {@category Endpoint}
class EndpointContact extends _i1.EndpointRef {
  EndpointContact(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'contact';

  _i2.Future<void> submit(
    String name,
    String email,
    String message,
  ) => caller.callServerEndpoint<void>(
    'contact',
    'submit',
    {
      'name': name,
      'email': email,
      'message': message,
    },
  );
}

/// {@category Endpoint}
class EndpointContent extends _i1.EndpointRef {
  EndpointContent(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'content';

  _i2.Future<List<_i17.PublicArticle>> articles(int offset) =>
      caller.callServerEndpoint<List<_i17.PublicArticle>>(
        'content',
        'articles',
        {'offset': offset},
      );

  _i2.Future<List<_i18.PublicPartner>> partners(int offset) =>
      caller.callServerEndpoint<List<_i18.PublicPartner>>(
        'content',
        'partners',
        {'offset': offset},
      );

  _i2.Future<List<_i17.PublicArticle>> adminArticles(int offset) =>
      caller.callServerEndpoint<List<_i17.PublicArticle>>(
        'content',
        'adminArticles',
        {'offset': offset},
      );

  _i2.Future<List<_i18.PublicPartner>> adminPartners(int offset) =>
      caller.callServerEndpoint<List<_i18.PublicPartner>>(
        'content',
        'adminPartners',
        {'offset': offset},
      );

  _i2.Future<_i17.PublicArticle> saveArticle(
    int? id,
    String title,
    String summary,
    String body,
    String? externalUrl,
    bool published,
  ) => caller.callServerEndpoint<_i17.PublicArticle>(
    'content',
    'saveArticle',
    {
      'id': id,
      'title': title,
      'summary': summary,
      'body': body,
      'externalUrl': externalUrl,
      'published': published,
    },
  );

  _i2.Future<_i18.PublicPartner> savePartner(
    int? id,
    String name,
    String description,
    String website,
    bool active,
  ) => caller.callServerEndpoint<_i18.PublicPartner>(
    'content',
    'savePartner',
    {
      'id': id,
      'name': name,
      'description': description,
      'website': website,
      'active': active,
    },
  );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i1.EndpointRef {
  EndpointGreeting(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i2.Future<_i19.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i19.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );

  _i2.Future<_i19.Greeting> ola(String name) =>
      caller.callServerEndpoint<_i19.Greeting>(
        'greeting',
        'ola',
        {'name': name},
      );
}

/// {@category Endpoint}
class EndpointLegalClient extends _i1.EndpointRef {
  EndpointLegalClient(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'legalClient';

  _i2.Future<List<_i20.LegalClient>> list(int offset) =>
      caller.callServerEndpoint<List<_i20.LegalClient>>(
        'legalClient',
        'list',
        {'offset': offset},
      );

  _i2.Future<_i20.LegalClient> create(
    String name,
    String? email,
    String? phone,
    String? document,
  ) => caller.callServerEndpoint<_i20.LegalClient>(
    'legalClient',
    'create',
    {
      'name': name,
      'email': email,
      'phone': phone,
      'document': document,
    },
  );

  _i2.Future<_i20.LegalClient> update(
    int id,
    String name,
    String? email,
    String? phone,
    String? document,
  ) => caller.callServerEndpoint<_i20.LegalClient>(
    'legalClient',
    'update',
    {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'document': document,
    },
  );

  _i2.Future<_i20.LegalClient> bindOwner(
    int id,
    String? authUserId,
  ) => caller.callServerEndpoint<_i20.LegalClient>(
    'legalClient',
    'bindOwner',
    {
      'id': id,
      'authUserId': authUserId,
    },
  );

  _i2.Future<_i20.LegalClient> assign(
    int id,
    String? lawyerId,
  ) => caller.callServerEndpoint<_i20.LegalClient>(
    'legalClient',
    'assign',
    {
      'id': id,
      'lawyerId': lawyerId,
    },
  );
}

/// {@category Endpoint}
class EndpointNegotiation extends _i1.EndpointRef {
  EndpointNegotiation(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'negotiation';

  _i2.Future<List<_i21.Negotiation>> list(
    int offset,
    String kind,
  ) => caller.callServerEndpoint<List<_i21.Negotiation>>(
    'negotiation',
    'list',
    {
      'offset': offset,
      'kind': kind,
    },
  );

  _i2.Future<_i21.Negotiation> create(
    int clientId,
    String kind,
    String title,
    int amountCents,
  ) => caller.callServerEndpoint<_i21.Negotiation>(
    'negotiation',
    'create',
    {
      'clientId': clientId,
      'kind': kind,
      'title': title,
      'amountCents': amountCents,
    },
  );

  _i2.Future<_i21.Negotiation> transition(
    int id,
    String toStatus,
    String? note,
  ) => caller.callServerEndpoint<_i21.Negotiation>(
    'negotiation',
    'transition',
    {
      'id': id,
      'toStatus': toStatus,
      'note': note,
    },
  );

  _i2.Future<List<_i22.NegotiationEvent>> history(int id) =>
      caller.callServerEndpoint<List<_i22.NegotiationEvent>>(
        'negotiation',
        'history',
        {'id': id},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i4.Caller(client);
    serverpod_auth_core = _i5.Caller(client);
  }

  late final _i4.Caller serverpod_auth_idp;

  late final _i5.Caller serverpod_auth_core;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i23.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    accessAdmin = EndpointAccessAdmin(this);
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    billing = EndpointBilling(this);
    caseRecord = EndpointCaseRecord(this);
    chat = EndpointChat(this);
    contactAdmin = EndpointContactAdmin(this);
    contact = EndpointContact(this);
    content = EndpointContent(this);
    greeting = EndpointGreeting(this);
    legalClient = EndpointLegalClient(this);
    negotiation = EndpointNegotiation(this);
    modules = Modules(this);
  }

  late final EndpointAccessAdmin accessAdmin;

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointBilling billing;

  late final EndpointCaseRecord caseRecord;

  late final EndpointChat chat;

  late final EndpointContactAdmin contactAdmin;

  late final EndpointContact contact;

  late final EndpointContent content;

  late final EndpointGreeting greeting;

  late final EndpointLegalClient legalClient;

  late final EndpointNegotiation negotiation;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'accessAdmin': accessAdmin,
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'billing': billing,
    'caseRecord': caseRecord,
    'chat': chat,
    'contactAdmin': contactAdmin,
    'contact': contact,
    'content': content,
    'greeting': greeting,
    'legalClient': legalClient,
    'negotiation': negotiation,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
