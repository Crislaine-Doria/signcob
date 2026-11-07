# Jornadas Flutter com HTTP isolado — 03/11/2026

Handoff histórico do teste de interface. Comando atual, autoria da retomada
e resultados integrados em [Jornadas críticas com HTTP isolado](e2e-http-isolado.md).

Autoria real: subagente `jornadas_flutter`, consultando os perfis 23/51 e a
harness Flutter. Risco R2 por sessão, persistência e permissões. Integração,
execução do runner completo e build final pertencem à sessão principal;
revisão independente será registrada separadamente.

Arquivo: `packages/signcob_flutter/test/isolated_api_journeys_test.dart`.
Um caso percorre o `MyApp` real e seus callbacks de produção. A sequência
compartilha o cliente global `late final` da aplicação; cada etapa aguarda
um resultado observável e tem tempo limite, sem retries de escrita.

## Matriz de comportamento

| Dado / Quando / Então | Camada |
|---|---|
| Contato vazio, ao enviar, apresenta validação; contato sintético completo, ao enviar, é lido uma única vez pela caixa autenticada | UI → HTTP → Serverpod → PostgreSQL |
| Identidade descartável, ao entrar pelo formulário real, estabelece sessão em memória; ao sair, elimina sessão/dados internos e nova leitura protegida recebe HTTP401 | UI, gerenciador de sessão e HTTP real |
| Cliente vazio, ao salvar, valida; cadastro completo, ao editar/atribuir advogado/vincular titular, persiste os campos e UUIDs correspondentes | UI e releitura HTTP |
| Dívida e honorários separados, ao criar com valor brasileiro e registrar proposta/aceite, preservam centavos, estado e três eventos de histórico, sem aparecer no outro fluxo | UI e releitura HTTP |
| Artigo/parceiro ocultos, ao publicar/ativar, tornam-se públicos; ao ocultar novamente, deixam a consulta anônima | UI de gestão e HTTP público sem sessão |
| Processo sintético, ao importar/sincronizar, conserva vínculo, andamentos e data de consulta sem erro | UI e HTTP, transporte DataJud controlado no servidor |

Bloqueio, revogação, validação do servidor e isolamento completo por atribuição
ficam no arquivo HTTP independente `isolated_security_journeys_test.dart`.
Este teste não cria nem modifica identidades. A criação autorizada ocorre
somente na preparação descartável do runner.

## Ambiente e execução

O teste fica ignorado sem `--dart-define=SIGNCOB_ISOLATED_E2E=true` e exige
`SIGNCOB_E2E_MANIFEST`. O manifesto temporário deve identificar
`environment=signcob-isolated-e2e`, `database=signcob_e2e`, URL HTTP somente
`127.0.0.1` com porta explícita e identidades sintéticas `manager`, `lawyerA`
e `owner`. Não lê credenciais administrativas nem arquivos de desenvolvimento.

O runner do ambiente prepara banco/servidor, passa o manifesto e executa:

```powershell
flutter test --no-pub --dart-define=SIGNCOB_ISOLATED_E2E=true test/isolated_api_journeys_test.dart --reporter expanded
```

Executar esse comando somente a partir do runner descartável, que também
remove o banco e o manifesto após falhas. O teste fecha clientes, encerra a
sessão e drena timers de HTTP em `finally`, mesmo se um assert falhar.

## Verificações desta autoria

- `dart --suppress-analytics format test/isolated_api_journeys_test.dart`:
  concluído.
- `dart --suppress-analytics analyze test/isolated_api_journeys_test.dart`:
  **No issues found**, saída0.
- Execução HTTP desta autoria: **not_verified**, aguardando a preparação do
  runner pelo autor do ambiente. A sessão principal registrará a execução e
  eventuais correções da integração no relatório consolidado.

Nenhuma tela, paleta, contrato, migration ou dependência foi alterada nesta
autoria. Não declara aceite de navegador completo, fornecedor remoto,
aparelho físico, build nativo ou e-mail externo. Nenhuma cobrança, publicação
externa, consulta a tribunal real ou importação de dados do legado.
