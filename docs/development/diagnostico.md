# Diagnóstico inicial — arquitetura

Inspeção somente leitura por subagente independente em 03/11/2026.
Testes e execução da aplicação não realizados.

- Raiz exige Dart <3; pacotes exigem ^3.8.0: alinhar ambiente primeiro.
- Flutter novo contém autenticação e saudações; funcionalidades do legado ainda ausentes.
- Backend possui migrations e autenticação por e-mail/JWT. Verificar registro de dois token managers.
- Modelo experimental greetings/user.spy.yaml contém password String: não adotar para credenciais; usar autenticação Serverpod.
- Redis está configurado no Compose, mas desabilitado na configuração de desenvolvimento.
- Firestore legado usa posts, calculadoras_revisional, calculadoras_financiamento,
  estadia, renegociacao, emprestimo, financiamento e contact_messages.
- Formulários de calculadoras duplicados exigem identificar quais rotas são usadas.
- Confirmar quais funcionalidades financeiras compõem o produto jurídico antes de portar.

Direção proposta: manter os três pacotes e fronteira Flutter → cliente gerado →
Serverpod → PostgreSQL. Primeira fatia sugerida, ainda não decidida pelo produto:
formulário de contato com validação, persistência SQL, confirmação e erro recuperável.

Inventário inicial verificado por inspeção. Ambiente executável, integração e
migração de dados permanecem não verificados.
