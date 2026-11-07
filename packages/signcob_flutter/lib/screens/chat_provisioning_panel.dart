import 'dart:math';

import 'package:flutter/material.dart';
import 'package:signcob_client/signcob_client.dart';

String _chatRequestId() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex = bytes.map((value) => value.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-'
      '${hex.substring(16, 20)}-${hex.substring(20)}';
}

class ChatClientChoice {
  const ChatClientChoice({required this.id, required this.label});

  final int id;
  final String label;
}

class ChatCreationOptions {
  const ChatCreationOptions({
    required this.clients,
    required this.titleMaxLength,
  });

  final List<ChatClientChoice> clients;
  final int titleMaxLength;
}

class ChatParticipantOption {
  const ChatParticipantOption({required this.reference, required this.label});

  // Reference supplied by the server for a target, distinct from the caller.
  final String reference;
  final String label;
}

class ChatParticipantRoster {
  const ChatParticipantRoster({
    required this.active,
    required this.eligible,
    this.allowManualReference = false,
  });

  final List<ChatParticipantOption> active;
  final List<ChatParticipantOption> eligible;
  final bool allowManualReference;
}

class ServerpodChatProvisioning implements ChatProvisioning {
  ServerpodChatProvisioning(this.client);

  final Client client;

  @override
  Future<ChatCreationOptions> loadCreationOptions() async {
    final rows = await client.chat.listCreationClients(0, 50);
    return ChatCreationOptions(
      clients: rows
          .map((row) => ChatClientChoice(id: row.legalClientId, label: row.name))
          .toList(growable: false),
      titleMaxLength: 120,
    );
  }

  @override
  Future<void> createConversation({
    required int clientId,
    required String title,
  }) async {
    await client.chat.createConversation(clientId, title, _chatRequestId());
  }

  @override
  Future<ChatParticipantRoster> loadParticipants(int conversationId) async {
    final rows = await client.chat.listParticipants(conversationId, 0, 50);
    final active = rows
        .map(
          (row) => ChatParticipantOption(
            reference: row.authUserId,
            label: 'Participante',
          ),
        )
        .toList(growable: false);
    return ChatParticipantRoster(
      active: active,
      eligible: const [],
      allowManualReference: true,
    );
  }

  @override
  Future<void> addParticipant(int conversationId, String reference) async {
    await client.chat.addParticipant(conversationId, reference.trim());
  }

  @override
  Future<void> removeParticipant(int conversationId, String reference) async {
    await client.chat.removeParticipant(conversationId, reference.trim());
  }
}

/// Presentation boundary for the authenticated client.
abstract interface class ChatProvisioning {
  Future<ChatCreationOptions> loadCreationOptions();
  Future<void> createConversation({
    required int clientId,
    required String title,
  });
  Future<ChatParticipantRoster> loadParticipants(int conversationId);
  Future<void> addParticipant(int conversationId, String reference);
  Future<void> removeParticipant(int conversationId, String reference);
}

class ChatProvisioningPanel extends StatefulWidget {
  const ChatProvisioningPanel({
    super.key,
    required this.provisioning,
    required this.onBack,
    this.conversationId,
  });

  final ChatProvisioning provisioning;
  final VoidCallback onBack;
  final int? conversationId;

  @override
  State<ChatProvisioningPanel> createState() => _ChatProvisioningPanelState();
}

class _ChatProvisioningPanelState extends State<ChatProvisioningPanel> {
  static final _titleControls = RegExp(r'[\x00-\x1f\x7f]');
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _candidateController = TextEditingController();
  ChatCreationOptions? _creation;
  ChatParticipantRoster? _roster;
  int? _clientId;
  String? _candidate;
  bool _loading = true;
  bool _saving = false;
  bool _denied = false;
  bool _created = false;
  bool _creationUnconfirmed = false;
  String? _error;
  String? _notice;

  bool get _creating => widget.conversationId == null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _title.dispose();
    _candidateController.dispose();
    super.dispose();
  }

  bool _isDenied(Object error) =>
      error is AccessDeniedException ||
      error is ServerpodClientException &&
          (error.statusCode == 401 || error.statusCode == 403);

  void _deny() {
    _title.clear();
    _denied = true;
    _creation = null;
    _roster = null;
    _clientId = null;
    _candidate = null;
    _notice = null;
    _error = null;
  }

  Future<void> _load({bool preserveError = false}) async {
    setState(() {
      _loading = true;
      _creation = null;
      _roster = null;
      _clientId = null;
      _candidate = null;
      if (!preserveError) _error = null;
    });
    try {
      final conversationId = widget.conversationId;
      if (conversationId == null) {
        final options = await widget.provisioning.loadCreationOptions();
        if (mounted) setState(() => _creation = options);
      } else {
        final roster = await widget.provisioning.loadParticipants(
          conversationId,
        );
        if (mounted) setState(() => _roster = roster);
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        if (_isDenied(error)) {
          _deny();
        } else {
          _error = 'Não foi possível carregar os dados. Tente novamente.';
        }
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _validateTitle(String? input) {
    final title = input?.trim() ?? '';
    if (title.isEmpty) return 'Digite um título.';
    final limit = _creation!.titleMaxLength;
    if (title.length > limit) return 'Use até $limit caracteres.';
    if (_titleControls.hasMatch(title)) return 'Use um título sem controles.';
    return null;
  }

  Future<void> _create() async {
    if (_saving || _created || _creationUnconfirmed || _creation == null) {
      return;
    }
    final clientId = _clientId;
    if (_form.currentState?.validate() != true || clientId == null) return;
    final title = _title.text.trim();
    setState(() => _saving = true);
    try {
      await widget.provisioning.createConversation(
        clientId: clientId,
        title: title,
      );
      if (!mounted) return;
      _title.clear();
      setState(() => _created = true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        if (_isDenied(error)) {
          _deny();
        } else {
          _creationUnconfirmed = true;
          _error =
              'Não foi possível confirmar a criação. Volte ao chat e '
              'confira a lista antes de tentar novamente.';
        }
      });
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _changeParticipant(
    String reference, {
    required bool remove,
  }) async {
    final roster = _roster;
    if (_saving || roster == null) return;
    // A previous frame can still dispatch a tap after a fast write and reload.
    final isActive = roster.active.any(
      (option) => option.reference == reference,
    );
    if (remove ? !isActive : isActive || _candidate != reference) return;
    final conversationId = widget.conversationId!;
    setState(() {
      _saving = true;
      _notice = null;
      _error = null;
    });
    try {
      if (remove) {
        await widget.provisioning.removeParticipant(conversationId, reference);
      } else {
        await widget.provisioning.addParticipant(conversationId, reference);
      }
      if (!mounted) return;
      setState(() {
        _notice = remove ? 'Participante removido.' : 'Participante incluído.';
      });
      await _load();
    } catch (error) {
      if (!mounted) return;
      if (_isDenied(error)) {
        setState(_deny);
      } else {
        setState(() => _error = 'Não foi possível confirmar a alteração.');
        // Re-read before enabling another write after an ambiguous outcome.
        await _load(preserveError: true);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _creationForm(ChatCreationOptions options) {
    if (options.clients.isEmpty) {
      return const Text('Nenhum cliente disponível para criar uma conversa.');
    }
    final enabled = !_saving && !_creationUnconfirmed;
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<int>(
            key: const ValueKey('chat-provision-client'),
            decoration: const InputDecoration(labelText: 'Cliente'),
            isExpanded: true,
            initialValue: _clientId,
            items: [
              for (final option in options.clients)
                DropdownMenuItem(
                  value: option.id,
                  child: Text(option.label, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: enabled
                ? (value) => setState(() => _clientId = value)
                : null,
            validator: (value) =>
                value == null ? 'Selecione um cliente.' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: const ValueKey('chat-provision-title'),
            controller: _title,
            enabled: enabled,
            decoration: InputDecoration(
              labelText: 'Título',
              helperText: 'Até ${options.titleMaxLength} caracteres',
              errorMaxLines: 2,
            ),
            validator: _validateTitle,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: enabled ? _create : null,
            child: const Text('Criar conversa'),
          ),
        ],
      ),
    );
  }

  Widget _participants(ChatParticipantRoster roster) {
    final active = roster.active.map((option) => option.reference).toSet();
    final candidates = roster.eligible.where(
      (option) => !active.contains(option.reference),
    );
    final candidate = _candidate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (roster.active.isEmpty) const Text('Nenhum participante ativo.'),
        for (final option in roster.active)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(option.label),
            trailing: IconButton(
              tooltip: 'Remover ${option.label}',
              onPressed: _saving
                  ? null
                  : () => _changeParticipant(option.reference, remove: true),
              icon: const Icon(Icons.person_remove_outlined),
            ),
          ),
        const SizedBox(height: 12),
        if (candidates.isEmpty && !roster.allowManualReference)
          const Text('A identidade será validada pelo servidor.')
        else ...[
          DropdownButtonFormField<String>(
            key: const ValueKey('chat-provision-participant'),
            decoration: const InputDecoration(labelText: 'Participante'),
            isExpanded: true,
            initialValue: candidate,
            items: [
              for (final option in candidates)
                DropdownMenuItem(
                  value: option.reference,
                  child: Text(option.label, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: _saving
                ? null
                : (value) => setState(() => _candidate = value),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _saving || candidate == null
                ? null
                : () => _changeParticipant(candidate, remove: false),
            child: const Text('Incluir participante'),
          ),
        ],
        if (roster.allowManualReference) ...[
          const SizedBox(height: 12),
          TextField(
            key: const ValueKey('chat-provision-participant-reference'),
            controller: _candidateController,
            enabled: !_saving,
            decoration: const InputDecoration(
              labelText: 'Identidade autorizada (UUID)',
              helperText: 'O servidor valida vínculo e capacidade atuais.',
            ),
            onChanged: (value) => _candidate = value,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _saving || (_candidate?.trim().isEmpty ?? true)
                ? null
                : () => _changeParticipant(_candidate!.trim(), remove: false),
            child: const Text('Incluir participante'),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => ListView(
      padding: EdgeInsets.symmetric(
        horizontal: constraints.maxWidth > 640
            ? (constraints.maxWidth - 600) / 2
            : 16,
        vertical: 16,
      ),
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton(
            onPressed: _saving ? null : widget.onBack,
            child: const Text('Voltar ao chat'),
          ),
        ),
        Text(
          _creating ? 'Nova conversa' : 'Gerenciar participantes',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        if (_loading || _saving)
          LinearProgressIndicator(
            semanticsLabel: _saving ? 'Salvando alteração' : 'Carregando dados',
          ),
        if (_denied)
          Semantics(
            liveRegion: true,
            child: const Text('Acesso restrito para esta conta.'),
          ),
        if (_error case final error?)
          Semantics(liveRegion: true, child: Text(error)),
        if (_notice case final notice?)
          Semantics(liveRegion: true, child: Text(notice)),
        if (_created)
          Semantics(liveRegion: true, child: const Text('Conversa criada.'))
        else if (_creation case final creation?)
          _creationForm(creation)
        else if (_roster case final roster?)
          _participants(roster)
        else if (!_loading && !_saving && !_denied)
          TextButton(
            onPressed: _load,
            child: const Text('Tentar novamente'),
          ),
      ],
    ),
  );
}
