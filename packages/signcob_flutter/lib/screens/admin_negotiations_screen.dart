import 'package:flutter/material.dart';
import '../widgets/admin_page_scaffold.dart';
import 'package:signcob_client/signcob_client.dart';

typedef CreateNegotiation =
    Future<Negotiation> Function(int, String, String, int);
typedef ChangeNegotiation = Future<Negotiation> Function(int, String, String?);

int? parseNegotiationAmount(String value) {
  final match = RegExp(r'^(\d{1,12})(?:,(\d{1,2}))?$').firstMatch(value.trim());
  if (match == null) return null;
  final cents =
      int.parse(match[1]!) * 100 + int.parse((match[2] ?? '').padRight(2, '0'));
  return cents > 0 && cents <= 9000000000000 ? cents : null;
}

class AdminNegotiationsScreen extends StatefulWidget {
  const AdminNegotiationsScreen({
    super.key,
    required this.kind,
    required this.loadNegotiations,
    required this.createNegotiation,
    required this.changeNegotiation,
    required this.loadHistory,
  });
  final String kind;
  final Future<List<Negotiation>> Function(int, String) loadNegotiations;
  final CreateNegotiation createNegotiation;
  final ChangeNegotiation changeNegotiation;
  final Future<List<NegotiationEvent>> Function(int) loadHistory;
  @override
  State<AdminNegotiationsScreen> createState() =>
      _AdminNegotiationsScreenState();
}

class _AdminNegotiationsScreenState extends State<AdminNegotiationsScreen> {
  List<Negotiation> _items = [];
  bool _loading = true;
  String? _error;
  int _offset = 0;
  static const labels = {
    'draft': 'Rascunho',
    'proposed': 'Proposta',
    'accepted': 'Aceita',
    'rejected': 'Recusada',
    'cancelled': 'Cancelada',
  };
  @override
  void initState() {
    super.initState();
    _load(0);
  }

  String _message(Object e) =>
      e is AccessDeniedException ||
          e is ServerpodClientException &&
              (e.statusCode == 401 || e.statusCode == 403)
      ? 'Acesso restrito para esta conta.'
      : 'Não foi possível concluir. Tente novamente.';
  Future<void> _load(int offset) async {
    setState(() {
      _loading = true;
      _items = [];
      _error = null;
      _offset = offset;
    });
    try {
      final rows = await widget.loadNegotiations(offset, widget.kind);
      if (mounted) setState(() => _items = rows);
    } catch (e) {
      if (mounted) setState(() => _error = _message(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _create() async {
    var client = '';
    var title = '';
    var amount = '';
    final form = GlobalKey<FormState>();
    var saving = false;
    String? error;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: const Text('Nova negociação'),
          content: SizedBox(
            width: 440,
            child: SingleChildScrollView(
              child: Form(
                key: form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      onChanged: (value) => client = value,
                      decoration: const InputDecoration(
                        labelText: 'ID do cliente',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => (int.tryParse(v ?? '') ?? 0) > 0
                          ? null
                          : 'Informe um ID válido.',
                    ),
                    TextFormField(
                      onChanged: (value) => title = value,
                      maxLength: 160,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      validator: (v) => (v?.trim().isEmpty ?? true)
                          ? 'Informe a descrição.'
                          : null,
                    ),
                    TextFormField(
                      onChanged: (value) => amount = value,
                      decoration: const InputDecoration(
                        labelText: 'Valor (R\$)',
                        helperText: 'Use vírgula e sem separador de milhar.',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (v) => parseNegotiationAmount(v ?? '') == null
                          ? 'Informe um valor válido.'
                          : null,
                    ),
                    if (error != null) Text(error!),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: saving ? null : () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: saving
                  ? null
                  : () async {
                      if (!form.currentState!.validate()) return;
                      update(() {
                        saving = true;
                        error = null;
                      });
                      try {
                        await widget.createNegotiation(
                          int.parse(client),
                          widget.kind,
                          title.trim(),
                          parseNegotiationAmount(amount)!,
                        );
                        if (dialogContext.mounted) Navigator.pop(dialogContext);
                        if (mounted) await _load(0);
                      } catch (e) {
                        if (dialogContext.mounted) {
                          update(() {
                            saving = false;
                            error = _message(e);
                          });
                        }
                      }
                    },
              child: Text(saving ? 'Salvando…' : 'Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _transition(Negotiation item, String status) async {
    var note = '';
    var saving = false;
    String? error;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: Text('Registrar: ${labels[status]}'),
          content: SizedBox(
            width: 440,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Registro interno. Não confirma assinatura nem pagamento.',
                  ),
                  TextField(
                    onChanged: (value) => note = value,
                    maxLength: 1000,
                    decoration: const InputDecoration(
                      labelText: 'Observação (opcional)',
                    ),
                  ),
                  if (error != null) Text(error!),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: saving ? null : () => Navigator.pop(dialogContext),
              child: const Text('Voltar'),
            ),
            FilledButton(
              onPressed: saving
                  ? null
                  : () async {
                      update(() {
                        saving = true;
                        error = null;
                      });
                      try {
                        await widget.changeNegotiation(
                          item.id!,
                          status,
                          note.trim().isEmpty ? null : note.trim(),
                        );
                        if (dialogContext.mounted) Navigator.pop(dialogContext);
                        if (mounted) await _load(_offset);
                      } catch (e) {
                        if (dialogContext.mounted) {
                          update(() {
                            saving = false;
                            error = _message(e);
                          });
                        }
                      }
                    },
              child: Text(saving ? 'Registrando…' : 'Confirmar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _history(Negotiation item) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Histórico — até 100 registros'),
        content: SizedBox(
          width: 500,
          height: 350,
          child: FutureBuilder<List<NegotiationEvent>>(
            future: widget.loadHistory(item.id!),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text(_message(snapshot.error!));
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data!.isEmpty) return const Text('Sem registros.');
              return ListView(
                children: snapshot.data!
                    .map(
                      (event) => ListTile(
                        title: Text(labels[event.toStatus] ?? event.toStatus),
                        subtitle: Text(
                          '${event.occurredAt.toLocal()}\n${event.note ?? ''}',
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AdminPageScaffold(
    appBar: AppBar(
      title: Text(
        widget.kind == 'debt'
            ? 'Dívidas dos clientes'
            : 'Honorários e serviços',
      ),
      actions: [
        IconButton(
          tooltip: 'Atualizar',
          onPressed: _loading ? null : () => _load(_offset),
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),
    floatingActionButton: MediaQuery.sizeOf(context).width < 600
        ? FloatingActionButton(
            tooltip: 'Nova negociação',
            onPressed: _loading ? null : _create,
            child: const Icon(Icons.add),
          )
        : FloatingActionButton.extended(
            onPressed: _loading ? null : _create,
            label: const Text('Nova negociação'),
            icon: const Icon(Icons.add),
          ),
    body: _loading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_error!),
                TextButton(
                  onPressed: () => _load(_offset),
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: _items.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Aceites são registros internos; pagamentos serão confirmados separadamente pelo Asaas.',
                  ),
                );
              }
              if (index <= _items.length) {
                final item = _items[index - 1];
                final actions = item.status == 'draft'
                    ? ['proposed', 'cancelled']
                    : item.status == 'proposed'
                    ? ['accepted', 'rejected', 'cancelled']
                    : <String>[];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium,
                        ),
                        Text(
                          'Cliente #${item.legalClientId} • R\$ ${item.amountCents ~/ 100},${(item.amountCents % 100).toString().padLeft(2, '0')} • ${labels[item.status] ?? item.status}',
                        ),
                        Wrap(
                          spacing: 8,
                          children: [
                            TextButton(
                              onPressed: () => _history(item),
                              child: const Text('Histórico'),
                            ),
                            for (final status in actions)
                              TextButton(
                                onPressed: () => _transition(item, status),
                                child: Text(labels[status]!),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Column(
                children: [
                  if (_items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('Nenhuma negociação nesta página.'),
                    ),
                  Wrap(
                    alignment: WrapAlignment.center,
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
                        onPressed: _items.length < 25
                            ? null
                            : () => _load(_offset + 25),
                        child: const Text('Próxima'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
  );
}
