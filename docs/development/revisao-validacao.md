# Revisão independente da validação local — 03/11/2026

Revisor real: subagente `revisao_qa`, separado dos autores
`validacao_flutter`, `validacao_backend` e da sessão principal. Perfis consultados:
09 (revisão técnica), 10 (QA) e 54 (revisão breve de processo), além da harness
Flutter e da identidade aprovada. Risco R2 por autenticação, persistência e
acessibilidade das jornadas internas.

## Parecer

**accepted** para integrar as correções e os testes locais revisados. Nenhum
achado funcional pendente nas alterações verificadas. O aceite tem os limites
abaixo; não representa aprovação de distribuição externa ou de fornecedores.

Escopo de código lido: Clientes e Negociações, `SignInScreen`, novo
`EmailAccessForm`, matrizes e testes de autenticação, novo teste backend
`local_journeys_test.dart` e teste opt-in `live_api_journey_test.dart`.
Não houve alteração manual de contratos ou migrations neste incremento.

## Verificações executadas pelo revisor

| Verificação | Resultado |
|---|---|
| `dart --suppress-analytics test test/integration/local_journeys_test.dart --reporter expanded` no servidor | **passed**, cinco testes com PostgreSQL de testes e rollback |
| `flutter test --no-pub test/internal_journeys_layout_test.dart build/qa/review_auth_layout_test.dart --reporter expanded` | **passed**, quatro larguras das jornadas internas com texto 2 e login independente a 320 px/texto 2 |
| `flutter test --no-pub test/email_access_form_test.dart --reporter expanded` | **passed**, cinco testes: sete etapas sintéticas nas quatro larguras e carregamento/falha de login |
| Teste temporário sem rede: limpar senha fictícia ao mudar fluxo após alternar visibilidade | **passed**, sem credenciais reais |

Flutter foi executado por `dart.exe flutter_tools.snapshot --suppress-analytics`
do SDK instalado, com acesso local ao cache. Testes temporários do revisor estão
somente em `packages/signcob_flutter/build/qa/`, ignorado pelo Git; não alteram
os testes ou o código de autoria revisados.

Primeiro ciclo de QA reproduziu o botão de criar negociação fora da largura em
320/390 px com texto 2. Também reproduziu a tela inicial do componente de
autenticação anterior abrindo cadastro e causando overflow horizontal/vertical
em 320 px/texto 2. Os autores corrigiram os problemas; os checks do segundo
ciclo passaram. A nova apresentação conserva os endpoints de login, cadastro,
verificação e recuperação e o gerenciador de sessão existente.

## Evidências recebidas e limites

- O autor backend registrou a suíte completa **27 passed** e contagens finais
  zero nas tabelas sintéticas, inclusive identidades de teste. O revisor repetiu
  os cinco testes novos; autenticação nesse harness é injetada e DataJud é
  substituído por fixture SQL, explicitamente.
- A sessão principal executou a jornada Flutter com HTTP real. Log lido pelo
  revisor: `packages/signcob_flutter/build/qa/live-api-journey.log`, **1 passed**.
  O percurso envia contato fictício, entra com a conta local existente, lê o
  contato persistido, abre as oito seções internas e sai. Sessão em memória;
  sem criar identidade ou alterar permissões reais. Limpeza final de QA com
  contagem zero informada pela sessão principal, por filtro exato dos dados
  fictícios. O revisor não repetiu esse teste para evitar nova gravação local.
- O teste opt-in verifica leituras das áreas com a conta existente. CRUD,
  transições, bloqueio/revogação e ownership são cobertos em camadas separadas
  (widgets sintéticos e PostgreSQL de testes), não por todos os percursos de
  escrita em navegador autenticado.
- Cadastro e recuperação foram verificados por apresentação/contratos
  sintéticos; nenhuma conta foi criada e nenhuma senha real foi alterada.
- Análise integral, suíte Flutter completa, build e inspeção do artefato web
  final ficam executados/registrados pela sessão principal. Este revisor não
  operou navegador nem refez o build.
- DataJud remoto, e-mail externo, aparelhos físicos, builds nativos e Asaas
  não são aprovados por este parecer. Asaas/chat/agenda continuam fora das
  funcionalidades implementadas avaliadas.

## Revisão breve do processo

Evidências: handoffs dos autores e da integração, código e logs dos checks
acima. Autoria e revisão ocorreram em processos independentes, com áreas de
escrita separadas. Houve compilação/QA sobre arquivos ainda sendo alterados;
o aviso explícito de estabilidade permitiu repetir apenas os checks afetados.

Lição pontual: sinalizar arquivos estáveis antes de iniciar compilação integrada
e repetir o teste HTTP somente após limpar seus dados identificados. Não há
amostra suficiente para propor mudança permanente no framework. Sem alteração
de worker, roteamento, catálogo, permissões ou processo compartilhado.
