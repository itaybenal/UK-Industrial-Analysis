WITH t1 AS (
	SELECT
	    Industry,
       -- corr(y, x) calculates the Pearson correlation coefficient
       corr(avg_gva_per_fte, Micro_norm) AS corr_gva_micro,
       corr(avg_gva_per_fte, Small_norm) AS corr_gva_small,
       corr(avg_gva_per_fte, Medium_norm) AS corr_gva_medium,
       corr(avg_gva_per_fte, Large_norm) AS corr_gva_large
	FROM normalised_master_table_for_correlation
	GROUP BY Industry)
SELECT 
    Industry,
    corr_gva_micro,
    corr_gva_small,
    corr_gva_medium,
    corr_gva_large,
    CASE WHEN corr_gva_micro > 0.3 AND corr_gva_large > 0.2 THEN 'Dual'
	WHEN corr_gva_micro > 0.3 THEN 'Specialisation'
	WHEN corr_gva_micro > 0.2 THEN 'Specialisation (Weak)'
	WHEN corr_gva_large > 0.3 THEN 'Scale'
	WHEN corr_gva_large > 0.2 THEN 'Scale (Weak)'
	ELSE 'Hybrid' END AS industry_type
FROM
	t1
WHERE
corr_gva_micro IS NOT NULL
ORDER BY industry_type DESC, industry