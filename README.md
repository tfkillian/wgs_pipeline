# 🧬 Structural Variant Detection with nf-core/sarek

This repository provides a reproducible setup to process whole-genome sequencing (WGS) data using the [`nf-core/sarek`](https://nf-co.re/sarek) pipeline. It is tailored for the detection of structural variants (SVs), such as viral integrations caused by deltaviruses—HTLV-1 in humans or BLV in sheep.

## 🔧 Pipeline Overview

The pipeline leverages `nf-core/sarek` (v3.5.1) to process WGS FASTQ data and identify SVs using the tools **Manta** and **TIDDIT**, both of which are included in the configuration.

### Key Features

- Structural variant detection from WGS  
- Ready-to-run pipeline with Conda/Docker  
- Supports both human (e.g., GRCh38) and custom references (e.g., sheep + BLV)  

## 📁 Repository Contents

- `run_sarek.sh` — Bash script to launch the nf-core/sarek pipeline  
- `sarek-env.yaml` — Conda environment file to install required dependencies  
- `samplesheet.csv` — Input file template listing your WGS sample files  

## 🖥️ Requirements

- Nextflow ≥ 23.10.0  
- Either:
  - Docker/Singularity for containerized execution (recommended)  
  - Or Conda to install dependencies locally  

## ⚙️ Installation (Conda)

To install all tools required to run the pipeline:

```bash
conda env create -f sarek-env.yaml
conda activate sarek-env
```

## 🚀 Running the Pipeline

### 1. Prepare the `samplesheet.csv`

Your input file should look like this:

```csv
sample,fastq_1,fastq_2
SAMPLE1,/path/to/SAMPLE1_R1.fastq.gz,/path/to/SAMPLE1_R2.fastq.gz
SAMPLE2,/path/to/SAMPLE2_R1.fastq.gz,/path/to/SAMPLE2_R2.fastq.gz
```

### 2. Launch the Pipeline

```bash
bash run_sarek.sh
```

The `run_sarek.sh` script contains:

```bash
#!/bin/bash
set -euo pipefail

SAMPLESHEET="samplesheet.csv"
OUTDIR="results"
GENOME="GATK.GRCh38"  # or path to custom FASTA for sheep
TOOLS="Manta,TIDDIT"
PROFILE="docker"

nextflow run nf-core/sarek \
  -r 3.5.1 \
  -profile ${PROFILE} \
  --input ${SAMPLESHEET} \
  --outdir ${OUTDIR} \
  --genome ${GENOME} \
  --tools ${TOOLS}
```

## 🧬 Viral Insertion Detection

To detect viral integration sites (HTLV-1 in humans or BLV in sheep):

- Augment your reference genome with viral genomes.  
- Use the output VCFs from **Manta** and **TIDDIT** to scan for large insertions and rearrangements.  
- Post-process breakpoints that overlap viral sequence regions to infer viral integration events.  

## 📦 Output Formats

Key output files for SV analysis:

- `*.manta.sv.vcf.gz` — SV calls from Manta  
- `*.tiddit.sv.vcf.gz` — SV calls from TIDDIT  
- `*.annotated.vcf.gz` — Variant annotations (optional)  
- `multiqc_report.html` — Quality summary  

## 📚 References

- [nf-core/sarek](https://nf-co.re/sarek)  
- [Manta](https://github.com/Illumina/manta)  
- [TIDDIT](https://github.com/SciLifeLab/TIDDIT)  

## 📬 Feedback or Issues?

Please use the [Issues](https://github.com/YOUR-USERNAME/YOUR-REPO-NAME/issues) tab to report problems or suggest improvements.
