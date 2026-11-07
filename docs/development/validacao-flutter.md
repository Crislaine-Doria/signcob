# Validação funcional Flutter — 03/11/2026

Autoria e execução reais: subagente `validacao_flutter`. Integração, jornada HTTP
e build final: sessão principal. Revisão independente: `revisao_qa`, com parecer
consolidado no relatório de validação ponta a ponta. Perfis 39 e 51 e a harness
Flutter foram consultados; não representam processos adicionais.

## Correções comprovadas

| Falha reproduzida | Correção | Evidência |
|---|---|---|
| Área administrativa abria cadastro em vez de login; linhas fixas do formulário do SDK transbordavam | `EmailAccessForm` começa em Entrar e apresenta os mesmos endpoints de e-mail em coluna responsiva, em português | Reprodução inicial da sessão principal e QA independente; cinco testes novos e jornada HTTP do integrador |
| Barra Clientes transbordava 33 px horizontalmente em 320 px/texto 2 | Ação Novo cliente usa ícone com tooltip em largura abaixo de 600 px | Nova matriz passou nas quatro larguras |
| Confirmação de transição de negociação transbordava 120/16 px em 320/390 px/texto 2 | Conteúdo do diálogo permite rolagem | Nova matriz abre o diálogo sem overflow |
| Negociações dentro do painel transbordavam 180/76 px verticalmente em 320/390 px/texto 2 | Aviso, cartões e paginação participam de uma única lista rolável | Nova matriz abre a seção real dentro do painel |
| Botão Nova negociação ficava fora da tela, com borda esquerda em -16 px em celulares/texto 2 | Botão compacto com tooltip no celular; botão extenso mantido em telas maiores | Teste verifica limites geométricos e abre formulário |

A identidade aprovada e os tokens de cor foram preservados. Não houve mudança
de contratos, migrations, dependências ou permissões. Alterações preexistentes
foram mantidas.

## Autenticação

A nova apresentação mantém login, início e verificação de cadastro, definição de
senha, solicitação e verificação de recuperação e redefinição. Usa diretamente
os endpoints gerados já existentes e `client.auth.updateSignedInUser`, sem
modificar a política do servidor. Links de cadastro e recuperação continuam
disponíveis. Solicitar novo código retorna à etapa de solicitação preservando
o e-mail. O guard de sessão, a chave por UUID e o descarte no logout continuam
em `SignInScreen`.

Envios pendentes desabilitam ações e campos; respostas só atualizam a tela
enquanto ela existe. Falhas têm mensagens genéricas; a senha fica oculta por
padrão e não é registrada em logs. A configuração atual do aplicativo é por
e-mail; provedores sociais não foram adicionados neste incremento.

Não foi criado usuário nem enviado e-mail nesta autoria. As seis chamadas das
etapas de cadastro/recuperação são interceptadas por `_FakeClient` no teste:
retornam UUID/token sintéticos ou erro sintético; não acessam servidor. Login
real com a identidade local existente foi verificado separadamente pela sessão
principal, conforme seu relatório.

## Cenários e resultados

| Dado / Quando / Então | Camada e resultado |
|---|---|
| Dada autenticação vazia, ao tentar entrar, os campos mostram validação e nenhuma chamada é feita | Widget, `passed` |
| Dado login pendente, ao aguardar, o botão fica desabilitado; falha permite corrigir dados e repetir | Widget com future controlada, `passed` |
| Dadas sete etapas de e-mail, ao navegar e validar, conteúdo e ações permanecem acessíveis com texto 2 em 320/390/768/1440 px | Widget com endpoints fictícios, `passed`, quatro casos |
| Dados clientes e negociações fictícios, ao abrir criação/atribuição/editores/transição/histórico e a seção dentro do painel, não ocorre overflow nas quatro larguras com texto 2 | Widget, `passed`, quatro casos |
| Dadas oito áreas, ao receber falha transitória ou negação de acesso, aparece mensagem/retry sem dados; nova tentativa volta a carregar e termina no vazio | Widget com futures controladas, `passed`, 16 casos |

As oito áreas são contatos, clientes, processos, usuários, dívidas, honorários,
blog e parceiros. Os testes existentes continuam responsáveis por simulações,
questionário, sucesso das operações, regras e navegação pública; a sessão
principal executa a suíte integrada ao final.

Arquivos de testes novos:

- `packages/signcob_flutter/test/email_access_form_test.dart`
- `packages/signcob_flutter/test/internal_journeys_layout_test.dart`
- `packages/signcob_flutter/test/internal_loading_states_test.dart`

## Execução

Diretório: `packages/signcob_flutter`. Ferramenta usada:
`C:/src/flutter/bin/cache/dart-sdk/bin/dart.exe` com
`C:/src/flutter/bin/cache/flutter_tools.snapshot` e argumentos Flutter abaixo.

- `test --no-pub test/email_access_form_test.dart`: cinco testes passaram.
- `test --no-pub test/internal_journeys_layout_test.dart`: quatro testes passaram.
- `test --no-pub test/internal_loading_states_test.dart`: 16 testes passaram.
- Execução conjunta dos três arquivos: **25 passaram**. Log local ignorado em
  `packages/signcob_flutter/build/qa/validacao-flutter-focada.log`.
- `analyze --no-pub`: produção limpa antes dos dois últimos arquivos de testes.
  A chamada posterior encontrou somente duas orientações de chaves em testes;
  ambas corrigidas. Análise integrada final fica com a sessão principal.
- Formatação Dart executada nos arquivos alterados.

O primeiro comando Flutter restrito falhou por acesso ao lockfile do cache do
SDK; execuções seguintes ocorreram com autorização de execução local. Não
foram alteradas permissões do SDK. Os testes inicialmente reproduziram os
overflows documentados; também houve ajuste do próprio teste para aguardar o
frame após rolagem antes de tocar em Proposta. Esse ajuste do teste não é
contado como defeito do produto.

## Limitações

Esta autoria valida apresentação e estados com dados fictícios e callbacks
controlados; não declara persistência real para esses testes. A jornada real
Flutter/HTTP/PostgreSQL, suíte completa, análise final, build web e navegador
ficam registrados pelo integrador. Cadastro/recuperação completos com entrega
de e-mail, dispositivos físicos e builds nativos permanecem `not_verified`.
Nenhuma consulta DataJud externa, cobrança, importação do legado ou publicação
foi executada por este subagente.
