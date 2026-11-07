# Processos — DataJud público

Responsável confirmou TJPR (Projudi), TRT9 (PJe), TRF4 (Eproc) e início por
metadados/andamentos públicos via DataJud. Integração direta autenticada nos
sistemas dos tribunais, documentos e processos restritos não fazem parte deste conector.

Fonte oficial e endpoints: https://datajud-wiki.cnj.jus.br/api-publica/endpoints/
Exemplo oficial de busca por número:
https://datajud-wiki.cnj.jus.br/api-publica/exemplos/exemplo1/

Conector no servidor, host fixo e tribunais permitidos; chave configurada localmente
em DATAJUD_API_KEY. Nunca incluir chave no aplicativo Flutter ou em logs.
Número normalizado, resposta conferida com o número consultado, limites e timeout.
Sem chave ou resposta válida, informar falha; não criar processo fictício.

## Acesso

Processo ligado ao cadastro cliente. Advogado acessa somente clientes atribuídos;
cliente autenticado acessa somente os processos vinculados à sua identidade;
gestor necessita capacidades específicas. Revogação conferida no banco.
Vínculo de identidade exige operação explícita e não depende de CPF público.

## Validação

Testes locais com resposta controlada validam importação, erros e autorização.
Consulta real depende da configuração da chave. Dados não equivalem a
acompanhamento instantâneo nem a intimações oficiais; exibir fonte e data da consulta.

## Configuração local

Obtenha a chave pública vigente na documentação de acesso do CNJ:
https://datajud-wiki.cnj.jus.br/api-publica/acesso/
Defina DATAJUD_API_KEY no ambiente do processo do servidor e reinicie-o.
Não salve o valor em arquivos rastreados pelo Git. O servidor iniciado antes
da configuração não recebe alterações posteriores do ambiente de outro terminal.

Esta etapa oferece importação e sincronização acionadas pela interface, com
busca remota automática dos dados; consulta periódica em segundo plano exige
definição posterior de frequência, limites e acompanhamento de falhas.
