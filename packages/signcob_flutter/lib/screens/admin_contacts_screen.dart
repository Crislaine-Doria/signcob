import 'package:flutter/material.dart';
import '../widgets/admin_page_scaffold.dart';
import 'package:signcob_client/signcob_client.dart';

typedef LoadContacts = Future<List<ContactMessage>> Function(int offset);

class AdminContactsScreen extends StatefulWidget {
  const AdminContactsScreen({
    super.key,
    required this.loadContacts,
    required this.onSignOut,
  });

  final LoadContacts loadContacts;
  final Future<void> Function() onSignOut;

  @override
  State<AdminContactsScreen> createState() => _AdminContactsScreenState();
}

class _AdminContactsScreenState extends State<AdminContactsScreen> {
  List<ContactMessage> _contacts = [];
  int _offset = 0;
  bool _loading = true;
  bool _signingOut = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load(0);
  }

  Future<void> _load(int offset) async {
    setState(() {
      _loading = true;
      _contacts = [];
      _error = null;
      _offset = offset;
    });
    try {
      final contacts = await widget.loadContacts(offset);
      if (!mounted || _signingOut) return;
      setState(() => _contacts = contacts);
    } catch (error) {
      if (!mounted || _signingOut) return;
      setState(() {
        _error =
            error is AccessDeniedException ||
                (error is ServerpodClientException &&
                    (error.statusCode == 401 || error.statusCode == 403))
            ? 'Acesso restrito. Sua conta precisa de autorização para consultar contatos.'
            : 'Não foi possível carregar os contatos. Tente novamente.';
      });
    } finally {
      if (mounted && !_signingOut) setState(() => _loading = false);
    }
  }

  Future<void> _signOut() async {
    setState(() {
      _signingOut = true;
      _contacts = [];
      _error = null;
    });
    try {
      await widget.onSignOut();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _signingOut = false;
        _loading = false;
        _error = 'Não foi possível sair. Tente novamente.';
      });
    }
  }

  String _date(DateTime value) {
    final local = value.toLocal();
    String pad(int n) => n.toString().padLeft(2, '0');
    return '${pad(local.day)}/${pad(local.month)}/${local.year} '
        '${pad(local.hour)}:${pad(local.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return AdminPageScaffold(
      appBar: AppBar(
        title: const Text('Contatos recebidos'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: _loading || _signingOut ? null : () => _load(_offset),
            icon: const Icon(Icons.refresh),
          ),
          TextButton(
            onPressed: _signingOut ? null : _signOut,
            child: const Text('Sair'),
          ),
        ],
      ),
      body: SafeArea(
        child: _loading || _signingOut
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => _load(_offset),
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: _contacts.isEmpty
                        ? const Center(
                            child: Text('Nenhum contato nesta página.'),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _contacts.length,
                            itemBuilder: (context, index) {
                              final item = _contacts[index];
                              return Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 900,
                                  ),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            item.name,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                          ),
                                          const SizedBox(height: 8),
                                          SelectableText(item.email),
                                          Text(_date(item.createdAt)),
                                          const SizedBox(height: 16),
                                          SelectableText(item.message),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Wrap(
                      spacing: 16,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        TextButton(
                          onPressed: _offset == 0
                              ? null
                              : () => _load(_offset - 25),
                          child: const Text('Anterior'),
                        ),
                        Text('Página ${_offset ~/ 25 + 1}'),
                        TextButton(
                          onPressed: _contacts.length < 25
                              ? null
                              : () => _load(_offset + 25),
                          child: const Text('Próxima'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
