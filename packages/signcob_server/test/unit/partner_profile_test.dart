import 'package:serverpod/serverpod.dart';
import 'package:signcob_server/src/access/access_admin_endpoint.dart';
import 'package:signcob_server/src/access/partner_profile.dart';
import 'package:test/test.dart';

void main() {
  test(
    'partner includes every managed capability and preserves external scopes',
    () {
      final scopes = partnerScopes({const Scope('external.audit')});
      expect(scopes.map((scope) => scope.name).toSet(), {
        'external.audit',
        ...AccessAdminEndpoint.managedPermissions,
      });
      expect(scopes, contains(const Scope('users.manage')));
      expect(scopes, contains(const Scope('clients.read')));
      expect(scopes, contains(const Scope('cases.write')));
      expect(partnerScopes(scopes), scopes);
    },
  );
}
