#rules for joint-calling, concatenation and post-processing fixes
#https://snakemake-wrappers.readthedocs.io/en/stable/wrappers/gatk/genomicsdbimport.html

rule create_sample_map:
    input: config['samples']
    output: 
        samples_map = "genotyped/samples_map.tsv", 
        #samples_seen = "genotyped/samples_seen.txt"
    log: "logs/input_prep/sample_map.log"
    shell:
        """
        set +u
        while read -r -a l; do 
            echo -e "${{l[0]}}\\t${{l[1]}}" >> {output.samples_map}
        done< <(grep -v "^sampleID" {input})
        """

rule genomics_db_import:
    input: "genotyped/samples_map.tsv"
    output:
        db = directory("genotyped/genomicsdb/{project}_{chrom}")
    log:
        "logs/gatk/genomicsdbimport_{project}_{chrom}.log"
    params:
        intervals = lambda wc: wc.get("chrom"),
        db_action = config['genomicsdb'],
        extra = config['tools']['gatk']['genomicsdb']['extra'],  
        java_opts = config['tools']['gatk']['genomicsdb']['java']  # optional
    threads: 12
    wrapper:
        get_wrapper_path("gatk", "genomicsdb")

rule genotype_gvcf:
    input: 
        genomicsdb = "genotyped/genomicsdb/{project}_{chrom}",
        ref = config['ref']['fasta']
    output: 
        vcf = "genotyped/joint-called/{project}_{chrom}_genotyped.vcf.gz"
    log:
        "logs/gatk/{project}_genotypegvcf_{chrom}.log"
    params:
        intervals = lambda wc: wc.get("chrom"),
        extra = config['tools']['gatk']['genotypegvcf']['extra'],  
        java_opts = config['tools']['gatk']['genotypegvcf']['java']  # optional
    wrapper:
        get_wrapper_path("gatk", "genotypegvcf")

