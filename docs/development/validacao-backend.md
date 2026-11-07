# Validação integrada do backend — 03/11/2026

Execução real pelo subagente `validacao_backend`, com perfis 22 (integração),
16 (identidade/acesso) e 03 (backend). Integração e revisão independente ficam
com a sessão principal e seu revisor. Risco R2 por persistência e permissões.

## Ambiente e limites

- Serverpod 3.2.3, Dart 3.13.3; PostgreSQL/pgvector 16 em Docker já ativo.
- Testes usam somente `localhost:9090/signcob_test`, conforme `config/test.yaml`.
- Harness Serverpod com rollback após cada caso; autenticação injetada por
  `AuthenticationOverride`, sem login por senha/JWT e sem criar contas de e-mail.
- Identidades e capacidades sintéticas são fixtures descartadas na transação.
  Nenhuma conta, concessão ou registro real foi alterado no ambiente de desenvolvimento.
- DataJud não foi chamado. Processo inserido como fixture no SQL apenas para
  validar vínculo/consulta e negação de sincronização. Nenhuma cobrança, acesso
  ao legado, publicação externa, mudança de contrato ou migration.

## Critérios e evidências

| Dado / Quando / Então | Estado | Evidência |
|---|---|---|
| Dado um contato fictício, quando enviado, então aparece normalizado na caixa autorizada e erro de validação não insere outro registro | passed | `local_journeys_test.dart`, contato → PostgreSQL → consulta administrativa |
| Dado gestor sintético, quando cria/edita cliente e vincula identidade, então o titular lê somente o processo vinculado e perde acesso ao remover vínculo | passed | jornada integrada; fixture SQL substitui fonte DataJud |
| Dado cliente acessível, quando negocia dívida e honorários, então fluxos separados persistem `draft → proposed → accepted` com histórico | passed | jornada integrada; suíte de negociações também valida transições inválidas e ausência de eventos extras |
| Dado conteúdo fictício, quando publica/despublica artigo ou ativa/desativa parceiro, então consulta pública respeita o estado atual | passed | jornada integrada e testes existentes de conteúdo |
| Dada identidade bloqueada, revogada ou sem escopos no token, quando acessa operações internas, então leituras e escritas são negadas sem persistência | passed | três testes com 19 operações cada: contatos, usuários, clientes, processos, negociações, artigos e parceiros |
| Dado advogado/cliente externo, quando consulta/altera registro sem atribuição/vínculo, então acesso é negado ou lista é vazia | passed | suíte existente de clientes, processos e negociações |
| Dada a suíte encerrada, quando consultadas as contagens, então fixtures foram revertidas | passed | SQL no `postgres_test`: contatos, clientes, processos, negociações, eventos, artigos e parceiros todos 0 |
| Login real por senha/JWT, navegador Flutter e fonte remota DataJud | not_verified por este subagente | Fronteiras fora destes testes; não confundir `AuthenticationOverride` com autenticação completa |

Arquivo novo: `packages/signcob_server/test/integration/local_journeys_test.dart`
(cinco testes). Nenhum defeito funcional do backend foi reproduzido nesta inspeção;
as regras existentes foram preservadas.

## Comandos executados

Dentro de `packages/signcob_server`, com o executável
`C:/src/flutter/bin/cache/dart-sdk/bin/dart.exe`:

```powershell
dart --suppress-analytics format test/integration/local_journeys_test.dart
dart --suppress-analytics test test/integration/local_journeys_test.dart
dart --suppress-analytics test
dart --suppress-analytics analyze
docker compose ps
```

- Baseline anterior à escrita: 22 testes passaram.
- Cinco novos testes isolados passaram; suíte integrada final: **27 passaram**.
- Análise do servidor terminou com código 1: **0 erros**, 16 avisos de
  `UuidValue` experimental e oito informações de chaves em `if` no módulo de
  negociações. São ocorrências em arquivos preexistentes; nenhum diagnóstico no
  arquivo de testes novo. Não registrar essa análise como limpa.
- Primeira tentativa com acesso restrito falhou ao consultar pub.dev e escrever
  telemetria fora do workspace. Execução local autorizada com
  `--suppress-analytics` concluiu normalmente; nenhuma dependência foi alterada.
- Docker confirmou serviços PostgreSQL de desenvolvimento e testes ativos.
- Contagens finais obtidas por `docker compose exec -T postgres_test psql` no
  banco de testes; resultados não contêm dados pessoais nem segredos.

## Pendências

- Automatizar autenticação HTTP com token real em ambiente de teste isolado e
  associá-la ao percurso Flutter, sem confundir o harness com E2E de navegador.
- Validar importação/sincronização DataJud por transporte controlado e, em etapa
  autorizada separada, disponibilidade real dos tribunais. Esta validação não
  depende de chamadas externas.
- Paginação de usuários continua em memória, conforme limitação já registrada.
- Avaliar atualização suportada do uso experimental de `UuidValue`; os avisos
  existentes continuam explícitos e não foram suprimidos.
