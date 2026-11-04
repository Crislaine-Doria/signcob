import 'package:flutter/material.dart';
import '../widgets/admin_page_scaffold.dart';
import 'package:signcob_client/signcob_client.dart';

typedef SaveArticle =
    Future<PublicArticle> Function(int?, String, String, String, String?, bool);
typedef SavePartner =
    Future<PublicPartner> Function(int?, String, String, String, bool);

class ContentScreen extends StatefulWidget {
  const ContentScreen({
    super.key,
    required this.partners,
    required this.loadArticles,
    required this.loadPartners,
    this.saveArticle,
    this.savePartner,
  });
  final bool partners;
  final Future<List<PublicArticle>> Function(int) loadArticles;
  final Future<List<PublicPartner>> Function(int) loadPartners;
  final SaveArticle? saveArticle;
  final SavePartner? savePartner;
  bool get admin => saveArticle != null || savePartner != null;
  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  List<dynamic> _items = [];
  int _offset = 0;
  bool _loading = true;
  String? _error;
  @override
  void initState() {
    super.initState();
    _load(0);
  }

  Future<void> _load(int offset) async {
    setState(() {
      _loading = true;
      _error = null;
      _items = [];
      _offset = offset;
    });
    try {
      final rows = widget.partners
          ? await widget.loadPartners(offset)
          : await widget.loadArticles(offset);
      if (mounted) setState(() => _items = rows);
    } catch (e) {
      if (mounted) {
        setState(
          () => _error =
              e is AccessDeniedException ||
                  e is ServerpodClientException &&
                      (e.statusCode == 401 || e.statusCode == 403)
              ? 'Acesso restrito para esta conta.'
              : 'Não foi possível carregar. Tente novamente.',
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _edit(dynamic item) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _ContentEditor(
        partner: widget.partners,
        item: item,
        saveArticle: widget.saveArticle,
        savePartner: widget.savePartner,
      ),
    );
    if (saved == true && mounted) _load(_offset);
  }

  void _detail(dynamic item) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          item is PublicArticle ? item.title : (item as PublicPartner).name,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: item is PublicArticle
                ? [
                    Text(item.summary),
                    const SizedBox(height: 16),
                    SelectableText(item.body),
                    if (item.externalUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: SelectableText(item.externalUrl!),
                      ),
                  ]
                : [
                    Text((item as PublicPartner).description),
                    const SizedBox(height: 16),
                    SelectableText(item.website),
                  ],
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
      title: Text(widget.partners ? 'Parceiros' : 'Blog'),
      actions: [
        if (widget.admin)
          TextButton(
            onPressed: _loading ? null : () => _edit(null),
            child: const Text('Novo'),
          ),
      ],
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
        : Column(
            children: [
              Expanded(
                child: _items.isEmpty
                    ? const Center(child: Text('Nenhum conteúdo disponível.'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          final article = item is PublicArticle;
                          return Card(
                            child: ListTile(
                              title: Text(
                                article
                                    ? item.title
                                    : (item as PublicPartner).name,
                              ),
                              subtitle: Text(
                                article
                                    ? '${item.summary}${widget.admin ? (item.published ? '\nPublicado' : '\nRascunho') : ''}'
                                    : '${(item as PublicPartner).description}${widget.admin ? (item.active ? '\nAtivo' : '\nInativo') : ''}',
                              ),
                              trailing: Icon(
                                widget.admin
                                    ? Icons.edit_outlined
                                    : Icons.chevron_right,
                              ),
                              onTap: () =>
                                  widget.admin ? _edit(item) : _detail(item),
                            ),
                          );
                        },
                      ),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  TextButton(
                    onPressed: _offset == 0 ? null : () => _load(_offset - 25),
                    child: const Text('Anterior'),
                  ),
                  TextButton(
                    onPressed: _items.length < 25
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

class _ContentEditor extends StatefulWidget {
  const _ContentEditor({
    required this.partner,
    this.item,
    this.saveArticle,
    this.savePartner,
  });
  final bool partner;
  final dynamic item;
  final SaveArticle? saveArticle;
  final SavePartner? savePartner;
  @override
  State<_ContentEditor> createState() => _ContentEditorState();
}

class _ContentEditorState extends State<_ContentEditor> {
  final _form = GlobalKey<FormState>();
  late final List<TextEditingController> _fields;
  late bool _visible;
  bool _saving = false;
  String? _error;
  @override
  void initState() {
    super.initState();
    final item = widget.item;
    final values = item == null
        ? ['', '', '', '']
        : widget.partner
        ? [(item as PublicPartner).name, item.description, item.website, '']
        : [
            (item as PublicArticle).title,
            item.summary,
            item.body,
            item.externalUrl ?? '',
          ];
    _fields = values.map((v) => TextEditingController(text: v)).toList();
    _visible = item == null
        ? false
        : widget.partner
        ? (item as PublicPartner).active
        : (item as PublicArticle).published;
  }

  @override
  void dispose() {
    for (final field in _fields) {
      field.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final values = _fields.map((f) => f.text.trim()).toList();
      if (widget.partner) {
        await widget.savePartner!(
          widget.item?.id as int?,
          values[0],
          values[1],
          values[2],
          _visible,
        );
      } else {
        await widget.saveArticle!(
          widget.item?.id as int?,
          values[0],
          values[1],
          values[2],
          values[3].isEmpty ? null : values[3],
          _visible,
        );
      }
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error =
              'Não foi possível salvar. Confira sua permissão e tente novamente.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = widget.partner
        ? ['Nome', 'Descrição', 'Site']
        : ['Título', 'Resumo', 'Conteúdo', 'Link externo (opcional)'];
    return AlertDialog(
      title: Text(widget.partner ? 'Parceiro' : 'Artigo'),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < labels.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextFormField(
                      controller: _fields[i],
                      enabled: !_saving,
                      decoration: InputDecoration(labelText: labels[i]),
                      minLines: i == 1 || !widget.partner && i == 2 ? 3 : 1,
                      maxLines: i == 1 || !widget.partner && i == 2 ? 6 : 1,
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty &&
                            !(i == 3 && !widget.partner) &&
                            !(i == 2 &&
                                !widget.partner &&
                                _fields[3].text.trim().isNotEmpty)) {
                          return 'Preencha este campo.';
                        }
                        final isUrl =
                            widget.partner && i == 2 ||
                            !widget.partner && i == 3;
                        if (isUrl && text.isNotEmpty) {
                          final uri = Uri.tryParse(text);
                          if (uri == null ||
                              !['https', 'http'].contains(uri.scheme) ||
                              uri.host.isEmpty ||
                              uri.userInfo.isNotEmpty) {
                            return 'Informe um endereço HTTP ou HTTPS válido.';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                CheckboxListTile(
                  value: _visible,
                  onChanged: _saving
                      ? null
                      : (value) => setState(() => _visible = value!),
                  title: Text(
                    widget.partner ? 'Ativo no site' : 'Publicado no site',
                  ),
                ),
                if (_error != null) Text(_error!),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? 'Salvando...' : 'Salvar'),
        ),
      ],
    );
  }
}
