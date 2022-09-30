# Performing GWAS on imputed data using PLINK2
This is a self contained workflow. no other steps need to be run prior to these steps. 

If you have already run 11a in the regenie step, you can proceed to 15a.

11a. Creates a plink file for each chromosome of the imputed data that meet cohort and QC filter (--maf 0.006 --mac 20 --geno 0.1 --mind 0.1)
15a. Runs plink on each chromosome of the imputed data
16a. Collects all the plink output into a single file.

In my case I created two files, phenotype and covariate, you can feel pree to combine them into one, but I prefer to keep them seperate.
Standalone workflow
