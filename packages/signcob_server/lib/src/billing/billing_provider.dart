import '../generated/protocol.dart';

abstract interface class BillingProvider {
  Future<String> verifyAccount();

  Future<List<ProviderCustomer>> findCustomers(String document);

  Future<ProviderCustomer> createCustomer({
    required String name,
    required String document,
    required String externalReference,
  });

  void ensureCreationAvailable();
  Future<ProviderPayment> createPayment(BillingChargeRecord charge);
  Future<ProviderPayment> fetchPayment(String providerId);
  Future<List<ProviderPayment>> findPayments(
    String customerId,
    String externalReference,
  );
  Future<List<ProviderPayment>> listInstallmentPayments(String installmentId);
  Future<ProviderSubscription> createSubscription(BillingChargeRecord charge);
  Future<List<ProviderSubscription>> findSubscriptions(
    String customerId,
    String externalReference,
  );
  Future<ProviderSubscription> fetchSubscription(String subscriptionId);
  Future<List<ProviderPayment>> listSubscriptionPayments(String subscriptionId);
}

class ProviderSubscription {
  const ProviderSubscription({
    required this.id,
    required this.customerId,
    required this.externalReference,
    required this.method,
    required this.amountCents,
    required this.nextDueDate,
    required this.cycle,
    required this.rawStatus,
  });

  final String id;
  final String customerId;
  final String? externalReference;
  final BillingMethod method;
  final int amountCents;
  final String nextDueDate;
  final BillingCycle cycle;
  final String rawStatus;
}

class ProviderPayment {
  const ProviderPayment({
    required this.id,
    required this.customerId,
    required this.externalReference,
    required this.method,
    required this.amountCents,
    required this.dueDate,
    required this.rawStatus,
    this.installmentId,
    this.subscriptionId,
    this.installmentNumber,
    this.invoiceUrl,
  });

  final String id;
  final String customerId;
  final String? externalReference;
  final BillingMethod method;
  final int amountCents;
  final String dueDate;
  final String rawStatus;
  final String? installmentId;
  final String? subscriptionId;
  final int? installmentNumber;
  final String? invoiceUrl;
}

class ProviderCustomer {
  const ProviderCustomer({
    required this.id,
    required this.document,
    this.externalReference,
  });

  final String id;
  final String document;
  final String? externalReference;
}
