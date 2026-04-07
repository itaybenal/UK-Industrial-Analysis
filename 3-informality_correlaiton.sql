WITH t1 AS (
    SELECT
        Industry,
        -- GVA vs Informality
        corr(avg_gva_per_fte, avg_informality_ratio) AS corr_gva_informality,

        -- Informality vs Business Sizes
        corr(avg_informality_ratio, Micro_norm) AS corr_informality_micro,
        corr(avg_informality_ratio, Small_norm) AS corr_informality_small,
        corr(avg_informality_ratio, Medium_norm) AS corr_informality_medium,
        corr(avg_informality_ratio, Large_norm) AS corr_informality_large
    FROM
        normalised_master_table_for_correlation
    GROUP BY
        Industry
)
SELECT
    *
FROM
    t1
WHERE
    corr_informality_micro IS NOT NULL
ORDER BY
    corr_gva_informality DESC;