# Configuração local em .env

O servidor carrega `packages/signcob_server/.env` ao iniciar por `bin/main.dart`,
executado a partir da pasta do servidor. Prepare o arquivo local a partir de
`.env.example` e configure apenas as integrações necessárias no ambiente.
Não copie credenciais do legado nem inclua segredos no controle de versão.

Para configurar `DATAJUD_API_KEY`, altere o arquivo local e reinicie o servidor.
Variáveis do processo têm precedência, inclusive quando explicitamente vazias. A chave
nunca é enviada ao Flutter. `.env` está ignorado; `.env.example` pode ser versionado.

Formato aceito: KEY=value, comentários em linhas iniciadas por #, valores literais
entre aspas simples ou duplas. Não há expansão de variáveis, comandos, escapes ou
comentários no fim da linha. Entradas duplicadas ou malformadas impedem a partida
com erro que informa somente a linha, sem revelar valores.

Mantenha `ASAAS_API_KEY` vazia durante os testes controlados.
`ASAAS_ENV=sandbox` seleciona o único ambiente aceito pelo adaptador.
O contrato e os limites desta etapa estão no [guia de cobranças](cobrancas-asaas.md).
