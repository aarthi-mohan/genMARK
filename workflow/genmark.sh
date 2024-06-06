#/bin/bash



#set path and environment
export PATH=/hpf/largeprojects/ccmbio/aarthi/mambaforge/bin:$PATH
conda activate snakemake8.11

#set variables
config=config/config.yaml
conda_prefix=/hpf/largeprojects/ccmbio/aarthi/genmark-conda-prefix
snakefile=workflow/Snakefile


snakemake --use-conda -s ${snakefile} --conda-prefix ${conda_prefix}  --configfile ${config} -n