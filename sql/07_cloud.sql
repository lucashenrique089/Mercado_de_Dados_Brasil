-- ============================================================================
-- 07_cloud.sql
--
-- PERGUNTA DE NEGÓCIO: quais provedores de cloud são mais utilizados pelos
-- profissionais de dados?
--
-- COMO FUNCIONA: mesmo padrão de UNION ALL da consulta de linguagens,
-- desagregando as colunas booleanas de múltipla escolha de cloud em uma
-- tabela categoria + contagem.
--
-- RESULTADO: AWS 786 · Azure 498 · Google Cloud 448 · On-premise 433
-- Executada com sucesso em: 2026-09-13T16:53:47 (Athena engine version 3)
-- ============================================================================

SELECT 'AWS' AS cloud, COUNT(*) AS quantidade FROM vw_data_hacker_2021 WHERE aws = '1'
UNION ALL
SELECT 'Google Cloud (GCP)', COUNT(*) FROM vw_data_hacker_2021 WHERE gcp = '1'
UNION ALL
SELECT 'Azure', COUNT(*) FROM vw_data_hacker_2021 WHERE azure = '1'
UNION ALL
SELECT 'Oracle Cloud', COUNT(*) FROM vw_data_hacker_2021 WHERE oracle_cloud = '1'
UNION ALL
SELECT 'IBM', COUNT(*) FROM vw_data_hacker_2021 WHERE ibm_cloud = '1'
UNION ALL
SELECT 'On-premise / não utiliza cloud', COUNT(*) FROM vw_data_hacker_2021 WHERE on_premise = '1'
UNION ALL
SELECT 'Cloud própria', COUNT(*) FROM vw_data_hacker_2021 WHERE cloud_propria = '1'
ORDER BY quantidade DESC;
