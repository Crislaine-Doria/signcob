# Cobranças Asaas em sandbox

O módulo de cobranças é interno. O servidor verifica as permissões vigentes
`billing.read` para consulta e `billing.read` mais `billing.write` para
criação e atualização. A sessão de um cliente externo não recebe essas
permissões. Nenhuma conta recebe acesso automaticamente nesta entrega.

| Operação Serverpod | Comportamento |
|---|---|
| `billing.create` | Recebe o ID do cliente, o ID opcional da negociação, o valor em centavos, o vencimento em `AAAA-MM-DD` e a chave de idempotência. Se houver negociação, ela deve pertencer ao cliente informado. |
| `billing.get` | Consulta o registro local pelo ID da cobrança. |
| `billing.refresh` | Consulta o fornecedor para atualizar o estado de uma cobrança existente. O chamador informa apenas o ID da cobrança. |

O aceite de uma negociação registra somente o aceite. A cobrança requer
uma chamada explícita ao endpoint de criação.

## Repetição e falhas

Use a mesma chave de idempotência para a mesma intenção de cobrança.
A chave é única por cliente. Uma repetição com os mesmos dados reutiliza
o registro e uma repetição com dados divergentes retorna conflito.
O servidor persiste a reserva antes de chamar o fornecedor. Se houver
falha ambígua depois da reserva, repetir a operação não reenvia a criação.
O registro permanece em `awaitingProvider` até a conciliação. Preserve a
chave e o registro. Gerar uma nova chave nesse
caso representa uma nova intenção e pode duplicar a cobrança.

| Código de erro | Significado |
|---|---|
| `invalid_input` | Valor, vencimento ou chave em formato inválido. |
| `idempotency_conflict` | A chave já existe para o cliente com outros dados. |
| `creation_disabled` | A criação no adaptador Asaas está desabilitada. |
| `creation_uncertain` | A reserva existe e requer conciliação. |
| `provider_configuration` / `provider_authentication` | A configuração local é inválida ou a credencial foi recusada. |
| `provider_unavailable` / `provider_response` | A consulta ao fornecedor falhou ou a resposta foi inválida. |
| `unsupported_status` / `invalid_transition` | O estado do fornecedor está fora do escopo ou a mudança violaria a transição permitida. |

## Configuração e validação

O adaptador usa `ASAAS_ENV=sandbox` e a credencial `ASAAS_API_KEY` do servidor.
O destino HTTPS é fixo em `api-sandbox.asaas.com`. O adaptador retorna erros
seguros para configuração ausente ou inválida e rejeições de autenticação.
Para rodar a suíte controlada, deixe a chave vazia. Os testes substituem
o transporte e o fornecedor e usam um PostgreSQL descartável para verificar
o contrato e a persistência.

Na pasta `packages/signcob_server`, com o SDK Dart do CI e as dependências
resolvidas, execute:

```text
dart format --set-exit-if-changed .
dart analyze --fatal-infos
dart test --reporter expanded --concurrency=1
```

Para os testes de integração, use um PostgreSQL 16 com pgvector descartável
e informe a conexão com `SERVERPOD_DATABASE_HOST`, `SERVERPOD_DATABASE_PORT`,
`SERVERPOD_DATABASE_NAME`, `SERVERPOD_DATABASE_USER` e
`SERVERPOD_DATABASE_PASSWORD`. Os testes aplicam as migrations nesse banco.

A criação pelo adaptador Asaas fica bloqueada até a decisão sobre as
modalidades aceitas e o mapeamento seguro entre o cliente SignCob e o cliente
Asaas. A base reconhece os estados pendente e vencido. Estados iguais são
repetíveis e a transição permitida é de pendente para vencido. A decisão
de negócio sobre o evento que confirma o pagamento no sandbox ainda está
pendente. Os sinais de confirmação ou recebimento do fornecedor ainda não
marcam uma cobrança como paga.

- [Ambientes da API Asaas](https://docs.asaas.com/reference/about-this-doc)
- [Autenticação na API Asaas](https://docs.asaas.com/docs/authentication-2)
- [Consulta de estado da cobrança](https://docs.asaas.com/reference/retrieve-status-of-a-payment)
- [Eventos de cobrança](https://docs.asaas.com/docs/payment-events)
