#!/bin/bash

# Requirements: 
# 0-4 - please refer to readme.md
# 5. Must have executed: 
# - partB-merge-files-dx-fuse.sh 
# - partC-step1-qc-filter.sh
# - partD-step1-regenie.sh
# - partE-step2-qc-filter.sh

# How to Run:
# Run this shell script using: 
#   sh partF-step2-regenie.sh 
# on the command line on your own machine

# Inputs:
# Note that you can adjust the output directory by setting the data_file_dir variable
# - /Data/diabetes_wes_200k.phe - from part A (please refer to notebook & slides)
# - /Data/diabetes_results_1.loco.gz - from part D
# - /Data/diabetes_results_pred.list - from part D

# Additional inputs
# for each chromosome, you will run a separate worker
# - /{exome_file_dir}/ukb23155_c1_b0_v1.bed - Chr1 file for 200k release
# - /{exome_file_dir}/ukb23155_c1_b0_v1.bim 
# - /{exome_file_dir}/ukb23155_c1_b0_v1.bam 
# - /Data/WES_c1_snps_qc_pass.snplist - from Part E

# Outputs (for each chromosome):
# - /Data/assoc.c1_diabetes_cc.regenie.gz - regenie results for chromosome 1 
# note that if you have multiple phenotypes, you will have a .regenie.gz for each phenotype
# - /Data/assoc.c1.log  - regenie log for chromosome 1

#set this to the exome sequence directory that you want (should contain PLINK formatted files)
imp_file_dir="/Bulk/Imputation/UKB imputation from genotype/"
#set this to the exome data field for your release
data_field="ukb22828"
data_file_dir="/data/ap_imp37_gwas"
txt_file_dir="/gwas_cohort_textfiles"


for chr in {1..22}; do
  run_regenie_cmd="regenie --step 2 --out assoc.c${chr} \
    --bgen ${data_field}_c${chr}_b0_v3 \
    --phenoFile phenotypes.v08-04-22.txt --covarFile covariates.v08-04-22.txt \
    --bt --approx --firth-se --firth --extract ${data_field}_c${chr}_snps_qc_pass.snplist \
    --phenoCol AP --covarCol age --covarCol sex.b2 --covarCol bmi --covarCol smoke \
    --covarCol pca{1:9} --pred ap37_results_pred.list --bsize 200 \
    --pThresh 0.05 --minMAC 3 --threads 16 --gz"

  dx run swiss-army-knife -iin="${imp_file_dir}/${data_field}_c${chr}_b0_v3.bgen" \
   -iin="${imp_file_dir}/${data_field}_c${chr}_b0_v3.sample" \
   -iin="${data_file_dir}/${data_field}_c${chr}_snps_qc_pass.snplist" \
   -iin="${txt_file_dir}/phenotypes.v08-04-22.txt" \
   -iin="${txt_file_dir}/covariates.v08-04-22.txt" \
   -iin="${data_file_dir}/ap37_results_pred.list" \
   -iin="${data_file_dir}/ap37_results_1.loco.gz" \
   -icmd="${run_regenie_cmd}" --tag="Step2" --instance-type "mem1_ssd1_v2_x16"\
   --destination="${project}:/data/ap_imp37_gwas/" --brief --yes

done

# now run chrX

  run_regenieX_cmd="regenie --step 2 --out assoc.cX \
    --bgen ${data_field}_cX_b0_v3 \
    --phenoFile phenotypes.v08-04-22.txt --covarFile covariates.v08-04-22.txt \
    --bt --approx --firth-se --firth --extract ${data_field}_cX_snps_qc_pass.snplist \
    --phenoCol AP --covarCol age --covarCol sex.b2 --covarCol bmi --covarCol smoke \
    --covarCol pca{1:9} --pred ap37_results_pred.list --bsize 200 \
    --pThresh 0.05 --minMAC 3 --threads 16 --gz"

  dx run swiss-army-knife -iin="${imp_file_dir}/${data_field}_cX_b0_v3.bgen" \
   -iin="${imp_file_dir}/${data_field}_cX_b0_v3.sample" \
   -iin="${data_file_dir}/${data_field}_cX_snps_qc_pass.snplist" \
   -iin="${txt_file_dir}/phenotypes.v08-04-22.txt" \
   -iin="${txt_file_dir}/covariates.v08-04-22.txt" \
   -iin="${data_file_dir}/ap37_results_pred.list" \
   -iin="${data_file_dir}/ap37_results_1.loco.gz" \
   -icmd="${run_regenieX_cmd}" --tag="Step2" --instance-type "mem1_ssd1_v2_x16"\
   --destination="${project}:/data/ap_imp37_gwas/" --brief --yes

