
# Performing GWAS on  WGS data using PLINK2
This is a self contained workflow. no other steps need to be run prior to these steps. 

UKB has released the population plink files in under bluk data field ukb24308. This workflow performs minor QC, GLM regresssion using plink2 and finally a merge of all the results files into a single output for generating a manhattan plot.

11. Creates a list of snps for each chromosome of the WGS data that meet cohort and QC filter (--maf 0.0005 --mac 20 --geno 0.1 --mind 0.1 --max-maf 0.9995)    
15. Runs plink2 on each chromosome of the WGS data using the variant lists from 11
16. Collects all the plink output into a single file.

In my case I created two files, phenotype and covariate, you can feel pree to combine them into one, but I prefer to keep them seperate.

The WGS plink files are very large. Even after QC, you are looking at over 31 million SNPS in your analysis across the autosomes and chrX. The combined result file is 3.6GB. 

Because to the large number of SNPS in each chromosome, I have yet to run a GWAS fully on spot instances even when using fairly small sample sizes around 25000 subjects. The largest GWAS I have run is on 150,000 subjects and most chromosomes took over an hour SO I recommend that you do not run this on the entire cohort.

This is a standalone workflow

