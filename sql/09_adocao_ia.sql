-- ============================================================================
-- 09_adocao_ia.sql
--
-- PERGUNTA DE NEGÓCIO: qual o índice de adoção de Inteligência Artificial
-- entre os profissionais de dados?
--
-- COMO FUNCIONA: a edição 2021 da pesquisa não tem uma seção dedicada à
-- adoção de IA no dia a dia (o boom de IA generativa só ganhou escala a
-- partir de 2022/2023). O único campo disponível relacionado ao tema é uma
-- pergunta binária sobre gestão de iniciativas de IA/ML, consultada direto
-- na tabela Prata (essa coluna não foi incluída na view Gold porque é o
-- único dado do bloco de IA disponível nesta edição).
--
-- LIMITAÇÃO: por isso este projeto recomenda, como próximo passo, ingerir
-- uma edição mais recente (2023/2024) da pesquisa para responder com
-- profundidade a essa pergunta.
--
-- RESULTADO: 159 pessoas (6% da amostra) se declaram gestoras de iniciativas
-- de IA/Machine Learning.
-- Executada com sucesso em: 2026-09-13T17:24:08 (Athena engine version 3)
-- ============================================================================

SELECT COUNT(*) AS quantidade
FROM "default"."tb-data-hacker"
WHERE "_'p3_c_g_'__'sou_gestor_da_equipe_responsável_por_iniciativas_e_projetos_envolvendo_inteligência_artificial_e_machine_learning.'_#64" = '1';
