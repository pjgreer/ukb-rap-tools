#!/bin/sh

# This script combines each of the script 2 rvtest result files 
# into a combined cohort file for each test.


# Requirements: 
#  Must have executed: 
#	- 01-wes38-qc-filter.sh
#	- 02-wes38-rv-test.sh 
#

# How to Run:
# Run this shell script using: 
#   sh 03-wes38-result-merge.sh
# on the command line on your own machine

# Inputs (for each chromosome):
# Note that you can adjust the output directory by setting the data_file_dir variable
# - /Data/wes_rvar/{phenotype}_c1_rvtest.CMC.assoc - CMC results for chromosome 1 
# - /Data/wes_rvar/{phenotype}_c2_rvtest.CMC.assoc - CMC results for chromosome 2 
# - /Data/wes_rvar/{phenotype}_c1_rvtest.Skat.assoc - skat results for chromosome 1 
# - /Data/wes_rvar/{phenotype}_c2_rvtest.Skat.assoc - skat results for chromosome 2 
# - /Data/wes_rvar/{phenotype}_c1_rvtest.SkatO.assoc - skat results for chromosome 1 
# - /Data/wes_rvar/{phenotype}_c2_rvtest.SkatO.assoc - skat results for chromosome 2 
# - etc.

# Output :
# - /data/wes_rvar/{phenotype}_rvtest.CMC.assoc - merged results for all chromosomes in tab-delimited format
# - /data/wes_rvar/{phenotype}_rvtest.Skat.assoc - merged results for all chromosomes in tab-delimited format
# - /data/wes_rvar/{phenotype}_rvtest.SkatO.assoc - merged results for all chromosomes in tab-delimited format

# Steps:
# 1. Use dxFUSE to copy the rvtest files into the container storage
# 2. add the header back to the top of the merged file with echo command
# 3.  for loop  each .assoc file
#       remove header with tail
#       transform to tab delimited with tr
#       save it into $out_file
# 5. delete rvtest files

data_file_dir="/data/wes_rvar"

merge_cmd='out_file_cmc="AP_rvtest_gs5.CMC.assoc"
     out_file_skat="AP_rvtest_gs5.Skat.assoc"
     out_file_skatO="AP_rvtest_gs5.SkatO.assoc"
     cp /mnt/project/data/wes_rvar/AP_c*.assoc .

echo -e "Gene\tRANGE\tN_INFORMATIVE\tNumVar\tNumPolyVar\tNonRefSite\tPvalue" > $out_file_cmc
echo -e "Gene\tRANGE\tN_INFORMATIVE\tNumVar\tNumPolyVar\tQ\tPvalue\tNumPerm\tActualPerm\tStat\tNumGreater\tNumEqual\tPermPvalue" > $out_file_skat
echo -e "Gene\tRANGE\tN_INFORMATIVE\tNumVar\tNumPolyVar\tQ\tRho\tPvalue" > $out_file_skatO

files="./*_c*CMC.assoc"
for f in $files
do
   tail -n+2 $f | tr " " "\t" >> $out_file_cmc
done

files="./*_c*Skat.assoc"
for f in $files
do
   tail -n+2 $f | tr " " "\t" >> $out_file_skat
done

files="./*_c*SkatO.assoc"
for f in $files
do
   tail -n+2 $f | tr " " "\t" >> $out_file_skatO
done

rm *_c*.assoc ' 


dx run swiss-army-knife -iin="/${data_file_dir}/WES_c11_qc_pass.log" \
   -icmd="${merge_cmd}" --tag="Step3" --instance-type "mem2_ssd1_v2_x32"\
   --destination="${project}:/data/wes_rvar/" --brief --yes 
