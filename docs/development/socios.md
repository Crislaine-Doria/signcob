# Perfil sócio

Decisão do responsável: acesso a todos os módulos e registros. O perfil é um
pacote explícito das capacidades registradas em `managedPermissions`, incluindo
`users.manage`, usado pelos módulos atuais para acesso de gestão aos registros.
Não existe atribuição automática ao primeiro cadastro ou por e-mail.

Na pasta do servidor, com uma identidade existente e não bloqueada:

```powershell
dart bin/grant_partner.dart AUTH_USER_UUID
```

Esse comando usa desenvolvimento, preserva permissões externas e concede todas
as capacidades atuais. Nenhuma conta foi promovida nesta entrega. Após concessão,
sair e entrar novamente para emitir token com os novos escopos.

Ao implementar novos módulos, registrar suas capacidades na allowlist e conferir
os testes de autorização do sócio. Reaplicar o comando e renovar a sessão para
acrescentar capacidades novas; o pacote não concede capacidades futuras por mágica.
O perfil não dispensa validações de negócio nem configura credenciais externas.
