import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signcob_client/signcob_client.dart';

import '../widgets/admin_page_scaffold.dart';
import 'admin_negotiations_screen.dart' show parseNegotiationAmount;

const _methodLabels = {
  BillingMethod.pix: 'Pix',
  BillingMethod.boleto: 'Boleto',
  BillingMethod.card: 'Cartão',
};
const _flowLabels = {
  BillingFlow.single: 'Única',
  BillingFlow.installment: 'Parcelada',
  BillingFlow.recurring: 'Recorrente',
};
const _cycleLabels = {
  BillingCycle.weekly: 'Semanal',
  BillingCycle.biweekly: 'A cada duas semanas',
  BillingCycle.monthly: 'Mensal',
  BillingCycle.bimonthly: 'A cada dois meses',
  BillingCycle.quarterly: 'Trimestral',
  BillingCycle.semiannually: 'Semestral',
  BillingCycle.yearly: 'Anual',
};

String _money(int cents) =>
    'R\$ ${cents ~/ 100},${(cents % 100).toString().padLeft(2, '0')}';

String _paymentLabel(BillingStatus status) => switch (status) {
  BillingStatus.awaitingProvider => 'Aguardando conciliação',
  BillingStatus.pending => 'Aguardando pagamento',
  BillingStatus.overdue => 'Vencida',
  BillingStatus.confirmed => 'Confirmado · saldo indisponível',
  BillingStatus.received => 'Recebido · saldo disponível',
  BillingStatus.attention => 'Requer atenção',
};

bool _denied(Object error) =>
    error is AccessDeniedException ||
    error is ServerpodClientException &&
        (error.statusCode == 401 || error.statusCode == 403);

String _message(Object error) {
  if (_denied(error)) return 'Acesso restrito para esta conta.';
  if (error is BillingException) {
    return switch (error.code) {
      'provider_configuration' || 'creation_disabled' =>
        'O sandbox Asaas precisa ser configurado no servidor.',
      'provider_authentication' =>
        'O acesso ao sandbox foi recusado. Solicite a revisão da configuração.',
      'account_mismatch' =>
        'A conta sandbox não corresponde à credencial configurada. Solicite a revisão da configuração.',
      'customer_uncertain' =>
        'O cadastro do pagador está pendente de conciliação.',
      'customer_conflict' || 'customer_identity_conflict' =>
        'Há cadastros conflitantes para este pagador. Confira o cadastro do cliente.',
      'invalid_input' || 'invalid_customer' || 'customer_invalid' =>
        'Confira os dados da cobrança e o documento do cliente cadastrado.',
      'idempotency_conflict' =>
        'Esta solicitação já foi registrada com outros dados. Consulte o registro existente.',
      'creation_uncertain' =>
        'O resultado da criação está pendente de conciliação.',
      'provider_response' || 'unsupported_status' || 'invalid_transition' =>
        'O resultado precisa ser conferido. Nenhum recebimento foi presumido.',
      _ =>
        'Não foi possível concluir a consulta ao sandbox. Tente consultar novamente.',
    };
  }
  return 'Não foi possível confirmar o resultado. Consulte a solicitação novamente.';
}

/// Internal sandbox operations. The server remains the permission authority.
class AdminBillingScreen extends StatefulWidget {
  const AdminBillingScreen({
    super.key,
    required this.kind,
    required this.loadCharges,
    required this.createCharge,
    required this.findIntent,
    required this.getCharge,
    required this.refreshCharge,
    required this.reconcileCustomer,
    required this.loadClients,
    required this.loadNegotiations,
    this.mayWrite,
  });

  final String kind;
  final Future<List<BillingCharge>> Function(String, int) loadCharges;
  final Future<BillingCharge> Function(BillingCreateRequest) createCharge;
  final Future<BillingCharge?> Function(int, String) findIntent;
  final Future<BillingCharge> Function(int) getCharge;
  final Future<BillingCharge> Function(int) refreshCharge;
  final Future<BillingCustomerLink> Function(int) reconcileCustomer;
  final Future<List<BillingClientOption>> Function(String, int) loadClients;
  final Future<List<BillingNegotiationOption>> Function(int, String)
  loadNegotiations;
  final bool Function()? mayWrite;

  @override
  State<AdminBillingScreen> createState() => _AdminBillingScreenState();
}

class _AdminBillingScreenState extends State<AdminBillingScreen> {
  List<BillingCharge> _items = [];
  BillingCreateRequest? _pending;
  BillingCharge? _pendingCharge;
  bool _customerReady = false;
  bool _mayResumePending = false;
  bool _mayEditPending = false;
  bool _busy = false;
  bool _formOpen = false;
  bool _loading = true;
  bool _accessDenied = false;
  int _offset = 0;
  String? _error;
  String? _feedback;

  bool get _canWrite => !_accessDenied && (widget.mayWrite?.call() ?? true);
  bool get _hasUncertainRecord =>
      _items.any((item) => item.creationState == 'awaitingProvider');

  @override
  void initState() {
    super.initState();
    _load(0);
  }

  void _failure(Object error) {
    _error = _message(error);
    if (_denied(error)) {
      _accessDenied = true;
      _items = [];
      _pending = null;
      _pendingCharge = null;
    }
  }

  Future<void> _load(int offset) async {
    setState(() {
      _loading = true;
      _error = null;
      _items = [];
      _offset = offset;
    });
    try {
      final rows = await widget.loadCharges(widget.kind, offset);
      if (!mounted) return;
      setState(() {
        _items = rows;
        _accessDenied = false;
      });
    } catch (error) {
      if (mounted) setState(() => _failure(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _newCharge() async {
    if (!_canWrite || _pending != null || _busy || _formOpen) return;
    _formOpen = true;
    final request = await showDialog<BillingCreateRequest>(
      context: context,
      builder: (_) => _BillingForm(
        kind: widget.kind,
        loadClients: widget.loadClients,
        loadNegotiations: widget.loadNegotiations,
      ),
    );
    _formOpen = false;
    if (!mounted || request == null || !_canWrite) return;
    setState(() {
      _pending = request;
      _pendingCharge = null;
      _customerReady = false;
      _mayResumePending = false;
      _mayEditPending = false;
      _feedback = null;
    });
    await _createPending();
  }

  Future<void> _createPending() async {
    final request = _pending;
    if (request == null || !_canWrite || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await widget.createCharge(request);
      if (!mounted) return;
      _observePending(result);
      await _load(0);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _failure(error);
        if (error is BillingException) {
          _mayEditPending = const {
            'invalid_input',
            'invalid_customer',
          }.contains(error.code);
          _mayResumePending = const {
            'provider_configuration',
            'account_mismatch',
          }.contains(error.code);
        }
      });
      // Recovery reads the durable intent. It never repeats creation.
      if (!_accessDenied) await _findPending();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _observePending(BillingCharge result) {
    setState(() {
      if (result.creationState == 'active') {
        _pending = null;
        _pendingCharge = null;
        _customerReady = false;
        _mayResumePending = false;
        _mayEditPending = false;
        _feedback =
            'Cobrança criada no sandbox. Acompanhe os pagamentos separadamente.';
      } else {
        _pendingCharge = result;
        _customerReady = false;
        _mayResumePending = false;
        _mayEditPending = false;
        _feedback =
            'Solicitação registrada. O resultado está pendente de conciliação.';
      }
    });
  }

  Future<bool> _findPending() async {
    final request = _pending;
    if (request == null) return false;
    try {
      final result = await widget.findIntent(
        request.clientId,
        request.idempotencyKey,
      );
      if (!mounted) return false;
      if (result != null) {
        _observePending(result);
      } else {
        setState(() {
          _feedback =
              'A cobrança ainda não foi localizada. Concilie o cadastro do pagador antes de retomar esta solicitação.';
        });
      }
      return true;
    } catch (error) {
      if (mounted) setState(() => _failure(error));
      return false;
    }
  }

  Future<void> _recover() async {
    if (_busy || _pending == null || !_canWrite) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      if (!await _findPending()) return;
      final charge = _pendingCharge;
      if (charge != null && !_accessDenied) {
        final result = await widget.refreshCharge(charge.id);
        if (mounted) _observePending(result);
      }
      if (mounted && !_accessDenied) await _load(_offset);
    } catch (error) {
      if (mounted) setState(() => _failure(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _reconcilePayer() async {
    final request = _pending;
    if (request == null || !_canWrite || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      if (!await _findPending()) return;
      if (_pending == null || _pendingCharge != null || _accessDenied) return;
      final link = await widget.reconcileCustomer(request.clientId);
      if (!mounted) return;
      setState(() {
        _customerReady = link.state == 'linked';
        _feedback = _customerReady
            ? 'Cadastro conciliado. Retome a mesma solicitação para concluir a criação.'
            : 'O cadastro continua pendente. Consulte novamente; outra cobrança pode duplicar a solicitação.';
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _failure(error);
          if (error is BillingException && error.code == 'customer_missing') {
            _mayResumePending = true;
            _feedback =
                'O cadastro ainda não foi enviado. Retome a mesma solicitação para prepará-lo.';
          }
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resume() async {
    if ((!_customerReady && !_mayResumePending) || _busy || !_canWrite) return;
    // A concurrent/original request may have reserved the intent meanwhile.
    setState(() => _busy = true);
    final found = await _findPending();
    if (!mounted) return;
    setState(() => _busy = false);
    if (!found) return;
    if (_pendingCharge != null) {
      await _recover();
    } else if (_pending != null && !_accessDenied) {
      await _createPending();
    }
  }

  Future<void> _editPending() async {
    final request = _pending;
    if (request == null || !_mayEditPending || !_canWrite || _busy) return;
    setState(() => _busy = true);
    final checked = await _findPending();
    if (!mounted) return;
    setState(() => _busy = false);
    if (!checked || _pending == null || _pendingCharge != null || !_canWrite) {
      return;
    }
    final edited = await showDialog<BillingCreateRequest>(
      context: context,
      builder: (_) => _BillingForm(
        kind: widget.kind,
        initial: request,
        loadClients: widget.loadClients,
        loadNegotiations: widget.loadNegotiations,
      ),
    );
    if (!mounted || edited == null || !_canWrite) return;
    setState(() => _busy = true);
    final checkedAfterEdit = await _findPending();
    if (!mounted) return;
    setState(() => _busy = false);
    if (!checkedAfterEdit ||
        _pending == null ||
        _pendingCharge != null ||
        !_canWrite) {
      return;
    }
    setState(() {
      _pending = edited;
      _mayEditPending = false;
      _mayResumePending = false;
    });
    await _createPending();
  }

  Future<void> _details(BillingCharge item) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _BillingDetails(
        initial: item,
        getCharge: widget.getCharge,
        refreshCharge: widget.refreshCharge,
        mayWrite: () => _canWrite,
        onDenied: (error) {
          if (mounted) setState(() => _failure(error));
        },
      ),
    );
    if (mounted && !_accessDenied) await _load(_offset);
  }

  Widget _pendingPanel() => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Solicitação em acompanhamento',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Cliente ${_pending!.clientId} · ${_money(_pending!.amountCents)}',
          ),
          const Text(
            'Preservamos esta solicitação. Consulte o resultado antes de criar outra cobrança.',
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: _busy || !_canWrite ? null : _recover,
                child: const Text('Consultar solicitação'),
              ),
              if (_pendingCharge == null)
                OutlinedButton(
                  onPressed: _busy || !_canWrite ? null : _reconcilePayer,
                  child: const Text('Conciliar cadastro'),
                ),
              if ((_customerReady || _mayResumePending) &&
                  _pendingCharge == null)
                FilledButton(
                  onPressed: _busy || !_canWrite ? null : _resume,
                  child: const Text('Retomar mesma solicitação'),
                ),
              if (_mayEditPending && _pendingCharge == null)
                OutlinedButton(
                  onPressed: _busy || !_canWrite ? null : _editPending,
                  child: const Text('Corrigir solicitação'),
                ),
            ],
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => AdminPageScaffold(
    appBar: AppBar(
      title: const Text(
        'Cobranças',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        IconButton(
          tooltip: 'Atualizar lista',
          onPressed: _loading || _busy ? null : () => _load(_offset),
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),
    body: _loading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                widget.kind == 'debt'
                    ? 'Cobranças de dívidas'
                    : 'Cobranças de honorários e serviços',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'Sandbox · somente testes com dados sintéticos. O aceite de negociação não cria cobrança nem confirma pagamento.',
              ),
              const SizedBox(height: 12),
              if (_busy) const LinearProgressIndicator(),
              if (_error != null) ...[
                Semantics(liveRegion: true, child: Text(_error!)),
                if (_pending == null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: _busy ? null : () => _load(_offset),
                      child: const Text('Tentar novamente'),
                    ),
                  ),
              ],
              if (_feedback != null)
                Semantics(liveRegion: true, child: Text(_feedback!)),
              if (_pending != null) _pendingPanel(),
              if (_pending == null && _hasUncertainRecord)
                const Text(
                  'Há uma solicitação pendente nesta área. Abra seus detalhes e concilie o resultado antes de criar outra cobrança.',
                ),
              if (_canWrite)
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    onPressed:
                        _busy ||
                            _pending != null ||
                            _error != null ||
                            _hasUncertainRecord
                        ? null
                        : _newCharge,
                    icon: const Icon(Icons.add),
                    label: const Text('Nova cobrança'),
                  ),
                ),
              if (!_canWrite && !_accessDenied)
                const Text(
                  'Consulta disponível. A criação e a conciliação exigem permissão de escrita.',
                ),
              if (_items.isEmpty && _error == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text('Nenhuma cobrança registrada nesta área.'),
                ),
              for (final item in _items)
                Card(
                  child: ListTile(
                    title: Text(
                      'Cliente ${item.legalClientId} · ${_money(item.amountCents)}',
                    ),
                    subtitle: Text(
                      '${_flowLabels[item.flow] ?? 'Registro anterior'} · ${_methodLabels[item.method] ?? 'Meio não informado'}\n${item.creationState == 'active' ? 'Criada no sandbox' : 'Pendente de conciliação'}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _busy ? null : () => _details(item),
                  ),
                ),
              if (!_accessDenied)
                Wrap(
                  spacing: 8,
                  children: [
                    TextButton(
                      onPressed: _busy || _offset == 0
                          ? null
                          : () => _load(_offset - 25),
                      child: const Text('Anterior'),
                    ),
                    TextButton(
                      onPressed: _busy || _items.length < 25
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

class _BillingForm extends StatefulWidget {
  const _BillingForm({
    required this.kind,
    required this.loadClients,
    required this.loadNegotiations,
    this.initial,
  });
  final String kind;
  final Future<List<BillingClientOption>> Function(String, int) loadClients;
  final Future<List<BillingNegotiationOption>> Function(int, String)
  loadNegotiations;
  final BillingCreateRequest? initial;

  @override
  State<_BillingForm> createState() => _BillingFormState();
}

class _BillingFormState extends State<_BillingForm> {
  final _form = GlobalKey<FormState>();
  BillingClientOption? _client;
  List<BillingNegotiationOption> _negotiations = [];
  int? _negotiationId;
  BillingMethod _method = BillingMethod.pix;
  BillingFlow _flow = BillingFlow.single;
  BillingCycle _cycle = BillingCycle.monthly;
  String _amount = '';
  String _dueDate = '';
  String _count = '';
  String? _error;
  bool _loading = false;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial != null) {
      _method = initial.method;
      _flow = initial.flow;
      _cycle = initial.cycle ?? BillingCycle.monthly;
      _amount =
          '${initial.amountCents ~/ 100},${(initial.amountCents % 100).toString().padLeft(2, '0')}';
      _dueDate = initial.dueDate;
      _count = initial.installmentCount?.toString() ?? '';
    }
  }

  Future<void> _selectClient() async {
    final client = await showDialog<BillingClientOption>(
      context: context,
      builder: (_) => _ClientPicker(loadClients: widget.loadClients),
    );
    if (!mounted || client == null) return;
    setState(() {
      _client = client;
      _negotiationId = null;
      _negotiations = [];
      _error = null;
      _loading = true;
    });
    try {
      final rows = await widget.loadNegotiations(client.id, widget.kind);
      if (mounted) setState(() => _negotiations = rows);
    } catch (error) {
      if (mounted) setState(() => _error = _message(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _validDate(String? value) {
    final date = value?.trim() ?? '';
    final parsed = DateTime.tryParse('${date}T00:00:00Z');
    return RegExp(r'^[0-9]{4}-[0-9]{2}-[0-9]{2}$').hasMatch(date) &&
            !date.startsWith('0000') &&
            parsed?.toIso8601String().split('T').first == date
        ? null
        : 'Informe uma data válida em AAAA-MM-DD.';
  }

  void _submit() {
    if (_loading || _submitted || !_form.currentState!.validate()) return;
    if (_client == null) {
      setState(() => _error = 'Selecione o cliente pagador.');
      return;
    }
    if (!_client!.readyForBilling) {
      setState(
        () => _error =
            'Complete o documento do cliente no cadastro antes de criar a cobrança.',
      );
      return;
    }
    setState(() => _submitted = true);
    final random = Random.secure();
    final key = List.generate(
      24,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
    Navigator.pop(
      context,
      BillingCreateRequest(
        clientId: _client!.id,
        negotiationId: _negotiationId,
        kind: widget.kind,
        method: _method,
        flow: _flow,
        amountCents: parseNegotiationAmount(_amount)!,
        dueDate: _dueDate.trim(),
        idempotencyKey: widget.initial?.idempotencyKey ?? key,
        installmentCount: _flow == BillingFlow.installment
            ? int.parse(_count.trim())
            : null,
        cycle: _flow == BillingFlow.recurring ? _cycle : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Nova cobrança no sandbox'),
    scrollable: true,
    content: SizedBox(
      width: 500,
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.kind == 'debt'
                  ? 'Dívidas dos clientes'
                  : 'Honorários e serviços',
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _loading ? null : _selectClient,
              child: Text(
                _client == null
                    ? 'Selecionar cliente'
                    : '${_client!.name} · trocar cliente',
              ),
            ),
            if (_client != null && !_client!.readyForBilling)
              const Text(
                'O documento do cliente precisa ser completado no cadastro.',
              ),
            if (_loading) const LinearProgressIndicator(),
            if (_client != null && !_loading)
              DropdownButtonFormField<int>(
                key: ValueKey(_client!.id),
                initialValue: _negotiationId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Negociação (opcional)',
                ),
                items: [
                  const DropdownMenuItem<int>(
                    value: null,
                    child: Text('Sem negociação'),
                  ),
                  for (final item in _negotiations)
                    DropdownMenuItem(
                      value: item.id,
                      child: Text(item.title, overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (value) => setState(() => _negotiationId = value),
              ),
            const SizedBox(height: 12),
            DropdownButtonFormField<BillingMethod>(
              initialValue: _method,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Meio de pagamento'),
              items: [
                for (final entry in _methodLabels.entries)
                  DropdownMenuItem(value: entry.key, child: Text(entry.value)),
              ],
              onChanged: (value) => setState(() => _method = value!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<BillingFlow>(
              initialValue: _flow,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Forma de cobrança'),
              items: [
                for (final entry in _flowLabels.entries)
                  DropdownMenuItem(value: entry.key, child: Text(entry.value)),
              ],
              onChanged: (value) => setState(() => _flow = value!),
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const ValueKey('billing-amount'),
              initialValue: _amount,
              decoration: InputDecoration(
                labelText: _flow == BillingFlow.recurring
                    ? 'Valor por ciclo (R\$)'
                    : 'Valor total (R\$)',
                helperText: 'Use vírgula e sem separador de milhar.',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (value) => _amount = value,
              validator: (value) => parseNegotiationAmount(value ?? '') == null
                  ? 'Informe um valor válido.'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const ValueKey('billing-date'),
              initialValue: _dueDate,
              decoration: InputDecoration(
                labelText: _flow == BillingFlow.single
                    ? 'Vencimento (AAAA-MM-DD)'
                    : 'Primeiro vencimento (AAAA-MM-DD)',
              ),
              keyboardType: TextInputType.datetime,
              onChanged: (value) => _dueDate = value,
              validator: _validDate,
            ),
            if (_flow == BillingFlow.installment) ...[
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('billing-count'),
                initialValue: _count,
                decoration: InputDecoration(
                  labelText: 'Quantidade de parcelas',
                  helperText: _method == BillingMethod.card
                      ? 'De 2 a 12 parcelas.'
                      : 'De 2 a 60 parcelas.',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _count = value,
                validator: (value) {
                  final count = int.tryParse(value?.trim() ?? '') ?? 0;
                  return count >= 2 &&
                          count <= (_method == BillingMethod.card ? 12 : 60)
                      ? null
                      : 'Informe uma quantidade válida.';
                },
              ),
              const Text(
                'O Asaas distribui o total entre as parcelas. Cada parcela será acompanhada separadamente.',
              ),
            ],
            if (_flow == BillingFlow.recurring) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<BillingCycle>(
                initialValue: _cycle,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Periodicidade'),
                items: [
                  for (final entry in _cycleLabels.entries)
                    DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    ),
                ],
                onChanged: (value) => setState(() => _cycle = value!),
              ),
              const Text(
                'A assinatura gera cobranças ao longo dos ciclos. Cada pagamento tem seu próprio estado.',
              ),
              if (_method == BillingMethod.pix)
                const Text('Pix por cobrança; não é débito automático.'),
            ],
            if (_method == BillingMethod.card)
              const Text(
                'O pagador informa o cartão na fatura hospedada pelo Asaas. Não informe cartão ou CVV no SignCob.',
              ),
            if (_error != null)
              Semantics(liveRegion: true, child: Text(_error!)),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: _loading || _submitted ? null : _submit,
        child: const Text('Criar no sandbox'),
      ),
    ],
  );
}

class _ClientPicker extends StatefulWidget {
  const _ClientPicker({required this.loadClients});
  final Future<List<BillingClientOption>> Function(String, int) loadClients;
  @override
  State<_ClientPicker> createState() => _ClientPickerState();
}

class _ClientPickerState extends State<_ClientPicker> {
  List<BillingClientOption> _items = [];
  String _query = '';
  String _loadedQuery = '';
  String? _error;
  int _offset = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load(0);
  }

  Future<void> _load(int offset) async {
    setState(() {
      _loading = true;
      _items = [];
      _error = null;
      _offset = offset;
      if (offset == 0) _loadedQuery = _query.trim();
    });
    try {
      final rows = await widget.loadClients(_loadedQuery, offset);
      if (mounted) setState(() => _items = rows);
    } catch (error) {
      if (mounted) setState(() => _error = _message(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Selecionar cliente pagador'),
    scrollable: true,
    content: SizedBox(
      width: 460,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Buscar cliente pelo nome',
            ),
            onChanged: (value) => _query = value,
            onSubmitted: (_) => _loading ? null : _load(0),
          ),
          TextButton(
            onPressed: _loading ? null : () => _load(0),
            child: const Text('Buscar'),
          ),
          if (_loading) const Center(child: CircularProgressIndicator()),
          if (_error != null) Text(_error!),
          if (!_loading && _items.isEmpty && _error == null)
            const Text('Nenhum cliente encontrado.'),
          for (final client in _items)
            ListTile(
              title: Text(client.name),
              subtitle: Text(
                client.readyForBilling
                    ? 'Cadastro pronto para cobrança'
                    : 'Documento cadastral pendente',
              ),
              onTap: () => Navigator.pop(context, client),
            ),
          Wrap(
            spacing: 8,
            children: [
              TextButton(
                onPressed: _loading || _offset == 0
                    ? null
                    : () => _load(_offset - 25),
                child: const Text('Anteriores'),
              ),
              TextButton(
                onPressed: _loading || _items.length < 25
                    ? null
                    : () => _load(_offset + 25),
                child: const Text('Mais clientes'),
              ),
            ],
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Voltar'),
      ),
    ],
  );
}

class _BillingDetails extends StatefulWidget {
  const _BillingDetails({
    required this.initial,
    required this.getCharge,
    required this.refreshCharge,
    required this.mayWrite,
    required this.onDenied,
  });
  final BillingCharge initial;
  final Future<BillingCharge> Function(int) getCharge;
  final Future<BillingCharge> Function(int) refreshCharge;
  final bool Function() mayWrite;
  final void Function(Object) onDenied;
  @override
  State<_BillingDetails> createState() => _BillingDetailsState();
}

class _BillingDetailsState extends State<_BillingDetails> {
  BillingCharge? _charge;
  bool _loading = true;
  bool _accessDenied = false;
  String? _error;
  String? _feedback;

  @override
  void initState() {
    super.initState();
    _load(false);
  }

  Future<void> _load(bool reconcile) async {
    setState(() {
      _loading = true;
      _error = null;
      _charge = null;
    });
    try {
      final result = await (reconcile
          ? widget.refreshCharge(widget.initial.id)
          : widget.getCharge(widget.initial.id));
      if (mounted) setState(() => _charge = result);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = _message(error);
        _accessDenied = _denied(error);
      });
      if (_accessDenied) widget.onDenied(error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _copyInvoice(String url) async {
    try {
      await Clipboard.setData(ClipboardData(text: url));
      if (mounted) setState(() => _feedback = 'Link da fatura copiado.');
    } catch (_) {
      if (mounted) {
        setState(() => _feedback = 'Selecione o link para copiá-lo.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final charge = _charge;
    return AlertDialog(
      title: const Text('Detalhes da cobrança'),
      scrollable: true,
      content: SizedBox(
        width: 560,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_error != null) Text(_error!),
                  if (_feedback != null)
                    Semantics(liveRegion: true, child: Text(_feedback!)),
                  if (charge != null) ...[
                    Text(
                      'Cliente ${charge.legalClientId} · ${_money(charge.amountCents)}',
                    ),
                    Text(
                      '${_flowLabels[charge.flow] ?? 'Registro anterior'} · ${_methodLabels[charge.method] ?? 'Meio não informado'}',
                    ),
                    Text(
                      charge.creationState == 'active'
                          ? 'Criação confirmada no sandbox'
                          : 'Criação pendente de conciliação',
                    ),
                    if (charge.providerGroupId != null)
                      SelectableText(
                        'Referência do grupo: ${charge.providerGroupId}',
                      ),
                    if (charge.subscriptionStatus != null)
                      Text(
                        'Assinatura: ${switch (charge.subscriptionStatus) {
                          'ACTIVE' => 'Ativa',
                          'INACTIVE' => 'Inativa',
                          'EXPIRED' => 'Expirada',
                          _ => 'Requer atenção',
                        }}',
                      ),
                    if (charge.flow == BillingFlow.recurring)
                      const Text(
                        'O estado da assinatura é separado do recebimento de cada cobrança.',
                      ),
                    const SizedBox(height: 12),
                    Text(
                      'Pagamentos individuais',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if ((charge.payments ?? []).isEmpty)
                      const Text(
                        'Nenhum pagamento individual conciliado. Consulte o sandbox para acompanhar a geração.',
                      ),
                    for (final payment in charge.payments ?? <BillingPayment>[])
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (payment.installmentNumber != null)
                                Text('Parcela ${payment.installmentNumber}'),
                              Text(
                                '${_money(payment.amountCents)} · vence ${payment.dueDate}',
                              ),
                              Text(_paymentLabel(payment.status)),
                              if (payment.confirmedAt != null)
                                Text(
                                  'Confirmação observada: ${payment.confirmedAt!.toLocal()}',
                                ),
                              if (payment.receivedAt != null)
                                Text(
                                  'Recebimento observado: ${payment.receivedAt!.toLocal()}',
                                ),
                              if (payment.invoiceUrl != null) ...[
                                SelectableText(payment.invoiceUrl!),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: () =>
                                        _copyInvoice(payment.invoiceUrl!),
                                    child: const Text('Copiar link da fatura'),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    const Text(
                      'Consultas atualizam o acompanhamento. A criação não confirma pagamento.',
                    ),
                  ],
                ],
              ),
      ),
      actions: [
        if (!_accessDenied)
          TextButton(
            onPressed: _loading ? null : () => _load(false),
            child: const Text('Consultar registro'),
          ),
        if (!_accessDenied && widget.mayWrite())
          FilledButton(
            onPressed: _loading ? null : () => _load(true),
            child: const Text('Conciliar no sandbox'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
