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

# Additional inputs
# for each chromosome, you will run a separate worker
# - /{data_file_dir}/ukb23158_c1_v3.bed - from 11a
# - /{data_file_dir}/ukb23158_c1_v3.bim 
# - /{data_file_dir}/ukb23158_c1_v3.fam 

# Outputs (for each chromosome):
# - /data/ap_wes_gwas/assoc.c1_AP.regenie.gz - regenie results for chromosome 1 
# note that if you have multiple phenotypes, you will have a .regenie.gz for each phenotype
# - /data/ap_wes_gwas/assoc.c1.log  - regenie log for chromosome 1

# Steps:
# 1. for each chromosome 1-22 and X:
#       - run regenie 

#set this to the exome sequence directory that you want (should contain PLINK formatted files)
imp_file_dir="/Bulk/Imputation/UKB imputation from genotype/"
#set this to the exome data field for your release
data_field="ukb22828"
data_file_dir="/data/ap_imp37_gwas"
txt_file_dir="/gwas_cohort_textfiles"


for chr in {1..22}; do
  run_regenie_cmd="regenie --step 2 --out assoc.c${chr} \
    --bed ${data_field}_c${chr}_v3 \
    --phenoFile phenotypes.v08-04-22.txt --covarFile covariates.v08-04-22.txt \
    --bt --approx --firth-se --firth \
    --phenoCol AP --covarCol age --covarCol sex.b2 --covarCol bmi --covarCol smoke \
    --covarCol pca{1:9} --pred ap37_results_pred.list --bsize 200 \
    --pThresh 0.05 --minMAC 3 --threads 16 --gz"

  dx run swiss-army-knife -iin="${data_file_dir}/${data_field}_c${chr}_v3.bed" \
   -iin="${data_file_dir}/${data_field}_c${chr}_v3.bim" \
   -iin="${data_file_dir}/${data_field}_c${chr}_v3.fam" \
   -iin="${txt_file_dir}/phenotypes.v08-04-22.txt" \
   -iin="${txt_file_dir}/covariates.v08-04-22.txt" \
   -iin="${data_file_dir}/ap37_results_pred.list" \
   -iin="${data_file_dir}/ap37_results_1.loco.gz" \
   -icmd="${run_regenie_cmd}" --tag="Step2" --instance-type "mem1_ssd1_v2_x16"\
   --destination="${project}:/data/ap_imp37_gwas/" --brief --yes

done

# now run chrX

  run_regenieX_cmd="regenie --step 2 --out assoc.cX \
    --bed ${data_field}_cX_v3 \
    --phenoFile phenotypes.v08-04-22.txt --covarFile covariates.v08-04-22.txt \
    --bt --approx --firth-se --firth \
    --phenoCol AP --covarCol age --covarCol sex.b2 --covarCol bmi --covarCol smoke \
    --covarCol pca{1:9} --pred ap37_results_pred.list --bsize 200 \
    --pThresh 0.05 --minMAC 3 --threads 16 --gz"

  dx run swiss-army-knife -iin="${data_file_dir}/${data_field}_cX_v3.bed" \
   -iin="${data_file_dir}/${data_field}_cX_v3.bim" \
   -iin="${data_file_dir}/${data_field}_cX_v3.fam" \
   -iin="${txt_file_dir}/phenotypes.v08-04-22.txt" \
   -iin="${txt_file_dir}/covariates.v08-04-22.txt" \
   -iin="${data_file_dir}/ap37_results_pred.list" \
   -iin="${data_file_dir}/ap37_results_1.loco.gz" \
   -icmd="${run_regenieX_cmd}" --tag="Step2" --instance-type "mem1_ssd1_v2_x16"\
   --destination="${project}:/data/ap_imp37_gwas/" --brief --yes

