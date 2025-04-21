#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -euo pipefail

# Define input parameters
SAMPLESHEET="samplesheet.csv"           # Path to your samplesheet
OUTDIR="results"                        # Output directory
GENOME="GATK.GRCh38"                    # Reference genome (e.g., GATK.GRCh38 for humans)
TOOLS="Manta,TIDDIT"                    # SV detection tools
PROFILE="docker"                        # Execution profile (e.g., docker, singularity)

# Run the nf-core/sarek pipeline
nextflow run nf-core/sarek \
  -r 3.5.1 \
  -profile ${PROFILE} \
  --input ${SAMPLESHEET} \
  --outdir ${OUTDIR} \
  --genome ${GENOME} \
  --tools ${TOOLS}
