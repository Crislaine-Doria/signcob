# Negociações separadas

Decisão do responsável: dívidas de clientes e honorários/serviços do escritório
em fluxos separados. Tipo debt/fees imutável; cada registro pertence a um cliente.

Primeiro incremento: cadastro interno de proposta com valor em centavos, título,
estado e histórico auditável. Rascunho → proposta → aceita/recusada/cancelada;
rascunho também pode ser cancelado. Estados finais não se alteram neste fluxo.
Aceite registrado é informação administrativa, sem assinatura ou pagamento automático.

Advogado somente clientes atribuídos; gestor requer capacidades explícitas.
Cliente externo continua limitado aos seus próprios processos conforme perfil
definido pelo responsável. Financeiro não ganha acesso às negociações por analogia.
Asaas será integração separada; nenhum acordo dispara cobrança automaticamente.

Aceite: tipos separados nas consultas/telas, valores exatos positivos, transições
validadas no servidor, evento e alteração atômicos, histórico protegido, acesso
indevido negado, formulários recuperáveis e testes de isolamento/transição.
