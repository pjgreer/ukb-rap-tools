These scripts were used to collect HWE statistics on resampled UK Biobank data for this paper:

https://www.medrxiv.org/content/10.1101/2024.02.07.24301951v1

These simulations and calulations are performed on chr1 only. we assume that other chromosomes may show similar distributions.

<code> v1-imp37-chr1-qc-filter.sh </code>

This script creates the cohort plink file and performs the initail QC steps filterin on MAF<0.006, genotype missingness of 0.1 and individual missingness of 0.1

It also performs the initail calulation of frequencies and HWE for the entire cohort. Please read the comments in the script for more info on running it.


<code> v2-sim-imp37-chr1-qc-filter.sh </code>

This script sub-samples imputed ukb data for chr1 and then computes HWE stats on each sample using plink2. Using the <code>shuf</code> command from <code>coreutils</code>, we sample without replacement from plink psam file and save the EIDs to a text file. The text file is then used by plink with the --keep flag to calculate HWE statistics on that subset alone. This is performed 10 seperate times and the results files for both the samples and the HWE statistics are saved using the sample size and batch ID (1 through 10).  There are 11 different for loops running 10 sampling replications across 11 sample sizes. 110 jobs are submitted to the UKB-RAP with this script each takes about 12 minutes each.


<code> v3_sim_merge.sh </code>

This script combines all the hardy result run files into a single file for each sample size and 1 for run 5 accross all samples sizes. Each batch gets a batch label in the combined file. 


The WES gwas from that paper was performed using this workflow:
https://github.com/pjgreer/ukb-rap-tools/tree/main/GWAS_pipeline/gwas_wes38_plink

WES GWAS was performed on all samples as well as hite european only samples with additional commands to calculate HWE statistics.
