import 'package:flutter/material.dart';
import '../widgets/admin_page_scaffold.dart';
import 'package:signcob_client/signcob_client.dart';

typedef LoadUsers = Future<List<ManagedUser>> Function(int offset);
typedef SavePermissions =
    Future<void> Function(String userId, List<String> permissions);

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({
    super.key,
    required this.loadUsers,
    required this.savePermissions,
  });
  final LoadUsers loadUsers;
  final SavePermissions savePermissions;
  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  List<ManagedUser> _users = [];
  int _offset = 0;
  bool _loading = true;
  String? _error;
  final Map<String, Set<String>> _permissions = {};
  final Set<String> _saving = {};
  final Map<String, String> _results = {};
  @override
  void initState() {
    super.initState();
    _load(0);
  }

  String _message(Object error) =>
      error is AccessDeniedException ||
          (error is ServerpodClientException &&
              (error.statusCode == 401 || error.statusCode == 403))
      ? 'Acesso restrito. Sua conta precisa de permissão para gerenciar acessos.'
      : 'Não foi possível concluir. Tente novamente.';
  Future<void> _load(int offset) async {
    setState(() {
      _loading = true;
      _error = null;
      _users = [];
      _permissions.clear();
      _results.clear();
      _offset = offset;
    });
    try {
      final users = await widget.loadUsers(offset);
      if (!mounted) return;
      setState(() {
        _users = users;
        for (final user in users) {
          _permissions[user.userId] = user.permissions.toSet();
        }
      });
    } catch (e) {
      if (mounted) setState(() => _error = _message(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save(ManagedUser user) async {
    setState(() {
      _saving.add(user.userId);
      _results.remove(user.userId);
    });
    try {
      await widget.savePermissions(
        user.userId,
        _permissions[user.userId]!.toList(),
      );
      if (mounted) {
        setState(
          () => _results[user.userId] =
              'Permissões salvas. A conta deve sair e entrar novamente para renovar a sessão.',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          if (e is AccessDeniedException ||
              (e is ServerpodClientException &&
                  (e.statusCode == 401 || e.statusCode == 403))) {
            _users = [];
            _permissions.clear();
            _error = _message(e);
          } else {
            _results[user.userId] = _message(e);
          }
        });
      }
    } finally {
      if (mounted) setState(() => _saving.remove(user.userId));
    }
  }

  @override
  Widget build(BuildContext context) => AdminPageScaffold(
    appBar: AppBar(title: const Text('Usuários e permissões')),
    body: _loading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_error!),
                FilledButton(
                  onPressed: () => _load(_offset),
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          )
        : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Atribua somente os acessos necessários a cada conta.',
              ),
              if (_users.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Nenhum usuário encontrado.'),
                ),
              for (final user in _users)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.email ?? 'E-mail não disponível',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SelectableText(user.userId),
                        OutlinedButton(
                          onPressed: _saving.contains(user.userId)
                              ? null
                              : () => setState(() {
                                  _permissions[user.userId] = {
                                    'contacts.read',
                                    'users.manage',
                                    'clients.read',
                                    'clients.write',
                                    'cases.read',
                                    'cases.write',
                                    'content.write',
                                    'negotiations.read',
                                    'negotiations.write',
                                  };
                                }),
                          child: const Text('Aplicar perfil de sócio'),
                        ),
                        const Text(
                          'Acesso completo aos módulos disponíveis. Confirme em Salvar.',
                        ),
                        for (final item in const {
                          'contacts.read': 'Consultar contatos',
                          'users.manage': 'Gerenciar acessos',
                          'clients.read': 'Consultar clientes',
                          'clients.write': 'Cadastrar e editar clientes',
                          'cases.read': 'Consultar processos autorizados',
                          'cases.write': 'Importar e sincronizar processos',
                          'content.write': 'Gerenciar blog e parceiros',
                          'negotiations.read':
                              'Consultar negociações atribuídas',
                          'negotiations.write': 'Criar e alterar negociações',
                        }.entries)
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(item.value),
                            value: _permissions[user.userId]!.contains(
                              item.key,
                            ),
                            onChanged: _saving.contains(user.userId)
                                ? null
                                : (value) => setState(() {
                                    if (value == true) {
                                      _permissions[user.userId]!.add(item.key);
                                    } else {
                                      _permissions[user.userId]!.remove(
                                        item.key,
                                      );
                                    }
                                  }),
                          ),
                        FilledButton(
                          onPressed: _saving.contains(user.userId)
                              ? null
                              : () => _save(user),
                          child: Text(
                            _saving.contains(user.userId)
                                ? 'Salvando…'
                                : 'Salvar',
                          ),
                        ),
                        if (_results[user.userId] != null)
                          Text(_results[user.userId]!),
                      ],
                    ),
                  ),
                ),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                children: [
                  OutlinedButton(
                    onPressed: _offset == 0 || _saving.isNotEmpty
                        ? null
                        : () => _load(_offset - 25),
                    child: const Text('Anterior'),
                  ),
                  OutlinedButton(
                    onPressed: _users.length < 25 || _saving.isNotEmpty
                        ? null
                        : () => _load(_offset + 25),
                    child: const Text('Próxima'),
                  ),
                ],
              ),
            ],
          ),
  );
}
