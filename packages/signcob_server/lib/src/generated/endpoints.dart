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
import '../access/access_admin_endpoint.dart' as _i2;
import '../auth/email_idp_endpoint.dart' as _i3;
import '../auth/jwt_refresh_endpoint.dart' as _i4;
import '../cases/case_record_endpoint.dart' as _i5;
import '../contact/contact_admin_endpoint.dart' as _i6;
import '../contact/contact_endpoint.dart' as _i7;
import '../content/content_endpoint.dart' as _i8;
import '../greetings/greeting_endpoint.dart' as _i9;
import '../legal/legal_client_endpoint.dart' as _i10;
import '../negotiations/negotiation_endpoint.dart' as _i11;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i12;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i13;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'accessAdmin': _i2.AccessAdminEndpoint()
        ..initialize(
          server,
          'accessAdmin',
          null,
        ),
      'emailIdp': _i3.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _i4.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'caseRecord': _i5.CaseRecordEndpoint()
        ..initialize(
          server,
          'caseRecord',
          null,
        ),
      'contactAdmin': _i6.ContactAdminEndpoint()
        ..initialize(
          server,
          'contactAdmin',
          null,
        ),
      'contact': _i7.ContactEndpoint()
        ..initialize(
          server,
          'contact',
          null,
        ),
      'content': _i8.ContentEndpoint()
        ..initialize(
          server,
          'content',
          null,
        ),
      'greeting': _i9.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
      'legalClient': _i10.LegalClientEndpoint()
        ..initialize(
          server,
          'legalClient',
          null,
        ),
      'negotiation': _i11.NegotiationEndpoint()
        ..initialize(
          server,
          'negotiation',
          null,
        ),
    };
    connectors['accessAdmin'] = _i1.EndpointConnector(
      name: 'accessAdmin',
      endpoint: endpoints['accessAdmin']!,
      methodConnectors: {
        'list': _i1.MethodConnector(
          name: 'list',
          params: {
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['accessAdmin'] as _i2.AccessAdminEndpoint).list(
                    session,
                    params['offset'],
                  ),
        ),
        'setPermissions': _i1.MethodConnector(
          name: 'setPermissions',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'permissions': _i1.ParameterDescription(
              name: 'permissions',
              type: _i1.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['accessAdmin'] as _i2.AccessAdminEndpoint)
                  .setPermissions(
                    session,
                    params['userId'],
                    params['permissions'],
                  ),
        ),
      },
    );
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i3.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i3.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i3.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i3.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i3.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i3.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i3.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i4.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['caseRecord'] = _i1.EndpointConnector(
      name: 'caseRecord',
      endpoint: endpoints['caseRecord']!,
      methodConnectors: {
        'list': _i1.MethodConnector(
          name: 'list',
          params: {
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['caseRecord'] as _i5.CaseRecordEndpoint).list(
                    session,
                    params['offset'],
                  ),
        ),
        'importFromDataJud': _i1.MethodConnector(
          name: 'importFromDataJud',
          params: {
            'clientId': _i1.ParameterDescription(
              name: 'clientId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'tribunal': _i1.ParameterDescription(
              name: 'tribunal',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'number': _i1.ParameterDescription(
              name: 'number',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['caseRecord'] as _i5.CaseRecordEndpoint)
                  .importFromDataJud(
                    session,
                    params['clientId'],
                    params['tribunal'],
                    params['number'],
                  ),
        ),
        'sync': _i1.MethodConnector(
          name: 'sync',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['caseRecord'] as _i5.CaseRecordEndpoint).sync(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['contactAdmin'] = _i1.EndpointConnector(
      name: 'contactAdmin',
      endpoint: endpoints['contactAdmin']!,
      methodConnectors: {
        'list': _i1.MethodConnector(
          name: 'list',
          params: {
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['contactAdmin'] as _i6.ContactAdminEndpoint).list(
                    session,
                    params['offset'],
                  ),
        ),
      },
    );
    connectors['contact'] = _i1.EndpointConnector(
      name: 'contact',
      endpoint: endpoints['contact']!,
      methodConnectors: {
        'submit': _i1.MethodConnector(
          name: 'submit',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'message': _i1.ParameterDescription(
              name: 'message',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['contact'] as _i7.ContactEndpoint).submit(
                session,
                params['name'],
                params['email'],
                params['message'],
              ),
        ),
      },
    );
    connectors['content'] = _i1.EndpointConnector(
      name: 'content',
      endpoint: endpoints['content']!,
      methodConnectors: {
        'articles': _i1.MethodConnector(
          name: 'articles',
          params: {
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['content'] as _i8.ContentEndpoint).articles(
                session,
                params['offset'],
              ),
        ),
        'partners': _i1.MethodConnector(
          name: 'partners',
          params: {
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['content'] as _i8.ContentEndpoint).partners(
                session,
                params['offset'],
              ),
        ),
        'adminArticles': _i1.MethodConnector(
          name: 'adminArticles',
          params: {
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['content'] as _i8.ContentEndpoint).adminArticles(
                    session,
                    params['offset'],
                  ),
        ),
        'adminPartners': _i1.MethodConnector(
          name: 'adminPartners',
          params: {
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['content'] as _i8.ContentEndpoint).adminPartners(
                    session,
                    params['offset'],
                  ),
        ),
        'saveArticle': _i1.MethodConnector(
          name: 'saveArticle',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'summary': _i1.ParameterDescription(
              name: 'summary',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'body': _i1.ParameterDescription(
              name: 'body',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'externalUrl': _i1.ParameterDescription(
              name: 'externalUrl',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'published': _i1.ParameterDescription(
              name: 'published',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['content'] as _i8.ContentEndpoint).saveArticle(
                    session,
                    params['id'],
                    params['title'],
                    params['summary'],
                    params['body'],
                    params['externalUrl'],
                    params['published'],
                  ),
        ),
        'savePartner': _i1.MethodConnector(
          name: 'savePartner',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'website': _i1.ParameterDescription(
              name: 'website',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'active': _i1.ParameterDescription(
              name: 'active',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['content'] as _i8.ContentEndpoint).savePartner(
                    session,
                    params['id'],
                    params['name'],
                    params['description'],
                    params['website'],
                    params['active'],
                  ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i9.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
        'ola': _i1.MethodConnector(
          name: 'ola',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i9.GreetingEndpoint).ola(
                session,
                params['name'],
              ),
        ),
      },
    );
    connectors['legalClient'] = _i1.EndpointConnector(
      name: 'legalClient',
      endpoint: endpoints['legalClient']!,
      methodConnectors: {
        'list': _i1.MethodConnector(
          name: 'list',
          params: {
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['legalClient'] as _i10.LegalClientEndpoint).list(
                    session,
                    params['offset'],
                  ),
        ),
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'phone': _i1.ParameterDescription(
              name: 'phone',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'document': _i1.ParameterDescription(
              name: 'document',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['legalClient'] as _i10.LegalClientEndpoint).create(
                    session,
                    params['name'],
                    params['email'],
                    params['phone'],
                    params['document'],
                  ),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'phone': _i1.ParameterDescription(
              name: 'phone',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'document': _i1.ParameterDescription(
              name: 'document',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['legalClient'] as _i10.LegalClientEndpoint).update(
                    session,
                    params['id'],
                    params['name'],
                    params['email'],
                    params['phone'],
                    params['document'],
                  ),
        ),
        'bindOwner': _i1.MethodConnector(
          name: 'bindOwner',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'authUserId': _i1.ParameterDescription(
              name: 'authUserId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['legalClient'] as _i10.LegalClientEndpoint)
                  .bindOwner(
                    session,
                    params['id'],
                    params['authUserId'],
                  ),
        ),
        'assign': _i1.MethodConnector(
          name: 'assign',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'lawyerId': _i1.ParameterDescription(
              name: 'lawyerId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['legalClient'] as _i10.LegalClientEndpoint).assign(
                    session,
                    params['id'],
                    params['lawyerId'],
                  ),
        ),
      },
    );
    connectors['negotiation'] = _i1.EndpointConnector(
      name: 'negotiation',
      endpoint: endpoints['negotiation']!,
      methodConnectors: {
        'list': _i1.MethodConnector(
          name: 'list',
          params: {
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'kind': _i1.ParameterDescription(
              name: 'kind',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['negotiation'] as _i11.NegotiationEndpoint).list(
                    session,
                    params['offset'],
                    params['kind'],
                  ),
        ),
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'clientId': _i1.ParameterDescription(
              name: 'clientId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'kind': _i1.ParameterDescription(
              name: 'kind',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'amountCents': _i1.ParameterDescription(
              name: 'amountCents',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['negotiation'] as _i11.NegotiationEndpoint).create(
                    session,
                    params['clientId'],
                    params['kind'],
                    params['title'],
                    params['amountCents'],
                  ),
        ),
        'transition': _i1.MethodConnector(
          name: 'transition',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'toStatus': _i1.ParameterDescription(
              name: 'toStatus',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'note': _i1.ParameterDescription(
              name: 'note',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['negotiation'] as _i11.NegotiationEndpoint)
                  .transition(
                    session,
                    params['id'],
                    params['toStatus'],
                    params['note'],
                  ),
        ),
        'history': _i1.MethodConnector(
          name: 'history',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['negotiation'] as _i11.NegotiationEndpoint)
                  .history(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i12.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i13.Endpoints()
      ..initializeEndpoints(server);
  }
}
