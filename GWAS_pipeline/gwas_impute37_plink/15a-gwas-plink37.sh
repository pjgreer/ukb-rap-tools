#!/bin/bash

# This script runs the step2 analysis for plink2 on imputed data.

# Requirements: 
# 0-4 - please refer to readme.md
# 5. Must have executed: 
# 	- 11a-gwas-s2-imp-qc-filter.sh

# How to Run:
# Run this shell script using: 
#   sh 15a-gwas-plink37.sh
# on the command line on your own machine

# Inputs:
# Note that you can adjust the output directory by setting the data_file_dir variable
# - /gwas_cohort_textfiles/phenotypes.v08-01-22.txt - (outside of scope)
# - /gwas_cohort_textfiles/covariates.v08-01-22.txt - (outside of scope)

# Additional inputs
# for each chromosome, you will run a separate worker
# - /{data_file_dir}/ukb23158_c1_v3.bed - from 11a
# - /{data_file_dir}/ukb23158_c1_v3.bim 
# - /{data_file_dir}/ukb23158_c1_v3.fam 

# Outputs (for each chromosome):
# - /data/ap_imp37_gwas/plink/ukb23158_AP_c1_v1.AP.glm.logistic.hybrid - plink results for chromosome 1 
# - /data/ap_imp37_gwas/plink/ukb23158_AP_c1_v1.log  - plink log for chromosome 1
# etc

# Steps:
# 1. for each chromosome 1-22 and X:
#       - run logistic regression using plink2

#set this to the exome sequence directory that you want (should contain PLINK formatted files)
imp_file_dir="/Bulk/Imputation/UKB imputation from genotype/"
#set this to the exome data field for your release
data_field="ukb22828"
data_file_dir="/data/ap_imp37_gwas"
txt_file_dir="/gwas_cohort_textfiles"


for i in {1..22}; do

  run_plink_imp="plink2 --bfile ${data_field}_c${i}_v3 --1 \
      --pheno phenotypes.v08-01-22.txt --pheno-name AP \
      --covar covariates.v08-01-22.txt --covar-name age,bmi,smoke,pca1-pca6 \
      --logistic sex hide-covar --out ${data_field}_AP_c${i}_v3"


  dx run swiss-army-knife -iin="${data_file_dir}/${data_field}_c${i}_v3.bed" \
   -iin="${data_file_dir}/${data_field}_c${i}_v3.bim" \
   -iin="${data_file_dir}/${data_field}_c${i}_v3.fam" \
   -iin="${txt_file_dir}/phenotypes.v08-01-22.txt" \
   -iin="${txt_file_dir}/covariates.v08-01-22.txt" \
   -icmd="${run_plink_imp}" --tag="plink" --instance-type "mem1_ssd1_v2_x16"\
   --destination="${project}:/data/ap_imp37_gwas/plink/" --brief --yes

done

# now run chrX

  run_plink_imp="plink2 --bfile "${data_field}_cX_v3" --1 \
      --pheno phenotypes.v08-01-22.txt --pheno-name AP \
      --covar covariates.v08-01-22.txt --covar-name age,bmi,smoke,pca1-pca6 \
      --logistic sex hide-covar --out ${data_field}_AP_cX_v3"

  dx run swiss-army-knife -iin="${data_file_dir}/${data_field}_cX_v3.bed" \
   -iin="${data_file_dir}/${data_field}_cX_v3.bim" \
   -iin="${data_file_dir}/${data_field}_cX_v3.fam" \
   -iin="${txt_file_dir}/phenotypes.v08-01-22.txt" \
   -iin="${txt_file_dir}/covariates.v08-01-22.txt" \
   -icmd="${run_plink_imp}" --tag="plink" --instance-type "mem1_ssd1_v2_x16"\
   --destination="${project}:/data/ap_imp37_gwas/plink/" --brief --yes

