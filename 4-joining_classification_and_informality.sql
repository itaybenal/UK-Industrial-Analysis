select
	ind.industry, industry_type, corr_gva_informality,
	corr_gva_micro, corr_informality_micro,
	corr_gva_small, corr_informality_small,
	corr_gva_medium, corr_informality_medium,
	corr_gva_large, corr_informality_large
from informality_correlation inf
join industry_classification ind on ind.Industry = inf.Industry
order by corr_gva_informality desc