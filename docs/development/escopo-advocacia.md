# Escopo de migração para advocacia

Inventário estático do legado em 03/11/2026, por inventario_advocacia.
Nenhum teste, chamada de pagamento, importação ou consulta a banco realizada.
As fontes abaixo são relativas a `C:/Users/Administrador/projetos/projetos_antigos/sign_cob`.

O responsável confirmou clientes, processos, negociações, pagamentos Asaas,
blog e parceiros. Acidente de trabalho continua indefinido.
Esse objetivo não significa que o legado já contenha gestão jurídica completa.

## O que existe no legado

| Módulo | Fontes | Comportamento observado |
|---|---|---|
| Processos | `lib/models/enum/enum_andamento_processo.dart`, `lib/models/estadia_motorista.dart`, `lib/administrativo/calculadora/card_list/andamento_processo.dart` | Enum de acompanhamento comercial: não visualizado, visualizado, interessado, desinteressado, acordo fechado, sucesso, perda e acordo recusado. Estadia armazena esse andamento. Não foi localizado modelo de processo judicial com número, tribunal, partes, responsável ou prazos. |
| Negociações | `lib/models/negociacoes.dart`, `lib/core/providers/renegociacao_store.dart`, `lib/pages/negocia_aqui/negocia_aqui_page.dart`, `renegociacao_page.dart`, `contratos_page.dart`, `negociacao_page.dart` | Renegociacao contém contrato, credor, CPF, nascimento, nome, valores original/atual/dívida, títulos e identificador Asaas. Título contém descrição, vencimento e valor. Consulta pública filtra Firestore por CPF e data de nascimento; não tratar esses dois dados como autenticação suficiente na nova aplicação. |
| Asaas | `api_asaas/lib/asaas.dart`, `api_asaas/lib/entities/*`, `lib/core/asaas/asaas_service.dart`, `backend-asaas/backend-asaas/routes/{clientes,pagamentos,pix}.js`, `lib/pages/negocia_aqui/widgets/card_pagamento.dart` | Há clientes, cobranças PIX/boleto/cartão, linha digitável e QR PIX, com múltiplas implementações. Card de pagamento coleta modalidade e parcelas. A tela alternativa `payment_screen.dart` inclui espera simulada; não comprova pagamento real. |
| Blog | `lib/models/post.dart`, `lib/pages/blog_page.dart`, `lib/administrativo/blog_post_create.dart`, `lib/widgets/widgets/blog_card.dart` | Modelo Blog com título, descrição, categoria, data como texto, imagem e URL. Página pública lê `posts` no Firestore. Há tela administrativa de posts; não foi comprovado fluxo editorial de rascunho/publicação. |
| Parceiros | `lib/models/list_parceiros.dart`, `lib/pages/parceiros_page.dart`, `lib/widgets/card_parceiros.dart` | Lista estática em Dart: nome, descrição, imagem de asset, texto do botão, site e categorias. Há links de indicação e pelo menos um destino cujo domínio não coincide com o nome exibido; validar destinos antes de reutilizar. |

Os fluxos ativos são referenciados em `lib/core/routes/app_routes.dart`.
As páginas `debts_screen.dart`, `debt_details_screen.dart` e `payment_screen.dart`
coexistem com o fluxo de renegociação; não assumir que todas sejam produtivas.

## Sequência proposta e aceite verificável

1. **Clientes:** cadastro/edição e consulta paginada, capacidades de leitura e escrita,
   validação no servidor, sem apagar históricos. Incremento já em implementação
   por outros agentes; este inventário não atesta sua conclusão.
2. **Processos:** definir modelo mínimo com vínculo ao cliente, dados descritivos e
   responsável; separar acompanhamento comercial de processo judicial. Aceite:
   acesso autorizado, vínculos consistentes e histórico verificável das alterações.
   Campos, estados, prazos e visibilidade do cliente exigem definição antes da autoria.
3. **Negociações:** migrar contrato/títulos/valores e associação ao cliente/processo;
   definir regras de oferta, aceite e parcelamento antes de automatizar. Aceite:
   transições autorizadas e valores coerentes, sem exposição por CPF/nascimento.
4. **Asaas:** consolidar um adaptador exclusivamente no Serverpod; configurar sandbox
   separada, vínculo cliente/cobrança, idempotência e confirmação de eventos. Aceite:
   testes de contrato sem cobranças reais, repetição sem duplicidade e atualização
   somente após confirmação validada. Credenciais não pertencem ao Flutter.
5. **Blog:** persistência SQL, leitura pública e gestão protegida; definir se será
   artigo interno ou catálogo de links. Aceite: conteúdo não publicado não aparece
   publicamente; links/imagens tratados e falhas recuperáveis.
6. **Parceiros:** catálogo público e manutenção protegida, caso o responsável queira
   edição dinâmica. Aceite: URLs validadas e dados aprovados, sem copiar indicações
   comerciais antigas automaticamente.
7. **Integração:** testes de jornadas por perfil, restauração e importação planejada
   dos dados antigos. Só declarar módulo migrado após autoria, revisão e evidências.

## Decisões ainda necessárias

### Perfis informados durante o inventário

- Sócio: capacidades ainda não definidas.
- Advogado: somente processos/clientes atribuídos, confirmado pelo responsável.
- Financeiro: somente Asaas.
- Atendimento: somente chat e agenda; ambos são módulos adicionais confirmados.
  Não conceder consulta de contatos por analogia ao nome do perfil.
- Cliente: somente seus próprios processos. O servidor deve impor propriedade/vínculo
  em cada consulta e alteração; filtrar apenas na interface não atende esse limite.

Chat e agenda precisam de requisitos próprios (participantes, visibilidade,
mensagens/anexos, eventos, responsáveis e notificações); nenhum fluxo equivalente
foi validado neste inventário. Esses perfis são decisões comunicadas pelo
orquestrador após a inspeção; atribuições reais ainda dependem da implementação.

- Capacidades do sócio; organização global ou restrita por equipe/escritório.
- O que significa processo nesta primeira versão: judicial, administrativo ou
  atendimento; campos obrigatórios, estados, responsáveis, prazos e anexos.
- Negociações de dívidas do legado versus honorários/serviços jurídicos novos;
  quem aprova ofertas e acordos e se haverá assinatura de documentos.
- Asaas: finalidade das cobranças, conta responsável, sandbox, modalidades,
  parcelamento, cancelamento/estorno e responsável por conciliação. Nenhuma cobrança
  ou configuração de credenciais está autorizada implicitamente por este documento.
- Blog: autoria, revisão/publicação, artigo completo ou link externo e conteúdo inicial.
- Parceiros: lista aprovada e destinos atuais, critérios de exibição e manutenção.
- Migração de dados existentes: quais coleções/arquivos, volume, duplicidades e
  correspondência entre identidades antigas e novas; não importar por suposição.

Acidente de trabalho permanece somente como funcionalidade planejada até seu escopo
ser informado. Automação de tribunais, cálculo de prazos legais e enquadramentos
jurídicos não foram encontrados como regras implementadas e não foram presumidos.
