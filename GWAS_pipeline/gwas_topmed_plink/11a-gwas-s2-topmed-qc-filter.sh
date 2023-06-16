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
# - /{imp_file_dir}/ukb21007_c1_b0_v1.bgen 
# - /{imp_file_dir}/ukb21007_c1_b0_v1.sample

# Outputs (for each chromosome):
# - /data/topmed_gwas/ukb21007_c1_v1.1.pgen  
# - /data/topmed_gwas/ukb21007_c1_v1.1.pvar
# - /data/topmed_gwas/ukb21007_c1_v1.1.psam                  
# - /data/topmed_gwas/ukb21007_c1_v1.1.log
# - /data/topmed_gwas/ukb21007_c1_b0.1_v1.sample

# Steps:
# 1. for each chromosome 1-22 and X:
#       - filter by QC metrics and cohort
#       - write out list of snps and ids that pass filter


#set this to the exome sequence directory that you want (should contain PLINK formatted files)
imp_file_dir="/Bulk/Imputation/Imputation from genotype (TOPmed)//"
#set this to the exome data field for your release
data_field="ukb21007"
data_file_dir="/data/topmed_gwas"
txt_file_dir="/gwas_cohort_textfiles"

#for i in {1..22}; do
#    run_plink_imp="sed 's/0 0 0 0/0 0 0 D/g' ${data_field}_c${i}_b0_v1.sample > ${data_field}_c${i}_b0.1_v1.sample; \
#    plink2 --bgen ${data_field}_c${i}_b0_v1.bgen ref-first \
#      --sample ${data_field}_c${i}_b0.1_v1.sample --set-missing-var-ids @:#:'\$r':'\$a' \
#      --new-id-max-allele-len 99 truncate --make-pgen --out ukbi_ch${i}_v1; \
#    plink2 --pfile ukbi_ch${i}_v1 \
#      --no-pheno --keep phenotypes.v03-15-23.txt \
#      --maf 0.006 --mac 20 --geno 0.1 --mind 0.1 --max-maf 0.994 \
#      --make-pgen --out ${data_field}_c${i}_v1.1; \
#     rm ukbi_ch${i}_v1* "

#    dx run swiss-army-knife -iin="${imp_file_dir}/${data_field}_c${i}_b0_v1.bgen" \
#     -iin="${imp_file_dir}/${data_field}_c${i}_b0_v1.sample" \
#     -iin="${txt_file_dir}/phenotypes.v03-15-23.txt" \
#     -icmd="${run_plink_imp}" --tag="Step2" --instance-type "mem2_ssd2_v2_x16"\
#     --destination="${project}:/data/topmed_gwas" --brief --yes 
#done


# now run chrX


    run_plink_impX="sed 's/0 0 0 0/0 0 0 D/g' ${data_field}_cX_b0_v1.sample > ${data_field}_cX_b0.1_v1.sample; \
    plink2 --bgen ${data_field}_cX_b0_v1.bgen ref-first \
      --sample ${data_field}_cX_b0.1_v1.sample --set-missing-var-ids @:#:'\$r':'\$a' \
      --new-id-max-allele-len 99 truncate --make-pgen --out ukbi_chX_v1; \
    plink2 --pfile ukbi_chX_v1 \
      --no-pheno --keep phenotypes.v03-15-23.txt \
      --maf 0.006 --mac 20 --geno 0.1 --mind 0.1 --max-maf 0.994 \
      --make-pgen --out ${data_field}_cX_v1.1; \
     rm ukbi_chX_v1* "
    
    dx run swiss-army-knife -iin="${imp_file_dir}/${data_field}_cX_b0_v1.bgen" \
     -iin="${imp_file_dir}/${data_field}_cX_b0_v1.sample" \
     -iin="${txt_file_dir}/phenotypes.v03-15-23.txt" \
     -icmd="${run_plink_impX}" --tag="Step2" --instance-type "mem2_ssd2_v2_x16"\
     --destination="${project}:/data/topmed_gwas" --brief --yes


