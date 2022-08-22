
# Performing GWAS on  WES data using PLINK2
This is a self contained workflow. no other steps need to be run prior to these steps. 

If you have already run 11b in the regenie step, you can proceed to 12b.

11. Creates a list of snps for each chromosome of the WES data that meet cohort and QC filter (--maf 0.0005 --mac 20 --geno 0.1 --mind 0.1)    
12. Runs plink2 on each chromosome of the WES data using the blocks from 09 and snps from 11b
13. Collects all the plink output into a single file.

In my case I created two files, phenotype and covariate, you can feel pree to combine them into one, but I prefer to keep them seperate.
Standalone workflow

