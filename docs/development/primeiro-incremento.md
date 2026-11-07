# Primeiro incremento — contato

Migração do formulário contact_form.dart do legado, antes persistido em
contact_messages no Firestore, para Flutter → Serverpod → PostgreSQL.

## Contrato e limites

Endpoint público contact.submit(name, email, message), retorno vazio.
Servidor normaliza espaços nas extremidades, exige conteúdo e limita nome a
120, e-mail a 254 e mensagem a 5000 caracteres. Data UTC gerada pelo servidor.
Tabela contact_message; nenhuma listagem pública ou importação de dados antigos.
Integrações de pagamento, usuários e processos ficam para incrementos futuros.

## Critérios verificáveis

- Dados válidos geram uma linha SQL com os valores normalizados e data UTC.
- Dados vazios, e-mail inválido ou limites excedidos falham antes da persistência.
- Formulário mostra envio em andamento e impede envio simultâneo.
- Sucesso limpa campos e confirma; falha mantém conteúdo e permite nova tentativa.
- Tela comporta largura pequena e teclado com rolagem.

## Responsáveis

Backend: subagente contato_backend, proprietário de modelo, endpoint, código
gerado, migration e teste de integração. Flutter: contato_flutter, proprietário
da tela, composição main e testes de widgets. Integração e execução local:
orquestrador. Revisão independente após as duas entregas.

Não há mudança de provedor de autenticação nem migração de usuários neste marco.
