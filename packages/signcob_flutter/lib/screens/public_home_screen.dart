import 'package:flutter/material.dart';
import '../theme/signcob_theme.dart';
import '../widgets/brand_header.dart';

class PublicHomeScreen extends StatelessWidget {
  const PublicHomeScreen({
    super.key,
    required this.onCalculators,
    required this.onContact,
    required this.onAdmin,
    this.onBlog,
    this.onPartners,
  });
  final VoidCallback onCalculators;
  final VoidCallback onContact;
  final VoidCallback onAdmin;
  final VoidCallback? onBlog;
  final VoidCallback? onPartners;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: SignCobColors.navy,
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final narrow = constraints.maxWidth < 700;
                    final inset = narrow ? 20.0 : 32.0;
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: inset),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 32,
                              runSpacing: 20,
                              children: [
                                const BrandHeader(),
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 8,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    if (onBlog != null)
                                      TextButton(
                                        onPressed: onBlog,
                                        child: const Text('Blog'),
                                      ),
                                    if (onPartners != null)
                                      TextButton(
                                        onPressed: onPartners,
                                        child: const Text('Parceiros'),
                                      ),
                                    TextButton(
                                      onPressed: onContact,
                                      child: const Text('Contato'),
                                    ),
                                    OutlinedButton.icon(
                                      onPressed: onAdmin,
                                      icon: const Icon(
                                        Icons.lock_outline,
                                        size: 16,
                                      ),
                                      label: const Text('Área administrativa'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: narrow ? 36 : 64,
                            ),
                            child: LayoutBuilder(
                              builder: (context, hero) {
                                final editorial = hero.maxWidth >= 880;
                                final introduction = _Introduction(
                                  compact: !editorial,
                                  onCalculators: onCalculators,
                                  onContact: onContact,
                                );
                                if (!editorial) return introduction;
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(flex: 6, child: introduction),
                                    const SizedBox(width: 56),
                                    const Expanded(
                                      flex: 4,
                                      child: _LegalMark(),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const Divider(height: 1),
                          const SizedBox(height: 36),
                          const Text(
                            'AO SEU ALCANCE',
                            style: TextStyle(
                              color: SignCobColors.gold,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Como podemos ajudar?',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Informação e atendimento para o seu próximo passo.',
                            style: TextStyle(
                              color: SignCobColors.silver,
                              fontSize: 16,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 28),
                          LayoutBuilder(
                            builder: (context, cards) {
                              final width = cards.maxWidth < 700
                                  ? cards.maxWidth
                                  : (cards.maxWidth - 20) / 2;
                              return Wrap(
                                spacing: 20,
                                runSpacing: 20,
                                children: [
                                  SizedBox(
                                    width: width,
                                    child: _AccessCard(
                                      number: '01',
                                      icon: Icons.calculate_outlined,
                                      title: 'Calculadoras jurídicas',
                                      description:
                                          'Explore as ferramentas disponíveis e simule cenários antes de conversar com a nossa equipe.',
                                      action: 'Explorar ferramentas',
                                      onTap: onCalculators,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width,
                                    child: _AccessCard(
                                      number: '02',
                                      icon: Icons.chat_bubble_outline,
                                      title: 'Atendimento especializado',
                                      description:
                                          'Conte o que você precisa. Envie sua mensagem pelo formulário de atendimento do SignCob.',
                                      action: 'Enviar mensagem',
                                      onTap: onContact,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 17,
                                color: SignCobColors.silver,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'As simulações são informativas. Cada situação exige uma análise jurídica individual.',
                                  style: TextStyle(
                                    color: SignCobColors.silver,
                                    fontSize: 13,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 48),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: SignCobColors.graphite,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 32,
                      runSpacing: 12,
                      children: [
                        Text(
                          'SignCob · Advocacia',
                          style: TextStyle(
                            color: SignCobColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Informação clara. Atendimento com seriedade.',
                          style: TextStyle(color: SignCobColors.silver),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _Introduction extends StatelessWidget {
  const _Introduction({
    required this.compact,
    required this.onCalculators,
    required this.onContact,
  });
  final bool compact;
  final VoidCallback onCalculators;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Row(
        children: [
          Icon(Icons.circle, size: 6, color: SignCobColors.neon),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'Atendimento especializado',
              style: TextStyle(
                color: SignCobColors.silver,
                fontSize: 13,
                letterSpacing: .4,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 24),
      Semantics(
        header: true,
        child: Text.rich(
          TextSpan(
            text: 'Mais clareza para\n',
            children: const [
              TextSpan(
                text: 'suas próximas decisões.',
                style: TextStyle(color: SignCobColors.gold),
              ),
            ],
          ),
          style: TextStyle(
            color: SignCobColors.white,
            fontSize: compact ? 36 : 50,
            height: 1.14,
            letterSpacing: -1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      const SizedBox(height: 24),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: const Text(
          'Conheça as ferramentas do SignCob e converse com a nossa equipe sobre sua necessidade jurídica.',
          style: TextStyle(
            color: SignCobColors.silver,
            fontSize: 17,
            height: 1.7,
          ),
        ),
      ),
      const SizedBox(height: 28),
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: compact ? double.infinity : 290),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: onCalculators,
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: const Text(
                'Acessar calculadoras',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onContact,
              child: const Text('Fale conosco'),
            ),
          ],
        ),
      ),
    ],
  );
}

/// Decorative brand illustration, excluded from the accessibility reading order.
class _LegalMark extends StatelessWidget {
  const _LegalMark();

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: SignCobColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: SignCobColors.gold.withValues(alpha: .24)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: Divider(color: SignCobColors.gold)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Icon(
                  Icons.diamond_outlined,
                  size: 13,
                  color: SignCobColors.gold.withValues(alpha: .8),
                ),
              ),
              const Expanded(child: Divider(color: SignCobColors.gold)),
            ],
          ),
          const SizedBox(height: 38),
          const Icon(
            Icons.balance_outlined,
            size: 116,
            color: SignCobColors.gold,
          ),
          const SizedBox(height: 30),
          const Text(
            'DIREITO COM CLAREZA',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: SignCobColors.white,
              letterSpacing: 2,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          const SizedBox(width: 24, child: Divider(color: SignCobColors.neon)),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

class _AccessCard extends StatelessWidget {
  const _AccessCard({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
    required this.action,
    required this.onTap,
  });
  final String number;
  final IconData icon;
  final String title;
  final String description;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 28, color: SignCobColors.gold),
              ExcludeSemantics(
                child: Text(
                  number,
                  style: const TextStyle(color: SignCobColors.silver),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: SignCobColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(color: SignCobColors.silver, height: 1.7),
          ),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: Text(action),
          ),
        ],
      ),
    ),
  );
}
