#!/bin/bash

# This script runs the step2 analysis for plink2 on imputed data.

# Requirements: 
# 0-4 - please refer to readme.md
# 5. Must have executed: 
# 	- 11a-gwas-s2-topmed-qc-filter.sh

# How to Run:
# Run this shell script using: 
#   sh 15a-gwas-topmed-plink.sh
# on the command line on your own machine

# Inputs:
# Note that you can adjust the output directory by setting the data_file_dir variable
# - /gwas_cohort_textfiles/phenotypes.v03-15-23.txt - (outside of scope)
# - /gwas_cohort_textfiles/covariates.v03-15-23.txt - (outside of scope)

# Additional inputs
# for each chromosome, you will run a separate worker
# - /data/topmed_gwas/ukb21007_c1_v1.1.pgen # From 11a 
# - /data/topmed_gwas/ukb21007_c1_v1.1.pvar 
# - /data/topmed_gwas/ukb21007_c1_v1.1.psam  

# Outputs (for each chromosome):
# - /data/gs_all_gwas/topmed_plink/ukb23158_AP_c1_v1.AP.glm.logistic.hybrid - plink results for chromosome 1 
# - /data/gs_all_gwas/topmed_plink/ukb23158_AP_c1_v1.log  - plink log for chromosome 1
# etc

# Steps:
# 1. for each chromosome 1-22 and X:
#       - run logistic regression using plink2

#set this to the exome sequence directory that you want (should contain PLINK formatted files)
imp_file_dir="/Bulk/Imputation/Imputation from genotype (TOPmed)//"
#set this to the exome data field for your release
data_field="ukb21007"
data_file_dir="/data/topmed_gwas"
txt_file_dir="/gwas_cohort_textfiles"


for i in {1..22}; do

  run_plink_imp="plink2 --pfile ${data_field}_c${i}_v1.1 --1 \
      --pheno phenotypes.v03-15-23.txt --pheno-name GS_ALL \
      --covar covariates.v03-15-23.txt --covar-name age,bmi,smoke,pca1-pca6 \
      --logistic sex hide-covar --hardy --freq --out ${data_field}_GS_ALL_c${i}_"

  dx run swiss-army-knife -iin="${data_file_dir}/${data_field}_c${i}_v1.1.pgen" \
   -iin="${data_file_dir}/${data_field}_c${i}_v1.1.pvar" \
   -iin="${data_file_dir}/${data_field}_c${i}_v1.1.psam" \
   -iin="${txt_file_dir}/phenotypes.v03-15-23.txt" \
   -iin="${txt_file_dir}/covariates.v03-15-23.txt" \
   -icmd="${run_plink_imp}" --tag="plink" --instance-type "mem1_ssd1_v2_x16" \
   --destination="${project}:/data/gs_all_gwas/topmed_plink/" --brief --yes

done


# now run chrX

  run_plink_imp="plink2 --pfile "${data_field}_cX_v1.1" --1 \
      --pheno phenotypes.v03-15-23.txt --pheno-name GS_ALL \
      --covar covariates.v03-15-23.txt --covar-name age,bmi,smoke,pca1-pca6 \
      --logistic sex hide-covar --hardy --freq --out ${data_field}_GS_ALL_cX_"

  dx run swiss-army-knife -iin="${data_file_dir}/${data_field}_cX_v1.1.pgen" \
   -iin="${data_file_dir}/${data_field}_cX_v1.1.pvar" \
   -iin="${data_file_dir}/${data_field}_cX_v1.1.psam" \
   -iin="${txt_file_dir}/phenotypes.v03-15-23.txt" \
   -iin="${txt_file_dir}/covariates.v03-15-23.txt" \
   -icmd="${run_plink_imp}" --tag="plink" --instance-type "mem1_ssd1_v2_x16"\
   --destination="${project}:/data/gs_all_gwas/topmed_plink/" --brief --yes

