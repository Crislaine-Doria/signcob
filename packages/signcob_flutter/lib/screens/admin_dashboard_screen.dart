import 'package:flutter/material.dart';
import '../widgets/admin_page_scaffold.dart';
import '../widgets/brand_header.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({
    super.key,
    required this.contacts,
    required this.users,
    required this.onSignOut,
    this.clients,
    this.cases,
    this.articles,
    this.partners,
    this.debts,
    this.fees,
    this.billingDebts,
    this.billingFees,
    this.chat,
    this.mayReadBilling,
  });
  final Widget contacts;
  final Widget users;
  final Widget? clients;
  final Widget? cases;
  final Widget? articles;
  final Widget? partners;
  final Widget? debts;
  final Widget? fees;
  final Widget? billingDebts;
  final Widget? billingFees;
  final Widget? chat;
  final bool Function()? mayReadBilling;
  final Future<void> Function() onSignOut;
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int? _section;
  bool _leaving = false;
  String? _error;
  final _visitedBilling = <int>{};

  bool get _canReadBilling => widget.mayReadBilling?.call() ?? true;

  void _select(int? section) => setState(() {
    _section = section;
    if (section == 8 || section == 9) _visitedBilling.add(section!);
  });

  Widget _mobileMenu() => DropdownButtonFormField<int>(
    initialValue: _section,
    isExpanded: true,
    decoration: const InputDecoration(labelText: 'Selecionar área'),
    items: [
      const DropdownMenuItem(value: 0, child: Text('Contatos')),
      const DropdownMenuItem(value: 1, child: Text('Usuários e permissões')),
      if (widget.clients != null)
        const DropdownMenuItem(value: 2, child: Text('Clientes')),
      if (widget.cases != null)
        const DropdownMenuItem(value: 3, child: Text('Processos')),
      if (widget.articles != null)
        const DropdownMenuItem(value: 4, child: Text('Blog')),
      if (widget.partners != null)
        const DropdownMenuItem(value: 5, child: Text('Parceiros')),
      if (widget.debts != null)
        const DropdownMenuItem(value: 6, child: Text('Dívidas dos clientes')),
      if (widget.fees != null)
        const DropdownMenuItem(value: 7, child: Text('Honorários e serviços')),
      if (widget.billingDebts != null)
        DropdownMenuItem(
          value: 8,
          enabled: _canReadBilling,
          child: const Text('Cobranças de dívidas'),
        ),
      if (widget.billingFees != null)
        DropdownMenuItem(
          value: 9,
          enabled: _canReadBilling,
          child: const Text('Cobranças de honorários'),
        ),
      if (widget.chat != null)
        const DropdownMenuItem(value: 10, child: Text('Chat interno')),
    ],
    onChanged: _select,
  );
  Future<void> _logout() async {
    setState(() {
      _leaving = true;
      _section = null;
      _error = null;
      _visitedBilling.clear();
    });
    try {
      await widget.onSignOut();
    } catch (_) {
      if (mounted) {
        setState(() {
          _leaving = false;
          _error = 'Não foi possível sair. Tente novamente.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => AdminPageScaffold(
    appBar: AppBar(
      title: const BrandHeader(compact: true),
      actions: [
        TextButton(
          onPressed: _leaving ? null : _logout,
          child: const Text('Sair'),
        ),
      ],
    ),
    body: _leaving
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Área interna',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(
                  builder: (context, constraints) => constraints.maxWidth < 600
                      ? _mobileMenu()
                      : Wrap(
                          spacing: 12,
                          children: [
                            if (widget.debts != null)
                              OutlinedButton(
                                onPressed: () => setState(() => _section = 6),
                                child: const Text('Dívidas dos clientes'),
                              ),
                            if (widget.fees != null)
                              OutlinedButton(
                                onPressed: () => setState(() => _section = 7),
                                child: const Text('Honorários e serviços'),
                              ),
                            if (widget.billingDebts != null)
                              OutlinedButton(
                                onPressed: _canReadBilling
                                    ? () => _select(8)
                                    : null,
                                child: const Text('Cobranças de dívidas'),
                              ),
                            if (widget.billingFees != null)
                              OutlinedButton(
                                onPressed: _canReadBilling
                                    ? () => _select(9)
                                    : null,
                                child: const Text('Cobranças de honorários'),
                              ),
                            if (widget.chat != null)
                              OutlinedButton(
                                onPressed: () => setState(() => _section = 10),
                                child: const Text('Chat interno'),
                              ),
                            if (widget.articles != null)
                              OutlinedButton(
                                onPressed: () => setState(() => _section = 4),
                                child: const Text('Blog'),
                              ),
                            if (widget.partners != null)
                              OutlinedButton(
                                onPressed: () => setState(() => _section = 5),
                                child: const Text('Parceiros'),
                              ),
                            OutlinedButton(
                              onPressed: widget.cases == null
                                  ? null
                                  : () => setState(() => _section = 3),
                              child: const Text('Processos'),
                            ),
                            OutlinedButton(
                              onPressed: widget.clients == null
                                  ? null
                                  : () => setState(() => _section = 2),
                              child: const Text('Clientes'),
                            ),
                            OutlinedButton(
                              onPressed: () => setState(() => _section = 0),
                              child: const Text('Contatos'),
                            ),
                            OutlinedButton(
                              onPressed: () => setState(() => _section = 1),
                              child: const Text('Usuários e permissões'),
                            ),
                          ],
                        ),
                ),
              ),
              if (_error != null) Text(_error!),
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_section != 8 && _section != 9)
                      switch (_section) {
                        0 => widget.contacts,
                        1 => widget.users,
                        // Keep client save feedback within its own section so it
                        // leaves with that section when the user navigates away.
                        2 => ScaffoldMessenger(
                          child: widget.clients ?? const SizedBox.shrink(),
                        ),
                        3 => widget.cases ?? const SizedBox.shrink(),
                        4 => widget.articles ?? const SizedBox.shrink(),
                        5 => widget.partners ?? const SizedBox.shrink(),
                        6 => widget.debts ?? const SizedBox.shrink(),
                        7 => widget.fees ?? const SizedBox.shrink(),
                        10 => widget.chat ?? const SizedBox.shrink(),
                        _ => const Center(
                          child: Text(
                            'Selecione uma área. O acesso depende das permissões da sua conta.',
                          ),
                        ),
                      },
                    for (final section in _visitedBilling)
                      Offstage(
                        key: ValueKey('billing-section-$section'),
                        offstage: _section != section,
                        child: TickerMode(
                          enabled: _section == section,
                          child: ExcludeFocus(
                            excluding: _section != section,
                            child: section == 8
                                ? widget.billingDebts ?? const SizedBox.shrink()
                                : widget.billingFees ?? const SizedBox.shrink(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
  );
}
