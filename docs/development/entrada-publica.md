# Entrada pública e contas internas

Decisão do responsável: uma página inicial pública oferece acesso às calculadoras
e abre outras telas. Contato é uma dessas telas, não a página inicial permanente.
Contas internas terão permissões diferentes; não há um único e-mail administrador.

## Navegação inicial

- `/`: apresentação do SignCob e acesso às funcionalidades.
- `/calculadoras`: ferramentas do legado e estado real de migração.
- `/contato`: formulário já conectado ao Serverpod.
- `/administrativo`: autenticação e consulta protegida existente.

Rotas Flutter web usam o mecanismo padrão de fragmentos sob `/app/` nesta etapa.
Ferramentas públicas não exigem cadastro. Simulações não importam dados do legado.

## Permissões

Manter concessões por capacidade no servidor. `contacts.read` já controla a
consulta de contatos independentemente do e-mail. Outras permissões serão
definidas com cada módulo, sem conceder acesso global por cadastro.
Gestão visual de usuários e atribuição de permissões ainda será implementada.

## Funcionalidade planejada

Acidente de trabalho: solicitado pelo responsável durante a preparação da página
pública. Escopo ainda não definido; apresentar como planejado, sem formulário,
coleta de dados ou regra de cálculo presumida.
