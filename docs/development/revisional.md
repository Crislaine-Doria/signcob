# Comparação revisional

Fonte ativa: pages/calculadoras/calculadora_revisional_page.dart importa
widgets/calculadora_emprestimo_form.dart. Cálculo encontrado: valor original ×
taxa informada × períodos pagos, comparando duas taxas. Preservado como
comparação simples, sem amortização ou composição.

Diferenças intencionais: não rotular taxa superior como abusiva, nem diferença
como restituição. Diferença assinada, inclusive negativa, em vez de truncar a zero.
Taxas são entradas do usuário sem valor legal pressuposto. Total de parcelas,
saldo devedor e dados pessoais foram omitidos: não participam da fórmula.
Não há gravação ou coleta de leads nesta etapa.
