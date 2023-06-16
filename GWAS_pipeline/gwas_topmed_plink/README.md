# Performing GWAS on TOPmed data using PLINK2
This is a self contained workflow. no other steps need to be run prior to these steps. 

This extends the GWAS methods for use with the TOPmed imputed dataset DF:21007. This workflow runs over all data ~480+K subjects and saves a complete plink file with maf>0.006 ~10 million snps.
This is in GRCh38 build format, and requires some tweeks to get it working properly.

The sample files currently need to have line2 modified. I did this with the sed comand in 11a.  Many variants also have no name or ID. To get around this, all non-named varaints are renamed 
to chr:pos:ref:alt, with a maximum ref/alt of 99 characters. Again this happens in 11a. All files are save in plink .pgen format on your personal RAP acocunt for analysis in 15a and 16a   

11a. Creates a plink file for each chromosome of the TOPmed imputed data that meet cohort and QC filter (--maf 0.006 --maf-max 0.994 --mac 20 --geno 0.1 --mind 0.1)
15a. Runs plink GWAS model on each chromosome of the TOPmed imputed data from your RAP account. In this case I also generated a cohort .freq file and a .hardy file. You are free to remove these steps as you 
wish. it will cut the analysis time by ~40%. 
16a. Collects all the plink output into a single file.

11a data setup takes at most 4 hours on the largest chromosome (chr2).
15a anaylsis takes at most 4.5 hours on chr2
16a collection takes ~7 minutes

Once you have run 11a, you do not have to run it again. All GWAS will be run on the output of 11a.

In my case I created two files, phenotype and covariate, you can feel pree to combine them into one, but I prefer to keep them seperate.
Standalone workflow
