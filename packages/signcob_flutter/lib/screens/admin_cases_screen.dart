import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/admin_page_scaffold.dart';
import 'package:signcob_client/signcob_client.dart';

class AdminCasesScreen extends StatefulWidget {
  const AdminCasesScreen({
    super.key,
    required this.loadCases,
    required this.importCase,
    required this.syncCase,
  });
  final Future<List<LegalCase>> Function(int offset) loadCases;
  final Future<LegalCase> Function(int clientId, String tribunal, String number)
  importCase;
  final Future<LegalCase> Function(int id) syncCase;
  @override
  State<AdminCasesScreen> createState() => _AdminCasesScreenState();
}

class _AdminCasesScreenState extends State<AdminCasesScreen> {
  final _form = GlobalKey<FormState>();
  final _client = TextEditingController();
  final _number = TextEditingController();
  String _tribunal = 'TJPR';
  List<LegalCase> _cases = [];
  int _offset = 0;
  bool _loading = true;
  bool _working = false;
  String? _error;
  @override
  void initState() {
    super.initState();
    _load(0);
  }

  @override
  void dispose() {
    _client.dispose();
    _number.dispose();
    super.dispose();
  }

  String _failure(Object error) => error is DataJudException
      ? error.message
      : error is AccessDeniedException ||
            (error is ServerpodClientException &&
                [401, 403].contains(error.statusCode))
      ? 'Acesso restrito. Sua conta não tem autorização para esta operação.'
      : 'Não foi possível consultar o DataJud. Confira os dados e a configuração do serviço e tente novamente.';
  Future<void> _load(int offset) async {
    setState(() {
      _loading = true;
      _cases = [];
      _error = null;
      _offset = offset;
    });
    try {
      final rows = await widget.loadCases(offset);
      if (mounted) setState(() => _cases = rows);
    } catch (e) {
      if (mounted) setState(() => _error = _failure(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _import() async {
    if (_working || !_form.currentState!.validate()) return;
    setState(() {
      _working = true;
      _error = null;
    });
    try {
      await widget.importCase(
        int.parse(_client.text.trim()),
        _tribunal.toLowerCase(),
        _number.text.trim(),
      );
      if (!mounted) return;
      _client.clear();
      _number.clear();
      await _load(0);
    } catch (e) {
      if (mounted) {
        setState(() {
          _cases = [];
          _error = _failure(e);
        });
      }
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _sync(LegalCase row) async {
    setState(() {
      _working = true;
      _error = null;
    });
    try {
      await widget.syncCase(row.id!);
      if (mounted) await _load(_offset);
    } catch (e) {
      if (mounted) {
        setState(() {
          _cases = [];
          _error = _failure(e);
        });
      }
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  List<String> _movements(String source) {
    try {
      final values = jsonDecode(source);
      if (values is! List) return ['Andamentos indisponíveis.'];
      return values
          .whereType<Map>()
          .map(
            (m) => [m['date'], m['name']].where((v) => v != null).join(' — '),
          )
          .toList();
    } catch (_) {
      return ['Andamentos indisponíveis.'];
    }
  }

  @override
  Widget build(BuildContext context) => AdminPageScaffold(
    appBar: AppBar(
      title: const Text('Processos'),
      actions: [
        IconButton(
          tooltip: 'Atualizar lista',
          onPressed: _loading || _working ? null : () => _load(_offset),
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Fonte: Conselho Nacional de Justiça (CNJ) — DataJud. Metadados e andamentos públicos; não inclui documentos ou processos restritos. A atualização depende dos dados disponibilizados pela fonte.',
          ),
          const SizedBox(height: 16),
          Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _client,
                  decoration: const InputDecoration(
                    labelText: 'Identificador do cliente',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) => (int.tryParse(v?.trim() ?? '') ?? 0) > 0
                      ? null
                      : 'Informe um identificador válido.',
                ),
                DropdownButtonFormField<String>(
                  initialValue: _tribunal,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Tribunal'),
                  items: ['TJPR', 'TRT9', 'TRF4']
                      .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                      .toList(),
                  onChanged: _working
                      ? null
                      : (v) => setState(() => _tribunal = v!),
                ),
                TextFormField(
                  controller: _number,
                  decoration: const InputDecoration(
                    labelText: 'Número CNJ do processo',
                  ),
                  validator: (v) =>
                      RegExp(
                        r'^\d{20}$',
                      ).hasMatch((v ?? '').replaceAll(RegExp(r'[.\-\s]'), ''))
                      ? null
                      : 'Informe os 20 dígitos do número CNJ.',
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _working || _loading ? null : _import,
                  child: Text(
                    _working ? 'Consultando…' : 'Importar do DataJud',
                  ),
                ),
              ],
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, semanticsLabel: _error),
            TextButton(
              onPressed: _working ? null : () => _load(_offset),
              child: const Text('Tentar novamente'),
            ),
          ],
          if (_loading) const Center(child: CircularProgressIndicator()),
          if (!_loading && _error == null && _cases.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('Nenhum processo disponível para sua conta.'),
            ),
          for (final row in _cases)
            Card(
              child: ExpansionTile(
                title: Text('${row.tribunal} — ${row.number}'),
                subtitle: Text(
                  'Cliente ${row.legalClientId}\nÚltima consulta: ${row.lastSyncedAt?.toLocal().toString() ?? 'Ainda não sincronizado'}',
                ),
                children: [
                  if (row.className != null)
                    ListTile(title: Text(row.className!)),
                  if (row.courtName != null)
                    ListTile(title: Text(row.courtName!)),
                  if (row.syncError != null)
                    const ListTile(
                      title: Text(
                        'A última sincronização falhou. Tente novamente.',
                      ),
                    ),
                  if (_movements(row.movementsJson).isEmpty)
                    const ListTile(
                      title: Text('Sem andamentos na resposta da fonte.'),
                    ),
                  for (final movement in _movements(row.movementsJson))
                    ListTile(title: Text(movement)),
                  TextButton(
                    onPressed: _working ? null : () => _sync(row),
                    child: const Text('Sincronizar processo'),
                  ),
                ],
              ),
            ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            children: [
              TextButton(
                onPressed: _loading || _working || _offset == 0
                    ? null
                    : () => _load(_offset - 25),
                child: const Text('Anterior'),
              ),
              Text('Página ${_offset ~/ 25 + 1}'),
              TextButton(
                onPressed: _loading || _working || _cases.length < 25
                    ? null
                    : () => _load(_offset + 25),
                child: const Text('Próxima'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
