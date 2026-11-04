import 'package:flutter/material.dart';
import '../widgets/legal_form_scaffold.dart';

typedef SubmitContact =
    Future<void> Function(String name, String email, String message);

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key, required this.onSubmit, this.onOpenAdmin});
  final SubmitContact onSubmit;
  final VoidCallback? onOpenAdmin;

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  String? _validate(String? value, String label, int limit) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Informe $label.';
    if (text.length > limit) return 'Use até $limit caracteres.';
    return null;
  }

  Future<void> _submit() async {
    if (_sending || !_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _sending = true);
    try {
      await widget.onSubmit(
        _name.text.trim(),
        _email.text.trim(),
        _message.text.trim(),
      );
      if (!mounted) return;
      _name.clear();
      _email.clear();
      _message.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mensagem enviada com sucesso!')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível enviar. Tente novamente.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LegalFormScaffold(
      title: 'Entre em contato',
      actions: [
        if (widget.onOpenAdmin != null)
          IconButton(
            tooltip: 'Área administrativa',
            onPressed: widget.onOpenAdmin,
            icon: const Icon(Icons.admin_panel_settings_outlined),
          ),
      ],
      child: Form(
        key: _form,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Envie sua mensagem para nossa equipe.'),
              const SizedBox(height: 28),
              TextFormField(
                controller: _name,
                enabled: !_sending,
                maxLength: 120,
                autofillHints: const [AutofillHints.name],
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => _validate(value, 'seu nome', 120),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _email,
                enabled: !_sending,
                maxLength: 254,
                autofillHints: const [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final error = _validate(value, 'seu e-mail', 254);
                  if (error != null) return error;
                  if (!RegExp(
                    r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                  ).hasMatch(value!.trim())) {
                    return 'Informe um e-mail válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _message,
                enabled: !_sending,
                maxLength: 5000,
                minLines: 4,
                maxLines: 8,
                decoration: const InputDecoration(
                  labelText: 'Mensagem',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) => _validate(value, 'sua mensagem', 5000),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _sending ? null : _submit,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: _sending
                      ? const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Enviando…'),
                          ],
                        )
                      : const Text('Enviar mensagem'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
