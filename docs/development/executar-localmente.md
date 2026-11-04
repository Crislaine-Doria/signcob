# Executar localmente

Pré-requisitos: Flutter com Dart >=3.8 <4 e Docker Desktop ativo.
Na raiz, execute `dart pub get`.

Dentro de `packages/signcob_server`:

Os segredos locais ficam em `config/passwords.yaml`, ignorado pelo Git. Antes de
subir os bancos, exporte `SIGNCOB_POSTGRES_PASSWORD` e
`SIGNCOB_POSTGRES_TEST_PASSWORD` com os valores de `database` dos respectivos
ambientes nesse arquivo. Para volumes existentes, mantenha as senhas já
configuradas. Se habilitar Redis, configure também
`SIGNCOB_REDIS_PASSWORD` e `SIGNCOB_REDIS_TEST_PASSWORD` com os valores
correspondentes. O runner isolado de E2E gera suas próprias senhas.

```powershell
docker compose up -d postgres postgres_test
# Somente na primeira preparação do volume:
docker compose exec -T postgres createdb -U postgres signcob_dev
dart pub get
dart bin/main.dart --apply-migrations
```

Se createdb informar que signcob_dev já existe, reutilize esse banco.
A configuração de desenvolvimento usa signcob_dev para preservar o banco
signcob preexistente, cujo histórico referencia uma migration ausente no código.
Não apague volumes nem faça repair automático nesse banco antigo.

Servidor: API em http://localhost:8080 e página em http://localhost:8082.
Para testes do servidor, execute `dart test` nessa mesma pasta.
Para parar o servidor, use Ctrl+C; para parar os bancos, `docker compose stop`.

Na raiz, `dart run melos run analyze`, `dart run melos run test:server` e
`dart run melos run test:flutter` oferecem atalhos. Esses atalhos não iniciam bancos.

No ambiente observado, dart.bat demorou para responder. O executável direto
`C:/src/flutter/bin/cache/dart-sdk/bin/dart.exe` funcionou com Dart 3.13.3.
