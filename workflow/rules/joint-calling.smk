#https://snakemake-wrappers.readthedocs.io/en/stable/wrappers/gatk/genomicsdbimport.html
rule genomics_db_import:
    input:
        sample_map = config['samples']
    output:
        db = directory(expand("genotyping/genomicsdb/{project}_chr{chrom}",project=config['project'], chrom=chrom_list))
    log:
        expand("logs/gatk/genomicsdbimport_{chrom}.log",chrom=chrom_list)
    params:
        db_action = config['genomicsdb'],
        extra = config['tools']['gatk']['genomicsdb']['extra'],  
        java_opts = config['tools']['gatk']['genomicsdb']['java']  # optional
    threads: 12
    resources:
        mem=1000
    wrapper:
        get_wrapper_path("gatk", "genomicsdb")