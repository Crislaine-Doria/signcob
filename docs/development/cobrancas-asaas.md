# Cobranças Asaas em sandbox

O módulo de cobranças é interno. O servidor verifica as permissões vigentes
`billing.read` para consulta e `billing.read` mais `billing.write` para
criação e atualização. A sessão de um cliente externo não recebe essas
permissões. Nenhuma conta recebe acesso automaticamente nesta entrega.

| Operação Serverpod | Comportamento |
|---|---|---|
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
|---|---|---|
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

## Decisões confirmadas em 05/11/2026

O responsável definiu:

- Pix, boleto e cartão, com cobrança única, parcelada e recorrente, para os
  fluxos de dívidas e honorários/serviços. Cada combinação deve respeitar o
  suporte do fornecedor; escolher todas as modalidades não presume que toda
  combinação entre meio e periodicidade seja válida na API.
- O pagador é o cliente cadastrado no SignCob. O próprio SignCob deve criar
  ou reutilizar o cadastro correspondente no Asaas.
- Pagamento confirmado e valor recebido terão estados separados:
  `PAYMENT_CONFIRMED` representa confirmação com saldo ainda indisponível;
  `PAYMENT_RECEIVED` representa recebimento com valor disponível.

Estas decisões orientam o incremento implementado em sandbox. O adaptador usa
somente a API sandbox configurada no servidor; a tela não inicia cobrança ao
aceitar negociação. Não há autorização para produção, cobrança real, importação
de clientes do legado ou envio automático de cobrança ao aceitar negociação.

## Critérios e estado da entrega

As etapas de implementação e revisão foram aceitas. Os testes controlados usam
transporte sintético; a disponibilidade real do fornecedor, emissão e liquidação
no sandbox não foram verificadas. A validação automatizada final foi executada
em 07/11/2026: 8 testes unitários e 21 de integração Asaas no servidor, 31 testes
Flutter Asaas e 72 testes na suíte completa do servidor passaram. Os testes de
integração usaram PostgreSQL/pgvector descartável e transporte sintético; não
representam chamadas, emissão ou liquidação reais no Asaas. A análise local do
servidor ainda reporta avisos experimentais de `UuidValue`, e a verificação
global de formato tem divergências fora do módulo Asaas.

| ID | Critério verificável | Estado |
|---|---|
| ASAAS-01 | A intenção informa meio e fluxo (única, parcelada ou recorrente); dados incompatíveis são recusados antes de IO. Dívidas e honorários continuam separados. | Implementado; testes sintéticos no repositório. |
| ASAAS-02 | O servidor resolve o pagador pelo cliente SignCob e persiste vínculo por ambiente/conta. Nome ou e-mail isolado não comprova identidade. | Implementado; testes sintéticos no repositório. |
| ASAAS-03 | Repetição/concorrência não duplica clientes; resultado incerto é conciliado antes de qualquer nova criação. | Implementado; testes sintéticos no repositório. |
| ASAAS-04 | Confirmação e recebimento são separados; `PAYMENT_RECEIVED` direto não fabrica confirmação; observações atrasadas não regridem estado nem duplicam pagamento. | Implementado; testes sintéticos e suíte final do servidor aprovados em 07/11/2026. |
| ASAAS-05 | Sem webhook neste incremento. Refresh autenticado verifica conta e associações; estados desconhecidos ficam em atenção sem baixa automática. Estorno/contestação seguem sem transição financeira automática. | Implementado por consulta explícita; webhook fora do escopo. |
| ASAAS-06 | Contratos e migrations são gerados pelo Serverpod; permissões e recuperação são cobertas por testes sintéticos; revisão técnica separada da autoria. | Implementado/revisado; testes focados Asaas (8 unitários, 21 integração, 31 Flutter) e suíte completa do servidor (72) passaram em 07/11/2026; análise local do servidor mantém avisos experimentais. |

O contrato detalhado está em [asaas-sandbox-contratos.md](asaas-sandbox-contratos.md).
Não se deve repetir automaticamente a criação em resultado incerto.

- [Ambientes da API Asaas](https://docs.asaas.com/reference/about-this-doc)
- [Autenticação na API Asaas](https://docs.asaas.com/docs/authentication-2)
- [Consulta de estado da cobrança](https://docs.asaas.com/reference/retrieve-status-of-a-payment)
- [Eventos de cobrança](https://docs.asaas.com/docs/payment-events)
