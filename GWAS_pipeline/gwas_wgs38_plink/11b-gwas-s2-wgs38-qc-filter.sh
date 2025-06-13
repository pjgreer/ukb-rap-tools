#!/bin/bash

# This script runs the cohort and QC filter on te WGS data using plink

# Requirements: 
# 0-4 - please refer to readme.md
# 5. Must have executed: 
# - all scripts including liftover from 01_prep_gtfile_4_GWAS


# How to Run:
# Run this shell script using: 
#   sh 11b-gwas-s2-wgs38-qc-filter
# on the command line on your own machine

# Inputs:
# Note that you can adjust the output directory by setting the data_file_dir variable
# - /gwas_cohort_textfiles/phenotypes.v08-04-22.tx - (outside of scope)

# for each chromosome, you will run a separate worker
# - /{wgs_file_dir}/ukb24308_c1_b0_v1.bed 
# - /{wgs_file_dir}/ukb24308_c1_b0_v1.bim 
# - /{wgs_file_dir}/ukb24308_c1_b0_v1.bam 

# Outputs (for each chromosome):
# - /data/ap_wgs_gwas/WGS_c1_snps_qc_pass.id  
# - /data/ap_wgs_gwas/WGS_c1_snps_qc_pass.snplist 
# - /data/ap_wgs_gwas/WGS_c1_snps_qc_pass.log

# Steps:
# 1. for each chromosome 1-22 and X:
# 	- filter by QC metrics and cohort
#	- write out list of snps and ids that pass filter


#set this to the WGS population sequence directory  (PLINK formatted files)
wgs_file_dir="/Bulk/DRAGEN WGS/DRAGEN population level WGS variants, PLINK format [500k release]/"
#set this to the dragen wgs population data field for your release
data_field="ukb24308"

# where you want the filtered data to be writtenn to
data_file_dir="/data/wgs_gwas/"
txt_file_dir="/gwas_cohort_textfiles/"
phenotype_file="phenotypes.v04-24-25.txt"

# loop over autosomes
for i in {1..22}; do
    run_plink_wgs="plink2 --pfile ${data_field}_c${i}_b0_v1\
      --no-pheno --keep ${phenotype_file} \
      --maf 0.0005 --mac 20 --geno 0.1 --mind 0.1 --max-maf 0.9995 \
      --write-snplist --write-samples --no-id-header\
      --out WGS_c${i}_snps_qc_pass"

    dx run swiss-army-knife -iin="${wgs_file_dir}/${data_field}_c${i}_b0_v1.pgen" \
     -iin="${wgs_file_dir}/${data_field}_c${i}_b0_v1.pvar" \
     -iin="${wgs_file_dir}/${data_field}_c${i}_b0_v1.psam"\
     -iin="${txt_file_dir}/${phenotype_file}" \
     -icmd="${run_plink_wgs}" --tag="wgs-qc${i}" --instance-type "mem1_ssd1_v2_x16"\
     --destination="${project}:${data_file_dir}" --brief --yes
done

# run chrX seperately
    run_plink_wgs="plink2 --pfile ${data_field}_cX_b0_v1\
      --no-pheno --keep ${phenotype_file} \
      --maf 0.0005 --mac 20 --geno 0.1  --mind 0.1 --max-maf 0.9995 \
      --write-snplist --write-samples --no-id-header\
      --out WGS_cX_snps_qc_pass"
    
    dx run swiss-army-knife -iin="${wgs_file_dir}/${data_field}_cX_b0_v1.pgen" \
     -iin="${wgs_file_dir}/${data_field}_cX_b0_v1.pvar" \
     -iin="${wgs_file_dir}/${data_field}_cX_b0_v1.psam"\
     -iin="${txt_file_dir}/${phenotype_file}" \
     -icmd="${run_plink_wgs}" --tag="wgs-qcX" --instance-type "mem1_ssd1_v2_x16"\
     --destination="${project}:${data_file_dir}" --brief --yes

