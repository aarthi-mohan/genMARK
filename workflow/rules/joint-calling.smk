#https://snakemake-wrappers.readthedocs.io/en/stable/wrappers/gatk/genomicsdbimport.html
rule genomics_db_import:
    input:
        sample_map = config['samples']
    output:
        db = directory("genotyped/genomicsdb/{project}_chr{chrom}")
    log:
        "logs/gatk/genomicsdbimport_{project}_{chrom}.log"
    params:
        db_action = config['genomicsdb'],
        extra = config['tools']['gatk']['genomicsdb']['extra'],  
        java_opts = config['tools']['gatk']['genomicsdb']['java']  # optional
    threads: 12
    resources:
        mem=1000
    wrapper:
        get_wrapper_path("gatk", "genomicsdb")

rule genotype_gvcf:
    input: 
        genomicsdb = "genotyped/genomicsdb/{project}_chr{chrom}",
        ref = config['ref']['fasta']
    output: 
        vcf = "genotyped/joint-called/{project}_chr{chrom}_genotyped.vcf.gz"
    log:
        "logs/gatk/{project}_genotypegvcf_{chrom}.log"
    params:
        #extra = config['tools']['gatk']['genomicsdb']['extra'],  
        java_opts = config['tools']['gatk']['genomicsdb']['java']  # optional
    resources:
        mem=1000
    wrapper:
        get_wrapper_path("gatk", "genotypegvcf")