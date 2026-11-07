import 'package:signcob_client/signcob_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'screens/contact_screen.dart';
import 'screens/public_home_screen.dart';
import 'screens/calculator_hub_screen.dart';
import 'screens/admin_contacts_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/admin_users_screen.dart';
import 'screens/admin_clients_screen.dart';
import 'screens/admin_cases_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/content_screen.dart';
import 'screens/admin_negotiations_screen.dart';
import 'screens/admin_billing_screen.dart';
import 'screens/admin_chat_screen.dart';
import 'screens/chat_provisioning_panel.dart';
import 'screens/calculators/work_accident_screen.dart';
import 'screens/privacy_screen.dart';
import 'theme/signcob_theme.dart';

late final Client client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final serverUrl = await getServerUrl();
  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();
  await client.auth.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SignCob',
      theme: SignCobTheme.dark,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => PublicHomeScreen(
          onCalculators: () => Navigator.pushNamed(context, '/calculadoras'),
          onContact: () => Navigator.pushNamed(context, '/contato'),
          onAdmin: () => Navigator.pushNamed(context, '/administrativo'),
          onBlog: () => Navigator.pushNamed(context, '/blog'),
          onPartners: () => Navigator.pushNamed(context, '/parceiros'),
        ),
        '/calculadoras': (_) => const CalculatorHubScreen(),
        '/acidente-trabalho': (_) => const WorkAccidentScreen(),
        '/privacidade': (_) => const PrivacyScreen(),
        '/blog': (_) => ContentScreen(
          key: const ValueKey('public-blog'),
          partners: false,
          loadArticles: client.content.articles,
          loadPartners: client.content.partners,
        ),
        '/parceiros': (_) => ContentScreen(
          key: const ValueKey('public-partners'),
          partners: true,
          loadArticles: client.content.articles,
          loadPartners: client.content.partners,
        ),
        '/contato': (context) => ContactScreen(
          onOpenAdmin: () => Navigator.pushNamed(context, '/administrativo'),
          onSubmit: (name, email, message) =>
              client.contact.submit(name, email, message),
        ),
        '/administrativo': (_) => SignInScreen(
          child: AdminDashboardScreen(
            chat: AdminChatScreen(
              sessionIdentity: client.auth.authInfo?.authUserId,
              loadConversations: (offset) async {
                final rows = await client.chat.listConversations(
                  offset,
                  chatPageSize,
                );
                return rows
                    .map(
                      (row) => ChatConversationItem(
                        id: row.id!,
                        title: row.title,
                        updatedAt: row.createdAt,
                      ),
                    )
                    .toList(growable: false);
              },
              loadMessages: (conversationId, offset) async {
                final currentUser = client.auth.authInfo?.authUserId.toString();
                final rows = await client.chat.listMessages(
                  conversationId,
                  offset,
                  chatPageSize,
                );
                return rows
                    .map(
                      (row) => ChatMessageItem(
                        id: row.id!,
                        authorLabel: row.authorAuthUserId == currentUser
                            ? 'Você'
                            : 'Participante',
                        content: row.content,
                        createdAt: row.createdAt,
                        isCurrentUser: row.authorAuthUserId == currentUser,
                      ),
                    )
                    .toList(growable: false);
              },
              sendMessage: (conversationId, content) async {
                final currentUser = client.auth.authInfo?.authUserId.toString();
                final row = await client.chat.sendMessage(
                  conversationId,
                  content,
                );
                return ChatMessageItem(
                  id: row.id!,
                  authorLabel: row.authorAuthUserId == currentUser
                      ? 'Você'
                      : 'Participante',
                  content: row.content,
                  createdAt: row.createdAt,
                  isCurrentUser: row.authorAuthUserId == currentUser,
                );
              },
              provisioning: ServerpodChatProvisioning(client),
            ),
            mayReadBilling: () =>
                client.auth.authInfo?.scopeNames.contains('billing.read') ??
                false,
            billingDebts: AdminBillingScreen(
              key: const ValueKey('billing-debt'),
              kind: 'debt',
              mayWrite: () =>
                  client.auth.authInfo?.scopeNames.contains('billing.write') ??
                  false,
              loadCharges: client.billing.list,
              createCharge: client.billing.create,
              findIntent: client.billing.findIntent,
              getCharge: client.billing.get,
              refreshCharge: client.billing.refresh,
              reconcileCustomer: client.billing.reconcileCustomer,
              loadClients: client.billing.listClients,
              loadNegotiations: client.billing.listNegotiations,
            ),
            billingFees: AdminBillingScreen(
              key: const ValueKey('billing-fees'),
              kind: 'fees',
              mayWrite: () =>
                  client.auth.authInfo?.scopeNames.contains('billing.write') ??
                  false,
              loadCharges: client.billing.list,
              createCharge: client.billing.create,
              findIntent: client.billing.findIntent,
              getCharge: client.billing.get,
              refreshCharge: client.billing.refresh,
              reconcileCustomer: client.billing.reconcileCustomer,
              loadClients: client.billing.listClients,
              loadNegotiations: client.billing.listNegotiations,
            ),
            debts: AdminNegotiationsScreen(
              key: const ValueKey('negotiations-debt'),
              kind: 'debt',
              loadNegotiations: client.negotiation.list,
              createNegotiation: client.negotiation.create,
              changeNegotiation: client.negotiation.transition,
              loadHistory: client.negotiation.history,
            ),
            fees: AdminNegotiationsScreen(
              key: const ValueKey('negotiations-fees'),
              kind: 'fees',
              loadNegotiations: client.negotiation.list,
              createNegotiation: client.negotiation.create,
              changeNegotiation: client.negotiation.transition,
              loadHistory: client.negotiation.history,
            ),
            articles: ContentScreen(
              key: const ValueKey('admin-blog'),
              partners: false,
              loadArticles: client.content.adminArticles,
              loadPartners: client.content.adminPartners,
              saveArticle: client.content.saveArticle,
            ),
            partners: ContentScreen(
              key: const ValueKey('admin-partners'),
              partners: true,
              loadArticles: client.content.adminArticles,
              loadPartners: client.content.adminPartners,
              savePartner: client.content.savePartner,
            ),
            cases: AdminCasesScreen(
              loadCases: (offset) => client.caseRecord.list(offset),
              importCase: (clientId, tribunal, number) => client.caseRecord
                  .importFromDataJud(clientId, tribunal, number),
              syncCase: (id) => client.caseRecord.sync(id),
            ),
            clients: AdminClientsScreen(
              bindOwner: (id, authId) async {
                await client.legalClient.bindOwner(id, authId);
              },
              assignLawyer: (id, lawyerId) async {
                await client.legalClient.assign(id, lawyerId);
              },
              loadClients: (offset) => client.legalClient.list(offset),
              saveClient: (id, name, email, phone, document) => id == null
                  ? client.legalClient.create(name, email, phone, document)
                  : client.legalClient.update(id, name, email, phone, document),
            ),
            contacts: AdminContactsScreen(
              loadContacts: (offset) => client.contactAdmin.list(offset),
              onSignOut: () => client.auth.signOutDevice(),
            ),
            users: AdminUsersScreen(
              loadUsers: (offset) => client.accessAdmin.list(offset),
              savePermissions: (userId, permissions) =>
                  client.accessAdmin.setPermissions(userId, permissions),
            ),
            onSignOut: () => client.auth.signOutDevice(),
          ),
        ),
      },
    );
  }
}
