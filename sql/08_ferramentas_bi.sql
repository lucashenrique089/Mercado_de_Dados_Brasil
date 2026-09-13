-- ============================================================================
-- 08_ferramentas_bi.sql
--
-- PERGUNTA DE NEGÓCIO: quais ferramentas de BI (Business Intelligence) são
-- mais utilizadas no trabalho?
--
-- COMO FUNCIONA: mesmo padrão de UNION ALL das duas consultas anteriores,
-- agora para o bloco de ferramentas de BI.
--
-- OBSERVAÇÃO: Looker e Google Data Studio são produtos distintos (Looker foi
-- adquirido pelo Google em 2019; Data Studio só foi renomeado para "Looker
-- Studio" em 2022, após esta pesquisa) — por isso são tratados como
-- categorias separadas, e não somados.
--
-- RESULTADO: Power BI 974 · Tableau 335 · Google Data Studio 334 · Só
-- Excel/planilhas 223
-- Executada com sucesso em: 2026-09-13T17:19:59 (Athena engine version 3)
-- ============================================================================

SELECT 'Power BI' AS ferramenta, COUNT(*) AS quantidade FROM vw_data_hacker_2021 WHERE bi_powerbi = '1'
UNION ALL
SELECT 'Tableau', COUNT(*) FROM vw_data_hacker_2021 WHERE bi_tableau = '1'
UNION ALL
SELECT 'Qlik', COUNT(*) FROM vw_data_hacker_2021 WHERE bi_qlik = '1'
UNION ALL
SELECT 'Looker', COUNT(*) FROM vw_data_hacker_2021 WHERE bi_looker = '1'
UNION ALL
SELECT 'Google Data Studio', COUNT(*) FROM vw_data_hacker_2021 WHERE bi_google_data_studio = '1'
UNION ALL
SELECT 'Metabase', COUNT(*) FROM vw_data_hacker_2021 WHERE bi_metabase = '1'
UNION ALL
SELECT 'Só Excel/planilhas', COUNT(*) FROM vw_data_hacker_2021 WHERE bi_so_excel = '1'
UNION ALL
SELECT 'Nenhuma ferramenta de BI', COUNT(*) FROM vw_data_hacker_2021 WHERE bi_nenhuma = '1'
ORDER BY quantidade DESC;
