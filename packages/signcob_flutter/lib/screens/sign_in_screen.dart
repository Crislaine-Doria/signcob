import 'package:flutter/material.dart';
import '../widgets/admin_page_scaffold.dart';
import '../widgets/brand_header.dart';
import '../widgets/email_access_form.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../main.dart';

class SignInScreen extends StatefulWidget {
  final Widget child;
  const SignInScreen({super.key, required this.child});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    client.auth.authInfoListenable.addListener(_updateSignedInState);
    _isSignedIn = client.auth.isAuthenticated;
  }

  @override
  void dispose() {
    client.auth.authInfoListenable.removeListener(_updateSignedInState);
    super.dispose();
  }

  void _updateSignedInState() {
    setState(() {
      _isSignedIn = client.auth.isAuthenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isSignedIn
        ? KeyedSubtree(
            key: ValueKey(client.auth.authInfo?.authUserId),
            child: widget.child,
          )
        : AdminPageScaffold(
            appBar: AppBar(title: const Text('Área administrativa')),
            body: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(
                  MediaQuery.sizeOf(context).width < 600 ? 16 : 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(
                        MediaQuery.sizeOf(context).width < 600 ? 20 : 32,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Center(child: BrandHeader()),
                          const SizedBox(height: 12),
                          Text(
                            'Atendimento especializado',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 24),
                          EmailAccessForm(client: client),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
