# Contratos do incremento Asaas sandbox

Desenho de 05/11/2026, autoria `/root/asaas_backend` (perfis 02/12/13/15).
Etapas de implementação e revisão aceitas. A validação automatizada final foi
executada em 07/11/2026 com transporte sintético: 8 testes unitários, 21 testes
de integração Asaas e 72 testes na suíte completa do servidor passaram; a suíte
Flutter Asaas teve 31 testes aprovados. Os testes de integração aplicaram as
migrations em PostgreSQL/pgvector descartável. A disponibilidade real do
fornecedor, chamadas, emissão, liquidação e jornada real de cartão permanecem
`not_verified`. A análise local do servidor ainda reporta avisos experimentais
de `UuidValue`; a verificação global de formato também encontrou divergências
fora do módulo Asaas.

## Decisões e suporte do fornecedor

Usar a API v3 diretamente, somente `api-sandbox.asaas.com`; não aplicar limites
do plugin WooCommerce à API. A documentação da [criação de cobrança](https://docs.asaas.com/reference/create-new-payment)
e de [assinaturas](https://docs.asaas.com/reference/create-new-subscription) permite
`PIX`, `BOLETO` e `CREDIT_CARD` nos fluxos abaixo. Nenhum fluxo usa `UNDEFINED`.

| Fluxo | Pix | Boleto | Cartão | Dados adicionais |
|---|---|---|---|---|
| Única | sim | sim | sim, fatura hospedada | valor total e vencimento |
| Parcelada | sim | sim | sim, fatura hospedada | total e quantidade >=2; cartão até12 nesta versão sem conhecer bandeira |
| Recorrente | sim, Pix convencional por cobrança | sim | sim, fatura hospedada | valor por ciclo, primeira data, ciclo explícito |

A [API de parcelas](https://docs.asaas.com/docs/criar-uma-cobranca-parcelada)
retorna a primeira cobrança e o ID do grupo, e oferece consulta das parcelas.
O total é enviado em centavos convertido em reais, sem calcular juros; o fornecedor
distribui eventual diferença na última parcela. Limite interno conservador de60
parcelas para Pix/boleto e12 para cartão; não é promessa do limite da conta.
Recorrência usa ciclos oficiais WEEKLY, BIWEEKLY, MONTHLY, BIMONTHLY, QUARTERLY,
SEMIANNUALLY, YEARLY. Não é Pix Automático e não implica débito autorizado.
[Cartão pela fatura](https://docs.asaas.com/docs/cobrancas-via-cartao-de-credito)
evita capturar ou persistir cartão e CVV. Não criar regras de multa, juros,
desconto, cancelamento, estorno ou contestação; tais campos não são enviados.
Na recorrência com cartão, o contrato desta entrega é geração de cobranças
com fatura hospedada; não se promete que preencher a primeira fatura habilite
débito automático de ciclos futuros. O processamento depende da jornada e
configuração do fornecedor e deve ser validado no sandbox real.

## Fronteiras e contratos Serverpod

Serverpod/PostgreSQL mantém reservas e vínculos; adaptador faz chamadas HTTPS
com tempo limite e sem redirecionamentos; Flutter consome somente DTOs gerados.
Mudança de contrato interno da base anterior é integrada com app e testes juntos.

| Método billing | Entrada | Saída e comportamento |
|---|---|---|
| create | BillingCreateRequest | BillingCharge; reserva durável antes de POST |
| get | id local | BillingCharge com pagamentos individuais |
| list | kind (`debt`/`fees`), offset | até25 intenções, ordem IDdesc |
| findIntent | clientId, idempotencyKey | BillingCharge?; recuperação após perda da resposta |
| refresh | id local | consulta/concilia cliente, intenção e pagamentos; nunca POST de intenção incerta |
| resolveCustomer | clientId | BillingCustomerLink; cria/reutiliza ou informa pendência |
| reconcileCustomer | clientId | BillingCustomerLink; somente GET, não reenvia criação incerta |
| listClients | query, offset | até25 BillingClientOption(id,name,readyForBilling), sem documento |
| listNegotiations | clientId, kind | até100 BillingNegotiationOption(id,title,amountCents), sem conceder acesso ao módulo jurídico |

Todos exigem sessão e `billing.read` no token e banco atual. create, refresh,
resolveCustomer e reconcileCustomer também exigem `billing.write`. Bloqueados e
revogados são negados. Nenhum acesso de cliente externo ou concessão automática.

BillingCreateRequest contém clientId, negotiationId?, kind, method (pix/boleto/card),
flow (single/installment/recurring), amountCents, dueDate, idempotencyKey,
installmentCount? e cycle?. amountCents significa total no parcelamento e valor
por ciclo na recorrência; single não aceita quantidade/ciclo; installment exige
quantidade e rejeita ciclo; recurring exige ciclo e rejeita quantidade. Datas
calendárias estritas, valor positivo e limite9e12 centavos, chave ASCII1..128.
Negociação opcional deve pertencer ao cliente e ao mesmo kind. Aceite não cria
cobrança. Nenhum campo Asaas controlado pelo chamador.

BillingCharge contém campos da intenção, id, creationState, subscriptionStatus?,
providerGroupId?, status (da cobrança única; grupos não agregam baixa), datas e
clientName? para reconhecimento do pagador e List<BillingPayment>. Os campos novos
do DTO são nullable para registros legados, sem inferir meio/conta ou estado.
BillingPayment contém id local, providerPaymentId, valor, vencimento,
installmentNumber?, status, confirmedAt?, receivedAt?, invoiceUrl? validada HTTPS
do host sandbox. BillingCustomerLink contém clientId e state (linked/uncertain),
sem documentos, credenciais ou referências privadas. Campos financeiros só nas
cobranças individuais; subscriptionStatus representa somente a assinatura.

## Persistência e concorrência

- BillingCustomerRecord: ambiente, accountId, legalClientId, documento normalizado
  em snapshot, externalReference aleatório estável, providerCustomerId?, state,
  createdAt/updatedAt. Chave única ambiente/conta/cliente, provider ID único por
  ambiente/conta e documento único por ambiente/conta. Nenhuma identificação
  apenas por nome/e-mail. Dois clientes SignCob com mesmo documento não são
  associados silenciosamente: conflito exige corrigir a identidade cadastral.
- BillingChargeRecord evolui aditivamente: environment/accountId, kind/method/flow,
  installmentCount/cycle, providerCustomerId, externalReference e providerGroupId,
  creationState e subscriptionStatus. Registros antigos sem conta ficam visíveis
  localmente mas não são enviados/conciliados automaticamente por conta presumida.
- BillingPaymentRecord: FK intenção, ambiente/conta, providerId único nesse escopo,
  valor/vencimento/número/status, confirmedAt/receivedAt, invoiceUrl e datas.
- Reserva por bloqueio `FOR UPDATE` do cliente serializa cliente e chave; POST
  ocorre depois do commit. Repetir chave idêntica retorna reserva, divergência
  retorna idempotency_conflict. O registro da intenção congela parâmetros.
- Reserva de cliente também toma advisory lock transacional por ambiente/conta/
  documento normalizado antes de consultar vínculo existente. O índice único de
  documento impede corrida entre dois IDs SignCob com o mesmo CPF/CNPJ.
- Cada operação externa comprova a conta com a própria chave por
  [GET myAccount/status](https://docs.asaas.com/reference/check-account-registration-status)
  e compara `id` ao ASAAS_ACCOUNT_ID configurado. O [exemplo oficial](https://docs.asaas.com/docs/onboarding-and-sending-documents-via-link)
  documenta esse id. Só aceita sandbox+prefixo hmlg; troca de conta não adota
  reservas anteriores. Rotação de chave da mesma conta preserva vínculo.

## Reutilização e recuperação

Cadastro exige nome e CPF/CNPJ estruturalmente válido do cliente SignCob; dados
extra são minimizados e notificações desabilitadas. Consulta por CPF/CNPJ antes
de criar e compara exatamente documento. Um único cadastro inequívoco pode ser
reutilizado; múltiplos resultados entram em conflito, sem escolher o primeiro.
Outra vinculação local do mesmo cadastro é recusada. Nome/e-mail não decidem.

Reserva cliente é persistida antes de consulta/criação. Após falha incerta,
repetição não faz POST. Conciliação busca por externalReference e documento,
percorrendo páginas; somente match único exato é ligado. Resultado vazio mantém
pendente, pois não prova inexistência após timeout. [Cadastro oficial](https://docs.asaas.com/docs/criando-um-cliente)
permite duplicidades e pede consulta após timeout; externalReference não é unique.
O marcador createAttempted é persistido antes do POST. Se for verdadeiro,
conciliação exige também nossa referência exata no único resultado da busca
ampla por documento. Se for falso, sabe-se que nenhum POST foi iniciado, e
um cadastro antigo único pode ser ligado após falha apenas na consulta inicial.

Cobrança incerta é conciliada pela [listagem de pagamentos](https://docs.asaas.com/reference/list-payments)
com referência+cliente e parâmetros exatos. Parcelamento adota um único grupo
compatível e depois lista todas parcelas. Assinatura usa [listagem de assinaturas](https://docs.asaas.com/reference/listar-assinaturas)
com referência+cliente e confere método, valor, data/ciclo; depois consulta seus
pagamentos. Paginação obrigatória com limite defensivo: se incompleta, falha
segura sem aprovar unicidade. Nenhum zero/múltiplos resultados permite reenviar.
O cliente é resolvido antes de reservar a intenção. `customer_uncertain` exige
reconcileCustomer (somente GET) e não deixa reserva de cobrança. Após vínculo
comprovado, create com a mesma chave pode reservar a primeira tentativa de
cobrança. `creation_uncertain` indica que a própria cobrança já foi reservada:
findIntent recupera o ID e refresh apenas consulta, sem repetir criação.
Conciliação e aplicação de observações são serializadas na intenção, e pagamentos
são upsertados pela identidade do fornecedor, preservando datas já observadas.

Não haverá webhook neste incremento: consultas são explícitas na UI, sem polling
ou workers. Assim não há entrada de eventos não autenticados. As associações de
conta, cliente, referência, grupo e parâmetros são verificadas antes de persistir.
Estado atual desconhecido/estorno/contestação é exibido como necessidade de
atenção sem baixa automática e sem inventar transições financeiras.

## Estados

Criação: awaitingProvider -> active; falha ambígua permanece awaitingProvider.
Resultado ambíguo da intenção exige ação Conciliar, nunca nova chave automática.
Cliente reservado/uncertain -> linked apenas após prova única de identidade.
Assinatura armazena ACTIVE/INACTIVE/EXPIRED como estado próprio, sem cancelar
ou confirmar seus pagamentos.

Pagamento: awaitingProvider -> pending -> overdue; pending/overdue -> confirmed
-> received, ou pending/overdue -> received diretamente. Datas confirmedAt e
receivedAt são separadas, capturadas na primeira observação autenticada. RECEIVED
sem CONFIRMED anterior não fabrica confirmação observada. Eventos repetidos ou
atrasados não regridem status/data de confirmação ou recebimento. Nenhuma criação
atribui confirmação por si só; somente status financeiro observado do fornecedor.

## Plano de testes e marcos

| Critério | Cenários controlados e verificações |
|---|---|
| ASAAS-01 | método/fluxo e campos incompatíveis recusados antes de IO; debt/fees e negociação coerentes; payloads single/parcelas/recorrência |
| ASAAS-02 | vínculo reutilizado, identidade/documento/account mismatch negados, credencial/host sandbox, consultas mínimas só financeiro |
| ASAAS-03 | chamadas concorrentes, duplicidade remota em páginas distintas, timeout cliente e reconciliação única/zero/múltiplos, zero POST repetido |
| ASAAS-04 | confirmado/recebido separados; recebido direto; repetido/atrasado; parcelas e ciclos financeiros independentes |
| ASAAS-05 | sem webhook; GET autenticado, customer/group/reference/account conferidos, status fora escopo em atenção sem efeitos financeiros |
| ASAAS-06 | generate+create-migration Serverpod; aplicação em banco descartável; integração permissões/revogação/chave divergente/timeout; análise/format/testes; revisão separada |

Marcos sequenciais: contrato revisado; cliente e testes; única e testes;
parcelas e testes; recorrência e testes; estados/conciliação e testes;
interface integrada; suíte final+revisão. Testes substituem transporte/fornecedor
e usam dados sintéticos. Sem credencial/configuração externa, chamadas reais,
faturas reais, emissão Pix/boleto e liquidação sandbox ficam `not_verified`.
