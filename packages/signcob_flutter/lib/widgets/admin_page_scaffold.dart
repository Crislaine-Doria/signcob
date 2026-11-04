import 'package:flutter/material.dart';

/// Consistent readable canvas for internal pages and public forms.
class AdminPageScaffold extends StatelessWidget {
  const AdminPageScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBar,
    floatingActionButton: floatingActionButton,
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: Padding(
              padding: EdgeInsets.symmetric(
                // Lists and forms provide their own comfortable mobile inset.
                horizontal: constraints.maxWidth < 600 ? 0 : 24,
              ),
              child: body,
            ),
          ),
        ),
      ),
    ),
  );
}
