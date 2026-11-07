# Calculadoras públicas

Rotas do legado: calculadoraRevisional, financiamento e estadia.

Migrada a fórmula isolada de pages/calculadoras/widgets/calculadora_financiamento_form.dart: saldo = valor - entrada; parcela = saldo * taxa * (1+taxa)^prazo / ((1+taxa)^prazo - 1); total = parcela * prazo + entrada.

A simulação nova é local, sem coletar nome/e-mail/telefone e sem gravar no Firebase. Esta etapa não migra captação de leads das calculadoras. A taxa deve ser positiva; taxa zero no legado produz divisão por zero, portanto não é suportada nesta etapa. Entrada deve ser inferior ao valor. Unidade de taxa e prazo explicitada como período pois o legado não especifica unidade no campo.

Revisional e estadia migradas como simulações matemáticas locais. Revisional
compara juros simples nas duas taxas informadas, conforme versão ativa do legado.
Estadia usa minutos completos/60, carga e tarifa informada sem valor legal fixo.
Detalhes e diferenças em revisional.md e estadia.md; não há classificação
automática de abusividade ou de valores juridicamente devidos.

Acidente de trabalho incluído somente como funcionalidade planejada, escopo a definir conforme esclarecimento do usuário; sem cálculo ou coleta de dados.
