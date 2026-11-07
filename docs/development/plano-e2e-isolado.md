# Jornadas HTTP isoladas — plano do incremento

Plano histórico anterior à execução. A tabela registra as frentes previstas.
A autoria das correções nesta retomada e os resultados verificados ficam em
`e2e-http-isolado.md` e no estado do projeto.

Data de referência: 03/11/2026. Stack e visual existentes preservados; alvo de
validação Flutter em testes de widgets com HTTP real, Serverpod 3.2.3 e
PostgreSQL descartável em Docker. Não equivale a navegador ou dispositivo físico.
Risco R2: escrita persistente, credenciais de teste e autorização.

| Responsável real | Arquivos reservados | Dependência | Critério de aceite |
|---|---|---|---|
| Subagente `ambiente_e2e` | runner, bootstrap em `test/e2e/support`, configuração temporária e `ambiente-e2e.md` | Contrato de fixture compartilhado | Banco separado; identidades sintéticas; limpeza automática em sucesso/falha; nenhum segredo real |
| Subagente `jornadas_flutter` | `isolated_api_journeys_test.dart`, helpers próprios e `jornadas-http-flutter.md` | Manifest temporário e API de teste | Escritas pelas telas reais, releitura HTTP, login/sessão/logout |
| Subagente `datajud_http` | DI de `CaseRecordEndpoint`, transporte controlado, `isolated_security_journeys_test.dart` e `datajud-http-controlado.md` | Mesmo ambiente isolado | Autorização HTTP real e processos sem acessar tribunais |
| Sessão principal | Integração, checks finais, este plano e `PROJECT_STATE.md` | Arquivos estáveis dos autores | Análise, suítes pertinentes, build web e evidências reproduzíveis |
| Revisor independente a iniciar após autoria | Relatório de revisão, sem editar objeto revisado | Candidato concreto e evidências | Parecer técnico/QA e revisão breve de processo (09/10/54) |

Perfis consultados 00/22/23/26/40/51 e harness Flutter; os papéis não indicam
processos adicionais. O clone da equipe permanece independente. Nenhum worker,
roteamento pago, publicação, envio externo ou cobrança está autorizado.

## Cenários e camadas

- Dado banco descartável, quando preparar e executar a suíte (inclusive falha),
  então dados e credenciais são removidos sem tocar desenvolvimento.
- Dada identidade sintética, quando entrar e sair pelas telas Flutter, então a
  sessão HTTP real acompanha a UI e as áreas internas descartam seus dados.
- Dados contato, cliente, dívida, honorários, artigo e parceiro fictícios,
  quando escrever pelas telas, então a releitura HTTP confirma persistência e
  visibilidade conforme as regras existentes.
- Dadas validação, falta/revogação de capacidade, bloqueio e atribuição diversa,
  quando chamar a API real, então não ocorre escrita ou leitura indevida.
- Dado transporte DataJud determinístico, quando importar e sincronizar,
  então persistência, falhas e vínculos são verificados sem rede externa.

Resultados e limitações serão registrados após execução. Contratos e migrations
não serão alterados manualmente; nenhuma mudança de schema é prevista.
