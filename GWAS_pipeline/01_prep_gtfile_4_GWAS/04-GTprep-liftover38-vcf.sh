#!/bin/sh

# This script converts the QCed, pruned plink cohort file generated in 03-GTprep-ldprune.sh
# into vcf format using plink in preperation for liftover from b37 to b38. 
# If you are running a GWAS on imputed data, steps 04, 05,and 06 are not necessary.

# Requirements: 
# (0-4). Please see readme.md
# 5. Must have executed 01-GTprep-merge-files-dxfuse.sh
# 6. Must have executed 02-step1-qc-filter.sh
# 7. Must have executed 03-GTprep-ldprune.sh

# How to Run:
# Run this shell script using: 
# sh 04-GTprep-liftover38-vcf.sh
# on the command line on your machine

# Inputs: 
# - /data/gt_genrel_block/ukb22418_allQC_v2_mrg_prun_cohort.bed 
# - /data/gt_genrel_block/ukb22418_allQC_v2_mrg_prun_cohort.bim
# - /data/gt_genrel_block/ukb22418_allQC_v2_mrg_prun_cohort.fam

# Output:
# - /data/gt_genrel_block/ukb_gt_p_temp.vcf.gz
#  

# Steps:
# 1. convert the b37 plink file bed to pgen 
# 2. convert the b37 pgen file to vcf 
# 3. delete temp files


# Variables
exome_file_dir="/Bulk/Exome sequences/Population level exome OQFE variants, PLINK format - final release/"
#set this to the exome data field for your release
data_field="ukb22418"
data_file_dir="/data/gt_genrel_block"
txt_file_dir="/gwas_cohort_textfiles"


run_plink_qc="plink2 --bfile ${data_field}_allQC_v2_mrg_prun_cohort --make-bpgen --out TEMP1 --merge-x --sort-vars n;\
plink2 --bpfile TEMP1 --export vcf bgz --out ukb_gt_p_temp ;\
rm TEMP1.* "


dx run swiss-army-knife -iin="${data_file_dir}/${data_field}_allQC_v2_mrg_prun_cohort.bed" \
   -iin="${data_file_dir}/${data_field}_allQC_v2_mrg_prun_cohort.bim" \
   -iin="${data_file_dir}/${data_field}_allQC_v2_mrg_prun_cohort.fam"\
   -icmd="${run_plink_qc}" --tag="Step1" --instance-type "mem1_ssd1_v2_x16"\
   --destination="${project}:/data/gt_genrel_block/" --brief --yes
