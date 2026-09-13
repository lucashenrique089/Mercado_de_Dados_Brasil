-- ============================================================================
-- 01_criacao_view_gold.sql
--
-- O QUE FAZ: cria a view vw_data_hacker_2021, a camada GOLD do projeto.
-- Renomeia as colunas sanitizadas pelo Glue (nomes ilegíveis, gerados a
-- partir dos cabeçalhos originais em formato de tupla Python, ex:
-- ('P1_b ', 'Genero')) para nomes legíveis, prontos para as análises.
--
-- COMO USAR: rode uma vez no Athena. Toda vez que rodar de novo com
-- CREATE OR REPLACE VIEW, ela é atualizada sem duplicar dados (é uma
-- consulta salva, não uma cópia física da tabela).
--
-- Executada com sucesso em: 2026-09-13T17:19:42 (Athena engine version 3)
-- ============================================================================

CREATE OR REPLACE VIEW vw_data_hacker_2021 AS
SELECT
  "_'p0'__'id'_#0"                                                 AS id,
  "_'p1_a_'__'idade'_#1"                                           AS idade,
  "_'p1_a_a_'__'faixa_idade'_#2"                                   AS faixa_idade,
  "_'p1_b_'__'genero'_#3"                                          AS genero,
  "_'p1_e_'__'estado_onde_mora'_#4"                                AS estado,
  "_'p1_e_a_'__'uf_onde_mora'_#5"                                  AS uf,
  "_'p1_e_b_'__'regiao_onde_mora'_#6"                              AS regiao,
  "_'p2_h_'__'faixa_salarial'_#18"                                 AS faixa_salarial,
  "_'p2_f_'__'cargo_atual'_#16"                                    AS cargo,
  "_'p2_g_'__'nivel'_#17"                                          AS nivel,
  "_'p2_q_'__'atualmente_qual_a_sua_forma_de_trabalho?'_#43"       AS forma_trabalho,

  -- Provedores de cloud (múltipla escolha: '1' = usa, '0'/vazio = não usa)
  "_'p4_g_a_'__'amazon_web_services__aws_'_#170"                   AS aws,
  "_'p4_g_b_'__'google_cloud__gcp_'_#171"                          AS gcp,
  "_'p4_g_c_'__'azure__microsoft_'_#172"                           AS azure,
  "_'p4_g_d_'__'oracle_cloud'_#173"                                AS oracle_cloud,
  "_'p4_g_e_'__'ibm'_#174"                                         AS ibm_cloud,
  "_'p4_g_f_'__'servidores_on_premise/não_utilizamos_cloud'_#175"  AS on_premise,
  "_'p4_g_g_'__'cloud_própria'_#176"                                AS cloud_propria,

  -- Linguagens de programação (múltipla escolha)
  "_'p4_d_a_'__'sql'_#105"                                         AS lang_sql,
  "_'p4_d_b_'__'r_'_#106"                                          AS lang_r,
  "_'p4_d_c_'__'python'_#107"                                      AS lang_python,
  "_'p4_d_d_'__'c/c++/c#'_#108"                                    AS lang_c,
  "_'p4_d_e_'__'.net'_#109"                                        AS lang_dotnet,
  "_'p4_d_f_'__'java'_#110"                                        AS lang_java,
  "_'p4_d_g_'__'julia'_#111"                                       AS lang_julia,
  "_'p4_d_h_'__'sas/stata'_#112"                                   AS lang_sas_stata,
  "_'p4_d_i_'__'visual_basic/vba'_#113"                            AS lang_vba,
  "_'p4_d_j_'__'scala'_#114"                                       AS lang_scala,
  "_'p4_d_k_'__'matlab'_#115"                                      AS lang_matlab,
  "_'p4_d_l_'__'php'_#116"                                         AS lang_php,
  "_'p4_d_m_'__'javascript'_#117"                                  AS lang_javascript,

  -- Ferramentas de BI (múltipla escolha)
  "_'p4_h_a_'__'microsoft_powerbi'_#178"                           AS bi_powerbi,
  "_'p4_h_b_'__'qlik_view/qlik_sense'_#179"                        AS bi_qlik,
  "_'p4_h_c_'__'tableau'_#180"                                     AS bi_tableau,
  "_'p4_h_d_'__'metabase'_#181"                                    AS bi_metabase,
  "_'p4_h_p_'__'looker'_#193"                                      AS bi_looker,
  "_'p4_h_q_'__'google_data_studio'_#194"                          AS bi_google_data_studio,
  "_'p4_h_v_'__'fazemos_todas_as_análises_utilizando_apenas_excel_ou_planilhas_do_google'_#199" AS bi_so_excel,
  "_'p4_h_x_'__'não_utilizo_nenhuma_ferramenta_de_bi_no_trabalho'_#200"  AS bi_nenhuma

FROM "default"."tb-data-hacker";


-- Exportação da camada Gold para CSV (usada para gerar data/gold.csv e para
-- validar os resultados de forma independente em Python/pandas):
-- SELECT * FROM vw_data_hacker_2021;
