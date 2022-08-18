#!/bin/sh

# This script combines all the regenie result files into a single cohort file.

# Requirements: 
# 0-4 - please refer to readme.md
# 5. Must have executed: 
# - all scripts including liftover from 01_prep_gtfile_4_GWAS
# - 09b-step1-regenie.sh
# - 11b-gwas-s2-imp37-qc-filter.sh
# - 12b-gwas-s2-imp37-regenie.sh

# How to Run:
# Run this shell script using: 
#   sh 13b-gwas-imp37-result-merge-regenie.sh
# on the command line on your own machine

# Inputs (for each chromosome):
# Note that you can adjust the output directory by setting the data_file_dir variable
# - /Data/ap_imp37_gwas/assoc.c1_AP.regenie.gz - regenie results for chromosome 1 
# - /Data/ap_imp37_gwas/assoc.c2_AP.regenie.gz - regenie results for chromosome 2 
# - /Data/ap_imp37_gwas/assoc.c3_AP.regenie.gz - regenie results for chromosome 3 
# - /Data/ap_imp37_gwas/assoc.c4_AP.regenie.gz - regenie results for chromosome 4 
# - etc.

# Output :
# - /data/ap_wes_gwas/assoc.regenie.merged.txt - merged results for all chromosomes in tab-delimited format

# Steps:
# 1. Use dxFUSE to copy the regenie files into the container storage
# 2. unzip regenie files
# 3. add the header back to the top of the merged file with echo command
# 4.  for loop  each .regenie file
#       remove header with tail
#       transform to tab delimited with tr
#       save it into $out_file
# 5. delete regenie files

data_file_dir="/data/ap_imp37_gwas"

merge_cmd='out_file="assoc.log.plink.merged.txt"

echo -e "CHROM\tPOS\tID\tREF\tALT\tA1\tFIRTH\tTEST\tOBS_CT\tOR\tLOG(OR)_SE\tZ_STAT\tP\tERRCODE" > $out_file

files="/mnt/project/data/ap_imp37_gwas/*.hybrid"
for f in $files
do
   tail -n+2 $f | tr " " "\t" >> $out_file
done '



dx run swiss-army-knife -iin="/${data_file_dir}/ukb22828_AP_c2_v3.AP.glm.logistic.hybrid" \
   -icmd="${merge_cmd}" --tag="Step1" --instance-type "mem1_ssd1_v2_x16"\
   --destination="${project}:/data/ap_imp37_gwas/" --brief --yes 
