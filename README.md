Snakemake based pipeline to perform WGS joint-calling, annotation, and GWAS for the genMARK project.

Input: TSV file with sampleID, path to GVCF files 

## Worklow: 
1. Combine GVCFs (genomicsdb) 
2. Joint-genotype (GenotypeGVCF)
3. Filter variants on qual and depth
3. Annotate variants (vep)
4. Convert the joint-called VCF to Plink BED format (Plink v1.9 & 2)
5. Quality control of sample and variants 
7. PCA and population stratification
6. Add phenotype information
8. Association testing and results (manhattan plots and significant variants report)
9. Validation of results and prioritization



## Installation:

1. Download and install mamba
2. mamba create -c conda-forge -c bioconda -n snakemake8.11 snakemake=8.11.3
3. mamba activate snakemake8.11
4. git clone this repo
5. make a directory with more space to create tool-sepcific conda environments
6. Edit the paths in genmark.sh according to your system; run the code listed as 1 and 2 for testing and setup 

## Running the pipeline (this is not tested yet!)
1. Add the input sampleid, gvcf paths to `config/samples.tsv`
2. edit `config/config.yaml` with project names and any other settings as required
3. use the "dry-run" line in `workflow/genmark.sh` to test
4. use the "run pipeline" in `workflow/genmark.sh` to submit jobs.

## Folder description
- config: Snakemake config files
- data: folder with test data
- workflow: main folder with rules, wrappers, Snakefile, envs, and dependent scripts.
- notebooks: Jupyter notebook used for REDCap files (input csv files should not be uploaded to github and listed in .gitignore; )

