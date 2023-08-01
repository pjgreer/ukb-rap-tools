
# Running liftover from grch37 to grch38 using picard.

Again, this is only needed if you plan on running regenie on WES, WGS, or the new TOPMED or GEL imputed data. 

You must have run all the steps in GTfile-prep prior to running these scripts.

 4. Export out the LD pruned, QC-ed, cohort plink file in bgzipped VCF format
 5. download liftover chain file, fasta, and picard. Run liftover and sort + bgzip resultant VCF file
 6. convert lifted over vcf file to plink format. (also a step in here to remove snps on alt contigs from the plink file)
 
 This takes takes a couple of hours or longer depending on the number of subjects in your cohort. Most of that time is in the liftover stage, 05.
 
 Once this is complete you are ready to run the initail regenie preperation step.
