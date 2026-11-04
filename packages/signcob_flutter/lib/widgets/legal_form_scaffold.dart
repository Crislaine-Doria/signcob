import 'package:flutter/material.dart';

import '../theme/signcob_theme.dart';
import 'brand_header.dart';

/// A shared, readable surface for the public forms and calculators.
class LegalFormScaffold extends StatelessWidget {
  const LegalFormScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.maxWidth = 680,
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title), actions: actions),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width < 600 ? 16 : 32,
          vertical: 24,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.all(
                  MediaQuery.sizeOf(context).width < 600 ? 20 : 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: BrandHeader(compact: true),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Atendimento especializado',
                      style: TextStyle(color: SignCobColors.silver),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(height: 1),
                    ),
                    Semantics(
                      header: true,
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: 16),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
