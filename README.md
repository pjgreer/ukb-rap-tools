# ukb-rap-tools
Scripts and workflows for use analyzing UK Biobank data from the DNANexus Research Analysis Platform

Most will be written in bash and will interact with the dx tools.
unless stated otherwise, these scripts will be executed on your local machine.

## Prerequisites:
1. You will need dx toolkit installed on your local workstation https://documentation.dnanexus.com/downloads
2. Must have a RAP project with data dispensed
3. Must be logged in using dx login
4. Must have RAP project selected with dx select
5. Must create a folder in your RAP project called /data/ for storing data
6. I have a folder where I store the phenotype and covariate text files seperate from the working directory in case I want to delete all my working files and recreate them later.
7. Must have already created your own phenotype and optionally a covarates file.
8. I also have a /scripts folder in my UKB RAP project for storing and combination scripts that I choose to execute within the dx instance.

