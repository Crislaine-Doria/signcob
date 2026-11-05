import '../generated/protocol.dart';

abstract interface class BillingProvider {
  /// Validates configuration and capability without making an external call.
  void ensureCreationAvailable();

  /// The reservation has already been committed. Use its ID as a stable
  /// external reference when a provider supports creating charges.
  Future<({String id, BillingStatus status})> create(BillingCharge charge);

  Future<BillingStatus> fetchStatus(String providerId);
}
