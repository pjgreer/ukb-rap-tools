#!/bin/bash

# This script sub-samples imputed ukb data for chr1 and then computes HWE stats 
# on each sample using plink2

# Requirements: 
# 0-4 - please refer to readme.md
# 5. Must have executed: 
#   - v1-imp37-chr1-qc-filter.sh 
# 

# How to Run:
# Run this shell script using: 
#   sh v2-sim-imp37-chr1-qc-filter.sh 
# on the command line on your own machine

# Inputs:
# Note that you can adjust the output directory by setting the data_file_dir variable

# for each chromosome, you will run a separate worker
# - /{data_file_dir}/ukb_c1_b0_v3.pgen 
# - /{data_file_dir}/ukb_c1_b0_v3.psam
# - /{data_file_dir}/ukb_c1_b0_v3.pvar

# Outputs (for each chromosome):
# - /{data_file_dir}/ukb_c1_b0_v3_{sample_size}k_{run}.hardy
# - /{data_file_dir}/ukb_c1_b0_v3_{sample_size}k_{run}.afreq
# - /{data_file_dir}/ukb_c1_b0_v3_{sample_size}k_{run}.log
# - /{data_file_dir}/samples{sample_size}k_${run}.txt
  

# Steps:
# 1. for each sample size:
#       - create 10 random resamplings using shuff
#       - compute maf and HWE stats for each run


#set this to the exome sequence directory that you want (should contain PLINK formatted files)
imp_file_dir="/Bulk/Imputation/UKB imputation from genotype/"
#set this to the genetic data field for your release
data_field="ukb22828"
data_file_dir="/data/qc_test"
txt_file_dir="/gwas_cohort_textfiles"


# run qctest on chr1 sample sike = 1k
for i in {1..10}; do
    
    run_plink_hwesim="sudo apt-get -y install coreutils; \
     echo -e 'IID' > samples1k_${i}.txt; \
     awk '{if (NR>1) {print $2}}' ukbi_ch1_v3.psam | shuf -n 1000 >> samples1k_${i}.txt ; \
     plink2 --pfile ukbi_ch1_v3 --no-pheno --keep samples1k_${i}.txt  \
       --hardy --freq --out ${data_field}_c1_v3_1k_${i} "
    
    dx run swiss-army-knife -iin="${data_file_dir}/ukbi_ch1_v3.psam" \
     -iin="${data_file_dir}/ukbi_ch1_v3.pvar" \
     -iin="${data_file_dir}/ukbi_ch1_v3.pgen" \
     -icmd="${run_plink_hwesim}" --tag="qc-test-1k" --instance-type "mem1_ssd1_v2_x16" \
     --destination="${project}:/data/qc_test" --brief --yes

done


# run qctest on chr1 sample sike = 5k
for i in {1..10}; do

    run_plink_hwesim="sudo apt-get -y install coreutils; \
     echo -e 'IID' > samples5k_${i}.txt; \
     awk '{if (NR>1) {print $2}}' ukbi_ch1_v3.psam | shuf -n 5000 >> samples5k_${i}.txt ; \
     plink2 --pfile ukbi_ch1_v3 --no-pheno --keep samples5k_${i}.txt  \
       --hardy --freq --out ${data_field}_c1_v3_5k_${i} "

    dx run swiss-army-knife -iin="${data_file_dir}/ukbi_ch1_v3.psam" \
     -iin="${data_file_dir}/ukbi_ch1_v3.pvar" \
     -iin="${data_file_dir}/ukbi_ch1_v3.pgen" \
     -icmd="${run_plink_hwesim}" --tag="qc-test-5k" --instance-type "mem1_ssd1_v2_x16" \
     --destination="${project}:/data/qc_test" --brief --yes

done


# run qctest on chr1 sample sike = 10k
for i in {1..10}; do

    run_plink_hwesim="sudo apt-get -y install coreutils; \
     echo -e 'IID' > samples10k_${i}.txt; \
     awk '{if (NR>1) {print $2}}' ukbi_ch1_v3.psam | shuf -n 10000 >> samples10k_${i}.txt ; \
     plink2 --pfile ukbi_ch1_v3 --no-pheno --keep samples10k_${i}.txt  \
       --hardy --freq --out ${data_field}_c1_v3_10k_${i} "

    dx run swiss-army-knife -iin="${data_file_dir}/ukbi_ch1_v3.psam" \
     -iin="${data_file_dir}/ukbi_ch1_v3.pvar" \
     -iin="${data_file_dir}/ukbi_ch1_v3.pgen" \
     -icmd="${run_plink_hwesim}" --tag="qc-test-10k" --instance-type "mem1_ssd1_v2_x16" \
     --destination="${project}:/data/qc_test" --brief --yes

done


# run qctest on chr1 sample sike = 20k
for i in {1..10}; do

    run_plink_hwesim="sudo apt-get -y install coreutils; \
     echo -e 'IID' > samples20k_${i}.txt; \
     awk '{if (NR>1) {print $2}}' ukbi_ch1_v3.psam | shuf -n 20000 >> samples20k_${i}.txt ; \
     plink2 --pfile ukbi_ch1_v3 --no-pheno --keep samples20k_${i}.txt  \
       --hardy --freq --out ${data_field}_c1_v3_20k_${i} "
    
    dx run swiss-army-knife -iin="${data_file_dir}/ukbi_ch1_v3.psam" \
     -iin="${data_file_dir}/ukbi_ch1_v3.pvar" \
     -iin="${data_file_dir}/ukbi_ch1_v3.pgen" \
     -icmd="${run_plink_hwesim}" --tag="qc-test-20k" --instance-type "mem1_ssd1_v2_x16" \
     --destination="${project}:/data/qc_test" --brief --yes

done


# run qctest on chr1 sample sike = 40k
for i in {1..10}; do

    run_plink_hwesim="sudo apt-get -y install coreutils; \
     echo -e 'IID' > samples40k_${i}.txt; \
     awk '{if (NR>1) {print $2}}' ukbi_ch1_v3.psam | shuf -n 40000 >> samples40k_${i}.txt ; \
     plink2 --pfile ukbi_ch1_v3 --no-pheno  --keep samples40k_${i}.txt \
       --hardy --freq --out ${data_field}_c1_v3_40k_${i} "

    dx run swiss-army-knife -iin="${data_file_dir}/ukbi_ch1_v3.psam" \
     -iin="${data_file_dir}/ukbi_ch1_v3.pvar" \
     -iin="${data_file_dir}/ukbi_ch1_v3.pgen" \
     -icmd="${run_plink_hwesim}" --tag="qc-test-40k" --instance-type "mem1_ssd1_v2_x16" \
     --destination="${project}:/data/qc_test" --brief --yes

done


# run qctest on chr1 sample sike = 70k
for i in {1..10}; do
       
    run_plink_hwesim="sudo apt-get -y install coreutils; \
     echo -e 'IID' > samples70k_${i}.txt; \
     awk '{if (NR>1) {print $2}}' ukbi_ch1_v3.psam | shuf -n 70000 >> samples70k_${i}.txt ; \
     plink2 --pfile ukbi_ch1_v3 --no-pheno  --keep samples70k_${i}.txt \
       --hardy --freq --out ${data_field}_c1_v3_70k_${i} "
     
    dx run swiss-army-knife -iin="${data_file_dir}/ukbi_ch1_v3.psam" \
     -iin="${data_file_dir}/ukbi_ch1_v3.pvar" \
     -iin="${data_file_dir}/ukbi_ch1_v3.pgen" \
     -icmd="${run_plink_hwesim}" --tag="qc-test-70k" --instance-type "mem1_ssd1_v2_x16" \
     --destination="${project}:/data/qc_test" --brief --yes

done


# run qctest on chr1 sample sike = 100k
for i in {1..10}; do
    
    run_plink_hwesim="sudo apt-get -y install coreutils; \
     echo -e 'IID' > samples100k_${i}.txt; \
     awk '{if (NR>1) {print $2}}' ukbi_ch1_v3.psam | shuf -n 100000 >> samples100k_${i}.txt ; \
     plink2 --pfile ukbi_ch1_v3 --no-pheno  --keep samples100k_${i}.txt \
       --hardy --freq --out ${data_field}_c1_v3_100k_${i} "
    
    dx run swiss-army-knife -iin="${data_file_dir}/ukbi_ch1_v3.psam" \
     -iin="${data_file_dir}/ukbi_ch1_v3.pvar" \
     -iin="${data_file_dir}/ukbi_ch1_v3.pgen" \
     -icmd="${run_plink_hwesim}" --tag="qc-test-100k" --instance-type "mem1_ssd1_v2_x16" \
     --destination="${project}:/data/qc_test" --brief --yes

done


# run qctest on chr1 sample sike = 150k
for i in {1..10}; do
       
    run_plink_hwesim="sudo apt-get -y install coreutils; \
     echo -e 'IID' > samples150k_${i}.txt; \
     awk '{if (NR>1) {print $2}}' ukbi_ch1_v3.psam | shuf -n 150000 >> samples150k_${i}.txt ; \
     plink2 --pfile ukbi_ch1_v3 --no-pheno  --keep samples150k_${i}.txt \
       --hardy --freq --out ${data_field}_c1_v3_150k_${i} "
     
    dx run swiss-army-knife -iin="${data_file_dir}/ukbi_ch1_v3.psam" \
     -iin="${data_file_dir}/ukbi_ch1_v3.pvar" \
     -iin="${data_file_dir}/ukbi_ch1_v3.pgen" \
     -icmd="${run_plink_hwesim}" --tag="qc-test-150k" --instance-type "mem1_ssd1_v2_x16" \
     --destination="${project}:/data/qc_test" --brief --yes

done


# run qctest on chr1 sample sike = 200k
for i in {1..10}; do
       
    run_plink_hwesim="sudo apt-get -y install coreutils; \
     echo -e 'IID' > samples200k_${i}.txt; \
     awk '{if (NR>1) {print $2}}' ukbi_ch1_v3.psam | shuf -n 200000 >> samples200k_${i}.txt ; \
     plink2 --pfile ukbi_ch1_v3 --no-pheno  --keep samples200k_${i}.txt \
       --hardy --freq --out ${data_field}_c1_v3_200k_${i} "
     
    dx run swiss-army-knife -iin="${data_file_dir}/ukbi_ch1_v3.psam" \
     -iin="${data_file_dir}/ukbi_ch1_v3.pvar" \
     -iin="${data_file_dir}/ukbi_ch1_v3.pgen" \
     -icmd="${run_plink_hwesim}" --tag="qc-test-200k" --instance-type "mem1_ssd1_v2_x16" \
     --destination="${project}:/data/qc_test" --brief --yes

done


# run qctest on chr1 sample sike = 300k
for i in {1..10}; do
       
    run_plink_hwesim="sudo apt-get -y install coreutils; \
     echo -e 'IID' > samples300k_${i}.txt; \
     awk '{if (NR>1) {print $2}}' ukbi_ch1_v3.psam | shuf -n 300000 >> samples300k_${i}.txt ; \
     plink2 --pfile ukbi_ch1_v3 --no-pheno  --keep samples300k_${i}.txt \
       --hardy --freq --out ${data_field}_c1_v3_300k_${i} "
     
    dx run swiss-army-knife -iin="${data_file_dir}/ukbi_ch1_v3.psam" \
     -iin="${data_file_dir}/ukbi_ch1_v3.pvar" \
     -iin="${data_file_dir}/ukbi_ch1_v3.pgen" \
     -icmd="${run_plink_hwesim}" --tag="qc-test-300k" --instance-type "mem1_ssd1_v2_x16" \
     --destination="${project}:/data/qc_test" --brief --yes

done


# run qctest on chr1 sample sike = 400k
for i in {1..10}; do
       
    run_plink_hwesim="sudo apt-get -y install coreutils; \
     echo -e 'IID' > samples400k_${i}.txt; \
     awk '{if (NR>1) {print $2}}' ukbi_ch1_v3.psam | shuf -n 400000 >> samples400k_${i}.txt ; \
     plink2 --pfile ukbi_ch1_v3 --no-pheno  --keep samples400k_${i}.txt \
       --hardy --freq --out ${data_field}_c1_v3_400k_${i} "
     
    dx run swiss-army-knife -iin="${data_file_dir}/ukbi_ch1_v3.psam" \
     -iin="${data_file_dir}/ukbi_ch1_v3.pvar" \
     -iin="${data_file_dir}/ukbi_ch1_v3.pgen" \
     -icmd="${run_plink_hwesim}" --tag="qc-test-400k" --instance-type "mem1_ssd1_v2_x16" \
     --destination="${project}:/data/qc_test" --brief --yes

done

