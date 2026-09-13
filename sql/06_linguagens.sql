-- ============================================================================
-- 06_linguagens.sql
--
-- PERGUNTA DE NEGÓCIO: quais linguagens de programação são mais adotadas no
-- dia a dia dos profissionais de dados?
--
-- COMO FUNCIONA: cada linguagem é uma coluna booleana separada na pesquisa
-- original (pergunta de múltipla escolha). UNION ALL empilha uma contagem
-- por linguagem, transformando várias colunas "largas" em uma tabela
-- "longa" (categoria + contagem), formato ideal para gráficos de barras.
-- (Uma tentativa mais avançada, com UNNEST + ARRAY de ROWs, para evitar
-- repetir o padrão 13 vezes, é registrada em 99_tentativa_unnest.sql — não
-- funcionou nesta versão do engine do Athena.)
--
-- RESULTADO (top 4): SQL 1.487 · Python 1.346 · R 306 · Java 223
-- Executada com sucesso em: 2026-09-13T17:10:18 (Athena engine version 3)
-- ============================================================================

SELECT 'SQL' AS linguagem, COUNT(*) AS quantidade FROM vw_data_hacker_2021 WHERE lang_sql = '1'
UNION ALL
SELECT 'Python', COUNT(*) FROM vw_data_hacker_2021 WHERE lang_python = '1'
UNION ALL
SELECT 'R', COUNT(*) FROM vw_data_hacker_2021 WHERE lang_r = '1'
UNION ALL
SELECT 'Java', COUNT(*) FROM vw_data_hacker_2021 WHERE lang_java = '1'
UNION ALL
SELECT 'JavaScript', COUNT(*) FROM vw_data_hacker_2021 WHERE lang_javascript = '1'
UNION ALL
SELECT 'C/C++/C#', COUNT(*) FROM vw_data_hacker_2021 WHERE lang_c = '1'
UNION ALL
SELECT 'VBA/Visual Basic', COUNT(*) FROM vw_data_hacker_2021 WHERE lang_vba = '1'
UNION ALL
SELECT 'SAS/Stata', COUNT(*) FROM vw_data_hacker_2021 WHERE lang_sas_stata = '1'
UNION ALL
SELECT '.NET', COUNT(*) FROM vw_data_hacker_2021 WHERE lang_dotnet = '1'
UNION ALL
SELECT 'Scala', COUNT(*) FROM vw_data_hacker_2021 WHERE lang_scala = '1'
UNION ALL
SELECT 'Matlab', COUNT(*) FROM vw_data_hacker_2021 WHERE lang_matlab = '1'
UNION ALL
SELECT 'PHP', COUNT(*) FROM vw_data_hacker_2021 WHERE lang_php = '1'
UNION ALL
SELECT 'Julia', COUNT(*) FROM vw_data_hacker_2021 WHERE lang_julia = '1'
ORDER BY quantidade DESC;
