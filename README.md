# ukb-rap-tools
Scripts and workflows for use analyzing UK Biobank data from the DNANexus Research Analysis Platform

Most will be written in bash and will interact with the dx tools.
unless stated otherwise, these scripts will be executed on your local machine.

## Prerequisites:
1. You will need dx toolkit installed on your local workstation https://documentation.dnanexus.com/downloads
2. Must have a RAP project with data dispensed
3. Must be logged in using dx login
4. Must have RAP project selected with dx select
5. Must create a folder in your RAP project called <code>/data/</code> for storing data
6. I have a folder where I store the phenotype and covariate text files seperate from the data directory in case I want to delete all my working files and recreate them later. <code>/gwas_cohort_textfiles/</code>
7. Must have already created your own phenotype and optionally a covariates file. (more on those files below)
8. I also have a <code>/scripts</code> folder in my UKB RAP project for storing and combination scripts that I choose to execute within the dx instance.


The phenotype file should be a tab or space delimited text file with a minimum of 3 columns. For plink, missing values should be coded "-9" for regenie "NA"

<code> FID IID pheno1 pheno2 pneno3 </code>

The covariate file will look similar with "-9" for missing data for regenie "NA"

<code> FID IID Sex Age BMI pca1 pca2 pca3 ... pca10 </code>

In both cases, FID and IID are duplicates of the EID column from the UKB.

