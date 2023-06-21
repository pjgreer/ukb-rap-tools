#!/bin/sh

# This script combines all the hardy result run files into a single file for 
# each sample size and 1 for run 5 accross all samples sizes

# Requirements: 
# 0-4 - please refer to readme.md
# 5. Must have executed: 
# - v1-imp37-chr1-qc-filter.sh
# - v2-sim-imp37-chr1-qc-filter.sh

# How to Run:
# Run this shell script using: 
#   sh v3_sim_merge.sh
# on the command line on your own machine

# Inputs:
# Note that you can adjust the output directory by setting the data_file_dir variable
# - /data/qc_test/ - hardy results for chromosome 1 
# - etc.

# Output :
# - /data/ap_wes_gwas/assoc.regenie.merged.txt - merged results for all chromosomes in tab-delimited format

# Steps:
# 1. Use dxFUSE to mount datadir
# 2. create merge file with new header with echo command
# 3.  for loop  each over each r5.hardy file
#       cat each file without header into a single file coded for the samplesize
#       save it into single r5.hardy file
# 4. for loop  each over each sample size 
#       create merge file with new header with echo command for each samplesize
#	for loop over the 10 runs
#		cat each file without header into a single file coded for the run	
#       save all 10 runs into single .hardy file for each sample size


data_file_dir="/data/qc_test"

merge_cmd=' echo -e "NSAMP\tID\tA1\tAX\tHOM_A1_CT\tHET_A1_CT\tTWO_AX_CT\tO(HET_A1)\tE(HET_A1)\tP" > ukb22828_c1_v3_all_r5.hardy

for i in {1,5,10,20,40,70,100,150,200,300,400}; do

   awk -v qqq="$i" '"'"'NR>=2 { print qqq,"\t" $2,"\t" $3,"\t" $4,"\t" $5,"\t" $6,"\t" $7,"\t" $8,"\t" $9,"\t" $10 }'"'"' /mnt/project/data/qc_test/ukb22828_c1_v3_${i}k_5.hardy >> ukb22828_c1_v3_all_r5.hardy  

done 

for i in {1,5,10,20,40,70,100,150,200,300,400}; do

   echo -e "RUN\tID\tA1\tAX\tHOM_A1_CT\tHET_A1_CT\tTWO_AX_CT\tO(HET_A1)\tE(HET_A1)\tP" > ukb22828_c1_v3_${i}k_all.hardy

   for g in {1..10}; do awk -v qqq="$ik_$g"  '"'"'NR>=2 { print qqq,"\t" $2,"\t" $3,"\t" $4,"\t" $5,"\t" $6,"\t" $7,"\t" $8,"\t" $9,"\t" $10 }'"'"'  /mnt/project/data/qc_test/ukb22828_c1_v3_${i}k_${g}.hardy >> ukb22828_c1_v3_${i}k_all.hardy ; done 

done '


dx run swiss-army-knife -iin="${data_file_dir}/ukb22828_c1_v3.log" \
   -icmd="${merge_cmd}" --tag="merge1" --instance-type "mem1_ssd1_v2_x16"\
   --destination="${project}:/data/qc_test/" --brief --yes 
