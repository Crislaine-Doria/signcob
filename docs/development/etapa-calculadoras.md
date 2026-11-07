# Migração das calculadoras restantes

Objetivo: disponibilizar simulações públicas de comparação de empréstimos e de
estadia, com regras explícitas e entradas validadas, preservando o legado como referência.

## Decisões de implementação

- Comparação revisional usa taxas fornecidas pelo usuário e não classifica
  contratos juridicamente nem consulta taxas de mercado automaticamente.
- Estadia usa tarifa fornecida pelo usuário: valor fixo 2,41 do legado não é
  apresentado como tarifa atual. Carga, tempo e unidade da tarifa são explícitos.
- Cálculos locais, sem Firebase, sem cadastro obrigatório ou gravação de dados pessoais.
- Acidente de trabalho permanece planejado com escopo indefinido.

## Aceite

Regras aritméticas testadas com casos conhecidos; valores não finitos e entradas
inválidas rejeitados; interface com erros recuperáveis e resultado; navegação
a partir do catálogo; testes integrados e build web concluídos.

Autoria revisional e estadia em agentes separados. Hub e integração pelo
orquestrador. Revisão independente antes da disponibilização local.
