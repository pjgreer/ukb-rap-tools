#!/bin/sh

# This script combines all the plink2 result files into a single cohort file.

# Requirements: 
# 0-4 - please refer to readme.md
# 5. Must have executed: 
# - 11a-gwas-s2-topmed-qc-filter.sh
# - 15a-gwas-topmed-plink.sh

# How to Run:
# Run this shell script using: 
#   sh 16a-gwas-topmed-result-merge-plink.sh 
# on the command line on your own machine

# Inputs (for each chromosome):
# Note that you can adjust the output directory by setting the data_file_dir variable
# - /Data/gs_all_gwas/topmed_plink/ukb21007_AP_c1_.AP.glm.logistic.hybrid - plink2 results for chromosome 1 
# - /Data/gs_all_gwas/topmed_plink/ukb21007_AP_c2_.AP.glm.logistic.hybrid - plink2 results for chromosome 2 
# - /Data/gs_all_gwas/topmed_plink/ukb21007_AP_c3_.AP.glm.logistic.hybrid - plink2 results for chromosome 3 
# - /Data/gs_all_gwas/topmed_plink/ukb21007_AP_c4_.AP.glm.logistic.hybrid - plink2 results for chromosome 4 
# - etc.

# Output :
# - /data/gs_all_gwas/topmed_plink/GS_ALL.topmed.assoc.log.plink.merged.txt - merged results for all chromosomes in tab-delimited format

# Steps:
# 1. Use dxFUSE to mount project data dir
# 2. add the header back to the top of the merged file with echo command
# 3.  for loop  each .hybrid file
#       remove header with tail
#       transform to tab delimited with tr
#       save it into $out_file

data_file_dir="/data/gs_all_gwas/topmed_plink/"

merge_cmd='out_file="GS_ALL.topmed.assoc.log.plink.merged.txt"

echo -e "RUN\tID\tA1\tAX\tHOM_A1_CT\tHET_A1_CT\tTWO_AX_CT\tO(HET_A1)\tE(HET_A1)\tP" > ukb21007_all.hardy

echo -e "CHR\tBP\tSNP\tREF\tALT\tA1\tFIRTH\tTEST\tOBS_CT\tOR\tLOG(OR)_SE\tZ_STAT\tP\tERRCODE" > $out_file

files="/mnt/project/data/gs_all_gwas/topmed_plink/*.hybrid"
for f in $files
do
   tail -n+2 $f | tr " " "\t" >> $out_file
done

filesH="/mnt/project/data/gs_all_gwas/topmed_plink/*.hardy"

for f in $filesH
do
   tail -n+2 $f | tr " " "\t" >> ukb21007_all.hardy
done'



dx run swiss-army-knife -iin="/${data_file_dir}ukb21007_GS_ALL_c2_.log" \
   -icmd="${merge_cmd}" --tag="Step1" --instance-type "mem1_ssd1_v2_x16"\
   --destination="${project}:/data/gs_all_gwas/topmed_plink/" --brief --yes 
