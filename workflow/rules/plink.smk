rule vcf2bed:
	'''
	plink takes only individual or multi-sample vcfs not GVCFs; 
	'''
	input: 
		expand("data/{sample}.vcf.{ext}",sample=wildcards.sample, ext=["gz","gz.tbi]")
	output: 
		expand("data/vcf2bed/{sample}.{ext}",sample=wildcards.sample,ext=["bed","bim","fam"])
	params: 
		prefix=lambda wildcards, output: output[0].split(".")[0]
	conda: 
		"../envs/plink.yaml"
	shell: 
		"plink --aec --vcf {input} --make-bed --out {params.output}
def get_bed_files(wildcards):
	with open(wildcards.config.sample) as f:
		x = [i.strip().split("\t")[0]".bed" for i in f]
	return x

rule create_merge_files:
	input: get_bed_files
	output:
		"data/plink/merge_list"
	conda: "../envs/plink.yaml"
	shell:
		"for i in {input}; do prefix=`echo ${i}| cut -d "." -f1`; echo ${prefix} >> {output}"
		
rule plink_merge:
	input:
		"data/plink/merge_list"
	output:
		expand("data/plink/{study}_merged.{ext}", study=wildcards.study,ext=["bed","bim","fam"])
	conda:
		"../envs/plink.yaml"
	params:
		output=wildcards.output[0].split(".bed")[0]
	shell:
		"plink --aec --merge-list {input} --make-bed --out {params.output}"


rule  qc:
	input: "data/plink/{study}_merged.bed"
	output: "data/plink/{study}_merged.{}" 
	conda: "../envs/plink.yaml"
	shell:
		"plink --bfile {input} --missing --hwe --freq --aec --out {output}"

	
