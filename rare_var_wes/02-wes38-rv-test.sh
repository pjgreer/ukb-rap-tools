#!/bin/bash

# This script runs rvtest on the output of script 1 (QC-passed WES vcf files) 
# It uses the QC-ed WES vcf files along with a set of GRCh38 GENE reference
# files (available in this repo) and pre-made pheotype and covariate files (made prior). 
#
# You must upload the refFlat*.gz files to the UKB-RAP prior to running this script.
# I uploaded them to a subfolder of my {txt_file_dir} names reflat38.
# 
# You may run this on a pre-defined genelist using the {genelist} variable.
# if you have no genes for a chromosome, it will error out, but this will not affect the results.
#
# It is possible to run this rarevariant test genome wide, BUT this may take a very long time
# resulting in an expensive move to normal instances. I have also found a runtime bug on chr2.
# If you must run genome wide, you should split out the refflat files into <200 gene sets.
# but that is beyond the scope of this tutorial.
 

# How to Run:
# Run this shell script using: 
#   sh ./02-wes38-rv-test.sh
# on the command line on your own machine

# Inputs:
# Note that you can adjust the output directory by setting the data_file_dir variable
# - /{txt_file_dir}/phenotypes.rvt.v09-09-22.txt - 
# - /{txt_file_dir}/covaraites.rvt.v09-09-22.txt - 
# For each chromosome you will use:
# - /{data_file_dir}/WES_c${i}_qc_pass.vcf.gz
# - /{data_file_dir}/WES_c${i}_qc_pass.vcf.gz.idx
# - /{data_file_dir}/reflat38/refFlat_c${i}.txt.gz

# for each chromosome, you will run a separate worker


# Outputs (for each chromosome $i):
# - /{data_file_dir}/{phenotype}_c${i}_rvtest.SkatO.assoc
# - /{data_file_dir}/{phenotype}_c${i}_rvtest.CMC.assoc
# - /{data_file_dir}/{phenotype}_c${i}_rvtest.Skat.assoc
# - /{data_file_dir}/{phenotype}_c${i}_rvtest.log

# Steps:
# 1. for each chromosome 1-22 and X:
# 	- download and install rvtests
#	- perform burden and skat tests for a gene panel {genelist}
# 	- remove unneeded files
#       - write out files back to RAP

#set this to the exome sequence directory that you want (should contain PLINK formatted files)
exome_file_dir="/Bulk/Exome sequences/Population level exome OQFE variants, PLINK format - final release/"
#set this to the exome data field for your release
data_field="ukb23158"
data_file_dir="/data/wes_rvar/"
txt_file_dir="/gwas_cohort_textfiles/"

# set $genelist to a list of genes for this rarevariant test,  otherwise leave it blank for all genes
#genelist=" "
#genelist="--gene ABCG5,ABCG8,APOE,CASR,CEL,CFTR,CLDN2,CMIP,CPA1,CTRC,GGT1,PRSS1,PRSS2,PRSS3,SBDS,SLC26A9,SPINK1,UBR1,CPA1,TRB,TRPV6,RIPPLY1,TYW1,LINC01251-PRSS3"

# gene set for gallstones
genelist="--gene GCKR,ABCG5,ABCG8,TMBIM1,UGT1A1,TM4SF4,LRBA,DAGLB,ABCB4,GATA4,CYP7A1,UBXN2B,MAL2,SNORA32,TTC39B,MLLT10,SKIDA1,MARCHF8,JMJD1C,FADS2,HNF1A,\
SLC10A2,SERPINA1,ANPEP,LITAF,HNF1B,ATP8B1,FUT6,IRF2BP1,FOXA3,SULT2A1,FUT2,HNF4A,KDELR3,GPR61,CPS1,AP1S3,FARP2,ARHGEF3,UGDH,VEGFA,SYNJ2,RP11-115J16.1,\
LOC107986957,TRIB1,FRAT2,MUC5AC,POC1B,SYT16,CYB5B,NFAT5,APOE,AL035045.1,PTTG1IP,NPAS2,PCDHB3,TBC1D32,GOT1,PKD2L1,MALAT1,ITCH,SH3BP4,EIF4E3,LMNB1,\
MLXIPL,ATG16L2,ADAMTS20,UBR1,CLDN7,ADAR,SHROOM3,GMDS-DT,FAM8A1,LIN28B,ABO,ANO1,TMEM147,SPTLC3,TNRC6B"


# loop over all genes

for i in {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,19,20,22,X}; do

    run_rvtest_wes="wget https://github.com/zhanxw/rvtests/releases/download/v2.1.0/rvtests_linux64.tar.gz; \
      tar zxvf rvtests_linux64.tar.gz;  \
      ./executable/rvtest --inVcf WES_c${i}_qc_pass.vcf.gz --freqUpper 0.05 \
      --pheno phenotypes.rvt.v09-09-22.txt --pheno-name AP --out AP_c${i}_rvtest_gs5 \
      --covar covariates.rvt.v09-09-22.txt --covar-name age,sex.b2,bmi,pca1,pca2,pca3,pca4,pca5,pca6 \
      --geneFile refFlat_c${i}.txt.gz ${genelist} --burden cmc --kernel skat,skato ; \
      rm rvtests_linux64.tar.gz; rm -rf ex*; rm -rf READM* "
    
    dx run swiss-army-knife -iin="${data_file_dir}/WES_c${i}_qc_pass.vcf.gz" \
     -iin="${data_file_dir}/WES_c${i}_qc_pass.vcf.gz.tbi" \
     -iin="${txt_file_dir}/phenotypes.rvt.v09-09-22.txt" \
     -iin="${txt_file_dir}/covariates.rvt.v09-09-22.txt" \
     -iin="${txt_file_dir}/reflat38/refFlat_c${i}.txt.gz" \
     -icmd="${run_rvtest_wes}" --tag="Step2-rvt" --instance-type "mem1_ssd1_v2_x16"\
     --destination="${project}:/data/wes_rvar/" --brief --yes

done
