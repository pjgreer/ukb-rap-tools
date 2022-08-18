#!/bin/sh

# This script runs the QC process using PLINK on the merged file generated in 
# step 01

# Requirements: 
# (0-4). Please see readme.md
# 5. Must have executed 01-GTprep-merge-files-dxfuse.sh

# How to Run:
# Run this shell script using: 
# sh 02-step1-qc-filter.sh 
# on the command line on your machine

# Inputs:
# - /data/gt_genrel_block/ukb22418_all_v2_merged.bed
# - /data/gt_genrel_block/ukb22418_all_v2_merged.bim
# - /data/gt_genrel_block/ukb22418_all_v2_merged.fam

# Outputs: 
# - /data/gt_genrel_block/ukb22418_allQC_v2_merged.bed 
# - /data/gt_genrel_block/ukb22418_allQC_v2_merged.bim
# - /data/gt_genrel_block/ukb22418_allQC_v2_merged.fam

# Steps:
# 1. filter merged file for QC metrics


# Variables
exome_file_dir="/Bulk/Exome sequences/Population level exome OQFE variants, PLINK format - final release/"
#set this to the exome data field for your release
data_field="ukb22418"
# working dir and reference text file dir
data_file_dir="/data/gt_genrel_block"
txt_file_dir="/gwas_cohort_textfiles"

run_plink_qc="plink2 --bfile ${data_field}_all_v2_merged\
 --maf 0.01 --mac 20 --geno 0.1 \
 --mind 0.1 --make-bed\
 --out  ${data_field}_allQC_v2_merged"

dx run swiss-army-knife -iin="${data_file_dir}/${data_field}_all_v2_merged.bed"\
   -iin="${data_file_dir}/${data_field}_all_v2_merged.bim" \
   -iin="${data_file_dir}/${data_field}_all_v2_merged.fam"\
   -icmd="${run_plink_qc}" --tag="Step1" --instance-type "mem1_ssd1_v2_x16"\
   --destination="${project}:/data/gt_genrel_block/" --brief --yes
