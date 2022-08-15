#!/bin/sh

# This script runs the prunes the merged plink file generated in 02-step1-qc-filter.sh 
# using plink. 

# Requirements: 
# (0-4). Please see readme.md
# 5. Must have executed 01-GTprep-merge-files-dxfuse.sh
# 6. Must have executed 02-step1-qc-filter.sh

# How to Run:
# Run this shell script using: 
# sh 02-step1-qc-filter.sh 
# on the command line on your machine

# Inputs:
# - /data/gt_genrel_block/ukb22418_allQC_v2_merged.bed
# - /data/gt_genrel_block/ukb22418_allQC_v2_merged.bim
# - /data/gt_genrel_block/ukb22418_allQC_v2_merged.fam
# - /gwas_cohort_textfiles/phenotypes.v08-04-22.txt

# Outputs: 
# - /data/gt_genrel_block/ukb22418_allQC_v2_mrg_prun_cohort.bed 
# - /data/gt_genrel_block/ukb22418_allQC_v2_mrg_prun_cohort.bim
# - /data/gt_genrel_block/ukb22418_allQC_v2_mrg_prun_cohort.fam

# Steps:
# 1. identify snps of high LD
# 2. remove pruned snps and save pruned, QCed, plink file 


# Variables
exome_file_dir="/Bulk/Exome sequences/Population level exome OQFE variants, PLINK format - final release/"
#set this to the exome data field for your release
data_field="ukb22418"
data_file_dir="/data/gt_genrel_block"
txt_file_dir="/gwas_cohort_textfiles"

run_plink_qc="plink2 --bfile ${data_field}_allQC_v2_merged \
 --indep-pairwise 1000 50 0.4  --out ukb-pruning ;\
ls *bed; \
plink2 --bfile ${data_field}_allQC_v2_merged --extract ukb-pruning.prune.in \
 --keep phenotypes.v08-04-22.txt --make-bed --out ${data_field}_allQC_v2_mrg_prun_cohort ;\
wc *.bim "

dx run swiss-army-knife -iin="${data_file_dir}/${data_field}_allQC_v2_merged.bed" \
   -iin="${data_file_dir}/${data_field}_allQC_v2_merged.bim" \
   -iin="${data_file_dir}/${data_field}_allQC_v2_merged.fam"\
   -iin="${txt_file_dir}/phenotypes.v08-04-22.txt" \
   -icmd="${run_plink_qc}" --tag="Step1" --instance-type "mem1_ssd1_v2_x16"\
   --destination="${project}:/data/gt_genrel_block/" --brief --yes
