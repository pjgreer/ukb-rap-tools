#!/bin/bash

# This script runs the step2 analysis for regenie on WES data.

# Requirements: 
# 0-4 - please refer to readme.md
# 5. Must have executed: 
# - all scripts including liftover from 01_prep_gtfile_4_GWAS
# - 09b-step1-regenie.sh
# - 11b-gwas-s2-wes38-qc-filter.sh

# How to Run:
# Run this shell script using: 
#   sh 12b-gwas-s2-wes38-regenie.sh
# on the command line on your own machine

# Inputs:
# Note that you can adjust the output directory by setting the data_file_dir variable
# - /gwas_cohort_textfiles/phenotypes.v08-04-22.txt - from part A (please refer to notebook & slides)
# - /gwas_cohort_textfiles/covariates.v08-04-22.txt - from part A (please refer to notebook & slides)
# - /data/ap38_results_1.loco.gz - from 09b-step1-regenie.sh
# - /data/ap38_results_pred.list - from 09b-step1-regenie.sh

# Additional inputs
# for each chromosome, you will run a separate worker
# - /{exome_file_dir}/ukb23158_c1_b0_v1.bed - Chr1 file for 200k release
# - /{exome_file_dir}/ukb23158_c1_b0_v1.bim 
# - /{exome_file_dir}/ukb23158_c1_b0_v1.bam 
# - /data/ap_wes_gwas/WES_c1_snps_qc_pass.snplist - from 11b-gwas-s2-wes38-qc-filter.sh

# Outputs (for each chromosome):
# - /data/ap_wes_gwas/assoc.c1_AP.regenie.gz - regenie results for chromosome 1 
# note that if you have multiple phenotypes, you will have a .regenie.gz for each phenotype
# - /data/ap_wes_gwas/assoc.c1.log  - regenie log for chromosome 1

# Steps:
# 1. for each chromosome 1-22 and X:
#       - run regenie 

exome_file_dir="/Bulk/Exome sequences/Population level exome OQFE variants, PLINK format - final release/"
#set this to the exome data field for your release
data_field="ukb23158"
data_file_dir="/data/ap_wes_gwas/"
txt_file_dir="/gwas_cohort_textfiles/"


for chr in {1..22}; do
  run_regenie_cmd="regenie --step 2 --out assoc.c${chr} \
    --bed ${data_field}_c${chr}_b0_v1 \
    --phenoFile phenotypes.v08-04-22.txt --covarFile covariates.v08-04-22.txt \
    --bt --approx --firth-se --firth --extract WES_c${chr}_snps_qc_pass.snplist \
    --phenoCol AP --covarCol age --covarCol sex.b2 --covarCol bmi --covarCol smoke \
    --covarCol pca{1:9} --pred ap38_results_pred.list --bsize 200 \
    --pThresh 0.05 --minMAC 3 --threads 16 --gz"

  dx run swiss-army-knife -iin="${exome_file_dir}/${data_field}_c${chr}_b0_v1.bed" \
   -iin="${exome_file_dir}/${data_field}_c${chr}_b0_v1.bim" \
   -iin="${exome_file_dir}/${data_field}_c${chr}_b0_v1.fam" \
   -iin="${data_file_dir}/WES_c${chr}_snps_qc_pass.snplist" \
   -iin="${txt_file_dir}/phenotypes.v08-04-22.txt" \
   -iin="${txt_file_dir}/covariates.v08-04-22.txt" \
   -iin="${data_file_dir}/ap38_results_pred.list" \
   -iin="${data_file_dir}/ap38_results_1.loco.gz" \
   -icmd="${run_regenie_cmd}" --tag="Step2" --instance-type "mem1_ssd1_v2_x16"\
   --destination="${project}:/data/ap_wes_gwas/" --brief --yes

done


  run_regenie_cmd="regenie --step 2 --out assoc.cX \
    --bed ${data_field}_cX_b0_v1 \
    --phenoFile phenotypes.v08-04-22.txt --covarFile covariates.v08-04-22.txt \
    --bt --approx --firth-se --firth --extract WES_cX_snps_qc_pass.snplist \
    --phenoCol AP --covarCol age --covarCol sex.b2 --covarCol bmi --covarCol smoke \
    --covarCol pca{1:9} --pred ap38_results_pred.list --bsize 200 \
    --pThresh 0.05 --minMAC 3 --threads 16 --gz"

  dx run swiss-army-knife -iin="${exome_file_dir}/${data_field}_cX_b0_v1.bed" \
   -iin="${exome_file_dir}/${data_field}_cX_b0_v1.bim" \
   -iin="${exome_file_dir}/${data_field}_cX_b0_v1.fam" \
   -iin="${data_file_dir}/WES_cX_snps_qc_pass.snplist" \
   -iin="${txt_file_dir}/phenotypes.v08-04-22.txt" \
   -iin="${txt_file_dir}/covariates.v08-04-22.txt" \
   -iin="${data_file_dir}/ap38_results_pred.list" \
   -iin="${data_file_dir}/ap38_results_1.loco.gz" \
   -icmd="${run_regenie_cmd}" --tag="Step2" --instance-type "mem1_ssd1_v2_x16"\
   --destination="${project}:/data/ap_wes_gwas/" --brief --yes

