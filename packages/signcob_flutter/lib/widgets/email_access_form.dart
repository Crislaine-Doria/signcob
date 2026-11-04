import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:signcob_client/signcob_client.dart';

enum _EmailStep {
  login,
  register,
  registerCode,
  registerPassword,
  reset,
  resetCode,
  resetPassword,
}

/// Responsive presentation of the existing Serverpod email authentication API.
class EmailAccessForm extends StatefulWidget {
  const EmailAccessForm({super.key, required this.client});
  final Client client;

  @override
  State<EmailAccessForm> createState() => _EmailAccessFormState();
}

class _EmailAccessFormState extends State<EmailAccessForm> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _code = TextEditingController();
  var _form = GlobalKey<FormState>();
  _EmailStep _step = _EmailStep.login;
  // Serverpod 3.2 exposes UUID request IDs through this experimental type.
  // ignore: experimental_member_use
  UuidValue? _request;
  String? _token;
  bool _busy = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _code.dispose();
    super.dispose();
  }

  void _navigate(_EmailStep step) {
    setState(() {
      _step = step;
      _error = null;
      _request = null;
      _token = null;
      _form = GlobalKey<FormState>();
      _obscure = true;
      _password.clear();
      _code.clear();
    });
  }

  Future<void> _submit() async {
    if (_busy || !_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final endpoint = widget.client.emailIdp;
      switch (_step) {
        case _EmailStep.login:
          final result = await endpoint.login(
            email: _email.text.trim(),
            password: _password.text,
          );
          if (!mounted) return;
          await widget.client.auth.updateSignedInUser(result);
        case _EmailStep.register:
          final request = await endpoint.startRegistration(
            email: _email.text.trim(),
          );
          if (!mounted) return;
          setState(() {
            _request = request;
            _step = _EmailStep.registerCode;
          });
        case _EmailStep.registerCode:
          final token = await endpoint.verifyRegistrationCode(
            accountRequestId: _request!,
            verificationCode: _code.text.trim(),
          );
          if (!mounted) return;
          setState(() {
            _token = token;
            _step = _EmailStep.registerPassword;
          });
        case _EmailStep.registerPassword:
          final result = await endpoint.finishRegistration(
            registrationToken: _token!,
            password: _password.text,
          );
          if (!mounted) return;
          await widget.client.auth.updateSignedInUser(result);
        case _EmailStep.reset:
          final request = await endpoint.startPasswordReset(
            email: _email.text.trim(),
          );
          if (!mounted) return;
          setState(() {
            _request = request;
            _step = _EmailStep.resetCode;
          });
        case _EmailStep.resetCode:
          final token = await endpoint.verifyPasswordResetCode(
            passwordResetRequestId: _request!,
            verificationCode: _code.text.trim(),
          );
          if (!mounted) return;
          setState(() {
            _token = token;
            _step = _EmailStep.resetPassword;
          });
        case _EmailStep.resetPassword:
          await endpoint.finishPasswordReset(
            finishPasswordResetToken: _token!,
            newPassword: _password.text,
          );
          if (!mounted) return;
          final result = await endpoint.login(
            email: _email.text.trim(),
            password: _password.text,
          );
          if (!mounted) return;
          await widget.client.auth.updateSignedInUser(result);
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = _step == _EmailStep.login
              ? 'Não foi possível entrar. Confira os dados ou tente novamente.'
              : 'Não foi possível concluir. Confira os dados, a validade do código e tente novamente.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final login = _step == _EmailStep.login;
    final emailStep =
        login || _step == _EmailStep.register || _step == _EmailStep.reset;
    final codeStep =
        _step == _EmailStep.registerCode || _step == _EmailStep.resetCode;
    final passwordStep =
        login ||
        _step == _EmailStep.registerPassword ||
        _step == _EmailStep.resetPassword;
    final title = switch (_step) {
      _EmailStep.login => 'Entrar com e-mail',
      _EmailStep.register => 'Criar conta',
      _EmailStep.reset => 'Recuperar senha',
      _EmailStep.registerCode || _EmailStep.resetCode => 'Verificar código',
      _EmailStep.registerPassword ||
      _EmailStep.resetPassword => 'Definir senha',
    };
    return Form(
      key: _form,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            if (emailStep)
              TextFormField(
                key: const ValueKey('auth-email'),
                controller: _email,
                enabled: !_busy,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  errorMaxLines: 3,
                ),
                autofillHints: const [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                textInputAction: login
                    ? TextInputAction.next
                    : TextInputAction.done,
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.length > 254 ||
                      !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
                    return 'Informe um e-mail válido.';
                  }
                  return null;
                },
                onFieldSubmitted: login ? null : (_) => _submit(),
              ),
            if (codeStep) ...[
              const Text(
                'Se a solicitação for válida, use o código recebido por e-mail. O envio depende da configuração do serviço.',
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const ValueKey('auth-code'),
                controller: _code,
                enabled: !_busy,
                decoration: const InputDecoration(
                  labelText: 'Código de verificação',
                  errorMaxLines: 3,
                ),
                autofillHints: const [AutofillHints.oneTimeCode],
                validator: (value) =>
                    value?.trim().isEmpty ?? true ? 'Informe o código.' : null,
                onFieldSubmitted: (_) => _submit(),
              ),
            ],
            if (passwordStep) ...[
              const SizedBox(height: 16),
              TextFormField(
                key: const ValueKey('auth-password'),
                controller: _password,
                enabled: !_busy,
                obscureText: _obscure,
                enableSuggestions: false,
                autocorrect: false,
                autofillHints: [
                  login ? AutofillHints.password : AutofillHints.newPassword,
                ],
                decoration: InputDecoration(
                  labelText: login ? 'Senha' : 'Nova senha',
                  errorMaxLines: 3,
                  suffixIcon: IconButton(
                    tooltip: _obscure ? 'Mostrar senha' : 'Ocultar senha',
                    onPressed: _busy
                        ? null
                        : () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Informe a senha.' : null,
                onFieldSubmitted: (_) => _submit(),
              ),
              if (!login)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    'Use uma senha forte. A política de senha é validada pelo servidor.',
                  ),
                ),
            ],
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Semantics(liveRegion: true, child: Text(_error!)),
              ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _busy ? null : _submit,
              child: Text(
                _busy
                    ? 'Aguarde…'
                    : login
                    ? 'Entrar'
                    : passwordStep
                    ? 'Salvar senha'
                    : 'Continuar',
              ),
            ),
            if (login) ...[
              TextButton(
                onPressed: _busy ? null : () => _navigate(_EmailStep.reset),
                child: const Text('Esqueci minha senha'),
              ),
              TextButton(
                onPressed: _busy ? null : () => _navigate(_EmailStep.register),
                child: const Text('Criar conta'),
              ),
            ] else ...[
              if (codeStep)
                TextButton(
                  onPressed: _busy
                      ? null
                      : () => _navigate(
                          _step == _EmailStep.registerCode
                              ? _EmailStep.register
                              : _EmailStep.reset,
                        ),
                  child: const Text('Solicitar novo código'),
                ),
              TextButton(
                onPressed: _busy ? null : () => _navigate(_EmailStep.login),
                child: const Text('Voltar para entrar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
