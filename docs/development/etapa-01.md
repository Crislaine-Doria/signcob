# Etapa 01 — preparação da migração

## Entrega inicial

Framework disponível localmente; instruções de retomada em AGENTS.md;
estado factual em PROJECT_STATE.md. Esta entrega prepara a equipe e não
representa migração concluída do aplicativo.

## Plano de trabalho

| ID | Responsável | Escopo de escrita | Dependência | Aceite | Revisão |
|---|---|---|---|---|---|
| E01 | 02 Arquitetura | docs/development/diagnostico.md | nenhuma | Inventário do legado e fronteiras Flutter/API/banco documentados | 09 |
| E02 | 26 Ambiente | pubspec.yaml, melos.yaml, configurações locais documentadas | E01 | Dependências compatíveis, análise e comandos de execução verificados | 09 e 10 |
| E03 | 26 Ambiente | packages/signcob_server/docker-compose.yaml e documentação de execução | E02 | PostgreSQL/Redis disponíveis e servidor inicia com migrations | 09 e 10 |
| E04 | 11 Requisitos e 13 Dados | docs/development/primeiro-incremento.md | E01 | Primeira jornada definida, dados mapeados e critérios verificáveis | 02 e responsável pelo produto |

Integração: orquestrador designa 40 para código revisado. Não migrar dados reais
durante setup. Contratos, lockfiles e migrations terão autor único por tarefa.

## Direção técnica

Flutter apresenta telas; cliente gerado chama Serverpod; regras de negócio,
autorização e integrações ficam no backend; PostgreSQL persiste dados;
Docker fornece serviços locais. Firebase do legado exige mapeamento explícito
antes de substituir autenticação, documentos e armazenamento.

## Evidências

Clone do framework concluído. Inspeção confirmou conflito de SDK na raiz.
Análise, testes e inicialização do aplicativo permanecem não verificados.
Revisão de processo: manter preparação separada da migração para evitar copiar
dependências, configurações e segredos do legado sem avaliação.
