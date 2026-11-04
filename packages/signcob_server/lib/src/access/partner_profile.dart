import 'package:serverpod/serverpod.dart';
import 'access_admin_endpoint.dart';

/// Explicitly granted partner capabilities for the modules currently registered.
/// Existing external scopes are preserved. New modules require reapplication.
Set<Scope> partnerScopes(Iterable<Scope> existing) => {
  ...existing,
  ...AccessAdminEndpoint.managedPermissions.map(Scope.new),
};
