# SignCob — equipe de desenvolvimento

Objetivo autorizado: migrar gradualmente o aplicativo de advocacia do legado
`C:/Users/Administrador/projetos/projetos_antigos/sign_cob` para este workspace,
com Flutter, Serverpod, PostgreSQL (SQL) e Docker.

## Retomada

Leia `PROJECT_STATE.md`, `docs/development/etapa-01.md` e os perfis
`tools/software-house/docs/agents/agent_00_orquestrador_master.md` e
`tools/software-house/docs/agents/INDEX.md`.
Carregue apenas os especialistas necessários e a harness
`tools/software-house/docs/standards/FLUTTER_HARNESS.md` para tarefas Flutter.

## Execução

Use subagentes independentes para autoria e revisão quando necessário. Informe
quem realmente executou cada tarefa; perfis não equivalem a processos ativos.
O framework está em `tools/software-house`, revisão
`24124bbf2832b83996eb1fe716dac02e5d508585`. É um clone independente:
não adicionar seu Git interno ao repositório do aplicativo como gitlink acidental.
Para reinstalar: `git clone https://github.com/RBSoftwareBR/multi-agent-software-house.git tools/software-house`
e selecionar a revisão acima nesse clone.

## Limites do trabalho

- Legado serve como referência; implementação e documentação novas ficam aqui.
- Preserve alterações preexistentes do usuário.
- Gere contratos e migrations pelas ferramentas Serverpod; não edite código gerado manualmente.
- Integrações Asaas e credenciais ficam no servidor; não copie segredos do legado.
- Registre decisões, evidências, falhas e verificações pendentes no estado.
- Não habilite workers externos, roteamento pago ou publicação implicitamente.
