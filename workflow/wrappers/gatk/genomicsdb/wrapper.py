__author__ = "Filipe G. Vieira"
__copyright__ = "Copyright 2021, Filipe G. Vieira"
__license__ = "MIT"


import os
from snakemake.shell import shell


extra = snakemake.params.get("extra", "")
java_opts = snakemake.params.get("java_opts", "")

if java_opts:   
    java_opts = '--java-options "{}"'.format(java_opts)
    
interval = snakemake.params.get("intervals")
if not interval.startswith("chr"):
    interval = "chr" + interval


db_action = snakemake.params.get("db_action", "create")
if db_action == "create":
    db_action = "--genomicsdb-workspace-path"
elif db_action == "update":
    db_action = "--genomicsdb-update-workspace-path"
else:
    raise ValueError(
        "invalid option provided to 'params.db_action'; please choose either 'create' or 'update'."
    )

log = snakemake.log_fmt_shell(stdout=True, stderr=True)

shell(
    "set +u; "
    "gatk {java_opts} GenomicsDBImport"
    " --reader-threads {snakemake.threads}"
    " --tmp-dir {snakemake.resources.tmpdir}"
    " {extra}"
    " --sample-name-map {snakemake.input}"
    " --intervals {interval}"
    " {db_action} {snakemake.output.db} {log}"
)