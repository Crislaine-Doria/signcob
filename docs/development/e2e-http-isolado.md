# Jornadas críticas com HTTP isolado

O runner sobe um PostgreSQL 16 com pgvector em Docker, aplica as migrations
existentes com Serverpod 3.2.3 e inicia uma API dedicada. Os testes exercitam
widgets Flutter e o cliente gerado com HTTP real. Os serviços da jornada usam
portas dinâmicas. A porta do banco é publicada apenas em loopback e o middleware
da API só atende conexões de loopback.

## Reprodução no Windows

Com Docker Desktop em modo Linux, a imagem `pgvector/pgvector:pg16` disponível
e as dependências Flutter/Dart resolvidas, execute na raiz:

```powershell
$dart = 'C:/src/flutter/bin/cache/dart-sdk/bin/dart.exe'
& $dart tools/testing/run_isolated_e2e.dart
& $dart tools/testing/run_isolated_e2e.dart --inject-failure
```

A rodada normal deve sair com código 0. A prova de falha deve sair com código
1 e registrar `stage: injected-failure-after-committed-fixture` e
`cleanupPassed: true`. O runner usa o Dart do SDK Flutter para localizar a
ferramenta Flutter instalada. Ajuste o caminho se o SDK estiver em outro local.

As evidências ficam em `build/e2e/latest-result.json`,
`build/e2e/latest-flutter.log` e `build/e2e/latest-failure-probe.json`. A suíte
Flutter padrão ignora os arquivos opt-in. A validação que dependia de conta e
limpeza manual no banco de desenvolvimento está documentada no relatório
histórico. Use o runner descartável para reproduzir as jornadas atuais.

Verificações complementares a partir da raiz, reutilizando `$dart`:

```powershell
$flutter = 'C:/src/flutter/bin/cache/flutter_tools.snapshot'
Push-Location packages/signcob_flutter
& $dart $flutter --suppress-analytics analyze --no-pub
& $dart $flutter --suppress-analytics test --no-pub --reporter expanded
& $dart $flutter --suppress-analytics build web --no-pub --base-href /app/
Pop-Location
Push-Location packages/signcob_client
& $dart --suppress-analytics analyze
Pop-Location
Push-Location packages/signcob_server
docker compose up -d postgres_test
& $dart --suppress-analytics test --reporter expanded
& $dart --suppress-analytics analyze
docker compose stop postgres_test
Pop-Location
```

O comando `stop` restaura o estado quando `postgres_test` estava parado antes
da execução.

## Isolamento e limpeza

- Cada rodada cria um contêiner identificado por um rótulo próprio, com o banco
  `signcob_e2e` em memória. O runner confirma o tipo da montagem e o bootstrap
  confere o nome do banco antes de criar identidades. A entrada de teste usa
  configuração explícita, senhas aleatórias e callbacks de e-mail sem envio.
- A API publica atomicamente um manifesto temporário com identidades sintéticas
  e guarda os logs do servidor na mesma pasta descartável. O runner remove a
  pasta após encerrar os subprocessos. As credenciais ficam fora dos relatórios.
- O modo de falha grava um contato sintético antes de interromper o runner. O
  bloco de limpeza remove o contêiner e confirma a ausência dele por rótulo com
  uma consulta bem-sucedida ao Docker. Ele também confere a remoção da pasta.
- A limpeza é executada em sucesso, erro e interrupção tratável. Se o sistema
  encerrar o processo à força ou o Docker cair, confira o resultado da rodada
  e liste sobras com `docker ps -a --filter label=signcob.isolated-e2e=true`.
  Depois de conferir que a rodada terminou, use
  `docker rm --force --volumes <nome-exato-do-contêiner>` e remova somente a
  pasta `build/e2e/run-*` correspondente ao mesmo ID.

## Cenários

| Dado / Quando / Então | Camada |
|---|---|
| Dada entrada pública, ao validar e enviar o contato sintético e entrar com uma identidade descartável, a caixa interna mostra o contato persistido | Widgets → HTTP → SQL |
| Dada sessão autenticada, ao sair, o Flutter limpa a sessão, chamadas sem credencial recebem 401 e o token de renovação anterior é rejeitado | Widgets → HTTP → SQL |
| Dado gestor, ao criar, editar e atribuir cliente, transicionar dívida e honorários e gerenciar artigo e parceiro, a releitura confirma estado e visibilidade | Widgets → HTTP → SQL |
| Dados registros atribuídos e vinculados, ao ler ou tentar alterar com outra identidade, os dados ficam restritos e acompanham reatribuição e desvinculação | Cliente Flutter gerado → HTTP → SQL |
| Dado token sem escopos, bloqueado ou com permissões revogadas, 20 operações por condição são negadas e as escritas deixam o estado intacto | Cliente Flutter gerado → HTTP → SQL |
| Dados valores inválidos, ao enviar pela API, os registros e o histórico permanecem iguais | Cliente Flutter gerado → HTTP → SQL. O Serverpod 3.2.3 mapeia o `ArgumentError` atual a HTTP 500 |
| Dado transporte DataJud controlado, ao importar, sincronizar, provocar falhas e recuperar, a releitura confirma dados, vínculos e andamentos | Widgets e cliente Flutter gerado → HTTP → SQL, com transporte em memória |

A verificação de logout cobre revogação do token de renovação. O JWT de acesso
já emitido permanece sujeito à validade configurada e às verificações de
permissão atuais de cada operação. O modo HTTP usa testes de widgets em vez de
navegador. Dispositivos físicos, entrega de e-mail e conectividade com tribunais
ficam fora da suíte.

## Jornada no navegador

O modo `--browser` compila o Flutter web com base `/app/` e recursos
CanvasKit locais. O Serverpod descartável serve o build e o endereço dinâmico
da API. O Playwright aciona os controles da interface pelo Chrome ou Chromium.
Gestor e advogados entram com as identidades do bootstrap em três contextos
temporários, cada um com seu próprio armazenamento de sessão.
A navegação e as chamadas HTTP ficam restritas às
origens do build e da API da rodada. A API e a rota do build rejeitam conexões
de origem não local.

| Dado / Quando / Então | Evidência |
|---|---|
| Dada a página pública do build, ao entrar com a identidade descartável, a área interna aparece | `web-build-loaded`, `signed-in` |
| Dada uma lista vazia, ao cadastrar e editar um cliente sintético, a lista mostra os dados gravados. Ao trocar de seção e voltar, a lista confirma o nome atualizado | `client-created`, `client-updated`, `client-reloaded` |
| Dado o cliente criado, quando o gestor atribui pela interface ao primeiro advogado, a consulta do primeiro traz o registro e a do segundo traz uma lista vazia | `client-assigned-lawyer-a`, `lawyer-a-client-visible`, `lawyer-b-client-hidden` |
| Dada a atribuição inicial, quando o gestor reatribui ao segundo e ambos voltam a Clientes nas mesmas sessões, novas consultas invertem a visibilidade | `client-reassigned-lawyer-b`, `lawyer-a-client-hidden`, `lawyer-b-client-visible` |
| Dada a sessão do gestor, ao sair e tentar voltar à área administrativa após recarregar, o login reaparece e a consulta anônima de clientes recebe HTTP 401 | `signed-out`, `internal-access-denied` |
| Dada a reatribuição confirmada pelos dois advogados, ao injetar a falha, o runner retorna 1 e verifica a remoção do contêiner e da pasta privada | `injected-failure-after-browser-reassignment` |

O cenário confere o mesmo identificador de cliente nas duas atribuições e nas
leituras positivas. Cada leitura exige uma resposta HTTP bem-sucedida e a
renderização correspondente. Nas leituras negativas, a API devolve uma lista
vazia e o app exibe “Nenhum cliente encontrado.”.

Prepare as dependências do Flutter e do servidor, Node 20 ou superior,
Docker local com `pgvector/pgvector:pg16` e o navegador. Na raiz do
repositório, use o mesmo `$dart` da reprodução acima:

```powershell
Push-Location tools/testing/browser
npm.cmd ci --ignore-scripts --no-audit --no-fund
npx.cmd --no-install playwright install chromium
Pop-Location

# Opcional para usar o Chrome já instalado no Windows
# $env:SIGNCOB_E2E_CHROME = 'C:/Program Files/Google/Chrome/Application/chrome.exe'
& $dart tools/testing/run_isolated_e2e.dart --browser
$normal = $LASTEXITCODE
& $dart tools/testing/run_isolated_e2e.dart --browser --inject-failure
$probe = $LASTEXITCODE
node tools/testing/browser/verify-results.mjs $normal $probe
```

O verificador exige saída 0 com 13 marcos na rodada normal e saída 1 com
11 marcos na prova de falha, que termina antes do logout do gestor. Ele
confere duas rodadas distintas, consulta novamente o Docker pelo rótulo
de cada rodada e verifica que as pastas privadas deixaram de existir.
Execute as duas rodadas em sequência, pois os arquivos `latest-*` são
substituídos.

O fluxo **SignCob browser E2E** em GitHub Actions usa acionamento manual.
O preparo baixa dependências, Chromium e a imagem Docker. A jornada usa
serviços locais e dados sintéticos. Os únicos artefatos enviados são
`latest-browser-result.json` e `latest-browser-failure-probe.json`.
O manifesto, perfil e logs brutos ficam na pasta descartável. Os resumos
incluem os marcos fixos da jornada e da limpeza. As evidências do modo HTTP
continuam separadas.

A jornada automatizada cobre Chrome/Chromium em desktop, visibilidade por
atribuição e perda de acesso do gestor após logout. Os demais cenários de
autorização continuam nas camadas indicadas acima.

## Autoria e correções da retomada

- A sessão principal integrou o runner e o servidor descartável a partir do
  rascunho existente. Corrigiu a preparação das identidades, a invocação do
  Dart com configuração explícita de pacotes, a limpeza verificável e o
  acompanhamento de HTTP dentro do relógio simulado dos testes de widgets.
- `flutter_e2e` reforçou os seletores e as verificações da jornada de
  interface, incluindo a mudança de classe/andamento e a revogação do token
  de renovação. A jornada reproduziu o aviso “Cliente salvo.” sobrepondo
  o botão “Nova negociação” ao trocar de seção. O subagente isolou o defeito,
  limitou o aviso à área de Clientes e adicionou a regressão em
  `internal_journeys_layout_test.dart`. A matriz focada passou 5/5.
- `seguranca_e2e` reforçou as recusas HTTP, a comparação do estado persistido
  antes e depois e os cenários de falha e recuperação do DataJud controlado.
- `revisao_e2e` revisou separadamente isolamento, sigilo, limpeza e asserções.
  O parecer estático ficou condicionado à execução integrada e à prova de
  limpeza. A revisão recomendou registrar as duas rodadas separadamente e
  usar um único comando de reprodução. A revisão aceitou a correção da
  sobreposição e conferiu os resultados finais. Foi uma revisão somente leitura.

## Evidências de 04/11/2026

| Verificação | Resultado |
|---|---|
| Rodada normal isolada | **6 aprovados** em 40 s de testes. Uma jornada pelas telas e cinco cenários HTTP de segurança e DataJud. Saída 0, contêiner e pasta privada removidos |
| Falha após gravação confirmada | **Aprovada**. Saída 1 intencional na etapa `injected-failure-after-committed-fixture`, com `cleanupPassed=true` e `privateRuntimeRemoved=true` |
| Suíte Flutter padrão | **73 aprovados**, sete opt-in ignorados. Inclui a regressão do aviso de salvamento |
| Suíte do servidor | **27 aprovados** em `signcob_test`. Oito tabelas verificadas com zero registros após rollback, incluindo identidades. Contêiner de testes parado ao final |
| Análise Flutter, cliente gerado e código de automação | Sem diagnósticos |
| Análise completa do servidor | Zero erros, 16 avisos de API experimental e oito informações de estilo preexistentes |
| Build web | Saída 0, artefato em `packages/signcob_flutter/build/web` e verificação preliminar Wasm aprovada |

As rodadas foram executadas pela sessão principal. A primeira inicialização
do Docker travou ao abrir um socket antigo. A pasta contendo apenas os dois
sockets inativos foi preservada como `run.signcob-stale-*` e o Docker recriou
sua pasta temporária. A primeira falha de preparação do servidor também
confirmou limpeza automática. O banco de desenvolvimento ficou fora das
execuções.
Uma consulta final encontrou zero contêineres rotulados da jornada e zero
diretórios privados `run-*`.
