-- ============================================================================
-- 04_senioridade_regiao.sql
--
-- PERGUNTA DE NEGÓCIO: como a senioridade dos profissionais varia entre as
-- regiões do Brasil?
--
-- COMO FUNCIONA: GROUP BY com duas colunas (regiao, nivel) cria um grupo
-- para cada combinação existente das duas — por isso o resultado tem várias
-- linhas por região, uma para cada nível de senioridade encontrado nela.
--
-- RESULTADO: Nordeste concentra o maior % de juniores (42,6%); Centro-oeste
-- tem a maior proporção de seniores (42,0%).
-- Executada com sucesso em: 2026-09-07T17:56:19 (Athena engine version 3)
-- ============================================================================

SELECT
  regiao,
  nivel,
  COUNT(*) AS quantidade
FROM vw_data_hacker_2021
GROUP BY regiao, nivel
ORDER BY regiao, quantidade DESC;
