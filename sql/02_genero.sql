-- ============================================================================
-- 02_genero.sql
--
-- PERGUNTA DE NEGÓCIO: qual o cenário de diversidade de gênero entre os
-- profissionais de dados no Brasil?
--
-- COMO FUNCIONA: GROUP BY agrupa os respondentes por gênero; COUNT(*) conta
-- quantos há em cada grupo; a janela SUM(COUNT(*)) OVER() soma o total geral
-- sem precisar de uma subquery separada, permitindo calcular o percentual de
-- cada grupo em relação ao total numa única consulta.
--
-- RESULTADO: Masculino 2.144 (81,1%) · Feminino 493 (18,6%) · Outro 8 (0,3%)
-- Executada com sucesso em: 2026-09-07T16:53:17 (Athena engine version 3)
-- ============================================================================

SELECT
    genero,
    COUNT(*) AS quantidade,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS percentual
FROM "default"."vw_data_hacker_2021"
GROUP BY genero
ORDER BY quantidade DESC;
