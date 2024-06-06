import glob
import pandas as pd
from snakemake.utils import validate

###### Config file and sample sheets #####
validate(config, schema="../schemas/config.schema.yaml")

samples = pd.read_csv(config["samples"], sep="\t", dtype={"sampleID": str}).set_index("sampleID", drop=False)
validate(samples, schema="../schemas/samples.schema.yaml")


##### Wildcard constraints #####
wildcard_constraints:
    sample = "|".join(samples.index),
    project = config['project']

chrom_list= list(range(1,23)) + ["X", "Y", "MT"]

def get_wrapper_path(*dirs):
    return "file:%s" % os.path.join(workflow.basedir, "wrappers", *dirs)