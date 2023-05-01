# PRS Score Calulator
Scripts and workflows for use analyzing UK Biobank data from the DNANexus Research Analysis Platform

Most will be written in bash and will interact with the dx tools.
Unless stated otherwise, these scripts will be executed on your local machine.

## Prerequisites:
1. Base prerequisites from the main folder of this repo: https://github.com/pjgreer/ukb-rap-tools
2. Create directories for prs text files /prs_testfiles and output data /data/imp37_prsfiles
3. PRS file in same format as ex_prsfile.txt as seen in the example-prs-inputs folder
4. From that PRS file you can easily create the other three files
```
	awk '{ if (NR>1) { print sprintf("%02d", $2)":"$3"-"$3 }}' ex_prsfile.txt > chrposlist.txt
	awk '{ if (NR>1) { print $1 }}' ex_prsfile.txt > rsidlist.txt
	awk '{ print $1, $4, $6 }' ex_prsfile.txt > scorefile.txt
```
5. All four .txt files must be uploaded to the RAP


One last thing of note, this works for single SNPs but not currently for complex haplotypes or dyplotypes. Also, some SNPs may have may be multiallelic. Most multiallelic SNPs have the extra alleles with very small allele frequencies. filtering the dataset with an MAF of 0.01 will remove them from the dataset. 

A protion of this work is based on the work by Jennifer Collister in her repo here: https://github.com/2cjenn/PRS_Pipeline and her indepth tutorial here: https://2cjenn.github.io/PRS_Pipeline/ The main difference between that tutorial and this repo is that this works on the UKB RAP and in this one, the main QC step is filtering MAF>0.01 while dropping most other QC steps such as altering the score file based on matching the effect allele to the alt allele thereby changing the sign of the effect weight. By skipping that step, the PRS remains positive. Regardless, the two computed scores are highly correlated r^2>0.99.
