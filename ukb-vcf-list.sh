#!/bin/bash

# This script creates a list of vcf files from the Bulk WGS folder via the dx ls command.
# It loops over each chromosome 1 to 22 plus X

# the path to the vcf files is hard coded in for now as is needs forward slashes for the spaces
# note the sorting does not properly sort the vcf files and you will need to resort the merged file using bcftools

# loop over chromosomes 1 to 22

for qq in {1..22}; do

# list all vcf.gz files for a chromosome
dx ls Bulk/Whole\ genome\ sequences/Whole\ genome\ GraphTyper\ joint\ call\ pVCF/*_c"$qq"_*gz > tempfile_c"$qq".txt

# sort tmpfile and add the path for use in the bcftools merge step
sort tempfile_c"$qq".txt | awk '{print "/mnt/project/Bulk/Whole genome sequences/Whole genome GraphTyper joint call pVCF/"$1}' > ukb_c"$qq"_vcf_full_path_mergelist.txt

# cleanup and remove temp file
rm tempfile_c"$qq".txt

done

# list all vcf.gz files for a chromosome X
dx ls Bulk/Whole\ genome\ sequences/Whole\ genome\ GraphTyper\ joint\ call\ pVCF/*_cX_*gz > tempfile_cX.txt

# sort tmpfile and add the path for use in the bcftools merge step
sort tempfile_cX.txt | awk '{print "/mnt/project/Bulk/Whole genome sequences/Whole genome GraphTyper joint call pVCF/"$1}' > ukb_cX_vcf_full_path_mergelist.txt

# cleanup and remove temp file
rm tempfile_cX.txt

exit
