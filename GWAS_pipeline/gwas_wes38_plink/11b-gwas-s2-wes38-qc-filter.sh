#!/bin/bash

# This script runs the cohort and QC filter on te WES data using plink

# Requirements: 
# 0-4 - please refer to readme.md
# 5. Must have executed: 
# - all scripts including liftover from 01_prep_gtfile_4_GWAS


# How to Run:
# Run this shell script using: 
#   sh 11b-gwas-s2-wes38-qc-filter
# on the command line on your own machine

# Inputs:
# Note that you can adjust the output directory by setting the data_file_dir variable
# - /gwas_cohort_textfiles/phenotypes.v08-04-22.tx - (outside of scope)

# for each chromosome, you will run a separate worker
# - /{exome_file_dir}/ukb23158_c1_b0_v1.bed 
# - /{exome_file_dir}/ukb23158_c1_b0_v1.bim 
# - /{exome_file_dir}/ukb23158_c1_b0_v1.bam 

# Outputs (for each chromosome):
# - /data/ap_wes_gwas/WES_c1_snps_qc_pass.id  
# - /data/ap_wes_gwas/WES_c1_snps_qc_pass.snplist 
# - /data/ap_wes_gwas/WES_c1_snps_qc_pass.log

# Steps:
# 1. for each chromosome 1-22 and X:
# 	- filter by QC metrics and cohort
#	- write out list of snps and ids that pass filter

#set this to the exome sequence directory that you want (should contain PLINK formatted files)
exome_file_dir="/Bulk/Exome sequences/Population level exome OQFE variants, PLINK format - final release/"
#set this to the exome data field for your release
data_field="ukb23158"
# where you want the filtered data to be writtenn to
data_file_dir="/data/wes_gwas/"
txt_file_dir="/gwas_cohort_textfiles/"
phenotype_file="phenotypes.v04-24-25.txt"

for i in {1..22}; do
    run_plink_wes="plink2 --bfile ${data_field}_c${i}_b0_v1\
      --no-pheno --keep ${phenotype_file} \
      --maf 0.0005 --mac 20 --geno 0.1 --mind 0.1 --max-maf 0.9995 \
      --write-snplist --write-samples --no-id-header\
      --out WES_c${i}_snps_qc_pass"

    dx run swiss-army-knife -iin="${exome_file_dir}/${data_field}_c${i}_b0_v1.bed" \
     -iin="${exome_file_dir}/${data_field}_c${i}_b0_v1.bim" \
     -iin="${exome_file_dir}/${data_field}_c${i}_b0_v1.fam"\
     -iin="${txt_file_dir}/${phenotype_file}" \
     -icmd="${run_plink_wes}" --tag="Step2" --instance-type "mem1_ssd1_v2_x16"\
     --destination="${project}:${data_file_dir}" --brief --yes
done


    run_plink_wes="plink2 --bfile ${data_field}_cX_b0_v1\
      --no-pheno --keep ${phenotype_file} \
      --maf 0.0005 --mac 20 --geno 0.1  --mind 0.1 --max-maf 0.9995 \
      --write-snplist --write-samples --no-id-header\
      --out WES_cX_snps_qc_pass"
    
    dx run swiss-army-knife -iin="${exome_file_dir}/${data_field}_cX_b0_v1.bed" \
     -iin="${exome_file_dir}/${data_field}_cX_b0_v1.bim" \
     -iin="${exome_file_dir}/${data_field}_cX_b0_v1.fam"\
     -iin="${txt_file_dir}/${phenotype_file}" \
     -icmd="${run_plink_wes}" --tag="Step2" --instance-type "mem1_ssd1_v2_x16"\
     --destination="${project}:${data_file_dir}" --brief --yes

