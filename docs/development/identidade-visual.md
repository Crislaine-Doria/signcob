# Identidade visual do SignCob

## Escopo autorizado — 03/11/2026

Aplicar ao aplicativo Flutter a identidade de escritório de advocacia solicitada:
confiança, seriedade e modernidade. A marca textual permanece SignCob Advocacia.
Todas as rotas herdam o tema global; páginas públicas, formulários, calculadoras,
questionário e área interna mantêm as funções existentes.

| Uso | Cor |
|---|---|
| Fundo principal e cabeçalho | `#0B1630` |
| Cartões e superfícies | `#14294A` |
| Texto em botão dourado e rodapé | `#111318` |
| Botões principais e detalhes | `#C6A15B` |
| Foco, seleção e indicadores discretos | `#19C8FF` |
| Texto principal em fundo escuro | `#F5F6F8` |
| Texto auxiliar e divisórias | `#AAB3C2` |

## Plano e responsabilidades reais

| Tarefa | Processo responsável | Arquivos | Dependência |
|---|---|---|---|
| Tema, marca e página inicial | subagente identidade_visual | theme/signcob_theme.dart, widgets/brand_header.dart, screens/public_home_screen.dart | requisitos atuais |
| Adaptação das demais telas | subagente telas_responsivas | widgets/admin_page_scaffold.dart, screens exceto public_home_screen.dart | paleta existente; tema compartilhado estável para integração |
| Revisão técnica e aceite | subagente revisao_visual | leitura da entrega integrada, matriz de layout e evidências | autoria estável |
| Integração, execução das verificações e registro | sessão principal | documentação, metadados web e artefato web local | autores e revisão |

Caminhos de código relativos a `packages/signcob_flutter/lib`. Mudança visual
R2 por afetar várias rotas; máximo de dois ciclos de correção por handoff.
O clone de ferramentas não integra o repositório como gitlink. Sem workers
externos, roteamento pago, publicação externa ou mudanças no banco/API.

## Decisões técnicas

- Manter Flutter/Material 3, navegação e estado existentes. Não há nova regra
  de negócio ou decisão estrutural que justifique adotar novas bibliotecas.
- Reutilizar tokens e componentes, sem depender de fontes ou imagens remotas.
- Home e área interna com conteúdo limitado em telas grandes; formulários
  com largura de leitura própria; questionário limitado a 420 px.
- Verificar layout em 320/390/768/1440 px, rolagem, aumento de texto e ações.
- Preservar validação, callbacks, contratos Serverpod, autenticação e permissões.

## Cenários de aceite

| Critério | Dado / Quando / Então | Verificação |
|---|---|---|
| Identidade global | Dada qualquer rota, ao abrir, então cores e controles usam o tema SignCob | análise de código + inspeção visual |
| Entrada pública | Dada a home, ao acionar calculadoras/contato/área interna/blog/parceiros, então a ação existente é preservada | testes de widgets e navegador |
| Responsividade | Dada uma tela de celular, tablet ou desktop, ao abrir e rolar, então conteúdo e ações ficam acessíveis sem overflow | testes de layout e inspeção visual |
| Questionário | Dada uma etapa respondida, ao avançar e voltar, então respostas e validação continuam funcionando e o cartão fica centralizado | testes existentes + inspeção visual |
| Regressões | Dado o conjunto de telas, ao executar análise e suíte Flutter, então não surgem erros | analyze, test e build web |

## Evidências

- Inspeção inicial: paleta e tema global já existiam e foram preservados como base.
- Git exigiu exceção de diretório seguro; somente `git -c safe.directory=...`
  por chamada, sem modificar configuração global. Alterações existentes preservadas.
- Docker estava ativo, mas o acesso pela sessão restrita foi negado. Consulta
  local autorizada confirmou PostgreSQL de desenvolvimento/teste em execução.
- Servidor local iniciado sem migrations; web em `http://127.0.0.1:8082/app/`.
- `flutter.bat --version` não respondeu e foi encerrado. Flutter por Dart direto
  detectou falta de acesso ao cache do SDK; verificações seguintes usarão execução
  local autorizada, sem mudança nas permissões do SDK.
- Autoria entregue por `identidade_visual` e `telas_responsivas`. `LegalFormScaffold`
  reúne contato e três calculadoras; catálogo usa uma/duas colunas; questionário
  usa marca compartilhada e progresso neon; ações/paginação internas adaptam-se.
- Teste inicial da home detectou `const ConstrainedBox` incompatível. Autor
  corrigiu no primeiro ciclo; dois testes da home passaram após a correção.
- Análise Flutter integrada: `No issues found`.
- Suíte integrada e matriz de layout: 47 testes passaram (35 existentes e 12
  combinações de quatro larguras com escalas de texto 1, 1,5 e 2).
- Matriz verificou home, primeira etapa do questionário, catálogo, três
  calculadoras, contato, privacidade e painel interno com seções substitutas.
  Fluxo completo do questionário permanece coberto pela suíte existente.
- Revisor ampliou e manteve a matriz em
  `packages/signcob_flutter/test/responsive_layout_test.dart`: 15 telas/estados,
  incluindo contatos e usuários com dados fictícios, estados vazios e acesso
  negado. As 12 combinações ampliadas passaram. Logs locais ignorados em
  `packages/signcob_flutter/build/qa/`.
- Build web concluído em 56,1 s e copiado para `packages/signcob_server/web/app`.
  Servidor reiniciado; HTTP 200 e hash SHA256 do JavaScript servido iguais ao
  artefato compilado. Sem alterações em contratos, migrations ou banco.
- Navegador manteve versões antigas em cache nas origens da porta 8082, mesmo
  após atualização da página. Para conferir o artefato novo, prévia estática
  adicional apenas em loopback: `http://127.0.0.1:8765/app/`, servindo a mesma
  pasta `web/app`. A API existente continua na porta 8080. Nenhuma publicação.
- Conferência visual real pelo orquestrador: home desktop e 390 px; questionário
  em 390 e 768 px; navegação home → catálogo → questionário, avanço à etapa 2
  e retorno à etapa 1 preservando seleção. Sem dados reais, envio ou persistência.
- Capturas: `identidade-desktop.jpg`, `identidade-mobile.jpg`,
  `identidade-questionario-mobile.jpg`, `identidade-questionario-tablet.jpg`.
- Revisão independente `revisao_visual`: **accepted** para integração local,
  sem achados acionáveis. Leu código e logs; não executou navegador, análise
  ou Flutter. Esses checks foram executados pela sessão principal.

## Limitações e reprodução

- Build e inspeção realizados na versão web. Dispositivo físico, distribuição
  nativa, login real e operações remotas completas não fazem parte desta verificação
  visual. As permissões e integrações existentes foram preservadas.
- Os testes de widgets não substituem inspeção visual de todos os dados reais e
  diálogos. Cobertura ampliada inclui estados representativos sem acesso à API.
- No diretório `packages/signcob_flutter`, usar o Flutter do ambiente:
  `flutter analyze --no-pub`, `flutter test --no-pub` e
  `flutter build web --no-pub --base-href /app/`.
- Neste ambiente, executados via
  `C:/src/flutter/bin/cache/dart-sdk/bin/dart.exe C:/src/flutter/bin/cache/flutter_tools.snapshot`
  seguido do comando Flutter, com acesso ao cache do SDK autorizado.
- Formatação dos autores concluiu; algumas chamadas iniciais reportaram erro
  posterior na telemetria fora do workspace. A chamada do autor de identidade
  com `--suppress-analytics` terminou com saída 0.

## Revisão breve de processo

Realizada por `revisao_visual` após consultar o perfil 54. As reservas de arquivos
separaram autorias sem conflito observado. Houve um erro de compilação, corrigido
no primeiro ciclo. Lição pontual: conferir compilação antes de declarar autoria
estável. Sem necessidade de análise aprofundada ou mudança de processo compartilhado.
