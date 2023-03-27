#!/bin/bash

# This script searches for SNPS by rsid and chom:position from given input files rsidlist.txt and chrposlist.txt
# over each od the autosomal files in the imputed UKB dataset and writes out a smaller subset file in .bgen 
# format for all found SNPs  

# Requirements: 
# 0 please refer to readme.md


# How to Run:
# Run this shell script using: 
#   bash 01-pull-snps-imp37.sh
# on the command line on your own machine

# Inputs:
# Note that you can adjust the output directory by setting the data_file_dir variable
# - /prs_textfiles/rsidlist.txt - made previously
# - /prs_textfiles/chrposlist.txt - made previously
# - .bgen, .sample, and .bgi (index) for each chromosome


# Outputs (for each chromosome):
# - /data/imp37_prsfiles/chr_1.bgen  


# Steps:
# 1. for each chromosome 1-22 and X:
# 	- filter by RSID and CHR:Start:Stop
#	- write out bgen file with only those markers that match

#set this to the exome sequence directory that you want (should contain PLINK formatted files)
imp_file_dir="/Bulk/Imputation/UKB imputation from genotype/"
#set this to the imputed data field for your release
data_field="ukb22828"
data_file_dir="/data/imp37_prsfiles/"
txt_file_dir="/prs_textfiles/"


# loop over each autosomal chromosome

for i in {1..22}; do
    run_snps="bgenix -g ${data_field}_c${i}_b0_v3.bgen -incl-rsids rsidlist.txt -incl-range chrposlist.txt > chr_${i}.bgen"

    dx run swiss-army-knife -iin="${imp_file_dir}/${data_field}_c${i}_b0_v3.bgen" \
     -iin="${imp_file_dir}/${data_field}_c${i}_b0_v3.sample" \
     -iin="${imp_file_dir}/${data_field}_c${i}_b0_v3.bgen.bgi" \
     -iin="${txt_file_dir}/rsidlist.txt" -iin="/${txt_file_dir}/chrposlist.txt" \
     -icmd="${run_snps}" --tag="SelectSNPs" --instance-type "mem2_ssd2_v2_x16"\
     --destination="${project}:${data_file_dir}" --brief --yes

done
