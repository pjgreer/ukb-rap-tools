# Performing GWAS on imputed data using Regenie
You must have run all the steps in GTfile-prep prior to running these scripts.

9. Runs regenie on the ~410K snps of the GT array data from step 06.
11. Creates a plink file for each chromosome of the imputed data that meet cohort and QC filter (--maf 0.006 --mac 20 --geno 0.1 --mind 0.1)
12. Runs plink on each chromosome of the imputed data using the blocks from 09
13. Collects all the regenie output into a single file.

In my case I created two files, phenotype and covariate, you can feel pree to combine them into one, but I prefer to keep them seperate.
