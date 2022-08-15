#!/bin/bash

# Requirements: 
# 0-4 - please refer to readme.md
# 5. Must have executed: 
# - partB-merge-files-dx-fuse.sh 
# - partC-step1-qc-filter.sh
# - partD-step1-regenie.sh

# How to Run:
# Run this shell script using: 
#   sh partE-step2-qc-filter.sh 
# on the command line on your own machine

# Inputs:
# Note that you can adjust the output directory by setting the data_file_dir variable
# - /Data/diabetes_wes_200k.phe - from part A (please refer to notebook & slides)

# for each chromosome, you will run a separate worker
# - /{exome_file_dir}/ukb23155_c1_b0_v1.bed - Chr1 file for 200k release
# - /{exome_file_dir}/ukb23155_c1_b0_v1.bim 
# - /{exome_file_dir}/ukb23155_c1_b0_v1.bam 
# - /Data/ukb22418_c1_22_merged.bed - from part B
# - /Data/ukb22418_c1_22_merged.bed - from part B

# Outputs (for each chromosome):
# - /Data/WES_c1_snps_qc_pass.id  
# - /Data/WES_c1_snps_qc_pass.snplist - used in Part F 
# - /Data/WES_c1_snps_qc_pass.log


#set this to the exome sequence directory that you want (should contain PLINK formatted files)
imp_file_dir="/Bulk/Imputation/UKB imputation from genotype/"
#set this to the exome data field for your release
data_field="ukb22828"
data_file_dir="/data/ap_imp37_gwas"
txt_file_dir="/gwas_cohort_textfiles"

for i in {1..22}; do
    run_plink_imp="plink2 --bgen ${data_field}_c${i}_b0_v3.bgen \
      --sample ${data_field}_c${i}_b0_v3.sample \
      --no-pheno --keep phenotypes.v08-04-22.txt \
      --maf 0.01 --mac 20 --geno 0.1 --mind 0.1 \
      --write-snplist --write-samples --no-id-header \
      --out ${data_field}_c${i}_snps_qc_pass"

    dx run swiss-army-knife -iin="${imp_file_dir}/${data_field}_c${i}_b0_v3.bgen" \
     -iin="${imp_file_dir}/${data_field}_c${i}_b0_v3.sample" \
     -iin="${txt_file_dir}/phenotypes.v08-04-22.txt" \
     -icmd="${run_plink_imp}" --tag="Step2" --instance-type "mem1_ssd1_v2_x16"\
     --destination="${project}:/data/ap_imp37_gwas" --brief --yes
done

# now run chrX

    run_plink_impX="plink2 --bgen ${data_field}_cX_b0_v3.bgen \
      --sample ${data_field}_cX_b0_v3.sample \
      --no-pheno --keep phenotypes.v08-04-22.txt \
      --maf 0.01 --mac 20 --geno 0.1 --mind 0.1 \
      --write-snplist --write-samples --no-id-header \
      --out ${data_field}_cX_snps_qc_pass"
    
    dx run swiss-army-knife -iin="${imp_file_dir}/${data_field}_cX_b0_v3.bgen" \
     -iin="${imp_file_dir}/${data_field}_cX_b0_v3.sample" \
     -iin="${txt_file_dir}/phenotypes.v08-04-22.txt" \
     -icmd="${run_plink_impX}" --tag="Step2" --instance-type "mem1_ssd1_v2_x16"\
     --destination="${project}:/data/ap_imp37_gwas" --brief --yes



