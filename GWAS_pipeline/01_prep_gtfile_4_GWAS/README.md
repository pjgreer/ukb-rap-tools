# Genotype file preparation

## Seperated into 2 parts. 
Scripts 01-03 do the following.
1. Mergeing existing genotype date
2. Filtering gt data by regular QC metrics
3. Pruning data to remove snps in high LD r^2 >0.4
4. Filter by cohort

You can then proceed to the partB_gwas_impute if using the imputed dataset.

If analyzing whole exome or whole genome data, you will need to lift over the genotype data to grch38 using scripts 04, 05, and 06 before continueing on to partC_gwas_wes

