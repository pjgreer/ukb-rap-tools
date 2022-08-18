 # GWAS pipeline
 
 I probably made this too complex, but while working these out, several sections rely on a prior section in order to run properly.
 
 There are 6 seperate parts:
 
 1. genotype file preparation
 2. genotype file liftover to grch38
 3. GWAS using imputed dataset with plink
 4. GWAS using imputed dataset with regenie
 5. GWAS using WES dataset with plink
 6. GWAS using WES dataset with regenie
 

'GWAS using imputed dataset with plink' and 'GWAS using WES dataset with plink' are stand alone workflows. Each has three seperate scripts than when run sequentially will produce GWAS results from your preset phenotype and covariate file.

The 'GWAS using imputed dataset with regenie' workflow requires that you run 'genotype file preparation' prior to the gwas analysis.

FInally, 'GWAS using WES dataset with regenie' workflow requires 'genotype file preparation' and 'genotype file liftover to grch38' to be run first. 

Two scripts are repeated to make each workflow semi-selfcontained. If you are planning to run GWAS on the imputed dataset using both regenie and plink, the QC filter script "11a-gwas-s2-imp37-qc-filter.sh" only needs to be run once. The same for "11b-gwas-s2-wes38-qc-filter.sh" in the wgat using WES data folders. 

The phenotype and covariate files for regenie must code missing data as NA

The phenotype and covariate files for plink must code missing data as -9

