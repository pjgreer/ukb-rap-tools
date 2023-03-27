# PRS Score Calulator
Scripts and workflows for use analyzing UK Biobank data from the DNANexus Research Analysis Platform

Most will be written in bash and will interact with the dx tools.
Unless stated otherwise, these scripts will be executed on your local machine.

## Prerequisites:
1. Base prerequisites from the main folder
2. Create directories for prs text files /prs_testfiles and output data /data/imp37_prsfiles
3. PRS file as seen in the example-prs-inputs folder
4. From that PRS file you cna easily create the other three files
```
	awk '{ if (NR>1) { print sprintf("%02d", $2)":"$3"-"$3 }}' ex_prsfile.txt > chrposlist.txt
	awk '{ if (NR>1) { print $1 }}' ex_prsfile.txt > rsidlist.txt
	awk '{ print $1, $4, $6 }' ex_prsfile.txt > scorefile.txt
```
5. All four .txt files must ne uploaded to the RAP


One last thing of note, this works for single SNPs but not currently for complex haplotypes or dyplotypes. Also, some SNPs may have may be multiallelic. Most multiallelic SNPs have the extra alleles with very small allele frequencies. filtering the dataset with an MAF of 0.01 will remove them from the dataset. 

