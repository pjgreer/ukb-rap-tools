#!/bin/bash

# This script runs the cohort and QC filter on te imputed data using plink

# Requirements: 
# 0-4 - please refer to readme.md
# 5. Must have executed: 
# 	- This the first script in a standalone workflow


# How to Run:
# Run this shell script using: 
#   sh 11a-gwas-s2-imp37-qc-filter.sh
# on the command line on your own machine

# Inputs:
# Note that you can adjust the output directory by setting the data_file_dir variable
# - /gwas_cohort_textfiles/phenotypes.v08-04-22.txt - (outside of scope)

# for each chromosome, you will run a separate worker
# - /{imp_file_dir}/ukb22828_c1_b0_v3.bgen 
# - /{imp_file_dir}/ukb22828_c1_b0_v3.sample

# Outputs (for each chromosome):
# - /data/ap_imp37_gwas/ukb22828_c1_v3.bed  
# - /data/ap_imp37_gwas/ukb22828_c1_v3.bim 
# - /data/ap_imp37_gwas/ukb22828_c1_v3.fam                  
# - /data/ap_imp37_gwas/ukb22828_c1_v3.log

# Steps:
# 1. for each chromosome 1-22 and X:
#       - filter by QC metrics and cohort
#       - write out list of snps and ids that pass filter


#set this to the exome sequence directory that you want (should contain PLINK formatted files)
imp_file_dir="/Bulk/Imputation/UKB imputation from genotype/"
#set this to the exome data field for your release
data_field="ukb22828"
data_file_dir="/data/ap_imp37_gwas"
txt_file_dir="/gwas_cohort_textfiles"

for i in {1..22}; do
    run_plink_imp="plink2 --bgen ${data_field}_c${i}_b0_v3.bgen ref-first\
      --sample ${data_field}_c${i}_b0_v3.sample \
      --make-pgen --out ukbi_ch${i}_v3; \
    plink2 --pfile ukbi_ch${i}_v3 \
      --no-pheno --keep phenotypes.v08-04-22.txt \
      --maf 0.006 --mac 20 --geno 0.1 --mind 0.1 --maf-max 0.994 \
      --make-bed --out ${data_field}_c${i}_v3; \
     rm ukbi_ch${i}_v3* "

    dx run swiss-army-knife -iin="${imp_file_dir}/${data_field}_c${i}_b0_v3.bgen" \
     -iin="${imp_file_dir}/${data_field}_c${i}_b0_v3.sample" \
     -iin="${txt_file_dir}/phenotypes.v08-04-22.txt" \
     -icmd="${run_plink_imp}" --tag="Step2" --instance-type "mem2_ssd2_v2_x16"\
     --destination="${project}:/data/ap_imp37_gwas" --brief --yes
done

# now run chrX

    run_plink_impX="plink2 --bgen ${data_field}_cX_b0_v3.bgen ref-first\
      --sample ${data_field}_cX_b0_v3.sample \
      --make-pgen --out ukbi_chX_v3; \
    plink2 --pfile ukbi_chX_v3 \
      --no-pheno --keep phenotypes.v08-04-22.txt \
      --maf 0.006 --mac 20 --geno 0.1 --mind 0.1 --maf-max 0.994 \
      --make-bed --out ${data_field}_cX_v3; \
     rm ukbi_chX_v3* "
    
    dx run swiss-army-knife -iin="${imp_file_dir}/${data_field}_cX_b0_v3.bgen" \
     -iin="${imp_file_dir}/${data_field}_cX_b0_v3.sample" \
     -iin="${txt_file_dir}/phenotypes.v08-04-22.txt" \
     -icmd="${run_plink_impX}" --tag="Step2" --instance-type "mem2_ssd2_v2_x16"\
     --destination="${project}:/data/ap_imp37_gwas" --brief --yes


