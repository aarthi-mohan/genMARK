#/bin/bash



#set path and environment
export PATH=/hpf/largeprojects/ccmbio/aarthi/mambaforge/bin:$PATH
conda activate snakemake8.11

#set variables
config=config/config.yaml
conda_prefix=/hpf/largeprojects/ccmbio/aarthi/genmark-conda-prefix
snakefile=workflow/Snakefile


#1. dry-run to check if dag is generated correctly; comment out later
snakemake --use-conda -s ${snakefile} --conda-prefix ${conda_prefix}  --configfile ${config} -n 

#2. create tool specific conda envs
snakemake --use-conda -s ${snakefile} --conda-prefix ${conda_prefix}  --configfile ${config} -n --conda-create-envs-only

#3. run the pipeline (comment the other two snakemake)
#snakemake --use-conda -s ${snakefile} --conda-prefix ${conda_prefix}  --configfile ${config} -n 