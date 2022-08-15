#!/bin/sh


# This script to convert liftover vcf file generated in 05-GTprep-liftover38.sh
# back to plink format. 

# Requirements: 
# (0-4). Please see readme.md
# 5. Must have executed 01-GTprep-merge-files-dxfuse.sh
# 6. Must have executed 02-step1-qc-filter.sh
# 7. Must have executed 03-GTprep-ldprune.sh
# 8. Must have executed 04-GTprep-liftover38-vcf.sh
# 9. Must have executed 05-GTprep-liftover38.sh

# How to Run:
# Run this shell script using: 
# sh 06-GTprep-lo38toplink.sh
# on the command line on your machine

# Inputs: 
# - /data/gt_genrel_block/ukb_gt_lo38_sort.vcf.gz
# - /data/gt_genrel_block/ukb22418_allQC_v2_mrg_prun_cohort.fam 
# - /gwas_cohort_textfiles/phenotypes.v08-04-22.txt

# Output:
# - /data/gt_genrel_block/ukb22418_allQC_mrg_prnd_cohort_lo38_v3.bed
# - /data/gt_genrel_block/ukb22418_allQC_mrg_prnd_cohort_lo38_v3.bim
# - /data/gt_genrel_block/ukb22418_allQC_mrg_prnd_cohort_lo38_v3.fam
#  

# Steps:
# 1. convert lo38 vcf file to plink
# 2. add fam info to plink
# 4. remove temp plink files
# 5. extract rsids for snps on alt contigs
# 6. remove snps from alt contigs and save plink format


# Variables
exome_file_dir="/Bulk/Exome sequences/Population level exome OQFE variants, PLINK format - final release/"
#set this to the exome data field for your release
data_field="ukb22418"
data_file_dir="/data/gt_genrel_block"
txt_file_dir="/gwas_cohort_textfiles"


run_plink_qc="plink2 --vcf ukb_gt_lo38_sort.vcf.gz --make-bed --out ukb_gt_lo38_temp --id-delim "_" \
  --indiv-sort f ${data_field}_allQC_v2_mrg_prun_cohort.fam --ref-allele force ukb_gt_lo38_sort.vcf.gz 4 3 '#' \
  --alt1-allele force ukb_gt_lo38_sort.vcf.gz 5 3 '#' --allow-extra-chr ;\
plink2 --bfile ukb_gt_lo38_temp --make-bed --out ${data_field}_allQC_mrg_prnd_cohort_lo38_v2 \
  --fam ${data_field}_allQC_v2_mrg_prun_cohort.fam --allow-extra-chr ;\
rm ukb_gt_lo38_temp.* ;\
grep alt ukb22418_allQC_mrg_prnd_cohort_lo38_v2.bim | awk '{print $2}' > remove_losnps.txt; \
plink2 --bfile ${data_field}_allQC_mrg_prnd_cohort_lo38_v2 --exclude remove_losnps.txt --make-bed \
  -out ${data_field}_allQC_mrg_prnd_cohort_lo38_v3 --allow-extra-chr "


dx run swiss-army-knife -iin="${data_file_dir}/ukb_gt_lo38_sort.vcf.gz" \
   -iin="${data_file_dir}/${data_field}_allQC_v2_mrg_prun_cohort.fam"\
   -iin="${txt_file_dir}/phenotypes.v08-04-22.txt" \
   -icmd="${run_plink_qc}" --tag="Step1" --instance-type "mem2_ssd1_v2_x16"\
   --destination="${project}:/data/gt_genrel_block/" --brief --yes
