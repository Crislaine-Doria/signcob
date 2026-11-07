# Consulta administrativa de contatos

Incremento autorizado após o formulário público. A consulta exige sessão
autenticada e permissão contacts.read no servidor. Cadastro comum não concede
permissão administrativa. Não incluir edição ou exclusão neste incremento.

## Contrato

contactAdmin.list(offset): lista de ContactMessage, páginas de até 25 itens,
mais recentes primeiro com desempate por ID. Offset não negativo.
O endpoint público contact.submit permanece disponível para envio.

## Aceite

- Sessão ausente ou sem permissão não consulta mensagens.
- Administrador autorizado vê dados reais, estado vazio e paginação.
- Falhas permitem nova tentativa sem mostrar dados de outra sessão.
- Sair remove a tela com os dados e retorna à autenticação.
- Permissão é concedida por operação local explícita a uma identidade existente.

Autoria backend e Flutter em subagentes distintos. Contrato e código gerado
pertencem ao autor backend; integração e documentação ao orquestrador;
revisão técnica e QA por execução independente.

## Autenticação local

A base atual usa autenticação Serverpod por e-mail. Os códigos de verificação
e recuperação são registrados no console pelo template, sem envio de e-mail
configurado. Esse comportamento permite desenvolvimento local; configurar um
provedor de e-mail antes de disponibilizar o cadastro externamente.

Não atribuir contacts.read automaticamente à primeira conta ou ao cadastro
público. Após concessão local explícita, sair e entrar para renovar a sessão.

## Conceder acesso local

Cadastre a conta pelo botão Área administrativa e confirme o código registrado
no console do servidor. Com o UUID da identidade existente, na pasta do servidor:

```powershell
dart bin/grant_contact_admin.dart AUTH_USER_UUID
```

Substitua AUTH_USER_UUID pelo identificador real. O comando usa a configuração
development e preserva outras permissões. Não executado para uma pessoa nesta
entrega: conta administrativa ainda não indicada pelo responsável.
