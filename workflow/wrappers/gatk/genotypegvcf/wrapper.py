__author__ = "Johannes Köster"
__copyright__ = "Copyright 2018, Johannes Köster"
__email__ = "johannes.koester@protonmail.com"
__license__ = "MIT"


import os
import tempfile
from snakemake.shell import shell


extra = snakemake.params.get("extra", "")
java_opts = snakemake.params.get("java_opts","")

if java_opts:
    java_opts = "--java-options '{}' ".format(java_opts)

interval = snakemake.params.get("intervals", "")
if not interval.startswith("chr"):
    interval = "chr" + interval

dbsnp = snakemake.input.get("known", "")
if dbsnp:
    dbsnp = "--dbsnp {}".format(dbsnp)

# Allow for either an input gvcf or GenomicsDB
gvcf = snakemake.input.get("gvcf", "")
genomicsdb = snakemake.input.get("genomicsdb", "")
if gvcf:
    if genomicsdb:
        raise Exception("Only input.gvcf or input.genomicsdb expected, got both.")
    input_string = gvcf
else:
    if genomicsdb:
        input_string = "gendb://{}".format(genomicsdb)
    else:
        raise Exception("Expected input.gvcf or input.genomicsdb.")

log = snakemake.log_fmt_shell(stdout=True, stderr=True)


with tempfile.TemporaryDirectory() as tmpdir:
    shell(
        "gatk {java_opts} GenotypeGVCFs"
        " --variant {input_string}"
        " --reference {snakemake.input.ref}"
        " {dbsnp}"
        " -L {interval}"
        " {extra}"
        " --tmp-dir {snakemake.resources.tmpdir}"
        " --output {snakemake.output.vcf}"
        " {log}"
    )