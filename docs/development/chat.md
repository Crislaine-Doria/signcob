# Chat interno

Implementação mínima de conversa interna autenticada. Esta etapa cobre listagem
de conversas acessíveis, leitura paginada e envio de texto. A autorização é
reavaliada no servidor em cada operação; filtros da interface e dados antigos do
token não substituem o estado atual da identidade e dos vínculos.

## Modelo e invariantes

- `ChatConversation`: título, vínculo opcional com `LegalClient` e criação em
  UTC. O vínculo com processo foi deliberadamente omitido porque não é necessário
  para aplicar as regras desta fatia e exigiria um novo invariante cruzado.
- `ChatParticipant`: conversa, UUID textual normalizado da identidade, criação em
  UTC e `removedAt` opcional. O par conversa/identidade é único; remoção é lógica.
- `ChatMessage`: conversa, UUID do autor autenticado, texto e criação em UTC.
  Autor e timestamp são sempre definidos pelo servidor.
- Texto é normalizado com `trim`, deve conter de 1 a 4.000 caracteres e não é
  registrado integralmente em logs pela implementação do chat.
- Mensagens são ordenadas por `createdAt DESC, id DESC`. Conversas são ordenadas
  por `createdAt DESC, id DESC`. Os índices seguem essas chaves de isolamento e
  paginação.
- Não há exclusão física, anexos, edição ou criação pública de conversas nesta
  fatia.

## Matriz de acesso

O projeto ainda não possui um campo persistido de perfil. Os limites abaixo são
representados por capacidades explícitas atuais e pelos vínculos já existentes;
nenhum papel é inferido por e-mail, ordem de cadastro ou nome informado pelo app.

| Capacidade | Regra no servidor |
|---|---|
| `chat.partner` | Acessa as conversas do escritório. Integra o pacote explícito do perfil sócio. |
| `chat.lawyer` | Acessa somente conversa vinculada a `LegalClient.assignedLawyerId` igual à identidade atual. |
| `chat.support` | Acessa somente conversa com `ChatParticipant` ativo para a identidade atual. |
| `chat.client` | Exige participante ativo e `LegalClient.ownerAuthUserId` igual à identidade atual. |
| Sem capacidade, inclusive financeiro por padrão | Acesso negado. |

As capacidades precisam existir tanto na sessão quanto no `AuthUser` atual.
Conta bloqueada, capacidade revogada, participante removido, titular desvinculado
ou cliente reatribuído perde acesso na operação seguinte, sem depender da emissão
de outro token. Contas com mais de uma capacidade recebem a união apenas dos
vínculos que cada capacidade autoriza. Um registro de remoção prevalece sobre
qualquer capacidade naquela conversa, inclusive sócio e advogado atribuído.

## Endpoints

Todos os métodos de `chat` exigem login e retornam erro genérico para recurso
inexistente ou alheio, sem confirmar a existência de outra conversa.

| Método | Entrada | Resultado |
|---|---|---|
| `listConversations` | `offset`, `limit` | Conversas autorizadas, filtradas e paginadas no PostgreSQL. |
| `listMessages` | `conversationId`, `offset`, `limit` | Mensagens da conversa após nova verificação de acesso. |
| `sendMessage` | `conversationId`, `content` | Mensagem persistida com autor autenticado e hora UTC do servidor. |
| `createConversation` | `legalClientId`, `title`, `requestId` | Conversa vinculada a um cadastro existente. Uma repetição válida retorna a mesma conversa. |
| `addParticipant` | `conversationId`, `authUserId` | Participação ativa, existente ou recém-inserida. |
| `removeParticipant` | `conversationId`, `authUserId` | Registra a remoção lógica. Uma repetição por administrador ainda autorizado preserva o instante original. |
| `listCreationClients` | `offset`, `limit` | Clientes que o chamador pode usar para uma nova conversa, filtrados no servidor. |
| `listParticipants` | `conversationId`, `offset`, `limit` | Participantes ativos da conversa após nova autorização. |
| `listCreationClients` | `offset`, `limit` | Clientes que o chamador pode usar na criação, com ID estável e nome cadastrado. |
| `listParticipants` | `conversationId`, `offset`, `limit` | Participantes ativos de uma conversa que o chamador pode ler, identificados pelo UUID persistido. |

O servidor aceita páginas de 1 a 50 itens; a interface usa 25. `offset` não pode
ser negativo. A tela oferece carregamento, vazio, falha recuperável, acesso
negado, seleção responsiva, paginação, envio único em andamento e descarte do
estado ao trocar a sessão.

## Provisionamento autenticado

- Sócio cria para qualquer cliente existente e administra conversas vinculadas.
  Pode incluir sócio, atendimento, advogado atualmente atribuído ou titular
  atual, desde que a conta esteja ativa e tenha a capacidade correspondente.
- Advogado cria e administra pelo vínculo atual de atribuição. Pode incluir o
  titular atual, o advogado atribuído e atendimento. A gestão de participante
  com capacidade atual de sócio cabe a outro sócio ou ao próprio participante.
- Atendimento com participação ativa pode incluir ou remover o titular atual
  na própria conversa e remover a própria participação. Sócio e advogado
  atribuído provisionam a entrada de atendimento. O titular com capacidade de
  sócio ou com atribuição e capacidade de advogado fica sob gestão de sócio
  ou do advogado atribuído, conforme a regra acima.
- O título recebe `trim`, aceita de 1 a 120 unidades UTF-16 e rejeita controles
  ASCII internos. `requestId` e `authUserId` usam a forma canônica de UUID, com
  letras normalizadas. O UUID do participante identifica apenas o alvo da
  operação. O ator vem da sessão autenticada.
- `requestId` é único por criador. O solicitante reutiliza a mesma chave e os
  mesmos dados normalizados para repetir a criação. A autorização continua
  obrigatória em cada tentativa. Criador e chave ficam no servidor e os
  registros antigos continuam válidos com os novos campos nulos.
- Participação removida fica registrada e não é reativada por `addParticipant`.
  A gestão usa bloqueio da linha da conversa para serializar inclusões e
  remoções. A leitura de mensagens e o envio usam bloqueio compartilhado na
  mesma linha. A atribuição e a titularidade são lidas sob bloqueio
  compartilhado quando exigidas pela operação.
- `listCreationClients` aceita sócio para todos os clientes e advogado para os
  clientes atualmente atribuídos. Atendimento, cliente, financeiro e anônimo
  recebem a mesma negativa genérica do restante do chat.
- `listParticipants` aplica a autorização de leitura vigente e retorna somente
  participações sem `removedAt`, preservando o UUID autenticado como referência.
  Não carrega nome, e-mail ou perfil inferido da identidade.

## Geração e verificação

Na pasta `packages/signcob_server`, usando o Serverpod CLI 3.2.3 offline ativado
globalmente:

```powershell
serverpod generate
serverpod create-migration --tag chat-first-slice
serverpod --no-analytics create-migration --tag chat-provisioning --force
```

A geração oficial produziu os contratos em `lib/src/generated/chat` e
`../signcob_client/lib/src/protocol/chat`, atualizou os registros de protocolo,
endpoint e ferramentas de teste, e criou a migration
`20261107133745758-chat-first-slice`. O `migration.sql` incremental cria somente
`chat_conversation`, `chat_participant` e `chat_message`, com seus índices e
chaves estrangeiras. Os arquivos gerados e a migration não foram editados à mão.

A migration de provisionamento `20261107164547739-chat-provisioning` acrescenta
duas colunas nulas a `chat_conversation` e o índice único por criador e
solicitação. O CLI exige `--force` pelo aviso genérico de índice único. As duas
colunas novas ficam nulas nas linhas existentes e o índice PostgreSQL distingue
chaves com valores nulos para fins de unicidade.

Comandos de análise e teste usados nesta etapa ficam registrados em
`PROJECT_STATE.md`, junto dos resultados e das limitações do ambiente.

## Fora de escopo e limitações

- Agenda, Google Calendar, OAuth, anexos, edição, exclusão, reações, presença,
  leitura em tempo real, notificações, webhooks, filas e workers.
- A interface administrativa integra criação, seleção de clientes autorizados,
  gestão de participantes ativos, acesso negado, retry e prevenção de duplicação.
  Quando o servidor não fornece a lista de candidatos, a inclusão aceita uma
  referência UUID digitada; ela nunca substitui a identidade autenticada e é
  validada novamente no servidor contra conta, capacidade, vínculo e bloqueio.
- O adaptador gera `requestId` UUID no cliente apenas como chave de repetição;
  ator, timestamp, cliente elegível e participante autorizado são decididos no
  servidor.
- Nome público do autor. O contrato persiste a identidade autenticada; a UI mostra
  apenas “Você” ou “Participante”, sem confiar em nome fornecido pelo cliente.
- Atualização em tempo real. O usuário atualiza a página de mensagens de forma
  explícita.
