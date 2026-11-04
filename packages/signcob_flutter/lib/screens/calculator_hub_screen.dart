import 'package:flutter/material.dart';

import '../theme/signcob_theme.dart';
import '../widgets/brand_header.dart';
import 'calculators/financing_calculator_screen.dart';
import 'calculators/revision_calculator_screen.dart';
import 'calculators/stay_calculator_screen.dart';

class CalculatorHubScreen extends StatelessWidget {
  const CalculatorHubScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Calculadoras')),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(
          MediaQuery.sizeOf(context).width < 600 ? 16 : 32,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: BrandHeader(compact: true),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Atendimento especializado',
                  style: TextStyle(color: SignCobColors.silver),
                ),
                const SizedBox(height: 32),
                Text(
                  'Ferramentas para começar',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Acesse as simulações disponíveis sem criar uma conta.',
                  style: TextStyle(color: SignCobColors.silver, height: 1.6),
                ),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth < 720
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 20) / 2;
                    return Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        for (final item in [
                          (
                            icon: Icons.calculate_outlined,
                            title: 'Financiamento',
                            description:
                                'Simule parcelas com valor, entrada, taxa e prazo.',
                            action: 'Abrir calculadora',
                            screen: const FinancingCalculatorScreen(),
                          ),
                          (
                            icon: Icons.balance_outlined,
                            title: 'Revisão de empréstimos',
                            description:
                                'Compare juros com taxas informadas por você.',
                            action: 'Comparar juros',
                            screen: const RevisionCalculatorScreen(),
                          ),
                          (
                            icon: Icons.local_shipping_outlined,
                            title: 'Estadia de motorista',
                            description:
                                'Simule duração, carga e tarifa informada.',
                            action: 'Simular estadia',
                            screen: const StayCalculatorScreen(),
                          ),
                          (
                            icon: Icons.work_outline,
                            title: 'Acidente de trabalho',
                            description:
                                'Questionário em seis etapas para organizar seu caso.',
                            action: 'Iniciar questionário',
                            screen: null,
                          ),
                        ])
                          SizedBox(
                            width: width,
                            child: Card(
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Icon(
                                        item.icon,
                                        size: 30,
                                        color: SignCobColors.gold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      item.title,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      item.description,
                                      style: const TextStyle(
                                        color: SignCobColors.silver,
                                        height: 1.6,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    FilledButton(
                                      onPressed: () {
                                        if (item.screen == null) {
                                          Navigator.pushNamed(
                                            context,
                                            '/acidente-trabalho',
                                          );
                                        } else {
                                          Navigator.of(context).push(
                                            MaterialPageRoute<void>(
                                              builder: (_) => item.screen!,
                                            ),
                                          );
                                        }
                                      },
                                      child: Text(
                                        item.action,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
