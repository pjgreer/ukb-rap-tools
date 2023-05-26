#!/bin/bash

# This script runs the cohort and QC filter on imputed UKB data using plink2

# Requirements: 
# 0-4 - please refer to top level Readme.md
# 5. Must have executed: 
#  - This is the first step of the HWE simulation
# 


# How to Run:
# Run this shell script using: 
#   sh v1-imp37-chr1-qc-filter.sh
# on the command line on your own machine

# Inputs:
# Note that you can adjust the output directory by setting the data_file_dir variable

# for chromosome 1
# - /{imp_file_dir}/ukb22828_c1_b0_v3.bgen 
# - /{imp_file_dir}/ukb22828_c1_b0_v3.sample

# Outputs:
# - /data/qc_test/ukb_c1_v3.pgen  
# - /data/qc_test/ukb_c1_v3.psam  
# - /data/qc_test/ukb_c1_v3.pvar  
# - /data/qc_test/ukb_c1_v3.log
# - /data/qc_test/ukb_c1_v3_all.hardy
# - /data/qc_test/ukb_c1_v3_all.afreq
# - /data/qc_test/ukb_c1_v3_all.smiss
# - /data/qc_test/ukb_c1_v3_all.imiss
# - /data/qc_test/ukb_c1_v3_all.log


# Steps:
# 1. for chromosome 1:
#       - filter by QC metrics
#       - write out pgen file set


#set this to the exome sequence directory that you want (should contain PLINK formatted files)
imp_file_dir="/Bulk/Imputation/UKB imputation from genotype/"
#set this to the genetic data field for your release
data_field="ukb22828"
data_file_dir="/data/qc_test"
txt_file_dir="/gwas_cohort_textfiles"


# run qctest on  chr1
# i did not at the time but I should have added the --maf-max 0.994
# this is the upper maf bound in plink2, but does not affect the results much


    run_plink_hsim="plink2 --bgen ${data_field}_c1_b0_v3.bgen ref-first \
      --sample ${data_field}_c1_b0_v3.sample \
      --maf 0.006 --mac 20 --geno 0.1 --mind 0.1 \
      --make-pgen --out ukbi_ch1_v3 ; \
    plink2 --pfile ukbi_ch1_v3 --freq --missing --no-psam-pheno \
      --hardy --out ${data_field}_c1_v3_all "
    
    dx run swiss-army-knife -iin="${imp_file_dir}/${data_field}_c1_b0_v3.bgen" \
     -iin="${imp_file_dir}/${data_field}_c1_b0_v3.sample" \
     -icmd="${run_plink_hsim}" --tag="qc-test" --instance-type "mem2_ssd1_v2_x32"\
     --destination="${project}:/data/qc_test" --brief --yes


