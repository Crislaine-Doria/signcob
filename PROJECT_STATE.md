# Estado do SignCob

Atualizado em 05/11/2026.

## Decisões do responsável

- Usar multi-agent-software-house como equipe para desenvolver SignCob.
- Manter o novo aplicativo neste diretório e aproveitar o legado como referência.
- Stack solicitada: SQL, Serverpod e Docker; PostgreSQL já presente na base.
- Primeira etapa de preparação autorizada.
- Escopo ampliado confirmado: clientes, processos, negociações, pagamentos Asaas,
  blog e parceiros, além dos módulos já implementados. Perfis internos ainda
  serão informados; não presumir os três perfis sugeridos anteriormente.
- Esclarecimento posterior: múltiplas contas com permissões diferentes; entrada
  principal pública, com calculadoras e navegação para outras telas antes do acesso interno.
  Não há uma única conta administrativa definida.

## Fatos observados

- Monorepo com packages/signcob_flutter, signcob_client e signcob_server.
- Pacotes Serverpod 3.2.3 exigem Dart ^3.8.0.
- pubspec.yaml raiz alinhado para Dart ^3.8.0; Melos 3.4.0 preservado como dev_dependency.
- Docker Compose existente fornece PostgreSQL/pgvector e Redis para desenvolvimento e testes.
- Legado contém Firebase, Asaas, negociações, pagamentos, calculadoras e painel administrativo.
- Framework clonado em tools/software-house na revisão 24124bbf2832b83996eb1fe716dac02e5d508585.
- Alterações preexistentes: .idea/caches/deviceStreaming.xml,
  packages/signcob_flutter/pubspec.lock e .idea/vcs.xml. Preservadas.

## Execução e limites

Orquestração nesta sessão e diagnóstico delegado a subagente de arquitetura.
Worker externo e fila SQLite não foram habilitados. Migração de dados e
funcionalidades ainda não executada.

## Validação do ambiente

- Dart 3.13.3 e Docker Server 29.2.1 confirmados.
- Dependências da raiz resolvidas; lockfile atualizado pela ferramenta.
- PostgreSQL de desenvolvimento e testes iniciados via Compose.
- Banco antigo signcob preservado: migration 20260205192549009 não existe no código atual.
- Banco isolado signcob_dev criado; configuração de desenvolvimento atualizada.
- Migration 20260205193534254 aplicada; Serverpod iniciou em localhost:8082.
- Análise do cliente sem problemas; servidor tem dois avisos de UuidValue experimental.
- Revisão independente confirmou manifests coerentes e solicitou instrução reproduzível
  de criação do banco, registrada em docs/development/executar-localmente.md.
- Testes Flutter ainda não executados.
- Teste de integração existente do servidor passou (1 teste); página local respondeu HTTP 200.

## Próximo incremento

Primeira fatia implementada: formulário de contato Flutter → Serverpod → PostgreSQL.
Contrato e critérios em docs/development/primeiro-incremento.md.

## Entrega de contato — 03/11/2026

- Autoria independente: contato_backend e contato_flutter; revisão: revisao_contato.
- Modelo ContactMessage e endpoint contact.submit sem listagem pública.
- Validação no app e servidor; trim, limites 120/254/5000 e timestamp UTC no servidor.
- Migration 20261103130710998 gerada pelo Serverpod e aplicada em signcob_dev.
- Três testes Flutter passaram; suíte servidor passou com três testes no total.
- Build Flutter web concluído e copiado para web/app (artefato local ignorado).
- Serverpod anterior reiniciado com contratos e assets atualizados.
- Revisão independente aceitou integração local; revisão de processo registrou
  necessidade de verificar o lockfile final após resolução automática do Flutter.
- Sem importação de dados antigos. Fluxo visual completo no navegador ainda não verificado.

Próximo incremento sugerido: definir acesso administrativo autenticado aos contatos,
ou priorizar com o responsável a jornada jurídica a migrar em seguida.

## Consulta administrativa — 03/11/2026

- Implementada por admin_backend e admin_flutter; revisada por revisao_admin.
- Endpoint contactAdmin.list exige login e contacts.read, paginação de 25,
  ordenação por data/ID descendentes. Sem alteração no envio público.
- UI inclui login, lista, vazio, falha/retry, paginação e saída; sessão trocada
  descarta tela anterior e logout limpa dados.
- Removido registro JWT duplicado da base.
- Servidor: cinco testes passaram; Flutter: seis testes passaram e análise limpa.
- Script local bin/grant_contact_admin.dart preserva permissões de identidade
  existente. Conexão testada com UUID inexistente, sem concessão de acesso.
- Conta administrativa ainda não indicada; nenhuma permissão real concedida.
- Teste manual de login completo e leitura por conta real permanece pendente.
- Revisão de processo: contrato compartilhado e autoria separada funcionaram;
  aguardar arquivos estáveis antes de compilar evita falha em código intermediário.
- Instruções: docs/development/contatos-administrativos.md.

## Entrada pública — 03/11/2026

- Responsável esclareceu múltiplos e-mails com permissões distintas e entrada
  pública com calculadoras antes do acesso interno; nenhuma conta privilegiada criada.
- Autoria pagina_publica e catalogo_calculadoras; revisão independente revisao_publica.
- Página inicial com navegação para calculadoras, contato e área administrativa.
- Financiamento migrado como simulação local usando fórmula do legado, sem coleta
  pessoal; revisão e estadia sinalizadas em migração.
- Acidente de trabalho solicitado com escopo indefinido: card planejado, sem cálculo.
- Dois testes de home e dois de cálculo passaram pelos autores.
- Revisão aceitou integração local; interação completa da calculadora no navegador
  permanece não verificada. Regras jurídicas de revisão/estadia não foram presumidas.
- Detalhes: docs/development/entrada-publica.md e calculadoras.md.
- Suíte Flutter integrada: 10 testes passaram. Build web concluído e publicado
  apenas no servidor local em web/app; página respondeu HTTP 200.

## Calculadoras de revisão e estadia — 03/11/2026

- Autores migrar_revisional e migrar_estadia; revisor revisao_calculadoras.
- Revisional compara juros simples agregados conforme versão ativa do legado,
  com duas taxas informadas e sem conclusão jurídica automática.
- Estadia usa duração em minutos completos/60 × toneladas × tarifa informada;
  datas estritas e saída posterior à chegada; sem tarifa fixa presumida.
- Ambas executam localmente sem coletar dados pessoais. Acidente de trabalho
  permanece com escopo a definir.
- Suíte integrada com 14 testes passou. Análises focadas dos autores sem problemas.
- Revisão aceitou integração; ajustes aplicados: texto correto no catálogo e
  limpeza do resultado de estadia após edição dos campos.
- Detalhes: docs/development/etapa-calculadoras.md, revisional.md e estadia.md.
- Interação manual completa no navegador ainda não verificada.
- Build web final concluído após revisão, copiado para web/app; HTTP 200 confirmado.

## Gestão de acessos e consolidação — 03/11/2026

- Autorização do responsável: continuar o desenvolvimento e encaminhar dúvidas.
  Perguntas pendentes sobre módulos da primeira versão e perfis de negócio.
- usuarios_backend implementou listagem e alteração de capacidades contacts.read
  e users.manage, preservando scopes externos; usuarios_flutter implementou painel.
- Verificação de permissão atual no banco torna revogação efetiva mesmo com token
  anterior; AccessDeniedException reconhecida pela UI; conta bloqueada negada.
- Auto remoção de users.manage impedida com UUID normalizado.
- Script grant_access_manager.dart concede somente a uma identidade existente;
  nenhuma concessão real realizada. Instruções em gestao-acessos.md.
- Revisão independente auditoria_qualidade aceitou integração após correções.
- Sete testes servidor passaram segundo autoria; suíte Flutter integrada passou
  com 19 testes; análise Flutter limpa, backend sem erros e quatro avisos experimentais.
- Build web final concluído, servidor reiniciado, HTTP 200 e gestão anônima 401 confirmados.
- Corrigidos caminhos de três workflows para packages/signcob_server e limpeza
  de resultado financiamento após edição. Workflows remotos não executados.
- Limitações para finalizar produto: escopo de módulos/perfis e acidente de trabalho
  indefinidos; conta real/primeiro operador não escolhido; e-mail ainda usa console
  local; segredos literais de desenvolvimento no Compose precisam externalização
  antes de compartilhamento/publicação; listagem de usuários usa paginação em memória.
- Nenhuma publicação externa, importação de dados antigos ou cobrança executada.

## Clientes e escopo jurídico — 03/11/2026

- Escopo confirmado clientes, processos, negociações, Asaas, blog e parceiros;
  chat e agenda acrescentados pela definição de atendimento.
- Perfis registrados em docs/development/perfis.md: advogado somente atribuídos,
  financeiro só Asaas, atendimento só chat/agenda, cliente só próprios processos;
  sócio indefinido. Não concedidas permissões reais.
- Clientes implementados por clientes_backend/clientes_flutter e revisados por
  inventario_advocacia: cadastro, edição, lista paginada e atribuição explícita.
- Advogado não lista/edita cliente de outro advogado. Atribuição exige users.manage,
  clients.read e clients.write no token e banco; alvo existente não bloqueado.
- Migrations geradas 20261103134443321 e 20261103134559249.
- Suíte Flutter integrada: 22 testes passaram; suíte servidor de autoria: 10 testes
  passaram; correção de atribuição validada com 3 testes focados.
- Build web concluído. Reinicialização com migrations e cópia do artefato local executadas.
- Requisito novo: integração automática de processos desde o início. Pergunta
  pendente sobre tribunais/provedor. DataJud é candidato para metadados públicos,
  não pressupor cobertura de documentos, sigilo ou atualização imediata.
- Asaas: pergunta pendente sobre sandbox/preparação sem cobrança.
- Produto completo ainda não concluído; inventário e lacunas em escopo-advocacia.md.
- Tribunais confirmados: TJPR, TRT9 e TRF4; responsável autorizou começar pelos
  dados públicos do DataJud. Conector automático e UI em implementação.

## Integração DataJud — preparação

- Escopo público aprovado explicitamente pelo responsável; nenhuma credencial
  de tribunal ou documento restrito é usada.
- Autoria datajud_backend e datajud_flutter; revisão revisao_datajud.
- Consulta remota por número CNJ e tribunal permitido; validação de número e
  tribunal da resposta, host fixo, limites e timeout.
- Processo vinculado ao cadastro cliente; listagem por atribuição do advogado ou
  identidade do próprio cliente; vínculo explícito bindOwner por gestor autorizado.
- UI informa fonte CNJ/DataJud, última consulta e erros; não inventa andamentos.
- Configuração DATAJUD_API_KEY necessária no servidor. Consulta real não validada.
- Documentação operacional: docs/development/processos-datajud.md.

## Retomada após interrupção — 03/11/2026

- git pull --ff-only executado no clone tools/software-house: já atualizado,
  revisão 24124bbf2832b83996eb1fe716dac02e5d508585 preservada.
- Revisão independente fechar_datajud aceitou integração local; schema remoto
  validado antes dos casts. Consulta externa real e importação remota completa
  continuam não verificadas sem configuração DATAJUD_API_KEY.
- Suíte servidor reexecutada: 13 testes passaram. Última suíte Flutter integrada:
  25 testes passaram; build web concluído na etapa anterior.
- Migration 20261103135341689 já aplicada. Serverpod estava parado e foi reiniciado.
- Artefato web/app/index.html presente. Não realizadas concessões de acesso,
  chamadas de cobrança ou importações de dados reais.
- A interrupção anterior incluiu falha da revisão automática por limite de uso;
  a checagem de HTTP que não havia sido executada foi retomada nesta sessão.

## ENV, blog e parceiros — 03/11/2026

- env_servidor implementou carregamento .env literal sem dependências, prioridade
  de variáveis do processo e testes. .env local ignorado; .env.example sem valores.
- Chave PÚBLICA do DataJud obtida da documentação CNJ e gravada apenas no .env
  local. ASAAS_API_KEY permanece vazio e ASAAS_ENV=sandbox.
- Verificação real sem processos (size0/match_none): TJPR HTTP200, TRT9 HTTP429,
  TRF4 falha de conexão no timeout. Sem importação real ou persistência de processos.
- conteudo_backend/conteudo_flutter implementaram artigos e parceiros SQL com
  leitura pública apenas publicados/ativos e gestão content.write atual no banco.
- Revisionista env_servidor detectou reutilização de estado entre seções; corrigido
  por chaves distintas com teste de alternância. Conteúdo exibido como texto.
- Migration 20261103180219063 aplicada e servidor reiniciado carregando .env.
- Suíte servidor integrada 19 passed; Flutter integrada 29 passed; análise Flutter
  limpa segundo autoria. Nenhum conteúdo do legado importado/publicado.
- Perguntas pendentes: negociações dívidas vs honorários; participantes chat/agenda;
  Asaas sandbox/preparação sem cobranças; sócio e acidente de trabalho indefinidos.
- Produto completo ainda não finalizado. Negociações, Asaas, chat e agenda ainda
  precisam de implementação e das decisões de negócio pendentes.
- Responsável confirmou negociações de dívidas e de honorários/serviços em fluxos
  separados. Módulo interno em implementação; sem cobrança automática.
- Sócio confirmado com acesso a tudo. Responsável autorizou criar apenas
  signcobadministrador@signcob.com.br como administradora principal e sócia.

## Negociações e conta principal — 03/11/2026

- negociacoes_backend/negociacoes_flutter implementaram debt e fees separados,
  valores centavos, estados e eventos atômicos com bloqueio de linha.
- revisao_negociacoes aceitou implementação; helper partnerScopes e comando
  grant_partner incluem todas capacidades disponíveis, preservando externas.
- Migration 20261103180746293 aplicada; build web copiado e servidor reiniciado.
- Suíte servidor 22 passou; suíte Flutter 33 passou; análise Flutter limpa.
- Autorização explícita usuário: criar APENAS signcobadministrador@signcob.com.br
  administradora principal/sócia. Bootstrap revisado e executado com sucesso,
  sem criar outras contas. Login real confirmado e usuários/clientes/processos HTTP200.
- Senha forte inicial salva em config/admin-initial-access.txt ignorado pelo Git;
  não registrada no estado nem nos resultados. Não houve envio de e-mail.
- Perfil contém todas nove capacidades atuais, inclusive negociações e gestão.
  Novos módulos exigem reaplicar perfil e renovar sessão conforme socios.md.
- Produto completo ainda pendente: Asaas, chat e agenda; perguntas respectivas
  continuam abertas. Aceite interno de negociação não confirma assinatura/pagamento.

## Questionário acidente de trabalho — 03/11/2026

- Escopo de seis etapas fornecido pelo responsável; implementação acidente_questionario
  revisada por revisao_questionario, integração e privacidade pelo orquestrador.
- Página /acidente-trabalho com azul-marinho/dourado, cartão max420, progressão,
  voltar preservando respostas, rolagem ao topo e validação contatos.
- Etapa5 exige faixa salarial e tempo; etapa6 resumo e avaliação preliminar sem
  valor inventado. Demonstração local: nenhum dado enviado ou persistido.
- Aviso de privacidade específico em /privacidade; detalhes em acidente-trabalho.md.
- Dois testes focados passaram (inclui320px e fluxo completo); análise focada limpa.
- Build web concluído e copiado; conferência visual desktop e390px realizada,
  capturas acidente-desktop.png e acidente-mobile.png em docs/development.
- Browser localhost apresentou versão antiga em cache;127.0.0.1:8082/app/#/acidente-trabalho
  exibiu versão atual e foi deixado como entrega. Nenhum dado real usado na conferência.

## Identidade visual em todo o Flutter — 03/11/2026

- Pedido do responsável: aplicar azul-marinho, azul institucional, grafite,
  dourado, acentos neon, branco suave e prata a todo o projeto, com adaptação
  mobile/tablet/desktop. Paleta existente reaproveitada e tema global ampliado.
- Autoria real: `identidade_visual` (tema, marca e home) e `telas_responsivas`
  (formulários, calculadoras, questionário e ajustes internos). Integração,
  metadados web, análise, testes, build e navegador pela sessão principal.
- Home com composição institucional e rodapé grafite. Componente compartilhado
  LegalFormScaffold centraliza contato/três calculadoras; catálogo responsivo;
  questionário mantém max420, estados e validação; ações/paginação internas adaptadas.
- Revisão independente `revisao_visual` accepted, sem achados acionáveis.
  Revisor também escreveu a matriz mantida em test/responsive_layout_test.dart
  e registrou revisão breve do processo (perfil54).
- Análise Flutter limpa. 35 testes existentes passaram; 12 testes de layout
  ampliados passaram, combinando 320/390/768/1440px com texto1/1,5/2 e15telas/estados.
- Falha de compilação inicial const ConstrainedBox corrigida pelo autor no
  primeiro ciclo. Flutter.bat não respondeu; usada ferramenta Flutter via Dart
  direto, com acesso local autorizado ao cache do SDK. Formatação teve aviso
  de telemetria externo em chamadas iniciais, sem impedir formatar arquivos.
- Build web concluído e copiado para web/app; servidor reiniciado sem migrations.
  HTTP200 e hash do JavaScript servido conferidos. Porta8082 reteve interface
  antiga em cache no navegador; prévia adicional do mesmo artefato somente em
  http://127.0.0.1:8765/app/ confirmou visual novo e foi deixada como entrega.
- Conferência real: home desktop/mobile390, questionário390/768 e navegação
  home→catálogo→questionário→etapa2→voltar preservando seleção. Capturas e detalhes
  em docs/development/identidade-visual.md. Sem dados reais ou publicação externa.
- Não verificados neste incremento visual: dispositivo físico, build nativo,
  autenticação real e jornadas remotas completas. Backend e permissões preservados.

## Validação de ponta a ponta e correções — 03/11/2026

- Autoria real `validacao_flutter`: cinco falhas corrigidas. Entrada interna
  abre login em português e responsivo (antes cadastro vendor com overflow);
  barra de Clientes cabe no celular; negociação tem diálogo rolável, lista
  rolável dentro do painel e botão de criação compacto acessível no celular.
  Mesmos endpoints de login/cadastro/recuperação, gerenciador de sessão,
  permissões e identidade azul-marinho/azul/grafite/dourado/neon preservados.
- Autoria real `validacao_backend`: cinco novos testes integrados; nenhum
  defeito funcional backend reproduzido. Suíte servidor27passed com PostgreSQL
  de testes real, rollback e contagens finais0 inclusive identidades sintéticas.
  Jornadas contato→caixa, cliente/vínculo→processo, debt/fees/histórico e
  conteúdo público/gestão. Bloqueado/revogado/sem scope:19operações por cenário.
  Auth injetada no harness e processo como fixture SQL; não é DataJud remoto.
- Sessão principal implementou teste opt-in `live_api_journey_test.dart`:
  Flutter MyApp→HTTP real→signcob_dev. Contato fictício enviado e lido após login
  real na conta previamente existente; oito áreas internas carregadas; logout
  retorna à entrada e descarta dados; acesso anônimo à caixa confirmou401.
  Sessão somente em memória, nenhum segredo exibido. Cadastro/recuperação só
  simulados, sem contas novas, alteração de senha ou concessões reais.
- Suíte Flutter integrada final73passed (47anteriores+25novos do autor+1HTTP),
  incluindo320/390/768/1440px, texto1/1,5/2, diálogos e estados de
  carregamento/sucesso/vazio/erro/validação/negado. Flutter e cliente gerado com
  análise limpa. Servidor:0erros,16avisos experimentais+8infos preexistentes;
  não registrar análise servidor como limpa.
- Revisão independente `revisao_qa`: accepted, sem achados pendentes; repetiu
  testes SQL, layout e autenticação responsiva. Revisão breve de processo
  registrada: aguardar arquivos estáveis antes de compilar a integração.
- Sessão principal conferiu no navegador navegação pública, três calculadoras
  com valores fictícios, blog/parceiros vazios, privacidade, etapas iniciais do
  questionário e login final em celular/desktop. Questionário completo coberto
  por testes; não afirmar preenchimento manual completo no navegador.
- Build web final concluído47,7s; copiado apenas para web/app local. Prévia
  limpa `http://127.0.0.1:8766/app/` (helper loopback processo13324), HTTP200 e
  hash do JS servido igual ao compilado. Origem8082 apresentou cache antigo.
  Capturas qa-*.jpg e relatório em docs/development/validacao-ponta-a-ponta.md;
  relatórios de autoria/revisão separados, logs locais ignorados em build/qa.
- Falhas de instrumentação (HttpOverrides e timers de HTTP) corrigidas antes
  do teste aprovado. Contatos fictícios de cada execução removidos por filtro
  exato; conferência final QA restante0. Nenhum contrato, migration, dependência,
  dado legado ou regra backend alterado. Nenhuma cobrança/publicação externa.
- Limites: CRUD interno e autorização têm cobertura em camadas, não todos por
  navegador autenticado; DataJud real, entrega de e-mail, aparelhos físicos e
  builds nativos seguem pendentes. Asaas/chat/agenda ainda não implementados;
  paginação de usuários em memória e avisos do backend continuam conhecidos.
- Próximo incremento recomendado: E2E HTTP isolado de escritas críticas com
  autenticação e preparação/limpeza automáticas, incluindo transporte DataJud
  controlado antes de validar disponibilidade real dos tribunais.

## Jornadas HTTP isoladas — 04/11/2026

- Execução e integração pela sessão principal. `flutter_e2e` reforçou a
  jornada de interface, `seguranca_e2e` reforçou a matriz HTTP e o DataJud
  controlado e `revisao_e2e` fez revisão estática independente, incluindo
  a revisão de processo. A autoria do rascunho anterior está separada no
  plano histórico.
- O runner em `tools/testing/run_isolated_e2e.dart` cria PostgreSQL 16 com
  pgvector e dados em memória, aplica migrations existentes e inicia o
  Serverpod dedicado. Login, escopos, bloqueio e escrita usam identidades
  sintéticas geradas para aquela rodada. Banco e arquivos privados são
  descartados e a ausência é verificada. O runner utiliza apenas a imagem
  Docker instalada localmente e o DataJud usa transporte em memória.
- Na raiz, execute `dart tools/testing/run_isolated_e2e.dart` com o Dart do
  SDK Flutter. Acrescente `--inject-failure` para verificar o descarte após
  uma gravação confirmada.
- Rodada HTTP normal concluída com saída 0 e seis testes aprovados, sendo um
  percurso de interface e cinco cenários pelo cliente Flutter gerado. A
  matriz cobriu 60 recusas, incluindo uso do JWT anterior após revogação.
  O logout rejeitou o token de renovação anterior e a leitura sem sessão
  recebeu 401. DataJud importou, sincronizou e se recuperou de falha simulada.
- O aviso “Cliente salvo.” cobria “Nova negociação” ao trocar de área.
  `flutter_e2e` limitou o aviso a Clientes e acrescentou uma regressão.
  `revisao_e2e` aceitou a correção e conferiu os resultados 6/6 e a limpeza
  em sucesso e em falha. Contratos, migrations e regras preservados.
- A prova `--inject-failure` terminou com saída 1 esperada depois de gravar
  dados sintéticos, com `cleanupPassed=true` e `privateRuntimeRemoved=true`.
  A falha de bootstrap anterior também terminou com limpeza confirmada.
  Evidências separadas em `build/e2e/latest-result.json`,
  `build/e2e/latest-flutter.log` e `build/e2e/latest-failure-probe.json`.
  Conferência final independente do runner encontrou zero contêineres da
  jornada e zero diretórios privados de execução.
- A suíte Flutter padrão terminou com 73 aprovados e sete opt-in ignorados.
  Flutter, cliente gerado e automação com análise limpa. A análise completa
  do servidor registrou zero erros, 16 avisos e oito informações preexistentes.
  O build web passou com verificação preliminar Wasm e ficou em
  `packages/signcob_flutter/build/web`.
- O Docker Desktop inicialmente falhou em um socket antigo. A sessão
  principal preservou a pasta de dois sockets inativos como
  `run.signcob-stale-*` e reiniciou o Docker com a pasta temporária recriada.
  A suíte padrão do servidor usou apenas `postgres_test`: 27 testes passaram.
  As oito contagens SQL voltaram a zero, incluindo identidades, e o contêiner
  voltou ao estado parado.
- Comandos, cobertura, autoria e limites em
  [Jornadas críticas com HTTP isolado](docs/development/e2e-http-isolado.md).
- Limites da rodada: interface exercitada em testes de widgets, transporte
  DataJud em memória, entrega de e-mail e dispositivos físicos pendentes.
  A API ainda mapeia `ArgumentError` de validação para HTTP 500 e a suíte
  comprova a rejeição e a ausência de escrita.
- Próxima etapa sugerida: levar o login e um percurso crítico ao navegador
  com o mesmo isolamento e preparar a execução em integração contínua,
  preservando a prova de limpeza e os relatórios sem segredos.

## Jornada de clientes no navegador — 04/11/2026

- Autoria da automação, integração e validação local pela sessão principal.
  O subagente `revisao_browser` fez revisão independente somente leitura.
- O modo `--browser` usa Playwright 1.64.1, build Flutter web real, rotas
  Serverpod dedicadas e PostgreSQL descartável do runner HTTP. Os controles
  são acionados pela semântica do Flutter. O navegador usa um perfil efêmero
  e apenas as duas origens de loopback da rodada. Os arquivos com dados
  privados ficam no runtime da rodada, com permissão 700 em sistemas Unix.
- O fluxo `SignCob browser E2E` está configurado apenas para
  `workflow_dispatch`, com permissão de leitura do repositório e upload
  limitado aos dois JSON de resumo. A execução remota permanece pendente.
- Comandos e critérios de aceite em
  [Jornadas críticas com HTTP isolado](docs/development/e2e-http-isolado.md).
  Foram verificadas a sintaxe dos scripts Node, a análise Dart focada e a
  estrutura YAML. A prova HTTP original com `--inject-failure` também
  confirmou saída 1 esperada e descarte completo.
- Durante o ajuste, rodadas pararam ao ativar a semântica e na releitura da
  edição. A limpeza foi verificada nesses casos. O teste passou a ativar o
  controle fora da tela, editar pelo teclado e checar a resposta HTTP antes
  de verificar o estado na interface.
- A revisão identificou o risco de reaproveitar uma prova anterior e de
  consultar um Docker remoto no verificador. O verificador agora exige
  ordem temporal e socket local. Também recarrega a página após o logout
  antes da nova tentativa de acesso administrativo.
- A rodada local com Windows, Flutter 3.47.3, Dart 3.13.3, Node 24.14.0
  e Chrome 156.0.8078.80 passou com saída 0 e sete marcos. Confirmou
  cadastro, edição de nome, releitura, logout e resposta 401 sem sessão.
  A edição de um campo foi escolhida para manter a jornada curta.
- A prova final `--browser --inject-failure` saiu com código 1 intencional
  em `injected-failure-after-browser-create`, depois de confirmar o
  cadastro pela lista. Nos dois resumos, `cleanupPassed`,
  `containerRemovalVerified` e `privateRuntimeRemoved` foram verdadeiros.
  `node tools/testing/browser/verify-results.mjs 0 1` retornou 0 após
  conferir novamente os rótulos e as pastas das duas rodadas.
- Parecer independente final de `revisao_browser`: aceito para isolamento
  e evidências locais. A checagem separada em PowerShell retornou 0 e
  confirmou resumos com campos previstos, ordem das rodadas, ausência
  das duas pastas e dos contêineres no socket local. Ao fim, zero pastas
  `run-*` e zero contêineres rotulados da jornada. Linux e GitHub Actions
  permanecem pendentes de execução.
- Próximo incremento sugerido: exercitar no navegador a atribuição e a
  visibilidade de clientes entre dois advogados sintéticos. Reutilizar
  o modo isolado, a prova de descarte e o mesmo fluxo manual de CI.

## Visibilidade de clientes por atribuição no navegador — 04/11/2026

- A sessão principal implementou e executou a ampliação da jornada. O gestor
  atribui e reatribui o mesmo cliente sintético pela interface. Cada advogado
  entra em um contexto independente de navegador e mantém a própria sessão
  ao voltar de Processos para Clientes. As quatro consultas são HTTP reais
  e conferidas também na tela. Antes da reatribuição, A vê o cliente e B
  vê a lista vazia. Depois, A vê a lista vazia e B vê o mesmo cliente.
- A mudança se concentra na automação e na documentação. Reutiliza o build
  servido pelo Serverpod, as identidades do bootstrap e o workflow manual
  `SignCob browser E2E`. A etapa de falha passou do cadastro para depois
  da inversão confirmada, com os três contextos ainda ativos.
- Reprodução na raiz com o Dart do Flutter e, para a rodada local,
  `SIGNCOB_E2E_CHROME` apontando para o Chrome instalado. Use os códigos
  reais das duas execuções como argumentos do verificador.

  ```powershell
  $dart = 'C:/src/flutter/bin/cache/dart-sdk/bin/dart.exe'
  & $dart tools/testing/run_isolated_e2e.dart --browser
  $normal = $LASTEXITCODE
  & $dart tools/testing/run_isolated_e2e.dart --browser --inject-failure
  $probe = $LASTEXITCODE
  node tools/testing/browser/verify-results.mjs $normal $probe
  ```

- Ambiente local Windows com Docker 29.2.1, Flutter 3.47.3, Dart 3.13.3,
  Node 24.14.0, Playwright 1.64.1 e Chrome 156.0.8078.80. `node --check`
  passou nos dois scripts, e `dart --suppress-analytics analyze
  tools/testing/run_isolated_e2e.dart` passou sem diagnósticos. A primeira
  checagem do Docker no ambiente restrito recebeu acesso negado no socket.
  A execução local autorizada alcançou o Docker. A análise inicial também
  encontrou bloqueio no arquivo de telemetria e foi repetida com a
  telemetria suprimida.
- Rodada normal entre 14:02:48 e 14:05:14, horário de São Paulo. Saída 0,
  13 marcos e limpeza confirmada. A jornada incluiu cadastro, edição,
  releitura, atribuição, inversão de visibilidade, logout do gestor e HTTP
  401 na consulta anônima após recarregar.
- Prova de falha entre 14:05:15 e 14:07:36, horário de São Paulo. Saída 1
  esperada, 11 marcos e etapa `injected-failure-after-browser-reassignment`.
  Nas duas rodadas, `cleanupPassed`, `containerRemovalVerified` e
  `privateRuntimeRemoved` foram verdadeiros. O verificador retornou 0 após
  consultar o Docker local e os caminhos das duas rodadas. A conferência
  global por rótulo encontrou zero contêineres e zero pastas `run-*`.
- Evidências locais em `build/e2e/latest-browser-result.json` e
  `build/e2e/latest-browser-failure-probe.json`. Os resumos contêm os
  marcos e resultados fixos do teste. O manifesto com credenciais, os logs
  brutos e os dados privados do navegador foram descartados com o runtime.
- Revisão independente somente leitura por `revisao_atribuicao`, parecer
  `accepted` sem achados acionáveis. O revisor conferiu o código e checou
  separadamente os campos, mensagens fixas, marcos, cronologia e ausência
  das duas pastas privadas. A evidência sobre os contêineres veio das
  verificações da sessão principal no Docker local.
- Revisão breve de processo por `revisao_atribuicao`: a pré-checagem do
  socket Docker revelou o bloqueio antes do build. Os dois resumos
  permitiram revisar a limpeza sem compartilhar dados privados. Manter
  ambas as checagens e acompanhar a primeira rodada manual no GitHub Actions.
- Escopo da execução local: Chrome desktop, SQL descartável e dados
  sintéticos. Execução em Linux/Chromium e no GitHub Actions permanece
  pendente. Critérios e preparo em
  [Jornadas críticas com HTTP isolado](docs/development/e2e-http-isolado.md#jornada-no-navegador).

### Revalidação da retomada — 04/11/2026

- A jornada já estava implementada no workspace. A sessão principal
  preservou a automação e executou novamente os dois comandos de navegador
  acima com o Chrome instalado, cada um com build web novo. As mudanças
  desta retomada se limitaram ao registro das evidências.
- Rodada normal das 14:11:13 às 14:13:00, horário de São Paulo. Saída 0,
  13 marcos. Na atribuição inicial, A viu o registro e B viu a lista vazia.
  Nas consultas novas após a reatribuição, A viu a lista vazia e B viu
  o mesmo registro.
- Prova das 14:13:00 às 14:14:45. Saída 1 esperada, 11 marcos e etapa
  `injected-failure-after-browser-reassignment`. O comando
  `node tools/testing/browser/verify-results.mjs 0 1` saiu com código 0.
  Ambas as rodadas confirmaram remoção dos contêineres e pastas privadas.
  A consulta global por rótulo e a listagem de `build/e2e/run-*` ficaram
  vazias. Uma checagem em PowerShell confirmou os 14 campos previstos
  nos dois JSON, a mensagem fixa da falha e ausência de padrões de
  credenciais.
- `node --check` passou para `journey.mjs` e `verify-results.mjs`.
  `dart --suppress-analytics analyze tools/testing/run_isolated_e2e.dart`
  passou sem diagnósticos. O socket Docker exigiu execução local autorizada.
  Uma tentativa inicial passou `--suppress-analytics` diretamente ao Dart
  antes do caminho do runner e foi recusada pela VM antes de iniciar.
  A execução usou os comandos documentados, com a opção apenas na análise.
- A revisão independente desta retomada foi de `revisao_independente`,
  com parecer `accepted` e sem achados acionáveis. O revisor conferiu
  código, isolamento das sessões, asserções HTTP e de tela, fluxo manual
  de CI e resumos da rodada anterior em modo somente leitura. A sessão
  principal executou as novas rodadas e verificou seus resumos. A execução
  em Linux/Chromium no GitHub Actions continua pendente.

## Pré-checagem para validação Linux/Chromium — 04/11/2026

- A sessão principal consultou o repositório pelo conector GitHub. A única
  branch listada foi a padrão `main`, no commit
  [c182451a4832fce5a023d6176116592b70246361](https://github.com/Crislaine-Doria/signcob/commit/c182451a4832fce5a023d6176116592b70246361).
  As consultas de conteúdo do workflow, do runner e de `journey.mjs`
  retornaram HTTP 404. O `git ls-remote --symref origin HEAD 'refs/heads/*' 'refs/tags/*'`
  falhou na resolução de rede do ambiente. A consulta pelo conector
  confirmou a revisão da branch padrão.
- `git status --short --branch`, `git rev-parse HEAD` e
  `git ls-files --others --exclude-standard -- tools/testing packages/signcob_server/test/e2e`
  confirmaram que a jornada aprovada no Windows está na árvore de trabalho.
  O `HEAD` local corresponde ao mesmo commit inicial, que serviu à
  comparação e não foi testado. A revisão candidata ainda não tem SHA.
  O workflow não foi acionado. Não há link de execução, resultado em
  Linux/Chromium ou artefatos remotos a conferir.
- A revisão candidata precisa incluir `.github/workflows/browser-e2e.yml`,
  `tools/testing/run_isolated_e2e.dart`,
  `tools/testing/browser/{journey.mjs,verify-results.mjs,package.json,package-lock.json}`
  e `packages/signcob_server/test/e2e/support/{server.dart,controlled_datajud.dart}`.
  Também precisa das mudanças locais do app Flutter em `lib/` e `web/`
  e do seu `pubspec.lock`, dos contratos gerados em
  `packages/signcob_client/lib/src/protocol/`, dos endpoints, modelos,
  contratos gerados e configurações de código em
  `packages/signcob_server/lib/`, e das migrations com
  `packages/signcob_server/migrations/migration_registry.txt`. Esses arquivos
  formam a base integrada que o runner compila e inicializa. Incluir o
  guia `docs/development/e2e-http-isolado.md` e este registro para retomada.
  Separar credenciais locais, saídas de build, caches `.dart_tool`,
  arquivos de IDE, `node_modules` e o clone `tools/software-house`
  ao preparar um eventual envio. Push ou publicação requer autorização explícita.
- A sessão principal executou `node --check` em `journey.mjs` e
  `verify-results.mjs` e conferiu em PowerShell os dois resumos da rodada
  Windows já registrada. Os dois têm os 14 campos esperados, os seis
  marcos na ordem esperada (A vê o cliente e B vê lista vazia, depois A
  vê lista vazia e B vê o mesmo cliente) e os indicadores de remoção
  de contêiner e pasta privada. Foram confirmados 13 e 11 marcos,
  respectivamente, sem padrões de credenciais nos JSON. Os códigos 0 e 1
  das rodadas e 0 do verificador são evidências da execução Windows anterior.
- A revisão independente somente leitura de `revisao_e2e_linux` confirmou
  três sessões isoladas, novas consultas HTTP e asserções na interface,
  comparação do ID e lista vazia nas leituras negativas, além da verificação
  de descarte e do upload restrito aos dois resumos. O revisor repetiu os
  checks de sintaxe, conferiu os JSON do Windows e a ausência das duas pastas
  privadas. A remoção Docker foi revisada pelos indicadores dos resumos.
  Parecer `blocked` para o aceite remoto pela ausência da revisão no
  GitHub, sem achado estático que justifique alterar a automação.
- Quando houver revisão autorizada no GitHub, confirmar o workflow na
  branch padrão e disparar `SignCob browser E2E` na referência conferida.
  No Ubuntu, o workflow instala Chromium e executa, na raiz, com o Dart
  do Flutter:

  ```bash
  dart_sdk="$(dirname "$(realpath "$(command -v flutter)")")/cache/dart-sdk/bin/dart"
  success=0
  "$dart_sdk" tools/testing/run_isolated_e2e.dart --browser || success=$?
  probe=0
  "$dart_sdk" tools/testing/run_isolated_e2e.dart --browser --inject-failure || probe=$?
  node tools/testing/browser/verify-results.mjs "$success" "$probe"
  ```

  Conferir SHA, link e conclusão da execução, códigos 0/1/0 e os dois
  JSON sanitizados no artefato. A jornada e a limpeza em Linux/Chromium
  seguem pendentes.

## Revisão candidata para Linux/Chromium — 04/11/2026

- A sessão principal consultou o GitHub pelo conector após `git ls-remote`
  falhar na resolução de rede. O remoto confirmou apenas `main` como branch
  e branch padrão, ainda em `c182451a4832fce5a023d6176116592b70246361`.
  O workflow, o runner e a jornada não estavam na branch padrão.
- A sessão principal preparou a branch local `codex/browser-e2e-linux` na
  cópia `C:/Users/Administrador/projetos/signcob/build/revisao-browser-e2e`.
  A seleção preservou a árvore de trabalho original. A candidata reúne a
  automação, os suportes de teste, o Flutter e seus testes, os contratos
  gerados, os endpoints e as migrations da base integrada. O caminho do
  override do cliente usa barra portátil. A cópia exclui configurações
  privadas, resumos de execução, caches, arquivos de IDE, builds,
  `node_modules` e o clone independente do framework.
- O Compose passou a receber as senhas do ambiente, e o workflow legado
  de testes passou a gerar a senha efêmera do PostgreSQL de testes.
  Os literais retirados já existem no commit inicial publicado. O
  histórico remoto foi preservado. O workflow browser usa seu próprio
  banco descartável.
- O subagente `revisao_candidata` revisou somente leitura. Identificou que
  o primeiro wrapper Redis contornava a redução de privilégios. A sessão
  principal corrigiu a invocação para passar pelo entrypoint da imagem.
  O revisor aceitou a árvore `5e449a8ef8a476177233df12419ae46e2cb19b7b`
  após verificar o índice, os imports, as migrations, o fluxo de CI e os
  resumos Windows anteriores. A revisão breve do processo pelo mesmo
  subagente orientou registrar o SHA final e reconferir o remoto antes
  do envio. Depois do parecer, houve apenas alterações documentais no
  conteúdo da revisão.
- Na cópia isolada, a sessão principal executou `flutter pub get --offline
  --enforce-lockfile`, `dart pub get --offline --enforce-lockfile` no servidor
  e `npm ci --offline --ignore-scripts --no-audit --no-fund` com os caches
  locais. O ambiente restrito inicialmente negou acesso ao cache do SDK e
  ao socket Docker. A execução local autorizada permitiu o preparo e as
  rodadas. Passaram `git diff --cached --check`, `node --check` nos dois scripts,
  `dart --suppress-analytics analyze tools/testing/run_isolated_e2e.dart`,
  `docker compose config --quiet` e a conferência de arquivos e padrões
  conhecidos de credenciais.
- Windows/Chrome, no conteúdo da candidata, com os comandos documentados
  de `run_isolated_e2e.dart --browser`, `--browser --inject-failure` e
  `node tools/testing/browser/verify-results.mjs 0 1`. A rodada normal
  saiu com código 0 e 13 marcos (14:24:11 a 14:25:55 em São Paulo). A
  prova saiu com código 1 esperado e 11 marcos (14:25:56 a 14:27:37),
  na etapa `injected-failure-after-browser-reassignment`. Em ambas,
  o gestor atribuiu a A e só A viu o cliente. Após reatribuir a B e
  consultar novamente em sessões separadas, só B viu o mesmo registro.
  O verificador retornou 0. Os dois JSON esperados tinham os 14 campos
  fixos, os indicadores de remoção do contêiner e da pasta privada
  verdadeiros e nenhum padrão de credenciais. As consultas finais
  encontraram zero contêineres rotulados e zero pastas privadas na cópia.
- Destino proposto após aprovação explícita: avanço direto de
  `origin/main` no repositório `Crislaine-Doria/signcob`, sem forçar
  e após reconferir a ponta remota. O acionamento manual requer o workflow
  na branch padrão. Linux/Chromium, SHA da execução remota, link e
  artefato ainda não verificados. Os workflows legados não foram executados.

## Integração seletiva Asaas sobre a main remota — 05/11/2026

- Origem local: `df3096cd61dd51fba4a17798f1747a7702ef12ba`, criado sobre
  `c182451`. A ponta remota confirmada por fetch é
  `64b5d2ce4f66090b1e96ae1b382139417a42a697`, com sete commits próprios.
  O SHA informado na retomada tinha um sufixo divergente; este é o SHA real do Git.
  A tentativa anterior de merge foi abortada e não foi reaproveitada.
- Integração por subagente `integracao_asaas` na cópia independente
  `build/asaas-integracao`, branch `codex/asaas-integracao`, baseada na ponta
  remota. A sessão principal preparou a cópia, executou QA e registrou evidências.
  Revisão técnica independente do commit candidato ainda pendente neste registro.
- Reaplicados somente fontes/modelos/testes de billing e documentação operacional.
  Incluídas as duas correções CI já revisadas: formatação de greeting_endpoint
  e chaves nas condicionais de negotiation_endpoint, sem mudança de comportamento.
  Workflows (inclusive senha efêmera dos testes), Compose, .gitignore, automação
  de navegador e demais avanços remotos foram preservados.
- Contratos do servidor/cliente e suporte de testes regenerados com Serverpod
  CLI 3.2.3 no Dart 3.13.3 (`generate`). `create-migration` gerou a migration
  `20261105145614533` sobre a cadeia remota: tabela billing_charge, duas FKs,
  dois índices únicos e registros de versão. A migration local antiga
  `20261104233003130` não integra esta nova cadeia. Nada gerado foi editado à mão.
- O contrato billing.create/get/refresh exige login e capacidades atuais no token
  e no banco. A chave é única por cliente, com reserva persistida antes do envio;
  repetição divergente é recusada e resultado incerto não dispara novo envio.
  O adaptador bloqueia criação Asaas, aceita somente configuração sandbox e
  consulta apenas host HTTPS fixo. O aceite de negociação não cria cobrança.
- Checks executados pela sessão principal no Windows com Dart 3.8.0:
  `dart format --set-exit-if-changed .` no servidor: saída 0, 57 arquivos,
  zero alterações; `dart analyze --fatal-infos` no servidor e no cliente gerado:
  saída 0, sem diagnósticos; `dart test --reporter expanded --concurrency=1`:
  saída 0, 34 testes aprovados (quatro de integração e três unitários Asaas novos).
  Dependências QA resolvidas offline; o lockfile temporário do servidor foi
  restaurado ao da base remota e não faz parte do incremento.
- PostgreSQL 16/pgvector descartável com porta loopback efêmera e armazenamento
  tmpfs; conexão por SERVERPOD_DATABASE_PASSWORD e variáveis oficiais, senha
  efêmera somente no processo. A suíte aplicou a cadeia de migrations no banco
  novo. O finally removeu o contêiner; consulta Docker pelo rótulo
  signcob.qa=asaas-integracao confirmou zero contêineres restantes.
  O Docker estava parado, foi iniciado em segundo plano e tornou-se disponível.
  Nenhum banco preexistente foi iniciado ou alterado.
- Preservação antes da revisão: hashes de 414 arquivos do workspace original e
  oito arquivos locais adicionais/privados conferidos, zero diferenças. Inclui
  arquivos de IDE, flutter_01.log, lockfile Flutter e configurações privadas.
  O workspace original permanece em df3096c; a candidata fica na cópia isolada.
  Caches, arquivos de IDE, logs, credenciais, clone do framework e documentos
  locais alheios ao incremento não integram a seleção para commit.
- Pendências de negócio preservadas: modalidades de cobrança, mapeamento seguro
  de cliente no fornecedor e evento que confirma pagamento no sandbox. Estados
  de confirmação/recebimento não são aceitos como pagamento. Conciliação de
  reservas incertas ainda não tem fluxo próprio. Nenhuma chamada ao Asaas,
  cobrança real, concessão de acesso, publicação ou worker externo foi habilitado.
- Push sem force autorizado nesta retomada, condicionado à revisão independente,
  conferência final de credenciais, preservação local e reconfirmação da ponta
  remota. Não se autoriza publicação do aplicativo nem cobrança real.

### Parecer e fechamento da candidata

- Revisão técnica independente por `revisao_integracao_asaas`: `accepted`, sem
  achados acionáveis, sobre o commit
  `5b1fea05537a18540b3694fb01da915539fed9be` (parent `64b5d2c`). O revisor leu
  fontes, contratos/dispatch, testes e evidência 34/34; não reexecutou suíte/CLI.
  Confirmou que a migration altera zero tabelas preexistentes e adiciona somente
  billing_charge. Varredura independente do diff commitado não encontrou nenhum
  dos 24 valores privados locais, credenciais reais ou arquivos indevidos.
- Revisão breve de processo pelo mesmo subagente (perfil 54): divergência de
  histórico e schema gerado foram a fricção observada; manter base remota e
  selecionar fontes antes de regenerar evitou repetir o merge conflituoso.
  Sem acompanhamento adicional além das conferências finais de remoto/estado.
- O commit posterior a essa revisão altera apenas este estado, registrando o
  SHA revisado e o parecer. Publicação do aplicativo e testes de navegador não
  fazem parte desta entrega. Os checks locais do incremento estão aprovados;
  os workflows remotos desta nova revisão dependem de execução após o push.
- Fechamento autorizado: reconfirmar origin/main, ancestralidade e diff final;
  enviar HEAD:main sem force a partir da cópia isolada. O histórico remoto é
  preservado. Caso a ponta tenha avançado, interromper o envio e reintegrar.
- Procedimento local após envio confirmado: preservar df3096c na branch
  `codex/asaas-original-df3096c`, alinhar a main à candidata e restaurar 58
  arquivos apenas locais sem sobrepor caminhos da candidata nem comitá-los.
  Incluem documentação, scripts auxiliares e arquivos de IDE/cache.
  Cinco arquivos da migration Asaas substituída permanecem na branch original
  e em build/asaas-arquivos-originais, fora da cadeia ativa. PROJECT_STATE.md
  anterior também tem cópia local. As configurações privadas e os três arquivos
  não rastreados devem manter seus hashes. As alterações intencionais ao
  workspace são a integração revisada e a preservação dos avanços remotos.

### Envio e preservação confirmados — 05/11/2026

- O commit documental `41c6f1adeacd718368ebd821032bf8a913f93ed8` também foi
  aceito por `revisao_integracao_asaas`. Antes do envio, o fetch confirmou a
  ponta remota `64b5d2c`, ancestralidade 0/2 e cópia candidata limpa. A varredura
  do intervalo commitado confirmou 33 arquivos, zero credenciais/arquivos
  indevidos e zero mudanças nos arquivos remotos protegidos.
- Push `HEAD:main` sem force concluído: avanço remoto `64b5d2c..41c6f1a`,
  confirmado por ls-remote. A main do workspace original foi alinhada a
  `41c6f1a` com main...origin/main = 0/0; não há alterações rastreadas pendentes.
  A branch `codex/asaas-original-df3096c` preserva o commit local anterior.
- Os 58 arquivos apenas locais foram restaurados, sem sobrepor arquivos
  rastreados da candidata e sem incluí-los no commit. A conferência final
  encontrou 401 arquivos originais não afetados/restaurados com hashes
  idênticos, além dos oito arquivos privados/adicionais intactos. Documentos e
  scripts auxiliares permanecem não rastreados; IDE/caches permanecem ignorados.
  A migration Asaas antiga está fora da cadeia ativa e preservada no backup.
- A primeira conferência final de preservação sinalizou o arquivo retirado
  definition_project.json como se fosse inalterado: o Git inferiu uma renomeação
  entre migrations. Repetir a comparação com --no-renames classificou origem
  e destino corretamente; a verificação passou sem restaurar a migration antiga.
- Este registro de resultado altera somente a documentação. Workflows remotos
  desta nova entrega ainda não foram inspecionados; testes locais e revisão
  acima permanecem a evidência de aceite. Decisões Asaas seguem pendentes,
  criação real permanece bloqueada e nenhuma publicação do aplicativo ocorreu.
