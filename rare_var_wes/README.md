# WES Rare variant tests in UKBiobank 

As with the GWAS scripts, I assume that you have a valid phenotype and covariate file.

If you have never used rvtests please see the documentation here: http://zhanxw.github.io/rvtests/#specify-groups-eg-burden-unit Explanation of how to use the program is beyond the scope of this tutorial.

This set of scripts will:
1. Prepare the WES data for rvtests
2. Run the rare variant tests (Skat, SkatO, and burden) for each chromosome
3. Collect the data for simple download

The first script runs the cohort and QC filter on the WES data using plink and unix tools. Rvtests requires a bgzipped vcf file with the "chr" suffix removed. Depending on the total number of subjects in your phenotypes file, you will have to adjust the size of the vm and more specifically the total storage of the VM. I am using ~34,000 subjects allowing me to get away with using smaller vms with <1TB of ssd storage.  

The second script runs rvtest on the output of script 1 (QC-passed WES vcf files) It uses the QC-ed WES vcf files along with a set of GRCh38 GENE reference files (available here: https://github.com/pjgreer/ukb-rap-tools/blob/4da5852da99a031d37da3a6fd6a6e5cc66b24060/rare_var_wes/refFlat38.zip) and pre-made pheotype and covariate files (made prior). For rvtest, the phenotype and covaraite files must be in tab selimited format.

You must uncompress the zip file and upload all the refFlat*.gz files (24 total) to the UKB-RAP prior to running this script. I uploaded them to a subfolder of my {txt_file_dir} named reflat38. Each chromosome file is a list of genes on that chromosome. 
```
gwas_cohort_textfiles/reflat38/refFlat_c1.txt.gz
gwas_cohort_textfiles/reflat38/refFlat_c10.txt.gz
gwas_cohort_textfiles/reflat38/refFlat_c11.txt.gz
etc...
```

You may run this on a pre-defined genelist using the {genelist} variable. if you have no genes for a chromosome, it will error out, but this will not affect the results.

It is possible to run this rarevariant test genome wide, BUT this may take a very long time resulting in an expensive move to normal instances. I have also found a runtime bug on chr2 that causes the test to run indefinitely. If you must run genome wide, you should split out the refflat files into <200 gene sets but that is also beyond the scope of this tutorial.

Finally, script 3 collects all the results into single cohort results files for each test run. 

