import 'package:flutter/material.dart';
import '../../widgets/brand_header.dart';
import '../../theme/signcob_theme.dart';

class WorkAccidentScreen extends StatefulWidget {
  const WorkAccidentScreen({super.key});

  @override
  State<WorkAccidentScreen> createState() => _WorkAccidentScreenState();
}

class _WorkAccidentScreenState extends State<WorkAccidentScreen> {
  static const _navy = SignCobColors.white;
  static const _gold = SignCobColors.gold;
  static const _situations = [
    'Acidente no local de trabalho',
    'Doença ocupacional',
    'Acidente de trajeto',
  ];
  static const _bodyParts = [
    'Mão ou dedos',
    'Braço ou ombro',
    'Perna ou pé',
    'Coluna ou costas',
    'Outra parte do corpo',
  ];
  static const _conditions = [
    'Ainda sinto dores ou limitações',
    'Ainda estou em tratamento',
    'Não',
  ];
  static const _salaries = [
    'Até R\$ 2.000',
    'Acima de R\$ 2.000 até R\$ 4.000',
    'Acima de R\$ 4.000 até R\$ 7.000',
    'Acima de R\$ 7.000',
    'Prefiro não informar',
  ];
  static const _times = [
    'Há menos de 1 mês',
    'De 1 a 6 meses',
    'De 7 a 12 meses',
    'Há mais de 1 ano',
  ];
  int _step = 0;
  String? _situation, _body, _condition, _salary, _time;
  int? _age;
  bool _complete = false;
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _next() {
    FocusScope.of(context).unfocus();
    setState(() => _step++);
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  Widget _option(
    String label,
    bool selected,
    VoidCallback onTap,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Semantics(
        selected: selected,
        button: true,
        child: Material(
          color: selected ? SignCobColors.navy : SignCobColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: selected ? SignCobColors.neon : SignCobColors.silver,
              width: selected ? 2 : 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 17),
              child: Row(
                children: [
                  Icon(icon, color: _navy, size: 23),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: _navy,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    selected ? Icons.check_circle : Icons.circle_outlined,
                    color: selected ? SignCobColors.neon : SignCobColors.silver,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _heading(String category, String question, String help) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        category.toUpperCase(),
        style: const TextStyle(
          color: SignCobColors.gold,
          fontSize: 11,
          letterSpacing: 1.7,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 12),
      Text(
        question,
        style: const TextStyle(
          color: _navy,
          fontSize: 26,
          height: 1.2,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 12),
      Text(
        help,
        style: const TextStyle(
          color: SignCobColors.silver,
          fontSize: 15,
          height: 1.5,
        ),
      ),
      const SizedBox(height: 24),
    ],
  );

  Widget _continue(bool enabled) => SizedBox(
    width: double.infinity,
    child: FilledButton(
      onPressed: enabled ? _next : null,
      style: FilledButton.styleFrom(
        backgroundColor: _gold,
        foregroundColor: SignCobColors.navy,
        minimumSize: const Size.fromHeight(52),
      ),
      child: const Text('Continuar'),
    ),
  );

  Widget _summary() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: SignCobColors.navy,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Seu resumo',
          style: TextStyle(fontWeight: FontWeight.w700, color: _navy),
        ),
        const SizedBox(height: 12),
        for (final entry in {
          'Situação': _situation,
          'Região afetada': _body,
          'Condição atual': _condition,
          'Idade': '$_age anos',
          'Faixa salarial': _salary,
          'Quando ocorreu': _time,
        }.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Text(
              '${entry.key}: ${entry.value ?? "Não informado"}',
              style: const TextStyle(color: _navy, height: 1.4),
            ),
          ),
      ],
    ),
  );

  Widget _content() {
    switch (_step) {
      case 0:
        return Column(
          children: [
            _heading(
              'Sua situação',
              'O que aconteceu com você?',
              'Escolha a opção que melhor descreve a situação.',
            ),
            for (var i = 0; i < _situations.length; i++)
              _option(
                _situations[i],
                _situation == _situations[i],
                () {
                  _situation = _situations[i];
                  _next();
                },
                [
                  Icons.work_outline,
                  Icons.health_and_safety_outlined,
                  Icons.directions_bus_outlined,
                ][i],
              ),
          ],
        );
      case 1:
        return Column(
          children: [
            _heading(
              'Região afetada',
              'Qual parte do corpo foi afetada?',
              'Se mais de uma região foi afetada, selecione a principal.',
            ),
            for (final part in _bodyParts)
              _option(part, _body == part, () {
                _body = part;
                _next();
              }, Icons.accessibility_new),
          ],
        );
      case 2:
        return Column(
          children: [
            _heading(
              'Como você está',
              'Ficou com alguma sequela?',
              'Conte como você se sente hoje. Esta resposta não substitui uma avaliação médica.',
            ),
            for (final condition in _conditions)
              _option(condition, _condition == condition, () {
                _condition = condition;
                _next();
              }, Icons.favorite_border),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _heading(
              'Sobre você',
              'Quantos anos você tem?',
              'Selecione sua idade atual para compor o resumo.',
            ),
            DropdownButtonFormField<int>(
              key: ValueKey('age-$_age'),
              initialValue: _age,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Sua idade',
                border: OutlineInputBorder(),
              ),
              items: List.generate(
                100,
                (i) => DropdownMenuItem(
                  value: i + 1,
                  child: Text('${i + 1} anos'),
                ),
              ),
              onChanged: (value) => setState(() => _age = value),
            ),
            const SizedBox(height: 24),
            _continue(_age != null),
          ],
        );
      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _heading(
              'Contexto',
              'Vamos entender o contexto?',
              'Informe a faixa salarial e há quanto tempo ocorreu a situação.',
            ),
            const Text(
              'Qual é a sua faixa salarial?',
              style: TextStyle(
                color: _navy,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            for (final salary in _salaries)
              _option(
                salary,
                _salary == salary,
                () => setState(() => _salary = salary),
                Icons.payments_outlined,
              ),
            const SizedBox(height: 18),
            const Text(
              'Há quanto tempo ocorreu?',
              style: TextStyle(
                color: _navy,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            for (final time in _times)
              _option(
                time,
                _time == time,
                () => setState(() => _time = time),
                Icons.schedule,
              ),
            const SizedBox(height: 12),
            _continue(_salary != null && _time != null),
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _heading(
              'Análise preliminar',
              _complete ? 'Seu resumo está pronto' : 'Revise suas respostas',
              'Cada situação exige análise individual. As respostas, sozinhas, não determinam direito ou valor de indenização.',
            ),
            _summary(),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: SignCobColors.navy,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Não calculamos valor: depende de análise profissional. O escritório ainda não forneceu regras de cálculo para esta ferramenta.',
                style: TextStyle(color: _navy, height: 1.5),
              ),
            ),
            const SizedBox(height: 24),
            if (!_complete) _contactForm(),
            if (_complete)
              Semantics(
                liveRegion: true,
                child: Text(
                  'Demonstração concluída. Nenhum pedido de contato foi enviado.',
                  style: TextStyle(
                    color: _navy,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ),
          ],
        );
    }
  }

  Widget _contactForm() => Form(
    key: _form,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Dados de contato',
          style: TextStyle(
            color: _navy,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Dados não enviados nem salvos nesta demonstração. O preenchimento serve apenas para apresentar o fluxo.',
          style: TextStyle(color: SignCobColors.silver, height: 1.5),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _phone,
          keyboardType: TextInputType.phone,
          maxLength: 20,
          decoration: const InputDecoration(
            labelText: 'WhatsApp com DDD',
            hintText: '(41) 99999-9999',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (!RegExp(r'^[+0-9()\s-]+$').hasMatch(value ?? '')) {
              return 'Informe um telefone com DDD válido.';
            }
            var digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
            if (digits.length > 11 && digits.startsWith('55')) {
              digits = digits.substring(2);
            }
            return !RegExp(r'^[1-9][0-9]{9,10}$').hasMatch(digits)
                ? 'Informe um telefone com DDD válido.'
                : null;
          },
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _name,
          textCapitalization: TextCapitalization.words,
          maxLength: 120,
          decoration: const InputDecoration(
            labelText: 'Nome',
            border: OutlineInputBorder(),
          ),
          validator: (v) =>
              (v?.trim().isEmpty ?? true) ? 'Informe seu nome.' : null,
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          maxLength: 254,
          decoration: const InputDecoration(
            labelText: 'E-mail',
            border: OutlineInputBorder(),
          ),
          validator: (v) =>
              !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v?.trim() ?? '')
              ? 'Informe um e-mail válido.'
              : null,
        ),
        const SizedBox(height: 18),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: _gold,
            foregroundColor: SignCobColors.navy,
            minimumSize: const Size.fromHeight(54),
          ),
          onPressed: () {
            if (_form.currentState!.validate()) {
              FocusScope.of(context).unfocus();
              setState(() => _complete = true);
            }
          },
          child: const Text('Ver minha indenização'),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: SignCobColors.navy,
    body: SafeArea(
      child: SingleChildScrollView(
        controller: _scroll,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: SignCobColors.surface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: SignCobColors.silver.withValues(alpha: .2),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33111318),
                          blurRadius: 28,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: BrandHeader(compact: true),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Advocacia · Atendimento especializado',
                          style: TextStyle(
                            color: SignCobColors.silver,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Etapa ${_step + 1} de 6',
                                style: const TextStyle(
                                  color: SignCobColors.silver,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _step > 0
                                  ? () => setState(() {
                                      _step--;
                                      _complete = false;
                                      if (_scroll.hasClients) _scroll.jumpTo(0);
                                    })
                                  : () => Navigator.maybePop(context),
                              icon: const Icon(Icons.arrow_back, size: 17),
                              label: const Text('Voltar'),
                              style: TextButton.styleFrom(
                                foregroundColor: _navy,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: (_step + 1) / 6,
                            minHeight: 5,
                            color: SignCobColors.neon,
                            backgroundColor: SignCobColors.navy,
                            semanticsLabel: 'Progresso do questionário',
                          ),
                        ),
                        const SizedBox(height: 30),
                        _content(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Uma orientação inicial para organizar sua história. Sem promessa de resultado ou valor de indenização.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: SignCobColors.silver,
                      height: 1.5,
                      fontSize: 12,
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/privacidade'),
                    child: const Text(
                      'Política de privacidade',
                      style: TextStyle(
                        color: _navy,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const Text(
                    'Respostas mantidas apenas nesta tela durante o uso. Não há envio ou armazenamento nesta demonstração.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: SignCobColors.silver,
                      height: 1.5,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
