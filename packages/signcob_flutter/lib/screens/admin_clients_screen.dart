import 'package:flutter/material.dart';
import '../widgets/admin_page_scaffold.dart';
import 'package:signcob_client/signcob_client.dart';

typedef SaveClient =
    Future<LegalClient> Function(
      int? id,
      String name,
      String email,
      String phone,
      String document,
    );

class AdminClientsScreen extends StatefulWidget {
  const AdminClientsScreen({
    super.key,
    required this.loadClients,
    required this.saveClient,
    this.assignLawyer,
    this.bindOwner,
  });
  final Future<List<LegalClient>> Function(int offset) loadClients;
  final SaveClient saveClient;
  final Future<void> Function(int id, String? lawyerId)? assignLawyer;
  final Future<void> Function(int id, String? authId)? bindOwner;
  @override
  State<AdminClientsScreen> createState() => _AdminClientsScreenState();
}

class _AdminClientsScreenState extends State<AdminClientsScreen> {
  List<LegalClient> _clients = [];
  int _offset = 0;
  bool _loading = true;
  bool _saving = false;
  String? _error;
  bool _editing = false;
  int? _id;
  final _form = GlobalKey<FormState>();
  final _fields = List.generate(4, (_) => TextEditingController());
  @override
  void initState() {
    super.initState();
    _load(0);
  }

  @override
  void dispose() {
    for (final field in _fields) {
      field.dispose();
    }
    super.dispose();
  }

  String _message(Object e) =>
      e is AccessDeniedException ||
          (e is ServerpodClientException &&
              (e.statusCode == 401 || e.statusCode == 403))
      ? 'Acesso restrito. Sua conta não tem a permissão necessária.'
      : 'Não foi possível concluir. Tente novamente.';
  Future<void> _load(int offset) async {
    setState(() {
      _loading = true;
      _error = null;
      _clients = [];
      _offset = offset;
    });
    try {
      final rows = await widget.loadClients(offset);
      if (mounted) setState(() => _clients = rows);
    } catch (e) {
      if (mounted) setState(() => _error = _message(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _edit(LegalClient? row) {
    _id = row?.id;
    final values = [
      row?.name ?? '',
      row?.email ?? '',
      row?.phone ?? '',
      row?.document ?? '',
    ];
    for (var i = 0; i < values.length; i++) {
      _fields[i].text = values[i];
    }
    setState(() {
      _editing = true;
      _error = null;
    });
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.saveClient(
        _id,
        _fields[0].text.trim(),
        _fields[1].text.trim(),
        _fields[2].text.trim(),
        _fields[3].text.trim(),
      );
      if (!mounted) return;
      setState(() => _editing = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cliente salvo.')));
      await _load(_offset);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = _message(e);
          if (e is AccessDeniedException) {
            _editing = false;
            _clients = [];
            for (final field in _fields) {
              field.clear();
            }
          }
        });
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _assign(LegalClient row, {bool owner = false}) async {
    var lawyerId = '';
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(owner ? 'Vincular conta do cliente' : 'Atribuir advogado'),
        content: TextField(
          onChanged: (value) => lawyerId = value,
          decoration: InputDecoration(
            labelText: owner
                ? 'Identificador da conta do cliente'
                : 'Identificador da conta do advogado',
            helperText: 'Vazio remove a atribuição. Exige gestão de acessos.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, lawyerId.trim()),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
    if (value == null || !mounted) return;
    setState(() => _saving = true);
    try {
      if (owner) {
        await widget.bindOwner!(row.id!, value.isEmpty ? null : value);
      } else {
        await widget.assignLawyer!(row.id!, value.isEmpty ? null : value);
      }
      if (mounted) await _load(_offset);
    } catch (e) {
      if (mounted) setState(() => _error = _message(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => AdminPageScaffold(
    appBar: AppBar(
      title: const Text('Clientes'),
      actions: [
        if (MediaQuery.sizeOf(context).width < 600)
          IconButton(
            tooltip: 'Novo cliente',
            onPressed: _saving ? null : () => _edit(null),
            icon: const Icon(Icons.person_add_outlined),
          )
        else
          TextButton(
            onPressed: _saving ? null : () => _edit(null),
            child: const Text('Novo cliente'),
          ),
      ],
    ),
    body: _editing
        ? SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _id == null ? 'Cadastrar cliente' : 'Editar cliente',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      for (var i = 0; i < _fields.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: TextFormField(
                            controller: _fields[i],
                            enabled: !_saving,
                            decoration: InputDecoration(
                              labelText: [
                                'Nome',
                                'E-mail (opcional)',
                                'Telefone (opcional)',
                                'Documento (opcional)',
                              ][i],
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              final text = value?.trim() ?? '';
                              if (i == 0 && text.isEmpty) {
                                return 'Informe o nome.';
                              }
                              if (text.length > [120, 254, 30, 30][i]) {
                                return 'Valor muito longo.';
                              }
                              if (i == 1 &&
                                  text.isNotEmpty &&
                                  !RegExp(
                                    r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                                  ).hasMatch(text)) {
                                return 'Informe um e-mail válido.';
                              }
                              return null;
                            },
                          ),
                        ),
                      if (_error != null) Text(_error!),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: _saving ? null : _save,
                        child: Text(_saving ? 'Salvando…' : 'Salvar cliente'),
                      ),
                      TextButton(
                        onPressed: _saving
                            ? null
                            : () => setState(() {
                                _editing = false;
                                _error = null;
                              }),
                        child: const Text('Cancelar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : _loading
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
              if (_clients.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Nenhum cliente encontrado.'),
                ),
              for (final row in _clients)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          row.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          [row.email, row.phone, row.document]
                              .whereType<String>()
                              .where((s) => s.isNotEmpty)
                              .join('\n'),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          alignment: WrapAlignment.end,
                          spacing: 4,
                          children: [
                            if (widget.bindOwner != null)
                              IconButton(
                                tooltip: 'Vincular conta do cliente',
                                onPressed: _saving
                                    ? null
                                    : () => _assign(row, owner: true),
                                icon: const Icon(Icons.link),
                              ),
                            if (widget.assignLawyer != null)
                              IconButton(
                                tooltip: 'Atribuir advogado',
                                onPressed: _saving ? null : () => _assign(row),
                                icon: const Icon(Icons.person_add_outlined),
                              ),
                            IconButton(
                              tooltip: 'Editar cliente',
                              onPressed: () => _edit(row),
                              icon: const Icon(Icons.edit_outlined),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                children: [
                  OutlinedButton(
                    onPressed: _offset == 0 ? null : () => _load(_offset - 25),
                    child: const Text('Anterior'),
                  ),
                  OutlinedButton(
                    onPressed: _clients.length < 25
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
