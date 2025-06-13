#!/bin/bash

# This script runs the logistic regression GWAS using plink2 on WGS data.

# Requirements: 
# 0-4 - please refer to readme.md
# 5. Must have executed: 
# - 11b-gwas-s2-wgs38-qc-filter.sh

# How to Run:
# Run this shell script using: 
#   sh 15b-gwas-plink-wgs.sh  
# on the command line on your own machine

# Inputs:
# Note that you can adjust the output directory by setting the data_file_dir variable
# - /gwas_cohort_textfiles/phenotypes.v08-01-22.txt -  (outside of scope)
# - /gwas_cohort_textfiles/covariates.v08-01-22.txt -  (outside of scope)

# Additional inputs
# for each chromosome, you will run a separate worker
# - /${wgs_file_dir}/${data_field}_c${i}_b0_v1.pgen
# - /${wgs_file_dir}/${data_field}_c${i}_b0_v1.pvar
# - /${wgs_file_dir}/${data_field}_c${i}_b0_v1.psam
# - /{data_file_dir}/WGS_c2_snps_qc_pass.snplist - from 11a

# Outputs (for each chromosome):
# - /data/ap_wgs_gwas/plink/ukb24308_AP_c1_v1.AP.glm.logistic.hybrid - plink results for chromosome 1 
# - /data/ap_wgs_gwas/plink/ukb24308_AP_c1_v1.log  - plink log for chromosome 1

# Steps:
# 1. for each chromosome 1-22 and X:
#       - run logistic regression using plink 

# This is the path to the bulk wgs population data
wgs_file_dir="/Bulk/DRAGEN WGS/DRAGEN population level WGS variants, PLINK format [500k release]/"
#set this to the dragen wgs population data field for your release
data_field="ukb24308"

data_file_dir="/data/wgs_gwas/"
txt_file_dir="/gwas_cohort_textfiles/"
phenotype_file="phenotypes.v04-24-25.txt"
covariates_file="covariates.v04-24-25.txt"


for i in {1..22}; do

  run_plink_wgs="plink2 --pfile ${data_field}_c${i}_b0_v1 --1 \
      --extract WGS_c${i}_snps_qc_pass.snplist --neg9-pheno-really-missing \
      --pheno ${phenotype_file} --pheno-name CP \
      --covar ${covariates_file} --covar-name age,bmi,smoke,pca1-pca6 \
      --logistic sex hide-covar --out ${data_field}_CP_c${i}_v1"


  dx run swiss-army-knife -iin="${wgs_file_dir}/${data_field}_c${i}_b0_v1.pgen" \
   -iin="${wgs_file_dir}/${data_field}_c${i}_b0_v1.pvar" \
   -iin="${wgs_file_dir}/${data_field}_c${i}_b0_v1.psam" \
   -iin="${data_file_dir}/WGS_c${i}_snps_qc_pass.snplist" \
   -iin="${txt_file_dir}/${phenotype_file}" \
   -iin="${txt_file_dir}/${covariates_file}" \
   -icmd="${run_plink_wgs}" --tag="plink-wgs${i}" --instance-type "mem1_ssd1_v2_x16"\
   --destination="${project}:/data/cp_wgs_plink/" --brief --yes

done

# now run chrX

  run_plink_wgs="plink2 --pfile "${data_field}_cX_b0_v1" --1 \
      --extract WGS_cX_snps_qc_pass.snplist --neg9-pheno-really-missing \
      --pheno ${phenotype_file} --pheno-name CP \
      --covar ${covariates_file} --covar-name age,bmi,smoke,pca1-pca6 \
      --logistic sex hide-covar --out ${data_field}_CP_cX_v1"

  dx run swiss-army-knife -iin="${wgs_file_dir}/${data_field}_cX_b0_v1.pgen" \
   -iin="${wgs_file_dir}/${data_field}_cX_b0_v1.pvar" \
   -iin="${wgs_file_dir}/${data_field}_cX_b0_v1.psam" \
   -iin="${data_file_dir}/WGS_cX_snps_qc_pass.snplist" \
   -iin="${txt_file_dir}/${phenotype_file}" \
   -iin="${txt_file_dir}/${covariates_file}" \
   -icmd="${run_plink_wgs}" --tag="plink-wgsX" --instance-type "mem1_ssd1_v2_x16"\
   --destination="${project}:/data/cp_wgs_plink/" --brief --yes

