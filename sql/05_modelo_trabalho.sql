-- ============================================================================
-- 05_modelo_trabalho.sql
--
-- PERGUNTA DE NEGÓCIO: como está distribuído o modelo de trabalho (remoto,
-- híbrido, presencial) entre os profissionais de dados?
--
-- COMO FUNCIONA: mesmo padrão de GROUP BY + janela para percentual usado em
-- gênero e cargos, agora agrupando pela forma de trabalho.
--
-- RESULTADO: 67,9% da área trabalha em regime 100% remoto (50,5%) ou
-- híbrido flexível (17,4%) somados.
-- Executada com sucesso em: 2026-09-13T16:29:38 (Athena engine version 3)
-- ============================================================================

SELECT
    forma_trabalho,
    COUNT(*) AS quantidade,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 1) AS percentual
FROM vw_data_hacker_2021
GROUP BY forma_trabalho
ORDER BY quantidade DESC;
