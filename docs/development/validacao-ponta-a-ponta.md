# Validação de jornadas locais — 03/11/2026

Registro histórico da validação anterior. Para reproduzir as jornadas HTTP
atuais, use o [runner isolado](e2e-http-isolado.md).

## Escopo e autoria real

- `validacao_flutter`: inspeção/correções Flutter, matriz de jornadas, estados e
  responsividade. Relatório próprio em `validacao-flutter.md`.
- `validacao_backend`: integração PostgreSQL, autorização e jornada de domínio.
  Relatório próprio em `validacao-backend.md`.
- Sessão principal: coordenação, teste Flutter com HTTP real, navegador, build
  web final, limpeza dos dados fictícios e registro integrado.
- `revisao_qa`: revisão independente e repetição de checks selecionados;
  parecer em `revisao-validacao.md`.

Mantidas Flutter/Material e navegação/estado existentes, Serverpod3.2.3 e SQL.
Sem dependência nova, alteração de contratos/migrations ou mudança de paleta.
Sem workers externos, publicação externa, cobranças ou importação do legado.

## Camadas de evidência

| Critério comportamental | Camada e limite |
|---|---|
| Dada entrada pública, ao navegar, então calculadoras, questionário, contato, blog e parceiros ficam acessíveis | Widgets e navegador local; cálculos locais sem envio |
| Dados inválidos, ao calcular/enviar/salvar, então há validação e não ocorre sucesso falso | Widgets; endpoints com PostgreSQL de teste |
| Dado carregamento ou falha, então telas indicam estado e permitem recuperação pertinente | Widgets com futuros controlados; não simula indisponibilidade real de tribunal |
| Dado contato fictício enviado pela UI, então é lido pela caixa interna após login | Teste opt-in `live_api_journey_test.dart`, HTTP real localhost8080 e signcob_dev |
| Dada conta existente, ao entrar, selecionar áreas e sair, então sessão e dados internos acompanham autenticação | Mesmo teste opt-in; armazenamento de sessão em memória, sem credencial em logs |
| Dada identidade bloqueada/revogada/sem escopos, então operações internas são negadas | Harness Serverpod:57 operações em três matrizes; auth injetada, SQL real |
| Dado cliente/processo/negociação/conteúdo fictícios, então vínculo, separação debt/fees, histórico e visibilidade são preservados | SQL signcob_test com rollback; DataJud substituído por fixture SQL |
| Dado celular/tablet/desktop com texto ampliado, então ações/diálogos continuam acessíveis | Matrizes de widgets320/390/768/1440px, escalas1/1,5/2 e inspeção de navegador |

## Reprodução do teste HTTP real

Exige a API de desenvolvimento já ativa e a conta local **já existente**.
O teste não cria identidade nem concede capacidades. Lê privadamente o arquivo
ignorado `packages/signcob_server/config/admin-initial-access.txt` e mantém JWT
somente em memória. Não executa cadastro, recuperação de senha ou chamadas de
fornecedores. O destino é fixo em loopback; não recebe host externo por parâmetro.
Não executar esse teste em paralelo ou sem planejar a limpeza abaixo.

Em `packages/signcob_flutter`:

```powershell
flutter test --no-pub --dart-define=SIGNCOB_LIVE_QA=true test/live_api_journey_test.dart --reporter expanded
```

Sem a definição explícita, esse teste é ignorado na suíte normal. Ele grava
somente um contato fictício de QA no banco local de desenvolvimento. A limpeza
é limitada aos três valores exatos abaixo; conferir a contagem após cada execução
(inclusive falhas) antes de repetir, para não acumular duplicatas. Nunca usar
limpeza por tabela, truncamento ou exclusão de dados reais.

Em `packages/signcob_server`:

```powershell
docker compose exec -T postgres psql -U postgres -d signcob_dev -c "DELETE FROM contact_message WHERE name = 'SignCob QA E2E 20261103' AND email = 'qa-e2e@example.invalid' AND message = 'Mensagem fictícia de verificação local.' RETURNING id;"
docker compose exec -T postgres psql -U postgres -d signcob_dev -c "SELECT count(*) AS qa_contacts_remaining FROM contact_message WHERE name = 'SignCob QA E2E 20261103' AND email = 'qa-e2e@example.invalid';"
```

## Resultados e pendências

Integração executada pela sessão principal; logs locais ignorados em
`packages/signcob_flutter/build/qa/validation-{analyze,tests,build}.log`.

- Banco de testes:27 testes passaram; rollback confirmado em todas as tabelas
  verificadas, inclusive identidades. Nenhum defeito funcional backend reproduzido.
- Flutter final: **73 testes passaram** em14s com `--dart-define=SIGNCOB_LIVE_QA=true`:
  47 existentes,25novos do autor e1jornada HTTP real da sessão principal.
  Acesso anônimo à caixa confirmou401; login pela UI na conta existente, oito
  áreas e logout aprovados. Inclusão de status401 revalidada na suíte final.
- Flutter e cliente gerado: análise **No issues found**, saída0. Revisão
  independente `revisao_qa`: accepted. Revisor repetiu integração backend,
  matriz interna, login estreito e sete etapas de apresentação da autenticação.
- Limpeza após cada uma das quatro execuções que enviaram contato: DELETE1 por
  execução, usando três campos exatos. Última conferência SQL: QA restante0.
  Nenhuma conta nova ou permissão real alterada; login/logout usam sessão normal
  da conta previamente existente. Credenciais e tokens não foram exibidos.
- Análise servidor:0 erros,16 avisos experimentais e8 informações preexistentes;
  não é análise limpa. Cliente gerado e Flutter serão conferidos na integração.
- A primeira tentativa real comprovou envio do contato e encontrou formulário
  de autenticação abrindo cadastro por padrão e overflow na dependência. Contato
  fictício removido por filtro exato (DELETE1). Correção encaminhada ao autor.
- A primeira compilação do teste revelou getter incorreto de HttpOverrides,
  corrigido pela sessão principal; outra chamada pegou edição intermediária do
  autor. Verificações finais devem aguardar arquivos estáveis.
- Outra tentativa completou os asserts reais mas falhou na invariável de timers
  do HttpClient no teste. Fechamento e drenagem antes do fim do teste corrigiram
  a instrumentação; execução isolada e suíte integrada posteriores passaram.
- Navegador: na origem8765 com identidade aprovada, financiamento10000/1000/1%/12
  resultou parcela799,64 e total10595,67; revisional10000/2%/1%/12 resultou
  juros2400/1200 e diferença1200; estadia2h×10t×2 resultou40. Valores fictícios.
- A origem8082 ainda serviu interface antiga em cache no navegador. Conferir
  artefato final em origem local limpa e comparar hash do JavaScript servido.
- Build web final concluído em47,7s, saída0, com dry-run Wasm aprovado.
  Artefato copiado para `packages/signcob_server/web/app`, sem publicação externa
  e sem reinício necessário do backend (produção servidor não mudou).
  Prévia estática somente loopback em `http://127.0.0.1:8766/app/` evita o cache
  antigo. HTTP200 e SHA256 do JS servido/compilado/copiado idênticos:
  `72CB5289A9E5DF1892B36BE6F64F2AE773A87A6CB0C2F7457D49D40BEBDE545A`.
  Helper local ignorado em `build/qa/preview-local.cjs`, processo13324.
  Primeiro helper restrito não ficou disponível; relançamento local autorizado
  funcionou. A conexão restrita negou socket; conferência HTTP autorizada passou.
  Nenhuma rejeição automática de aprovação ocorreu.
- Build final conferido no navegador: login inicial correto em celular391×845,
  desktop1440×1000 e validação de campos vazios. Capturas adicionais:
  `qa-login-mobile.jpg` e `qa-login-desktop.jpg`, sem credenciais.
  Viewport temporário restaurado ao concluir; prévia deixada na home.
- Navegador também conferiu blog/parceiros vazios, aviso de privacidade e
  questionário com avanço até etapa4. Fluxo de seis etapas validado nos testes
  existentes; não afirmar preenchimento manual completo em navegador.
- Capturas de navegação pública: `qa-revisional-desktop.jpg`,
  `qa-questionario-mobile.jpg` (viewport medido391×845) e
  `qa-questionario-tablet.jpg` (viewport medido768×1000).
  Pequena variação de1px do navegador registrada; matriz de widgets usa as
  larguras exatas320/390/768/1440 e escalas1/1,5/2.
- Próximo incremento recomendado: transformar as jornadas críticas de escrita
  e autenticação em E2E com HTTP num ambiente de teste inteiramente isolado,
  com preparação/limpeza automática e transporte DataJud controlado. A suíte
  opt-in atual exige conta local já existente e limpeza SQL documentada.
- DataJud remoto, disponibilidade dos tribunais, dispositivo físico/build
  nativo e envio de e-mail externo não são verificados aqui. Asaas/chat/agenda
  não estão implementados; não apresentar esses módulos como jornadas aprovadas.
