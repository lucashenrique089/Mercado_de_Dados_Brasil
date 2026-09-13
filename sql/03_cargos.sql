-- ============================================================================
-- 03_cargos.sql
--
-- PERGUNTA DE NEGÓCIO: quais são os perfis profissionais (cargos) mais
-- comuns/valorizados no mercado de dados brasileiro?
--
-- COMO FUNCIONA: mesmo padrão de GROUP BY + janela para percentual da
-- pergunta anterior, agora agrupando por cargo. LIMIT 15 evita trazer cargos
-- residuais com pouquíssimas respostas.
--
-- RESULTADO (top): Cientista de Dados 357 · Analista de BI/Analytics
-- Engineer 338 · Analista de Dados 324 · Engenheiro de Dados 300
-- Executada com sucesso em: 2026-09-07T16:55:28 (Athena engine version 3)
-- ============================================================================

SELECT
    cargo,
    COUNT(*) AS quantidade,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 1) AS percentual
FROM vw_data_hacker_2021
GROUP BY cargo
ORDER BY quantidade DESC
LIMIT 15;
