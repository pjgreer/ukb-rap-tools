#!/bin/sh

# This script liftsover the vcf file generated in 04-GTprep-liftover38-vcf.sh
# using picard and bcftools. 

# Requirements: 
# (0-4). Please see readme.md
# 5. Must have executed 01-GTprep-merge-files-dxfuse.sh
# 6. Must have executed 02-step1-qc-filter.sh
# 7. Must have executed 03-GTprep-ldprune.sh
# 8. Must have executed 04-GTprep-liftover38-vcf.sh

# How to Run:
# Run this shell script using: 
# sh 05-GTprep-liftover38.sh
# on the command line on your machine

# Inputs: 
# - /data/gt_genrel_block/ukb_gt_p_temp.vcf.gz 

# Output:
# - /data/gt_genrel_block/ukb_gt_lo38_sort.vcf.gz
#  

# Steps:
# 1. download picard 
# 2. download liftover chain 
# 3. copy wes grch38 fasta and dictionary from RAP
# 4. run liftover using picard
# 5. sort and gzip vcf file


# Variables
exome_file_dir="/Bulk/Exome sequences/Population level exome OQFE variants, PLINK format - final release/"
#set this to the exome data field for your release
data_field="ukb22418"
data_file_dir="/data/gt_genrel_block"
txt_file_dir="/gwas_cohort_textfiles"


run_plink_qc="wget https://github.com/broadinstitute/picard/releases/download/2.27.4/picard.jar ;\
wget https://raw.githubusercontent.com/broadinstitute/gatk/master/scripts/funcotator/data_sources/gnomAD/b37ToHg38.over.chain ;\
cp /mnt/project/Bulk/Exome\ sequences/Exome\ OQFE\ CRAM\ files/helper_files/GRCh38_full_analysis_set_plus_decoy_hla.* . ;\
java -jar picard.jar LiftoverVcf -I ukb_gt_p_temp.vcf.gz -O ukb_gt_lo38.vcf \
   -C b37ToHg38.over.chain --REJECT rejected_variants.vcf -R GRCh38_full_analysis_set_plus_decoy_hla.fa \
   --RECOVER_SWAPPED_REF_ALT true --DISABLE_SORT true ;\
bcftools sort -o ukb_gt_lo38_sort.vcf.gz -O z ukb_gt_lo38.vcf  "



dx run swiss-army-knife -iin="${data_file_dir}/ukb_gt_p_temp.vcf.gz" \
   -icmd="${run_plink_qc}" --tag="Step1" --instance-type "mem2_ssd1_v2_x16"\
   --destination="${project}:/data/gt_genrel_block/" --brief --yes
