# Prepare GT array data for regenie step 1

This is the very first step if you plan to run regeneie on the DNANexus UKB RAP. If you are planning to run a GWAS on the WES or WGS data, you will proceed to the GTprep liftover section. IF you are planning to run regenie on the imputed dataset which is in grch37, you can skip the liftover step. If you only plan to run plink, you do not need to run this step at all.

What these script actually do:

1. Combines per chromosome genotype data into a single file
2. QC filter the combined genotype file. (maf 0.01, minor allele count of 20, missing genotype call rate of 10%, missing individual call rate of 10%)
3. LD prune combined and QC-ed genotype file (r^2>0.4) and filter by total cohort

The final plink file will consist of your subject cohort file, and will be made up of ~410K snps. 

The output from steps 1 and 2 can be deleted, but if you plan on running this again for a new cohort, you will have to start all over again. These three steps are fairly quick and should be inexpensive to recreate.
