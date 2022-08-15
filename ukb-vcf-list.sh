#!/bin/bash

for qq in {1..22}; do 

dx ls Bulk/Whole\ genome\ sequences/Whole\ genome\ GraphTyper\ joint\ call\ pVCF/*_c"$qq"_*gz > tempfile_c"$qq".txt 

sort tempfile_c"$qq".txt | awk '{print "/mnt/project/Bulk/Whole genome sequences/Whole genome GraphTyper joint call pVCF/"$1}' > ukb_c"$qq"_vcf_full_path_mergelist.txt

rm tempfile_c"$qq".txt
 
done

dx ls Bulk/Whole\ genome\ sequences/Whole\ genome\ GraphTyper\ joint\ call\ pVCF/*_cX_*gz > tempfile_cX.txt

sort tempfile_cX.txt | awk '{print "/mnt/project/Bulk/Whole genome sequences/Whole genome GraphTyper joint call pVCF/"$1}' > ukb_cX_vcf_full_path_mergelist.txt

rm tempfile_cX.txt

exit
