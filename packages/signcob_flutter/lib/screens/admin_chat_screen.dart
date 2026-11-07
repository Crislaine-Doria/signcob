import 'package:flutter/material.dart';
import 'package:signcob_client/signcob_client.dart';

import 'chat_provisioning_panel.dart';

const chatPageSize = 25;
const chatMessageMaxLength = 4000;

class ChatConversationItem {
  const ChatConversationItem({
    required this.id,
    required this.title,
    required this.updatedAt,
    this.preview,
  });

  final int id;
  final String title;
  final DateTime updatedAt;
  final String? preview;
}

class ChatMessageItem {
  const ChatMessageItem({
    required this.id,
    required this.authorLabel,
    required this.content,
    required this.createdAt,
    required this.isCurrentUser,
  });

  final int id;
  final String authorLabel;
  final String content;
  final DateTime createdAt;
  final bool isCurrentUser;
}

typedef LoadChatConversations =
    Future<List<ChatConversationItem>> Function(int offset);
typedef LoadChatMessages =
    Future<List<ChatMessageItem>> Function(int conversationId, int offset);
typedef SendChatMessage =
    Future<ChatMessageItem> Function(int conversationId, String content);

class AdminChatScreen extends StatefulWidget {
  const AdminChatScreen({
    super.key,
    required this.sessionIdentity,
    required this.loadConversations,
    required this.loadMessages,
    required this.sendMessage,
    this.provisioning,
  });

  final Object? sessionIdentity;
  final LoadChatConversations loadConversations;
  final LoadChatMessages loadMessages;
  final SendChatMessage sendMessage;
  final ChatProvisioning? provisioning;

  @override
  State<AdminChatScreen> createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  final _composer = TextEditingController();
  final _messagesController = ScrollController();
  List<ChatConversationItem> _conversations = const [];
  List<ChatMessageItem> _messages = const [];
  ChatConversationItem? _selected;
  ({int? conversationId})? _provisioningTarget;
  int _conversationOffset = 0;
  int _messageOffset = 0;
  bool _loadingConversations = true;
  bool _loadingMessages = false;
  bool _sending = false;
  int _sessionGeneration = 0;
  int _messageRequest = 0;
  String? _conversationError;
  String? _messageError;
  String? _composerError;

  @override
  void initState() {
    super.initState();
    _loadConversations(0);
  }

  @override
  void didUpdateWidget(covariant AdminChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sessionIdentity != widget.sessionIdentity) {
      _resetForSession();
    } else if (!identical(oldWidget.provisioning, widget.provisioning) &&
        _provisioningTarget != null) {
      _closeProvisioning();
    }
  }

  @override
  void dispose() {
    _composer.dispose();
    _messagesController.dispose();
    super.dispose();
  }

  bool _isAccessDenied(Object error) =>
      error is AccessDeniedException ||
      error is ServerpodClientException &&
          (error.statusCode == 401 || error.statusCode == 403);

  String _safeError(Object error) => _isAccessDenied(error)
      ? 'Acesso restrito para esta conta.'
      : 'Não foi possível carregar o chat. Tente novamente.';

  void _resetForSession() {
    _sessionGeneration++;
    setState(() {
      _conversations = const [];
      _messages = const [];
      _selected = null;
      _provisioningTarget = null;
      _conversationOffset = 0;
      _messageOffset = 0;
      _conversationError = null;
      _messageError = null;
      _composerError = null;
      _sending = false;
      _loadingMessages = false;
    });
    _composer.clear();
    _loadConversations(0);
  }

  Future<void> _loadConversations(int offset) async {
    final generation = _sessionGeneration;
    setState(() {
      _loadingConversations = true;
      _conversationError = null;
      _conversations = const [];
      _conversationOffset = offset;
      _selected = null;
      _messages = const [];
      _messageError = null;
    });
    try {
      final conversations = await widget.loadConversations(offset);
      if (mounted && generation == _sessionGeneration) {
        setState(() => _conversations = conversations);
      }
    } catch (error) {
      if (mounted && generation == _sessionGeneration) {
        setState(() => _conversationError = _safeError(error));
      }
    } finally {
      if (mounted && generation == _sessionGeneration) {
        setState(() => _loadingConversations = false);
      }
    }
  }

  Future<void> _selectConversation(ChatConversationItem conversation) async {
    setState(() {
      _selected = conversation;
      _messages = const [];
      _messageOffset = 0;
      _messageError = null;
      _composerError = null;
    });
    _composer.clear();
    await _loadMessages(0);
  }

  Future<void> _loadMessages(int offset) async {
    final conversation = _selected;
    if (conversation == null) return;
    final generation = _sessionGeneration;
    final request = ++_messageRequest;
    bool isCurrent() =>
        mounted &&
        generation == _sessionGeneration &&
        request == _messageRequest &&
        _selected?.id == conversation.id;
    setState(() {
      _loadingMessages = true;
      _messageError = null;
      _messageOffset = offset;
    });
    try {
      final messages = await widget.loadMessages(conversation.id, offset);
      if (!isCurrent()) return;
      setState(() => _messages = messages);
    } catch (error) {
      if (!isCurrent()) return;
      setState(() {
        _messages = const [];
        _messageError = _safeError(error);
      });
    } finally {
      if (isCurrent()) {
        setState(() => _loadingMessages = false);
      }
    }
  }

  Future<void> _send() async {
    if (_sending || _selected == null) return;
    final content = _composer.text.trim();
    if (content.isEmpty) {
      setState(() => _composerError = 'Digite uma mensagem.');
      return;
    }
    if (content.length > chatMessageMaxLength) {
      setState(
        () => _composerError =
            'A mensagem deve ter até $chatMessageMaxLength caracteres.',
      );
      return;
    }
    final conversationId = _selected!.id;
    final generation = _sessionGeneration;
    setState(() {
      _sending = true;
      _composerError = null;
    });
    try {
      await widget.sendMessage(conversationId, content);
      if (!mounted ||
          generation != _sessionGeneration ||
          _selected?.id != conversationId) {
        return;
      }
      _composer.clear();
      await _loadMessages(0);
    } catch (error) {
      if (!mounted ||
          generation != _sessionGeneration ||
          _selected?.id != conversationId) {
        return;
      }
      setState(() {
        _composerError = _isAccessDenied(error)
            ? 'Acesso restrito para esta conta.'
            : 'Não foi possível enviar. Tente novamente.';
      });
    } finally {
      if (mounted && generation == _sessionGeneration) {
        setState(() => _sending = false);
      }
    }
  }

  void _openProvisioning({int? conversationId}) {
    if (_sending) return;
    setState(() {
      _provisioningTarget = (conversationId: conversationId);
      _selected = null;
      _messages = const [];
      _loadingMessages = false;
    });
    _composer.clear();
  }

  void _closeProvisioning() {
    setState(() => _provisioningTarget = null);
    _loadConversations(0);
  }

  Widget _conversationPane() {
    final body = _conversationBody();
    if (widget.provisioning == null ||
        _loadingConversations ||
        _conversationError != null) {
      return body;
    }
    return Column(
      children: [
        TextButton(
          onPressed: _sending ? null : () => _openProvisioning(),
          child: const Text('Nova conversa'),
        ),
        Expanded(child: body),
      ],
    );
  }

  Widget _conversationBody() {
    if (_loadingConversations) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_conversationError != null) {
      return _RetryState(
        message: _conversationError!,
        onRetry: () => _loadConversations(_conversationOffset),
      );
    }
    if (_conversations.isEmpty) {
      return const Center(child: Text('Nenhuma conversa disponível.'));
    }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            key: const ValueKey('chat-conversation-list'),
            itemCount: _conversations.length,
            itemBuilder: (context, index) {
              final conversation = _conversations[index];
              return ListTile(
                selected: _selected?.id == conversation.id,
                title: Text(conversation.title),
                subtitle: conversation.preview == null
                    ? null
                    : Text(
                        conversation.preview!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _selectConversation(conversation),
              );
            },
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            TextButton(
              onPressed: _conversationOffset == 0
                  ? null
                  : () => _loadConversations(
                      (_conversationOffset - chatPageSize).clamp(
                        0,
                        _conversationOffset,
                      ),
                    ),
              child: const Text('Anterior'),
            ),
            Text('Página ${_conversationOffset ~/ chatPageSize + 1}'),
            TextButton(
              onPressed: _conversations.length < chatPageSize
                  ? null
                  : () => _loadConversations(
                      _conversationOffset + chatPageSize,
                    ),
              child: const Text('Próxima'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _messagePane({required bool showBack}) {
    final conversation = _selected;
    if (conversation == null) {
      return const Center(child: Text('Selecione uma conversa.'));
    }
    return Column(
      children: [
        Material(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: ListTile(
            leading: showBack
                ? IconButton(
                    tooltip: 'Voltar às conversas',
                    onPressed: () => setState(() {
                      _selected = null;
                      _messages = const [];
                      _messageError = null;
                      _composerError = null;
                    }),
                    icon: const Icon(Icons.arrow_back),
                  )
                : null,
            title: Text(conversation.title),
            trailing: IconButton(
              tooltip: 'Atualizar mensagens',
              onPressed: _loadingMessages
                  ? null
                  : () => _loadMessages(_messageOffset),
              icon: const Icon(Icons.refresh),
            ),
          ),
        ),
        if (widget.provisioning != null &&
            !_loadingMessages &&
            _messageError == null)
          TextButton(
            onPressed: _sending
                ? null
                : () => _openProvisioning(conversationId: conversation.id),
            child: const Text('Gerenciar participantes'),
          ),
        Expanded(child: _messageBody()),
        _composerArea(),
      ],
    );
  }

  Widget _messageBody() {
    if (_loadingMessages) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_messageError != null) {
      return _RetryState(
        message: _messageError!,
        onRetry: () => _loadMessages(_messageOffset),
      );
    }
    return Column(
      children: [
        if (_messageOffset > 0 || _messages.length == chatPageSize)
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              TextButton(
                onPressed: _messageOffset == 0
                    ? null
                    : () => _loadMessages(
                        (_messageOffset - chatPageSize).clamp(
                          0,
                          _messageOffset,
                        ),
                      ),
                child: const Text('Mensagens mais recentes'),
              ),
              TextButton(
                onPressed: _messages.length < chatPageSize
                    ? null
                    : () => _loadMessages(_messageOffset + chatPageSize),
                child: const Text('Mensagens anteriores'),
              ),
            ],
          ),
        Expanded(
          child: _messages.isEmpty
              ? const Center(child: Text('Nenhuma mensagem nesta conversa.'))
              : ListView.builder(
                  key: const ValueKey('chat-message-list'),
                  controller: _messagesController,
                  padding: const EdgeInsets.all(12),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return Align(
                      alignment: message.isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: Card(
                          color: message.isCurrentUser
                              ? Theme.of(
                                  context,
                                ).colorScheme.primaryContainer
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.authorLabel,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                                const SizedBox(height: 4),
                                SelectableText(message.content),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _composerArea() => Material(
    elevation: 2,
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                key: const ValueKey('chat-composer'),
                controller: _composer,
                enabled: !_sending,
                minLines: 1,
                maxLines: 4,
                maxLength: chatMessageMaxLength,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  labelText: 'Mensagem',
                  errorText: _composerError,
                ),
                onChanged: (_) {
                  if (_composerError != null) {
                    setState(() => _composerError = null);
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Semantics(
              button: true,
              label: _sending ? 'Enviando mensagem' : 'Enviar mensagem',
              child: IconButton.filled(
                tooltip: _sending ? 'Enviando…' : 'Enviar',
                onPressed: _sending ? null : _send,
                icon: _sending
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final target = _provisioningTarget;
    final provisioning = widget.provisioning;
    if (target != null && provisioning != null) {
      return ChatProvisioningPanel(
        key: ValueKey((_sessionGeneration, target)),
        provisioning: provisioning,
        conversationId: target.conversationId,
        onBack: _closeProvisioning,
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 700;
        if (compact) {
          return _selected == null
              ? _conversationPane()
              : _messagePane(showBack: true);
        }
        return Row(
          children: [
            SizedBox(width: 320, child: _conversationPane()),
            const VerticalDivider(width: 1),
            Expanded(child: _messagePane(showBack: false)),
          ],
        );
      },
    );
  }
}

class _RetryState extends StatelessWidget {
  const _RetryState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          TextButton(onPressed: onRetry, child: const Text('Tentar novamente')),
        ],
      ),
    ),
  );
}
