# Gestão de acessos

Objetivo autorizado: múltiplas contas internas com permissões diferentes.
Papéis de negócio aguardam esclarecimento; implementação usa capacidades
individuais, sem presumir administrador único ou privilégios no cadastro.

- contacts.read: consulta de contatos.
- users.manage: consulta de contas e atribuição das capacidades gerenciáveis.

Somente identidades existentes recebem permissões. Alteração preserva scopes
externos. A própria permissão de gerenciar acessos não pode ser removida pelo
titular nesta interface, evitando bloqueio acidental do operador.
Servidor deve verificar permissões atuais no banco para não depender apenas
de tokens emitidos antes de uma revogação.

Primeiro operador habilitado explicitamente por comando local, sem atribuição
automática à primeira conta. Nenhum e-mail foi escolhido ou recebeu privilégio.

Aceite: acesso anônimo e conta sem capacidade rejeitados; operador autorizado
consulta páginas de contas e altera permissões permitidas; valores inválidos
rejeitados; UI confirma resultado e permite nova tentativa após erro.

## Primeiro operador local

Após cadastrar e verificar uma identidade, na pasta packages/signcob_server,
execute `dart bin/grant_access_manager.dart AUTH_USER_UUID` com o identificador
da conta escolhida. Nenhuma concessão realizada nesta entrega. Depois, sair e
entrar novamente para emitir token com a nova capacidade.

Limitação: listagem busca todas as identidades antes de recortar a página de 25;
substituir por consulta paginada no banco para operar com grande volume.
