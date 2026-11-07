# Cadastro de clientes

Primeiro incremento da ampliação confirmada para clientes, processos, negociações,
Asaas, blog e parceiros. Cadastro de clientes será a referência dos módulos seguintes.

## Limites e contrato

LegalClient: nome obrigatório; e-mail, telefone e documento opcionais; datas UTC
de criação e atualização. Não definir regras de CPF/CNPJ antes de requisitos.
Listagem paginada de 25 e criação/edição. Exclusão não incluída nesta etapa.

Permissões individuais clients.read e clients.write, verificadas no token e no
banco. Não atribuir essas capacidades automaticamente a contas existentes.
Perfis agrupando capacidades aguardam definição do responsável.

Esclarecimento posterior: advogado vê somente clientes atribuídos a ele. Backend
deve filtrar listagem e verificar atribuição na edição; advogado não pode tomar
para si um cadastro existente. Atribuição explícita fica restrita ao gestor de acessos.

## Aceite

Persistência SQL com dados normalizados, autorização por operação, rejeição de
entradas inválidas, edição preserva criação, tela com loading/erro/retry e
formulário sem perda de dados após falha. Contratos e migration gerados pelo CLI.

Autoria backend e Flutter separadas, integração e revisão após os testes.
