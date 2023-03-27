#!/bin/bash

# This script collects the output from 01-pull-snps-imp37.sh and combines it into a single .bgen file, indexes it, 
# then creates plink pgen format cohort file filtered on MAF>0.01. It then calulates the PRS score using the plink 
# --score command and twites out a .raw file with the genotype dosages.

# Requirements: 
# 0 - please refer to readme.md
# 1. Must have executed: 01-pull-snps-imp37.sh 


# How to Run:
# Run this shell script using: 
#   bash 02-comb-snps-imp37.sh 
# on the command line on your own machine


# Inputs:
# Note that you can adjust the output directory by setting the data_file_dir variable
# - /prs_textfiles/scorefile.txt - made previously
# - /prs_textfiles/ex_prsfile.txt - made previously
# - .bgen, for each chromosome from step 01
# - .sample file from ukb bulk data folder 


# Outputs (for each chromosome):
# - /data/imp37_prsfiles/chr_1.bgen


# Steps:
# 1. for each chromosome 1-22 and X:
#       - combine 22 chr_*.bgen files into a single file
#       - index the initial file
#       - convert to plink format, calulate MAF, and filter with MAF >0.01
#       - calculate PRS using --score option in plink
#       - write out raw data


#set this to the exome sequence directory that you want (should contain PLINK formatted files)
imp_file_dir="/Bulk/Imputation/UKB imputation from genotype/"
exome_file_dir="/Bulk/Exome sequences/Population level exome OQFE variants, PLINK format - final release/"
#set this to the exome data field for your release
data_field="ukb22828"
data_file_dir="/data/imp37_prsfiles/"
txt_file_dir="/prs_textfiles/"



  combine_snps='
      # Combine the .bgen files for each chromosome into one
      cat-bgen -g  /mnt/project/data/imp37_prsfiles/*.bgen -og initial_chr.bgen -clobber
      # Write index file .bgen.bgi
      bgenix -g initial_chr.bgen -index -clobber
      # convert to plinkformat
      plink2 --bgen initial_chr.bgen ref-first --sample ukb22828_c1_b0_v3.sample --freq --maf 0.01 --make-pgen --out ukb-select-all
      # calculate prs score 
      plink2 --pfile ukb-select-all --score scorefile.txt no-mean-imputation list-variants cols=maybefid,nallele,denom,dosagesum,scoreavgs,scoresums --out ex_score
      # write out raw file
      plink2 --pfile ukb-select-all --out ex_rawfile --extract ex_prsfile.txt --export A --alt1-allele force ex_prsfile.txt 5 --ref-allele force ex_prsfile.txt 4
'


    dx run swiss-army-knife -iin="${imp_file_dir}/${data_field}_c1_b0_v3.sample" \
     -iin="${txt_file_dir}/scorefile.txt" -iin="${txt_file_dir}/ex_prsfile.txt" \
     -icmd="${combine_snps}" --tag="CombSNPs" --instance-type "mem2_ssd2_v2_x16" \
     --destination="${project}:${data_file_dir}" --brief --yes

