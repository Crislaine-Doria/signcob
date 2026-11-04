import 'package:flutter/material.dart';
import '../widgets/brand_header.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Privacidade do questionário')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BrandHeader(compact: true),
              SizedBox(height: 24),
              Text(
                'Como esta demonstração usa seus dados',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'O questionário de acidente de trabalho é uma demonstração. '
                'As respostas e os contatos digitados são mantidos apenas na memória '
                'da tela. Este formulário não os envia ao servidor, ao WhatsApp '
                'ou a terceiros, nem os salva no banco de dados ou no navegador.',
              ),
              SizedBox(height: 16),
              Text(
                'Ao sair da tela ou recarregar a página, as respostas não são '
                'recuperadas. O botão final mostra somente um resumo local; não '
                'agenda atendimento nem solicita contato ao escritório.',
              ),
              SizedBox(height: 16),
              Text(
                'Nenhum valor de indenização é calculado. A avaliação do caso '
                'depende de análise profissional e de regras que ainda serão '
                'definidas pelo escritório.',
              ),
              SizedBox(height: 16),
              Text(
                'Este aviso descreve somente o questionário demonstrativo. '
                'Os demais módulos do SignCob têm fluxos próprios. Antes de '
                'habilitar o envio deste formulário, o escritório deverá definir '
                'finalidade, responsáveis, retenção e canal de atendimento sobre os dados.',
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
