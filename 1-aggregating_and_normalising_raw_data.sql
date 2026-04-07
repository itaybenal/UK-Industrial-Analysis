WITH t1 AS (
	SELECT
		year_of,
		"ITL2",
		industry,
		AVG(gva_per_fte) AS region_gva_per_fte,
		AVG(workforce_informality_ratio) * 100.0 AS region_informality_ratio,
		(SUM("pri_bs2(0-4)") * 100.0 / NULLIF (SUM("pri_bs1_Micro(0-9)") + SUM("pri_bs4_Small (10-49)") + SUM("pri_bs7_Medium(50-249)") + SUM("pri_bs10_Large(250+)"), 0)) AS "bs(0-4)_pct",
		(SUM("pri_bs3(5-9)") * 100.0 / NULLIF (SUM("pri_bs1_Micro(0-9)") + SUM("pri_bs4_Small (10-49)") + SUM("pri_bs7_Medium(50-249)") + SUM("pri_bs10_Large(250+)"), 0)) AS "bs(5-9)_pct",
		(SUM("pri_bs5(10-19)") * 100.0 / NULLIF (SUM("pri_bs1_Micro(0-9)") + SUM("pri_bs4_Small (10-49)") + SUM("pri_bs7_Medium(50-249)") + SUM("pri_bs10_Large(250+)"), 0)) AS "bs(10-19)_pct",
		(SUM("pri_bs6(20-49)") * 100.0 / NULLIF (SUM("pri_bs1_Micro(0-9)") + SUM("pri_bs4_Small (10-49)") + SUM("pri_bs7_Medium(50-249)") + SUM("pri_bs10_Large(250+)"), 0)) AS "bs(20-49)_pct",
		(SUM("pri_bs8(50-99)") * 100.0 / NULLIF (SUM("pri_bs1_Micro(0-9)") + SUM("pri_bs4_Small (10-49)") + SUM("pri_bs7_Medium(50-249)") + SUM("pri_bs10_Large(250+)"), 0)) AS "bs(50-99)_pct",
		(SUM("pri_bs9(100-249)") * 100.0 / NULLIF (SUM("pri_bs1_Micro(0-9)") + SUM("pri_bs4_Small (10-49)") + SUM("pri_bs7_Medium(50-249)") + SUM("pri_bs10_Large(250+)"), 0)) AS "bs(100-249)_pct",
		(SUM("pri_bs11(250-499)") * 100.0 / NULLIF (SUM("pri_bs1_Micro(0-9)") + SUM("pri_bs4_Small (10-49)") + SUM("pri_bs7_Medium(50-249)") + SUM("pri_bs10_Large(250+)"), 0)) AS "bs(250-499)_pct",
		(SUM("pri_bs12(500-999)") * 100.0 / NULLIF (SUM("pri_bs1_Micro(0-9)") + SUM("pri_bs4_Small (10-49)") + SUM("pri_bs7_Medium(50-249)") + SUM("pri_bs10_Large(250+)"), 0)) AS "bs(500-999)_pct",
		(SUM("pri_bs13(1000+)") * 100.0 / NULLIF (SUM("pri_bs1_Micro(0-9)") + SUM("pri_bs4_Small (10-49)") + SUM("pri_bs7_Medium(50-249)") + SUM("pri_bs10_Large(250+)"), 0)) AS "bs(1000+)_pct"
	FROM
		master_table
	GROUP BY
		year_of,
		"ITL2",
		industry), with_aggregates AS (
SELECT
	industry,
	ROUND(AVG(region_gva_per_fte)::NUMERIC,2) AS avg_gva_per_fte,
	ROUND(AVG(region_informality_ratio)::NUMERIC,2) AS avg_informality_ratio,
	ROUND(AVG("bs(0-4)_pct") + AVG("bs(5-9)_pct")::NUMERIC,2) AS Micro_pct,
	ROUND(AVG("bs(10-19)_pct") + AVG("bs(20-49)_pct")::NUMERIC,2) AS Small_pct,
	ROUND(AVG("bs(50-99)_pct") + AVG("bs(100-249)_pct")::NUMERIC,2) AS Medium_pct,
	ROUND(AVG("bs(250-499)_pct") + AVG("bs(500-999)_pct") + AVG("bs(1000+)_pct")::NUMERIC,2) AS Large_pct
FROM
	t1
GROUP BY
	industry), with_total AS (
SELECT
	*,
	Micro_pct + Small_pct + Medium_pct + Large_pct AS total_pct
FROM
	with_aggregates)
SELECT
	industry,
	avg_gva_per_fte,
	avg_informality_ratio,
	CASE WHEN total_pct = 0 THEN 0
		ELSE ROUND((Micro_pct * 100.0) / total_pct,2)
	END AS Micro_norm,
	CASE WHEN total_pct = 0 THEN 0
		ELSE ROUND((Small_pct * 100.0) / total_pct,2)
	END AS Small_norm,
	CASE WHEN total_pct = 0 THEN 0
		ELSE ROUND((Medium_pct * 100.0) / total_pct,2)
	END AS Medium_norm,
	CASE WHEN total_pct = 0 THEN 0
		ELSE ROUND((Large_pct * 100.0) / total_pct,2)
	END AS Large_norm
FROM
	with_total
ORDER BY
    avg_gva_per_fte DESC