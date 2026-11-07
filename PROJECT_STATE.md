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

## Verificação da integração contínua Asaas — 05/11/2026

- Autoria desta verificação e do registro: sessão principal (`/root`), usando
  os perfis 00, 27 e 08 como orientação; perfis não representam processos ativos.
  Revisão independente: `/root/revisao_ci_asaas`, `accepted`, sem achados
  acionáveis; conferiu Git e evidências remotas diretamente, somente leitura.
- Git local: `main`, HEAD e referência local `origin/main` em
  `0f8592277842cdd862a636d57b3c759e84412268`, sem alterações rastreadas antes
  deste registro e com 40 arquivos não rastreados preservados. A branch
  `codex/asaas-original-df3096c` continua em
  `df3096cd61dd51fba4a17798f1747a7702ef12ba`. Framework confirmado em
  `24124bbf2832b83996eb1fe716dac02e5d508585`; não foi adicionado ao índice.
- Ponta remota confirmada pela API de branches do conector GitHub no mesmo
  SHA completo acima. `git ls-remote` falhou com `getaddrinfo() thread failed
  to start`; não foi necessário alterar configurações globais ou credenciais.
  A API de status legado retornou lista vazia; o aceite abaixo vem das
  execuções Actions filtradas por `head_sha`, dos jobs e de seus logs, não
  dessa lista vazia nem do wrapper limitado a eventos de pull request.
- As três execuções são do evento `push`, branch `main`, tentativa 1, SHA
  `0f8592277842cdd862a636d57b3c759e84412268`. Todas terminaram em
  `completed/success` (`passed`). Horários abaixo em São Paulo (UTC−3).

| Workflow | Execução | Job | Atualização final em 05/11/2026 (`updated_at`) | Evidência |
|---|---|---|---|---|
| Tests | [42051998792](https://github.com/Crislaine-Doria/signcob/actions/runs/42051998792) | [127330233254](https://github.com/Crislaine-Doria/signcob/actions/runs/42051998792/job/127330233254) | 12:11:22 | `dart test`: 34 testes aprovados; `serverpod generate` e `Stop containers` aprovados. |
| Format | [42051998914](https://github.com/Crislaine-Doria/signcob/actions/runs/42051998914) | [127330233149](https://github.com/Crislaine-Doria/signcob/actions/runs/42051998914/job/127330233149) | 12:09:22 | Dart 3.8.0; `dart format --set-exit-if-changed .`: 57 arquivos, zero alterações. |
| Analyze | [42051998764](https://github.com/Crislaine-Doria/signcob/actions/runs/42051998764) | [127330233223](https://github.com/Crislaine-Doria/signcob/actions/runs/42051998764/job/127330233223) | 12:09:31 | Dart 3.8.0; `dart analyze --fatal-infos`: nenhum diagnóstico. |

- Tests executou no Ubuntu 24.04 com Flutter 3.32.8 configurado e Serverpod
  CLI 3.2.3 ativado no log. A senha de teste foi efêmera e mascarada. O log
  confirma remoção do contêiner PostgreSQL, volume e rede após os 34 testes.
  Os testes Asaas usam transporte/fornecedor controlados; não comprovam uma
  chamada real ao sandbox. Format e Analyze verificam o servidor; estes três
  workflows não representam aceite de navegador, build Flutter ou publicação.
- Os jobs emitiram aviso de depreciação do runtime Node 20 de
  `actions/checkout@v4`, executado pelo runner com Node 24. Não houve falha;
  atualização preventiva fica como manutenção futura, fora da correção mínima.
- Nenhuma correção, contrato ou migration foi necessária. Não houve reexecução
  local das suítes, commit ou push nesta etapa. Somente este estado foi editado;
  os documentos/scripts não rastreados, IDE/caches e arquivos privados não
  foram incluídos em commit. Nenhuma publicação, cobrança, credencial do legado
  ou worker externo foi utilizada.

### Decisões para o próximo incremento sandbox — ainda indefinidas

| Decisão do responsável | Alternativas a esclarecer antes de implementar |
|---|---|
| Modalidades e fluxo | Pix, boleto e/ou cartão; cobrança única, parcelada e/ou recorrente; indicar o que vale para dívidas e para honorários/serviços. Nenhuma modalidade está escolhida. |
| Vínculo de clientes | Definir quem é o pagador em cada fluxo (o cliente SignCob ou terceiro/devedor), se o operador vincula um `cus_...` existente ou se haverá cadastro controlado no sandbox, e se a relação será um para um. Persistir o vínculo por ambiente/conta e conferir duplicidades são propostas técnicas para revisão, sem criação automática nesta etapa. |
| Confirmação de pagamento | Definir se a baixa ocorre no sinal `PAYMENT_CONFIRMED`, em `PAYMENT_RECEIVED`, ou se o produto terá estados distintos para confirmação e disponibilidade. Prever também tratamento de estorno/contestação; nenhum desses eventos altera o estado atual. |

- Referências oficiais consultadas em 05/11/2026:
  [criar cobrança](https://docs.asaas.com/reference/create-new-payment),
  [cadastrar cliente](https://docs.asaas.com/reference/create-new-customer) e
  [eventos de pagamento](https://docs.asaas.com/docs/payment-events).
  Asaas distingue `PAYMENT_CONFIRMED` (pagamento sinalizado, saldo ainda
  indisponível) de `PAYMENT_RECEIVED` (valor disponível). O cadastro de cliente
  permite duplicidades; `externalReference` não deve ser presumido como chave
  única. Essas informações descrevem o fornecedor, não decidem a regra SignCob.
- Próximo passo: obter as três definições, especificar exemplos e critérios de
  aceite e então preparar um incremento sandbox revisado. A conciliação das
  reservas de resultado incerto continua pendente. `ensureCreationAvailable`
  permanece bloqueando criação no adaptador Asaas, e o aceite de negociação
  continua sem criar cobrança ou confirmar pagamento.

### Parecer independente e revisão breve de processo

- `/root/revisao_ci_asaas` aceitou o acréscimo documental de 64 linhas antes
  deste fechamento (SHA-256 do arquivo então revisado:
  `DB8A27C347E3AACD30F92FAEB6760800044725D1EB1BE6DDFFDFA9E57C3F68C2`).
  Confirmou separadamente SHA remoto/local, runs/jobs/logs, 34 testes, formatação,
  análise, preservação da branch e bloqueio de criação. Não reexecutou testes
  nem validou sandbox real ou navegador. Após o parecer, somente este fechamento
  e a precisão do cabeçalho de horário (`updated_at`) foram registrados.
- Revisão breve pelo mesmo subagente, orientado pelos perfis 09/54: fricção
  observada no status legado vazio e no wrapper restrito a pull requests;
  consultar Actions por SHA e conferir jobs/logs comprovou os resultados dos
  eventos push. Nenhum acompanhamento adicional de processo; permanecem as
  três decisões de negócio e a manutenção preventiva de Node 20.

## Definições do sandbox Asaas — 05/11/2026

- O responsável respondeu às decisões apresentadas após a CI: **todos** os
  meios (Pix, boleto e cartão) e fluxos (única, parcelada e recorrente), para
  dívidas e honorários/serviços; **cliente SignCob como pagador**; **estados
  separados** para confirmação do pagamento e recebimento do valor.
- Esclarecimento adicional explícito: **o SignCob cria ou reutiliza o cadastro
  Asaas**. A dúvida entre cadastro pelo sistema e vínculo manual está resolvida.
  As pendências de decisão registradas na seção anterior são históricas e
  ficam substituídas por estas definições. A disponibilidade de combinações
  entre meio/periodicidade deve ser conferida no fornecedor, sem presumir suporte.
- O próximo incremento deve representar confirmação (`PAYMENT_CONFIRMED`,
  saldo indisponível) e recebimento (`PAYMENT_RECEIVED`, valor disponível)
  separadamente. Essa definição não autoriza produção ou cobrança real.
- Autoria real do registro e dos critérios: sessão principal (`/root`), com
  orientação dos perfis 08/11. Critérios ASAAS-01 a ASAAS-06 em
  `docs/development/cobrancas-asaas.md`: `planned`. São requisitos para vínculo,
  modalidades, estados, idempotência/concorrência, conciliação e validação, não
  resultados de testes. Revisão independente por `/root/revisao_ci_asaas`:
  `accepted`, sem achados acionáveis, somente leitura dos dois documentos;
  conferiu fidelidade às respostas, critérios planejados e bloqueio mantido.
- Implementação ainda pendente: contratos/modelos de meios e periodicidades,
  cadastro/reutilização segura por ambiente/conta, parcelas/recorrências,
  estados separados, conciliação e tratamento de eventos. Nenhum código gerado,
  migration, credencial ou configuração foi alterado nesta definição. O bloqueio
  `ensureCreationAvailable` continua ativo até implementação, testes e revisão.
- Preservados o registro local anterior da CI e os arquivos não rastreados;
  sem commit/push, chamada ao Asaas, publicação ou concessão de permissões.
- Revisão breve 54 pelo mesmo subagente: separar identidade do pagador da
  responsabilidade pelo cadastro evitou deixar a segunda decisão incompleta;
  esclarecimento do responsável resolveu a lacuna. Acompanhamento: desenho
  técnico e testes já previstos, sem nova mudança de processo. Nenhum teste
  foi executado nesta etapa documental. `git diff --check` aprovado.

## Continuação funcional do sandbox Asaas — 05/11/2026

- Pedido integral recebido por anexo; autorizadas as etapas 1–8, exclusivamente
  sandbox/dados sintéticos, sem push, publicação, produção ou workers externos.
  Decisões de meios, fluxos, pagador e estados anteriores permanecem válidas.
- Inspeção inicial: HEAD/local e ponta `main` confirmada pela API GitHub em
  `0f8592277842cdd862a636d57b3c759e84412268`. `git ls-remote` falhou por
  resolução de rede; usado o conector em leitura. Branch de trabalho local
  `codex/asaas-sandbox-20261105` criada, sem alterar a main. Framework permanece
  na revisão fixada; não incluído no índice.
- Preservação: dois documentos já modificados e 40 arquivos não rastreados
  identificados; hashes iniciais em `build/asaas-sandbox-preexistentes-20261105.json`
  (artefato local ignorado). Documentos existentes serão ampliados preservando
  o conteúdo anterior; auxiliares não integram automaticamente a candidata.
- Processos reais: `/root` orquestra/integra/registra (perfis 00/40/08/26);
  `/root/asaas_backend` é autor de contratos, integração, dados e testes servidor;
  `/root/asaas_flutter` é autor da interface e testes Flutter;
  `/root/asaas_revisao` revisa independentemente (09/18/54). Sem worker externo.

| Etapa | Arquivos/responsável | Dependência e aceite | Estado |
|---|---|---|---|
| 1 Contratos | `docs/development/asaas-sandbox-contratos.md`, backend | Matriz API oficial, invariantes, estados e testes; revisão separada | planned |
| 2 Clientes | billing servidor/YAML/testes, backend | Contrato revisto; identidade, conta/ambiente, concorrência e incerteza verificadas | planned |
| 3 Única | billing servidor/testes, backend | Cliente conciliado; meios, validação e chave estável | planned |
| 4 Parcelas | billing servidor/YAML/testes, backend | IDs de grupo e parcelas, acompanhamento individual | planned |
| 5 Recorrência | billing servidor/YAML/testes, backend | Assinatura e pagamentos independentes, importação sem duplicação | planned |
| 6 Conciliação | billing servidor/testes, backend | GET autenticado, incerteza sem reenvio, estados financeiros monotônicos | planned |
| 7 Interface | Flutter lib/testes, Flutter | Contratos gerados estáveis; permissões, estados e responsividade | planned |
| 8 Candidata | verificações/estado, raiz; parecer, revisor | Suítes, geração, migration, revisão e limitações explícitas | planned |

- Cada marco passa por verificações proporcionais e revisão antes de liberar
  dependentes. Dono único de geração e migrations: `asaas_backend`.
- Ambiente: executáveis Dart diretos respondem (3.13.3 local e 3.8.0 do CI).
  Análise inicial com Dart 3.8.0: `passed`, nenhum diagnóstico. SDK local novo:
  17 avisos experimentais preexistentes (incluindo auxiliares não rastreados),
  sem erro; não confundir com regressão do incremento. Wrappers `.bat` travam;
  usar executáveis diretos. Docker 29.2.1 disponível com execução autorizada,
  imagem pgvector/pgvector:pg16 já local. Validação usará cópia/banco descartáveis.
- Nenhuma chamada Asaas foi executada. Autoria e revisão consultam a API
  oficial; restrições de WooCommerce não definem o contrato da API SignCob.

### Etapa 1 — contrato revisado

- Autoria real: `/root/asaas_backend`; revisão independente
  `/root/asaas_revisao`: `accepted` no SHA-256
  `5B23200C91B4344AA7C16CF050074E249DA5CD2AD08338D05EF7D1965908D94B`
  de `docs/development/asaas-sandbox-contratos.md`. Etapa 1: `passed` como
  desenho, sem considerar implementação/testes ainda não realizados.
- Desenho inclui DTOs, reservas duráveis, índices por conta/ambiente/documento,
  consultas mínimas para financeiro, parcelas e assinaturas com pagamentos
  individuais e confirmação/recebimento separados. Sem webhook neste incremento;
  conciliação explícita faz GET autenticado. Nenhum POST é refeito por incerteza.
- A API específica foi conferida pelo autor e revisor: Pix/boleto/cartão estão
  previstos em única/parcelada/assinatura; Pix recorrente convencional não é
  Pix Automático. Cartão usa fatura hospedada e não captura PAN/CVV; geração de
  faturas não promete ativação automática da recorrência pela primeira fatura.
  Jornada real ainda depende de credencial/configuração sandbox (`not_verified`).
- Revisão corrigiu antes da implementação: disputa de documento entre dois
  clientes SignCob; distinção entre incerteza no cadastro e na cobrança;
  limites explícitos da jornada de cartão. Processo 54 pelo mesmo revisor:
  consultar API específica evitou aplicar restrições do WooCommerce; acompanhar
  payloads e associação nos testes das próximas etapas.
- Liberada etapa 2 ao autor backend; Flutter pode iniciar apresentação/testes
  conforme contrato aceito, compilação integrada após geração estável. Geração
  e migrations continuam com autor único. A cópia de validação resolveu
  dependências offline com Dart 3.8.0, sem alterar lockfiles do workspace.
- Regressão inicial executada pela raiz antes da implementação: `passed`,
  **34/34 testes servidor** com Dart 3.8.0 na cópia
  `build/asaas-sandbox-qa-20261105`, PostgreSQL/pgvector descartável em tmpfs e
  porta aleatória apenas local. Cadeia de migrations aplicada; contêiner
  removido pelo finally e ausência conferida. Log local ignorado:
  `build/asaas-sandbox-baseline-tests-20261105.log`. Não comprova sandbox real.

### Etapa 2 — cliente Asaas, revisão em andamento

- Autor `/root/asaas_backend` gerou os novos DTOs e a migration aditiva
  `20261105154406797` usando Serverpod CLI 3.2.3, sem edição manual de gerados.
  Adiciona vínculo de cliente, pagamentos individuais e colunas opcionais da
  intenção; preserva registros anteriores. Código de clientes usa bloqueios,
  índices únicos e marcador durável de tentativa antes do POST.
- Verificação inicial pela raiz na cópia Dart 3.8.0: 16 testes focados aprovados,
  análise limpa, 71 arquivos formatados sem alterações. Depois da primeira
  correção de concorrência: 17 testes focados aprovados, incluindo conciliação
  que vence antes da marca de envio. Logs locais `build/asaas-sandbox-etapa2-*.log`.
  Ambos os bancos temporários foram removidos; testes não chamam Asaas real.
- Revisão independente identificou também a ordem inversa: uma consulta inicia
  antes da marca de POST e termina depois dela. O vínculo deve revalidar a
  referência dentro do bloqueio usando o estado atual, não o snapshot anterior.
  Correção e teste exigidos antes de aceitar etapa 2. As aprovações de testes
  acima são das versões anteriores; não aprovam antecipadamente essa correção.
- Configuração privada conferida somente por presença: `.env` está em sandbox,
  `ASAAS_API_KEY` e `ASAAS_ACCOUNT_ID` não preenchidos. Nenhum valor privado foi
  exibido ou alterado. Chamadas reais permanecem `not_verified`.

### Etapa 2 — aceite após correções

- `/root/asaas_revisao`: `accepted`, nenhum achado aberto. A corrida inversa
  P1 foi corrigida por releitura de `createAttempted` e validação da referência
  dentro do bloqueio; teste com duas barreiras cobre a ordem identificada.
  Hashes revistos e iguais na cópia de execução: serviço
  `9DFC59BB218FB9958176C0084C2588D96E511888A059588D9727BA48F7DF01F9`, teste
  `761F0333C80FEF770F5ED2CC2AD260D471DAAAD6E1B1C9BF1A61BC166029EF80`.
- Verificação final pela raiz: **18/18 aprovados** (8 integração SQL de clientes,
  3 adaptador cliente e 7 regressão de cobrança), análise Dart 3.8.0 limpa,
  formatação de 71 arquivos sem alterações. Log
  `build/asaas-sandbox-etapa2-revisada-tests-20261105.log`. Migration aplicada em
  banco novo e remoção conferida pelo runner. Revisor inspecionou código/logs;
  não reexecutou suíte nem confirmou Docker diretamente (pipe negado na leitura).
- Etapa 2: `passed` nos testes controlados. Cadastro remoto efetivo e vínculo
  em conta sandbox real: `not_verified`. Não há produção ou credenciais novas.
- Processo 54 pelo revisor: testar ambas as ordens da corrida do marcador
  durável; aplicar rigor equivalente às reservas e conciliação de cobranças.
  Etapa 3 liberada ao autor backend. UI tem 18 cenários controlados iniciais
  aprovados pelo autor Flutter; ainda aguarda integração e revisão da etapa 7.

### Etapa 3 — cobrança única aceita

- Autoria real `/root/asaas_etapa3_backend` (03/15/21/22): cobrança única
  `PIX`, `BOLETO` e `CREDIT_CARD` por `POST /v3/payments`, com payload mínimo,
  cartão somente por fatura hospedada e sem PAN/CVV, juros, multa ou desconto.
- A reserva idempotente agora registra `createAttempted` sob bloqueio antes do
  POST. Repetições e concorrência mantêm uma única reserva e um único dono da
  tentativa; após resultado incerto não há reenvio. `refresh` usa somente GET/
  listagem e confere conta, cliente, referência, meio, valor e vencimento.
- Migration aditiva `20261105211247382-asaas-single-attempt` gerada pela CLI
  Serverpod; artefatos gerados não foram editados manualmente. Hashes centrais
  conferidos pela raiz e pelo revisor.
- Evidência do autor: **6/6 testes unitários** e **3/3 testes de integração**
  aprovados em PostgreSQL/pgvector descartável, migration aplicada em banco
  novo, contêiner removido, formatação focal e `git diff --check` aprovados.
  Análise focal sem erros; um aviso experimental e quatro infos não bloqueantes.
- Revisão independente `/root/asaas_etapa3_revisao` (09/18/54): `accepted`,
  sem achados técnicos ou de segurança abertos. O revisor não reexecutou os
  testes porque a resolução tentou acessar pub.dev sem rede; inspecionou código,
  migration, hashes e evidências do autor. Processo 54 recomenda preservar um
  runner offline reproduzível ou documentar o shim do pré-check Flutter.
- ASAAS-01 e ASAAS-03 para cobrança única: `passed` em testes controlados.
  Emissão e conciliação em conta Asaas sandbox real: `not_verified`; nenhuma
  chamada externa, credencial, produção, push, commit ou publicação ocorreu.
  Etapa 4 liberada para autoria backend.

### Etapa 4 — parcelamento aceito após correção P1

- Autoria `/root/asaas_etapa3_backend`: `BillingFlow.installment` para Pix,
  boleto e cartão usa `POST /v3/payments` com `installmentCount + totalValue`,
  sem `value`, `installmentValue`, juros, multa ou desconto. A primeira resposta
  identifica o grupo; as parcelas são lidas por
  `GET /v3/installments/{id}/payments` e persistidas individualmente.
- Validações controladas cobrem conta, cliente, referência, meio, grupo, limites
  2–60 (cartão até 12), quantidade, números únicos, primeiro vencimento, soma
  total e arredondamento na última parcela. Conciliação encontra um grupo único
  sem novo POST; concorrência mantém uma reserva e uma tentativa.
- Evidência inicial do autor: **7/7 unitários** e **7/7 integrações** das etapas
  3–4 aprovados em PostgreSQL/pgvector descartável; formatação e
  `git diff --check` aprovados. Nenhum schema adicional ou migration foi preciso.
- Revisão independente `/root/asaas_etapa3_revisao` solicitou mudança P1: o
  upsert por `providerId` não conferia a estabilidade de `installmentNumber`,
  permitindo aplicar estado à parcela errada se o fornecedor trocasse números.
- Autor corrigiu `_observe` e adicionou regressão que troca 1↔2, exige
  `provider_response` e comprova rollback sem alterar números/estados. **5/5
  testes focados** passaram; hashes finais do serviço e teste conferidos.
- Parecer final independente: `accepted`, sem achados abertos; inspeção estática,
  hashes e diff conferidos, sem reexecução independente da integração. Processo
  54: incluir estabilidade ID↔posição no checklist de coleções da recorrência.
- Etapa 4: `passed` em testes controlados. Parcelamento em sandbox Asaas real:
  `not_verified`. Nenhuma chamada externa, migration nova, credencial, commit,
  push ou publicação. Etapa 5 liberada.

### Etapa 5 — recorrência aceita após correção P1

- Autoria `/root/asaas_etapa3_backend`: `BillingFlow.recurring` para Pix,
  boleto e cartão cria `POST /v3/subscriptions` com cliente, meio, valor por
  ciclo, primeira data, ciclo, referência e descrição. Não envia PAN/CVV/token,
  juros, multa, desconto, término ou quantidade máxima; não promete ativação ou
  débito automático do cartão nem confunde Pix convencional com Pix Automático.
- Assinatura usa `providerGroupId` e `subscriptionStatus` próprios; pagamentos
  já gerados são importados incrementalmente por
  `GET /v3/subscriptions/{id}/payments`, com estados financeiros individuais.
  Resultado incerto concilia por identidade e parâmetros exatos, sem novo POST.
- Evidência inicial: **8/8 unitários**, **8/8 integrações** das etapas 3–4 e,
  após corrigir colisão sintética de fixture, **3/3 recorrentes** aprovados.
  Análise focal sem erros; formatação e `git diff --check` aprovados. Nenhuma
  migration ou geração nova necessária.
- Revisão independente `/root/asaas_etapa3_revisao` pediu mudança P1: o refresh
  congelava `nextDueDate` na primeira data, embora esse campo avance conforme a
  assinatura gera novas cobranças, impedindo importações futuras.
- Autor separou a correlação inicial (data original obrigatória na criação e
  conciliação incerta) do cursor evolutivo de assinatura já vinculada. Teste
  avança `nextDueDate`, importa nova cobrança sem POST e preserva a data original
  da intenção; **4/4 testes recorrentes** passaram, análise e diff limpos.
- Parecer final: `accepted`, hashes e correção inspecionados, sem reexecução
  independente. Processo 54: distinguir invariantes imutáveis de cursores do
  fornecedor no checklist de integrações.
- Etapa 5: `passed` em testes controlados; recorrência real no sandbox e jornada
  real de cartão: `not_verified`. Nenhuma chamada externa, credencial, commit,
  push ou publicação. Etapa 6 liberada.

### Etapa 6 — estados e conciliação aceitos com validação local limitada

- Autoria real `/root/agente57` (modo econômico): nenhuma mudança de produção
  foi necessária; foi adicionada cobertura sintética em
  `billing_installment_endpoint_test.dart` para `PAYMENT_RECEIVED` direto sem
  fabricar confirmação, `CONFIRMED → RECEIVED`, observação atrasada sem
  regressão e ausência de duplicatas no upsert.
- Inspeção confirmou que a lógica existente mantém `confirmedAt` e `receivedAt`
  separados e monotônicos, preserva recebimento contra observação atrasada,
  mantém status desconhecido em `attention`, não repete POST após criação
  incerta, confere conta/ambiente/cliente/referência/grupo/assinatura e exige
  permissões atuais de leitura/escrita. Não há webhook, polling ou worker.
- Revisão independente `/root/agente57_revisao`: `accepted`, sem regressão
  evidente. Lacunas registradas: o novo teste não cobre revogação, divergência
  de conta/cliente ou negociação incompatível, não verifica timestamps da
  terceira parcela após observação atrasada e não afirma diretamente unicidade
  por cada `providerId`; permanecem pontos para a validação final, não falhas
  abertas da lógica inspecionada.
- `git diff --check` e formatação focal passaram. Teste de integração e análise
  Dart ficaram `not_verified`: o runtime local travou por mais de 90 segundos,
  inclusive em `dart --version`, e as execuções foram interrompidas. Nenhuma
  chamada Asaas real, credencial, commit, push ou publicação ocorreu.
- Etapa 6: `passed` por inspeção e cobertura adicionada, com execução dinâmica
  `not_verified`. A etapa 7 (interface interna) permanece pendente.

### Etapa 7 — interface interna aceita por inspeção

- Autoria `/root/agente57` (modo econômico): a tela Asaas já expunha os nove
  pares de fluxo/meio — única, parcelada e recorrente × Pix, boleto e cartão —;
  o teste focalizado foi ampliado para percorrer todas as combinações. Nenhuma
  mudança de produção foi necessária.
- A interface diferencia aguardando conciliação, aguardando pagamento,
  confirmado com saldo indisponível e recebido com saldo disponível. Informa que
  criação não confirma pagamento, mantém ação explícita de conciliação após
  timeout e identifica sandbox/dados sintéticos. Permissões de leitura/escrita
  continuam sob autoridade do servidor; acesso negado, revogação e modo somente
  leitura têm cobertura declarada.
- Revisão independente `/root/agente57_revisao`: `accepted`, sem regressão
  evidente. Lacuna: não executou a suíte, apenas confirmou a cobertura pelo
  código; a execução do teste Flutter também ficou `not_verified` por travamento
  do runtime local após 30 segundos. Formatação/checagem de espaços passaram.
- Hashes conferidos: tela sem alteração e teste focalizado ampliado. Nenhuma
  chamada Asaas real, credencial, publicação, commit ou push ocorreu.
- Etapa 7: `passed` por inspeção e cobertura declarada; execução Flutter
  dinâmica `not_verified`. Etapa 8 permanece pendente para consolidação final,
  verificação proporcional e registro explícito das limitações.

### Etapa 8 — consolidação Asaas sandbox

- `/root/agente57` atualizou `docs/development/cobrancas-asaas.md` e o cabeçalho
  de `docs/development/asaas-sandbox-contratos.md` para refletir que as etapas
  foram implementadas/revisadas, mantendo explícitos os limites: testes usam
  transporte sintético e a disponibilidade, emissão e liquidação reais do
  sandbox não foram verificadas.
- Critérios ASAAS-01 a ASAAS-06 agora estão documentados como implementados,
  com cobertura sintética e ressalvas individuais. `git diff --check` documental
  passou; nenhum segredo, endpoint de produção, worker, webhook ou cobrança real
  foi habilitado.
- Parecer independente econômico `/root/agente57_revisao`: `accepted` para a
  interface e para a cobertura de estados, sem regressões evidentes. Lacunas
  permanecem registradas: suíte final Dart/Flutter não executada por travamento
  do runtime; validação real do Asaas, permissões em ambiente final e liquidação
  continuam `not_verified`.
- Estado da candidata: etapas 1–7 concluídas em código/documentação e revisadas;
  etapa 8 consolidada com limitações explícitas. Não houve commit, push,
  publicação, chamada externa ou uso de credenciais.

## Chat e agenda com Google Agenda — preparação interrompida — 07/11/2026

- O escopo do MVP foi definido pelo responsável: chat interno e agenda integrada
  ao Google Calendar, com OAuth exclusivamente no servidor, sincronização sem
  workers externos, idempotência e isolamento por perfil/cliente.
- A tentativa inicial de autoria criou contratos/endpoints temporários, mas foi
  removida antes da integração porque o `serverpod_cli` não está disponível no
  ambiente local e `dart run serverpod_cli generate` ficou bloqueado durante a
  resolução. Nenhum código intermediário ou migration não gerada foi mantido.
- Retomada necessária: disponibilizar o CLI Serverpod 3.2.3 offline ou permitir
  a resolução das dependências; depois gerar contratos/migrations oficialmente,
  implementar OAuth/transport Google com credenciais somente no servidor e
  executar revisão, testes e build conforme o prompt do MVP.

## Chat e agenda — ambiente e geração desbloqueados — 07/11/2026

- Execução real: sessão principal `/root` preparou, gerou, integrou evidências e
  atualizou este estado; `/root/diagnostico_devex` fez diagnóstico independente
  somente leitura como especialista 26. Nenhum perfil foi contado como processo.
- Ambiente confirmado: Windows x64; Dart 3.13.3 stable no Flutter local; Flutter
  3.47.3 stable; SDK de validação Dart 3.8.0 preservado em
  `build/workflow-sdk-3.8.0`; Serverpod, cliente, autenticação e testes em 3.2.3.
  Nenhuma versão de projeto, manifesto ou lockfile foi alterada.
- `serverpod_cli` 3.2.3 está disponível offline no cache local e ativado
  globalmente. O snapshot respondeu `Serverpod version: 3.2.3`. O wrapper
  `flutter.bat` local trava/precisa escrever no lock do SDK; shims ignorados em
  `build/serverpod-shims` chamam os executáveis diretos e tornam o pre-check do
  CLI reproduzível. A execução requer acesso ao cache instalado em
  `C:/src/flutter`.
- `dart run serverpod_cli generate` literal não é resolvido pelo projeto porque
  `serverpod_cli` não consta em `dev_dependencies`. A simulação offline de
  inclusão não concluiu e foi interrompida; nenhuma resolução ou lockfile foi
  aceita. Também foi rejeitada a tentativa de apontar o package config global
  diretamente (`Could not find package serverpod_cli`). Decisão: preservar os
  manifests e usar a ativação global oficial já presente, como faz a CI.
- Geração oficial executada em `packages/signcob_server` pelo snapshot local
  do CLI 3.2.3 com `generate`: `passed`, 29,4 s, `Done`. O fluxo é equivalente
  ao comando versionado da CI (`serverpod generate`) e não usou rede para
  dependências. Antes e depois, SHA-256 de 62 arquivos em
  `lib/src/generated`, `signcob_client/lib/src/protocol`, manifests e lockfiles:
  zero diferenças. Os contratos de servidor e cliente já estavam compatíveis;
  nenhuma alteração Asaas ou outro trabalho preexistente foi sobrescrita.
- Verificações: servidor `dart analyze --fatal-infos` com Dart 3.8.0: `passed`,
  sem diagnósticos; cliente `dart analyze` com Dart 3.13.3: `passed`; Flutter
  `analyze`: `passed`, sem diagnósticos; Flutter `test --reporter expanded`:
  `passed`, 103 testes e 7 ignorados; servidor unitário via resolução local:
  `passed`, 15 testes. As execuções não usaram Google, Asaas real, publicação,
  push, migration nova ou worker externo.
- Falhas diagnosticadas antes do teste servidor aprovado: o comando comum
  tentou consultar `pub.dev`; a execução Dart 3.8.0 encontrou transitivas do
  analyzer que exigem linguagem 3.9; a primeira execução Dart 3.13.3 não pôde
  usar a pasta temporária restrita. A execução final usou o package config já
  resolvido, Dart 3.13.3 e acesso local à pasta temporária, sem alterar locks.
- Aceite desta preparação: `passed`. O CLI compatível está disponível, a geração
  oficial concluiu, cliente/servidor permaneceram idênticos e compatíveis, e as
  análises/testes mínimos passaram. Limitação reproduzível: usar `serverpod
  generate`/snapshot global 3.2.3; tornar o comando literal `dart run
  serverpod_cli generate` exigiria decisão futura para adicionar a dependência
  de desenvolvimento e resolver/registrar o lockfile.
- Próximo passo autorizado após este aceite: primeira fatia vertical do chat,
  com contratos Serverpod, migration gerada, endpoint protegido, listagem de
  conversas, envio de mensagem e testes de autorização/isolamento entre
  clientes. Agenda, Google OAuth e credenciais continuam fora dessa fatia.
- Revisão independente `/root/revisao_preparacao` (09): `accepted`, sem achados
  acionáveis. Conferiu CLI/cache, versões fixadas, zero diff em manifests e
  lockfiles, fluxo equivalente da CI, artefatos regenerados, shims ignorados e
  `git diff --check`. Não reexecutou geração ou suítes; validou as evidências da
  sessão principal e manteve explícita a limitação do comando literal.
- Revisão breve 54 pelo mesmo revisor: o baseline SHA-256 protegeu corretamente
  o worktree com alterações preexistentes; manter a CLI global alinhada à CI
  evitou mudança desnecessária de dependências. Preservar esse padrão até decisão
  explícita para versionar `serverpod_cli` como dependência de desenvolvimento.

### Etapa 9 — primeira fatia vertical do chat — 07/11/2026

- Autoria real independente: `/root/chat_backend` (contratos, persistência,
  endpoint e testes de autorização) e `/root/chat_flutter` (tela, adapters e
  testes Flutter). Integração, documentação e validação final: `/root`.
  Revisão independente: `/root/chat_revisao_final`, parecer **accepted**, sem
  achados P0/P1/P2. A revisão 54 recomendou iniciar/verificar o banco de teste
  antes de despachar a revisão independente.
- Modelo Serverpod aditivo: `ChatConversation`, `ChatParticipant` e
  `ChatMessage`, com índices de ordenação/paginação, unicidade de participante,
  remoção lógica e FKs. A migration oficial
  `20261107133745758-chat-first-slice` foi gerada com Serverpod CLI 3.2.3 usando
  `serverpod create-migration --tag chat-first-slice`; seu `migration.sql` contém
  somente as três tabelas do chat, índices e FKs. Gerados foram produzidos por
  `serverpod generate`, sem edição manual.
- Capacidades registradas em `access_admin_endpoint.dart`: `chat.partner`,
  `chat.lawyer`, `chat.support` e `chat.client`. O perfil sócio recebe a
  capacidade global já registrada. O servidor cruza escopos do token com o
  `AuthUser` atual, rejeita conta bloqueada/revogada, combina capacidades e
  aplica os vínculos atuais: sócio global; advogado por cliente atribuído;
  atendimento por participante ativo; cliente por participante ativo e titular
  do cliente. Financeiro e anônimo permanecem negados por padrão.
- Endpoints protegidos: `chat.listConversations`, `chat.listMessages` e
  `chat.sendMessage`. Paginação é executada no PostgreSQL, limite máximo 50,
  ordem determinística por data/ID, mensagem trim de 1–4.000 caracteres, autor
  e timestamp UTC definidos no servidor, e erros de recurso alheio/inexistente
  não revelam existência. Remoção de participante, revogação e reatribuição
  passam a valer sem depender de token novo.
- Flutter integrado ao painel administrativo em
  `packages/signcob_flutter/lib/main.dart` e
  `admin_dashboard_screen.dart`. A tela cobre carregamento, vazio, falha/retry,
  acesso negado, seleção, paginação, envio sem duplicação, 390 px/desktop e
  texto ampliado. O marcador `_sessionGeneration` invalida respostas atrasadas
  após troca de sessão, inclusive com o mesmo ID de conversa; nomes/identidade
  nunca são enviados pelo app.
- Evidências do backend: **6/6 testes focados** em
  `test/integration/chat_endpoint_test.dart` e **9/9** na regressão de chat,
  gestão de acessos e perfil parceiro; `dart analyze --fatal-infos` com exit 0
  (22 avisos experimentais preexistentes, nenhum no chat); geração final com
  `HASH_FILES_BEFORE=65`, `HASH_FILES_AFTER=65`, `HASH_CHANGED=0`.
- Evidências do Flutter: teste focado pós-correção **8/8**; suíte completa
  **111 testes aprovados e 7 ignorados**; `flutter analyze --no-pub` sem
  diagnósticos; cliente gerado `dart analyze` sem diagnósticos; `git diff
  --check` passou, com apenas avisos de conversão LF/CRLF do worktree.
- Limitação da revisão independente: o teste servidor não foi reexecutado pelo
  revisor porque o PostgreSQL de teste não estava ativo em `localhost:9090`.
  Isso não invalida os 6/6 e 9/9 executados pelo autor, mas a próxima retomada
  deve iniciar/verificar o banco antes da revisão. Nenhuma dependência foi
  resolvida pela rede, nenhum segredo/Asaas foi usado, e todas as alterações
  Asaas e demais mudanças locais preexistentes foram preservadas.
- Documentação criada em `docs/development/chat.md`. Conversas e participantes
  são previamente provisionados nesta fatia; não há endpoint de administração
  deles. Agenda, Google OAuth, anexos, edição/exclusão, presença, tempo real,
  notificações, workers, webhooks e filas continuam fora do escopo.
- Próximo passo recomendado: subir o PostgreSQL de teste e repetir a suíte
  independente do servidor; depois, implementar provisionamento administrativo
  de conversas/participantes com os mesmos vínculos e capacidade atuais, antes
  de iniciar agenda ou OAuth.

## Validação final do sandbox Asaas — 07/11/2026

- Autoria/executor real: `/root/agente57`; integração do estado e coordenação:
  `/root`. O parecer independente desta validação permanece pendente. Nenhum
  perfil foi contado como processo ativo.
- Diagnóstico de runtimes, com limite explícito de 10 s: `dart.bat --version`
  e `flutter.bat --version` expiraram e foram encerrados; os executáveis/snapshot
  diretos responderam. `dart.exe --version` reportou Dart 3.13.3 em 0,16 s;
  Flutter snapshot `--version` reportou Flutter 3.47.3/Dart 3.13.3 em 0,62 s.
  O runner Dart 3.8.0 existe no cache local, mas o package config atual referencia
  `analyzer 10.0.1` (linguagem 3.9); executar os testes com Dart 3.8.0 falha
  por incompatibilidade do analyzer, sem alterar lockfiles.
- Dependências: `dart test` tentou acessar pub.dev e terminou com socket error
  (exit 65, 24,52 s); `dart pub get --offline` informou `test` ausente no cache
  (exit 69). Os diretórios de pacotes referenciam um package config local já
  resolvido. Para evitar rede, a validação usou o runner `test-1.29.0` local
  diretamente, `--packages=.dart_tool/package_config.json` e compilador kernel
  padrão ou `--compiler source`, conforme indicado em cada execução.
- Suítes focadas Asaas: servidor unitário, 8/8 aprovados em 22,43 s; servidor
  integração, 21/21 em 72,30 s; Flutter, 31/31 em 23,69 s usando o snapshot
  Flutter direto com `test --no-pub`. A API e transporte dos testes são sintéticos.
- Suíte completa Serverpod/Dart repetida com compilador kernel padrão: 56/56
  testes passaram em 87,18 s. PostgreSQL 16/pgvector foi descartável, em tmpfs,
  porta somente localhost e senha aleatória; as fixtures `withServerpod`
  aplicaram o conjunto de migrations desde banco vazio. `ASAAS_API_KEY`,
  `ASAAS_ACCOUNT_ID` e `DATAJUD_API_KEY` foram vazias durante os testes. Os quatro
  contêineres desta validação foram conferidos ausentes após execução. Uma
  tentativa anterior da suíte completa com `--compiler source` teve 53 testes
  aprovados e erro de carregamento em `contact_admin_endpoint_test.dart`
  (`Protocol()` não encontrado); o mesmo teste passou 2/2 com kernel, e a suíte
  completa kernel passou. A falha é específica do modo source neste ambiente.
- Formatação sem gravação, Dart 3.8.0 direto: cliente, 26 arquivos, exit 0;
  arquivos Asaas de UI, 2 arquivos, exit 0; arquivos Asaas do servidor, 2
  arquivos, exit 0. A primeira verificação completa do servidor encontrou 78
  arquivos limpos; a verificação final encontrou 79 e reportou apenas
  `lib/src/chat/chat_endpoint.dart` fora de Asaas (exit 1), sem editar código.
  Flutter `lib test` verificou 46 e reportou apenas
  `test/admin_cases_screen_test.dart` fora de Asaas (exit 1), sem edição pelo
  formatador final. Cliente e Flutter: `dart analyze --fatal-infos .` passaram
  sem issues.
  Servidor: a primeira análise reportou 7 infos de chaves ausentes e 22 warnings
  `UuidValue` experimental; blocos explícitos foram adicionados apenas aos sete
  `if`s Asaas. A nova análise não reportou infos, mas ainda retorna exit 2 com
  22 warnings experimentais de `UuidValue` (16 preexistentes e 6 em fixtures
  Asaas). Não foram suprimidos warnings de API experimental.
- Falha operacional desta sessão: foi executado por engano na raiz o comando
  `C:\src\flutter\bin\cache\dart-sdk\bin\dart.exe format --set-exit-if-changed .`
  (Dart 3.13.3). Em 8,80 s, percorreu 1.183 arquivos, alterou 231 e terminou
  exit 65 por snapshots de SDK 3.8 incompatíveis com o parser mais novo. Tocou
  224 arquivos Dart ignorados em `/build` e 7 arquivos Dart fora de `/build`.
  Nenhum documento Asaas, manifesto ou lockfile foi editado por esse comando.
- Recuperação executada por `/root`: os três arquivos rastreados que estavam
  limpos no baseline (`admin_cases_screen_test.dart`, `admin_users_screen_test.dart`
  e `tools/testing/run_isolated_e2e.dart`) foram restaurados do `HEAD`; os hashes
  Git normalizados conferem com os blobs `6fb16148749e5f6725cb100bbf3b42308fafa7c7`,
  `d5f5c71bc2a387f5b64c36da53dec82077f8e4a8` e
  `34ac3363f988afb37c335baeb55820e076905b43`. Ainda estão formatados dois
  testes Asaas não rastreados (`admin_billing_screen_test.dart`,
  `billing_installment_endpoint_test.dart`) e duas fontes auxiliares QA
  (`packages/signcob_flutter/build/qa/review_auth_layout_test.dart`,
  `review_auth_state_test.dart`). Não encontrei cópia byte a byte desses quatro
  arquivos; não afirmo preservação exata nem alteração de comportamento. Os dois
  testes Asaas passaram; os helpers QA não foram reexecutados e requerem revisão.
- Recuperação exata de arquivos ignorados em `/build`: dos 224 arquivos Dart
  tocados pelo formatador acidental, 96 fontes do SDK foram restauradas de
  entradas correspondentes em `build/workflow-sdk-3.8.0/dart.zip` e tiveram
  hashes conferidos; outros 109 snapshots foram restaurados a partir de cópias
  que batiam com `build/asaas-preservacao-inicial.json`; mais 5 arquivos do
  snapshot QA foram restaurados a partir da raiz com hashes conferidos pelo
  `build/asaas-sandbox-qa-source-manifest-20261105.json`. Total restaurado:
  210/224, com caminhos absolutos validados dentro de `build` e SHA-256 igual à
  origem registrada. Permanecem 14 sem origem exata demonstrada: `admin_cases`
  e `admin_users` em `asaas-base` e `asaas-candidato`; `test.dart` em
  `asaas-etapa3-temp/dart_test.kernel.56087c80`; `admin_cases` em
  `asaas-integracao`; `client.dart` e `billing_charge.dart` em
  `asaas-sandbox-qa-20261105`; `client.dart` e `admin_cases` em
  `baseline-workflows-legados`; `client.dart`, `admin_cases` e `admin_users`
  em `revisao-browser-e2e`; e `client.dart` e `admin_cases` em
  `revisao-workflows-legados`. Não restaurei esses 14 por suposição. Todos os
  caminhos em `/build` seguem ignorados pelo Git; não declaro seu estado anterior
  byte a byte preservado.
- Arquivos funcionais Asaas ajustados nesta validação: blocos em sete `if`s em
  `asaas_sandbox_provider.dart` e `billing_endpoint.dart` para remover infos do
  analisador. Nenhuma migration/gerado foi editado manualmente. Nenhuma chamada
  externa Asaas/DataJud, credencial, cobrança, webhook, worker, produção,
  publicação, commit ou push foi usada.
- Estado de validação: testes focados e suíte completa passaram em transporte
  sintético; cliente/Flutter têm análise limpa; servidor ainda tem warnings
  experimentais e não retorna exit 0 no analyzer local; as APIs, cobrança,
  liquidação e combinação real de cartão permanecem `not_verified`. A revisão
  independente deve conferir os dois ajustes Asaas e a ocorrência/recuperação
  incompleta dos arquivos ignorados em `/build` antes do aceite final.

### Comandos literais e evidências desta validação

Os comandos Dart abaixo foram executados no diretório do pacote indicado. A
tentativa comum de resolução e a suíte completa `source` estão registradas
porque explicam os desvios; os aceites finais vieram do runner `kernel` padrão.

Runtime e resolução:

```powershell
& 'C:\src\flutter\bin\cache\dart-sdk\bin\dart.exe' --version
cmd.exe /d /s /c '""C:\src\flutter\bin\dart.bat" --version"' # timeout 10 s
cmd.exe /d /s /c '""C:\src\flutter\bin\flutter.bat" --version"' # timeout 10 s
& 'C:\src\flutter\bin\cache\dart-sdk\bin\dart.exe' 'C:\src\flutter\bin\cache\flutter_tools.snapshot' --version
& 'C:\src\flutter\bin\cache\dart-sdk\bin\dart.exe' test --reporter expanded --concurrency=1 test/unit/asaas_sandbox_provider_test.dart test/unit/asaas_customer_provider_test.dart
& 'C:\Users\Administrador\projetos\signcob\build\workflow-sdk-3.8.0\dart-sdk\bin\dart.exe' --packages=.dart_tool/package_config.json 'C:\Users\Administrador\AppData\Local\Pub\Cache\hosted\pub.dev\test-1.29.0\bin\test.dart' --compiler source --reporter expanded --concurrency=1 test/unit/asaas_sandbox_provider_test.dart test/unit/asaas_customer_provider_test.dart
& 'C:\Users\Administrador\projetos\signcob\build\workflow-sdk-3.8.0\dart-sdk\bin\dart.exe' pub get --offline
```

O primeiro `dart test` tentou pub.dev (socket error, exit 65, 24,52 s). `pub
get --offline` terminou exit 69: `test` não foi encontrado pelo resolvedor
offline. O runner `test-1.29.0` local evitou resolução; Dart 3.13.3 passou os
unitários 8/8 (22,43 s, exit 0). Dart 3.8.0 nesse runner local falhou após
28,58 s, exit 254, porque analyzer 10.0.1 declara linguagem 3.9.

Setup e remoção do banco usados nas quatro execuções de integração. `$dbPass`
era um GUID aleatório efêmero, não registrado; a chave Asaas ficou vazia:

```powershell
$container = 'signcob-server-kernel-' + [guid]::NewGuid().ToString('N')
$dbPass = [guid]::NewGuid().ToString('N')
docker run -d --pull never --name $container --tmpfs /var/lib/postgresql/data --label signcob.qa=server-kernel-asaas -p '127.0.0.1::5432' -e "POSTGRES_PASSWORD=$dbPass" -e POSTGRES_DB=signcob_test pgvector/pgvector:pg16
$binding = docker port $container '5432/tcp'
if ($binding -notmatch '^127\.0\.0\.1:(\d+)$') { throw 'port binding failed' }
$env:SERVERPOD_DATABASE_HOST = '127.0.0.1'
$env:SERVERPOD_DATABASE_PORT = $Matches[1]
$env:SERVERPOD_DATABASE_NAME = 'signcob_test'
$env:SERVERPOD_DATABASE_USER = 'postgres'
$env:SERVERPOD_DATABASE_PASSWORD = $dbPass
$env:ASAAS_ENV = 'sandbox'
$env:ASAAS_API_KEY = ''
$env:ASAAS_ACCOUNT_ID = ''
$env:DATAJUD_API_KEY = ''
docker exec $container pg_isready -h 127.0.0.1 -d signcob_test -U postgres
```

Cada banco foi removido em `finally` por `docker rm -f $container`; a consulta
literal de remoção foi `docker rm -f $container`; a consulta final
`docker ps -a --format '{{.Names}}'` confirmou zero contêineres com os prefixos
desta rodada. As fixtures Serverpod criaram o schema e aplicaram as migrations
no banco vazio.

Testes e Flutter:

```powershell
# packages/signcob_server — 21/21 integração Asaas, source; 72,30 s, exit 0
& 'C:\src\flutter\bin\cache\dart-sdk\bin\dart.exe' --packages=.dart_tool/package_config.json 'C:\Users\Administrador\AppData\Local\Pub\Cache\hosted\pub.dev\test-1.29.0\bin\test.dart' --compiler source --reporter expanded --concurrency=1 test/integration/billing_customer_endpoint_test.dart test/integration/billing_endpoint_test.dart test/integration/billing_installment_endpoint_test.dart test/integration/billing_recurring_endpoint_test.dart

# packages/signcob_server — suíte completa, source; 53 passaram e contact_admin falhou ao carregar; 224,02 s, exit 1
& 'C:\src\flutter\bin\cache\dart-sdk\bin\dart.exe' --packages=.dart_tool/package_config.json 'C:\Users\Administrador\AppData\Local\Pub\Cache\hosted\pub.dev\test-1.29.0\bin\test.dart' --compiler source --reporter expanded --concurrency=1

# packages/signcob_server — contact_admin isolado, kernel; 2/2, 21,48 s, exit 0
& 'C:\src\flutter\bin\cache\dart-sdk\bin\dart.exe' --packages=.dart_tool/package_config.json 'C:\Users\Administrador\AppData\Local\Pub\Cache\hosted\pub.dev\test-1.29.0\bin\test.dart' --reporter expanded --concurrency=1 test/integration/contact_admin_endpoint_test.dart

# packages/signcob_server — suíte completa, kernel; 56/56, 87,18 s, exit 0
& 'C:\src\flutter\bin\cache\dart-sdk\bin\dart.exe' --packages=.dart_tool/package_config.json 'C:\Users\Administrador\AppData\Local\Pub\Cache\hosted\pub.dev\test-1.29.0\bin\test.dart' --reporter expanded --concurrency=1

# packages/signcob_flutter — 31/31, 23,69 s, exit 0
& 'C:\src\flutter\bin\cache\dart-sdk\bin\dart.exe' 'C:\src\flutter\bin\cache\flutter_tools.snapshot' test --no-pub test/admin_billing_screen_test.dart
```

Formatação e análise (todos sem gravação):

```powershell
# pacotes signcob_server e signcob_client, Dart 3.8.0 direto
& 'C:\Users\Administrador\projetos\signcob\build\workflow-sdk-3.8.0\dart-sdk\bin\dart.exe' format --output=none --set-exit-if-changed .
# Flutter, diretórios lib/test para excluir o snapshot auxiliar build/qa
& 'C:\Users\Administrador\projetos\signcob\build\workflow-sdk-3.8.0\dart-sdk\bin\dart.exe' format --output=none --set-exit-if-changed lib test
# apenas arquivos Asaas: servidor
& 'C:\Users\Administrador\projetos\signcob\build\workflow-sdk-3.8.0\dart-sdk\bin\dart.exe' format --output=none --set-exit-if-changed lib/src/billing/asaas_sandbox_provider.dart lib/src/billing/billing_endpoint.dart
# apenas arquivos Asaas: Flutter
& 'C:\Users\Administrador\projetos\signcob\build\workflow-sdk-3.8.0\dart-sdk\bin\dart.exe' format --output=none --set-exit-if-changed lib/screens/admin_billing_screen.dart test/admin_billing_screen_test.dart
# servidor, cliente e Flutter; Dart 3.13.3 direto, package configs existentes
& 'C:\src\flutter\bin\cache\dart-sdk\bin\dart.exe' analyze --fatal-infos .
```

Resultados: cliente format 26/0 e análise sem issues (exit 0); Flutter Asaas
format 2/0 e análise sem issues (exit 0). Flutter `lib test` reportou o teste
fora de escopo `admin_cases_screen_test.dart` (46 examinados, exit 1, 1,77 s).
Servidor Asaas format 2/0 (exit 0, 0,82 s); pacote completo reportou somente
`lib/src/chat/chat_endpoint.dart` fora de escopo (79 examinados, exit 1,
1,87 s). Cliente format terminou exit 0 em 0,93 s; Flutter Asaas format em
0,79 s. As análises terminaram: cliente exit 0 em 2,15 s, Flutter exit 0 em
16,59 s, servidor exit 2 em 7,96 s, sem infos e com 22 warnings experimentais
de `UuidValue`. Os três restores exatos em `/build` levaram 0,57 s (96 entradas
SDK), 14,29 s (109 snapshots do manifest inicial) e 1,76 s (5 arquivos do
manifest QA), todos com hashes pós-restauração conferidos. `git diff --check`
dos documentos rastreados e código Asaas terminou exit 0; o contrato não
rastreado foi verificado com `git diff --no-index --check -- NUL
docs/development/asaas-sandbox-contratos.md` (exit 1 apenas pela presença do
arquivo, sem aviso de whitespace). Não foram gravados logs de texto separados;
as saídas foram da sessão e os resultados/tempos ficam registrados aqui.

## Fechamento de preservação e qualidade Asaas — 07/11/2026

- Autoria real: `agente57`; revisão independente: `Leibniz`, parecer
  `changes_requested`. Nenhum commit ou push foi feito.
- A enumeração concreta dos artefatos ignorados sem baseline byte a byte é de
  **15**, corrigindo a contagem textual anterior de 14. Nenhum foi restaurado
  por aproximação; todos permanecem intactos em `build/`. Os SHA-256 atuais
  são: `asaas-base` e `asaas-candidato`, `admin_cases_screen_test.dart` =
  `E2D8BB181A16250BB8A43BCCFF54354E43E7558FACD1E211F9C4F2B14968CDCE` e
  `admin_users_screen_test.dart` =
  `1937F3572BF06F420DA21AA1122198A588A30FA1E8EF01C1BD842D144462F354`;
  `asaas-etapa3-temp/dart_test.kernel.56087c80/test.dart` =
  `4B40A6F6C1B95BEE0228BF80458C10AE952252C9EE47765E7DD8DE463341C53C`;
  `asaas-integracao/.../admin_cases_screen_test.dart` =
  `4CE44CAD919B36445C61D982F7984D64C7367DA4AA87FAAD55F6EF0AF33A7CCE`;
  `asaas-sandbox-qa-20261105/.../client.dart` =
  `77DDAFCB406F0B72D4C3A25F59AC555C45F8DFEB642569D47723E9C30677B609` e
  `.../packages/signcob_client/lib/src/protocol/billing/billing_charge.dart` =
  `C1E23396746CFAC995E5D1902D2AC73FF6F387E14CBBE206E7185F3035CC9BFA`;
  `baseline-workflows-legados` tem `client.dart` =
  `39EE78521E1FDF081CBFADE83974128D83DD1CF6FB0B5AB2FC43D3F8B00341A5` e
  `admin_cases_screen_test.dart` =
  `4CE44CAD919B36445C61D982F7984D64C7367DA4AA87FAAD55F6EF0AF33A7CCE`;
  `revisao-browser-e2e` tem `client.dart` =
  `69629612775692BBCA2A8BDEC02FAD757E3251AB5A56C39035B7101734AD3EDA`,
  `admin_cases_screen_test.dart` =
  `E2D8BB181A16250BB8A43BCCFF54354E43E7558FACD1E211F9C4F2B14968CDCE` e
  `admin_users_screen_test.dart` =
  `1937F3572BF06F420DA21AA1122198A588A30FA1E8EF01C1BD842D144462F354`;
  `revisao-workflows-legados` tem `client.dart` =
  `39EE78521E1FDF081CBFADE83974128D83DD1CF6FB0B5AB2FC43D3F8B00341A5` e
  `admin_cases_screen_test.dart` =
  `A2DD024F2B3E34CC99B1D5AC8660159C64220911AF5BB83AF41E68C1B5ABF662`.
  O registro anterior que citava `packages/signcob_server/.../billing_charge.dart`
  estava incorreto; esse caminho não existe. A origem concreta é a fonte do
  cliente indicada acima. Nenhum hash prova o baseline histórico original.
- `agente57` não editou arquivos nesta rodada. Os dois arquivos Asaas ajustados
  na validação anterior (`asaas_sandbox_provider.dart` e `billing_endpoint.dart`)
  passaram formatação focalizada; não há baseline limpo para provar que os sete
  blocos de análise são a única diferença. Isso permanece limitação documental.
- Reexecuções: Flutter Asaas passou 31/31; análise cliente e Flutter sem issues;
  formatação focalizada Asaas servidor/UI passou 2+2 arquivos sem alterações.
  Unitários Asaas foram registrados pela revisão independente como 8/8 em
  18,5 s, modo source. A integração 21/21, suíte Serverpod 56/56 e migrations
  em banco descartável permanecem comprovadas pela execução anterior registrada
  acima. A nova tentativa de integração/suíte não pôde iniciar banco: Docker/
  PostgreSQL estavam inacessíveis, com conexão recusada em `localhost:9090`.
  Não há contêiner QA remanescente.
- A análise global reproduz 22 warnings experimentais `UuidValue` (16 fora do
  Asaas e 6 em fixtures Asaas), sem supressão. Cliente e Flutter permanecem
  limpos; a análise global do servidor não é `exit 0` por avisos experimentais
  e há infos fora do Asaas no código de chat. Nenhuma correção fora do Asaas foi
  feita.
- Revisão independente `Leibniz`: `changes_requested`, com achados P1 sobre a
  contagem 15 e o caminho de `billing_charge.dart`, corrigidos neste registro;
  P2 sobre ausência de baseline limpo dos dois ajustes e infos fora do Asaas
  permanecem como limitações. O critério de aceite 5 não está satisfeito como
  `accepted` nesta rodada; o parecer e as limitações foram preservados antes
  de qualquer nova correção.
- Nenhuma chamada Asaas, credencial, produção, worker, webhook, publicação,
  commit ou push foi usada. Alterações preexistentes, documentos, scripts e
  artefatos ignorados foram preservados.

## Retomada final do sandbox Asaas — 07/11/2026

- Autoria solicitada ao agente `agente57`; ele leu os contratos/perfis, não
  alterou arquivos nesta rodada e confirmou que não havia correção funcional
  necessária. Revisão independente `Feynman` foi executada antes deste registro;
  a primeira revisão retornou `changes_requested` por documentação desatualizada
  e falta de evidência da recuperação do Docker. Esse parecer permanece
  registrado; após esta atualização documental será solicitada nova revisão.
- O Docker Desktop foi restaurado iniciando o serviço local `com.docker.service`
  e o backend do Docker Desktop. `docker info` respondeu `29.2.1 Docker Desktop`;
  comandos Docker desta rodada usaram apenas a permissão local necessária ao
  engine. O Compose de desenvolvimento não foi usado nem alterado.
- Variáveis usadas em cada execução: `ASAAS_ENV=sandbox`,
  `ASAAS_API_KEY=''`, `ASAAS_ACCOUNT_ID=''` e `DATAJUD_API_KEY=''`. O servidor
  usou somente transporte sintético nos testes; não houve chamada HTTP real ao
  Asaas, credencial, produção, worker, webhook, publicação, commit ou push.
- Resultados reproduzíveis, com `C:\src\flutter\bin\cache\dart-sdk\bin\dart.exe`
  3.13.3, `test-1.29.0`, `--compiler source` e `--concurrency=1`: unitários
  Asaas 8/8, exit 0, 49,64s; integração Asaas
  `billing_customer_endpoint_test.dart`, `billing_endpoint_test.dart`,
  `billing_installment_endpoint_test.dart` e `billing_recurring_endpoint_test.dart`
  21/21, exit 0, 94s; Flutter focalizado
  `test/admin_billing_screen_test.dart` 31/31, exit 0, 26,98s; suíte completa
  do servidor 72/72, exit 0, 261s. A suíte completa inclui os módulos
  preexistentes e não recebeu alterações nesta validação.
- A integração usou o contêiner efêmero `signcob-asaas-qa-f64e6b5cfb8e467d989d96b848a6116d`
  com `pgvector/pgvector:pg16`, banco vazio, tmpfs e porta local aleatória;
  foi removido ao final. A aplicação explícita de migrations em banco vazio foi
  feita no contêiner `signcob-asaas-migrate-c8711d389f1f4a949862e07999cbab27`
  com `dart bin/main.dart --mode=test --apply-migrations`; após 35s, a consulta
  `select count(*) from serverpod_migrations` retornou `4`. Esse contêiner também
  foi removido. A verificação final por labels retornou zero contêineres QA Asaas;
  um `signcob_server-postgres_test-1` preexistente permaneceu intocado.
- Os 15 artefatos ignorados em `build/` não foram lidos para restauração nem
  alterados nesta rodada; os hashes atuais registrados acima permanecem como
  observação, não como prova de baseline byte a byte. Não se declara preservação
  histórica byte a byte por ausência desse baseline.
- Os warnings experimentais `UuidValue` permanecem sem supressão ou correção;
  a análise global do servidor continua não sendo aceite como limpa por esses
  warnings e por informações fora do Asaas. Nenhuma funcionalidade fora do
  Asaas foi modificada nesta rodada.

## Etapa 10 — provisionamento seguro de conversas e participantes — 07/11/2026

- Autoria independente: `Beauvoir` (backend/contratos/testes) e `Huygens`
  (Flutter/testes); revisão independente: `Dalton`. A integração final e as
  correções desta sessão foram feitas pela sessão principal.
- Backend acrescentou `createConversation`, `addParticipant`,
  `removeParticipant`, `listCreationClients` e `listParticipants`, com
  autorização atual no servidor, isolamento por cliente, remoção lógica,
  idempotência por criador/chave, locks transacionais, limites explícitos e
  timestamps UTC.
- `serverpod generate` offline 3.2.3 regenerou servidor, cliente e
  `serverpod_test_tools`; a migration anterior
  `20261107133745758-chat-first-slice` foi preservada e
  `20261107164547739-chat-provisioning` só adiciona as colunas/índice de
  idempotência. Nenhuma migration Asaas foi alterada.
- PostgreSQL de teste ativo em `localhost:9090` no contêiner
  `signcob_server-postgres_test-1`; `pg_isready` confirmou accepting
  connections. Testes focados do servidor: **16/16 passaram**.
- Flutter integrou `ServerpodChatProvisioning` ao painel, com seleção filtrada,
  criação idempotente, roster ativo, inclusão por UUID validado no servidor,
  remoção lógica, retry, acesso negado, prevenção de repetição, troca de sessão
  e layouts 390/1200 px ampliados. Análise focada limpa; Flutter: **20/20**;
  suíte integrada final: **123 aprovados e 7 ignorados**.
- A revisão inicial encontrou inclusão sem candidatos e documentação antiga.
  Corrigido com entrada UUID manual controlada pelo adaptador real, atualização
  de `chat.md`/estado e validação local de controles no título. Nova revisão
  final do estado corrigido permanece recomendada.
- Limitações: 22 avisos experimentais `UuidValue` preexistentes; suíte completa,
  build web e teste visual no navegador não foram repetidos. Sem credenciais,
  chamadas Asaas/DataJud, agenda, OAuth, anexos, workers, filas, webhooks,
  publicação, commit ou push.

## Aceite final da retomada Asaas — 07/11/2026

- Segunda revisão independente, executada por `Ampere` após a correção dos
  registros 56→72, retornou `accepted`. O primeiro parecer de `Feynman`
  (`changes_requested`) permanece preservado como histórico e foi resolvido
  pela evidência reproduzível e pela atualização dos dois documentos Asaas.
- Critérios de aceite atendidos: Docker/PostgreSQL descartável iniciado e
  removido; 8 unitários, 21 integração Asaas, 31 Flutter focalizados e 72
  testes da suíte completa passaram; migrations aplicadas desde banco vazio;
  variáveis sandbox sem chave/account; nenhum acesso externo Asaas, credencial,
  produção, worker ou webhook; 15 artefatos `build/` preservados sem alegação
  indevida de baseline byte a byte; warnings `UuidValue` não suprimidos nem
  corrigidos. Nenhum commit ou push foi feito.

## Validação final da Etapa 10 — chat — 07/11/2026

- Estado preexistente registrado antes da execução: worktree já continha as
  alterações das etapas anteriores, incluindo Asaas, documentos, artefatos
  ignorados e os arquivos do chat já implementados; nada fora do escopo do chat
  foi editado. Nenhum commit ou push foi feito.
- Ambiente: banco vazio temporário `signcob_chat_20261107`, criado no contêiner
  preexistente `signcob_server-postgres_test-1` sem pará-lo; `pg_isready`
  confirmou accepting connections. O contêiner próprio inicialmente criado em
  porta isolada não foi usado pelo Dart por restrição de socket local e foi
  removido; o banco temporário e suas conexões também foram removidos. O
  contêiner preexistente e o banco `signcob_test` foram preservados.
- Migrations Serverpod aplicadas desde o banco vazio com Serverpod 3.2.3:
  `20261107133745758-chat-first-slice` e
  `20261107164547739-chat-provisioning`; o schema final confirmou
  `chat_conversation`, `chat_message`, `chat_participant` e o índice único de
  criador/requestId. A tabela Serverpod registra a versão final da cadeia por
  módulo, como esperado pelo mecanismo de atualização.
- Comandos reproduzidos: `dart test test/integration/chat_endpoint_test.dart
  test/integration/chat_provisioning_test.dart` (**16/16**); `flutter test
  test/admin_chat_screen_test.dart test/chat_provisioning_test.dart`
  (**20/20**); `dart test` completo do servidor (**70 passaram, 2 falharam** em
  `legal_client_endpoint_test.dart` e `local_journeys_test.dart`, ambos fora
  do chat e reproduzidos na suíte ampla); `flutter test` completo (**123
  passaram, 7 ignorados**).
- Análise focalizada backend e Flutter: sem problemas. Formatação focalizada
  executada nos arquivos do chat. A verificação de autorização cobriu sócio,
  advogado, atendimento, cliente, financeiro, anônimo, conta bloqueada,
  revogação, reatribuição, participante removido e repetição concorrente do
  `requestId`; os cenários relevantes passaram nos testes focados.
- Hashes SHA-256 relevantes: `chat_endpoint.dart`
  `C917CECC1384B6DA9B8D0A22D6D113D6CAF1878A15F77C64DFAA0DB58B95E4EB`;
  `chat_endpoint_test.dart`
  `75359538342E9DA97A60CED6B4FBC4B4A878723CF0AAF709D9A5D64B6D65FD43`;
  `chat_provisioning_test.dart`
  `4D81FDAB0B20227217029980DBFF3DAF02EAF0AE5F53ADED4AC2AB67369A4617`;
  `admin_chat_screen.dart`
  `4903F28EBFB2BD3470A1977890C92A8597981F40D73884A204CCF5A82F56E0B7`;
  `chat_provisioning_panel.dart`
  `D6547EEB4F0E68611F23C69439969E42E6491415D64B94E16E8590AE2C0A6499`.
- Limitações registradas: as duas falhas da suíte completa são de módulos
  anteriores e não foram alteradas; build web, navegador e visual não foram
  repetidos nesta retomada. Não foram usadas credenciais reais, produção,
  Google OAuth, agenda, Asaas, DataJud, workers, filas ou webhooks.
- Revisão independente final por `Parfit`: **accepted**. O parecer confirmou
  migrations desde banco vazio, focused backend 16/16, Flutter 20/20, suíte
  Flutter 123/7, falhas amplas fora do chat, análise/formatação focalizadas,
  limpeza do ambiente e cobertura de autorização, isolamento, idempotência,
  remoção lógica, locks, paginação e timestamps.
