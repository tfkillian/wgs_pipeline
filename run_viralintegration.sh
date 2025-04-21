#!/usr/bin/env bash

# Exit on error and undefined variables
set -euo pipefail

# Variables - change these to match your data and paths
WORK_DIR="/path/to/work_dir"
OUT_DIR="/path/to/results"
INPUT="/path/to/your_input.csv"         # Must be in nf-core samplesheet format (see below)
VIRAL_GENOME="/path/to/viral.fasta"     # Viral genome FASTA
HOST_GENOME="GRCh38"                    # Host genome e.g., GRCh38 or custom path
PROFILE="docker"                        # Choose from: docker | singularity | conda
PIPELINE_VERSION="0.1.1"

# Run the pipeline
nextflow run nf-core/viralintegration \
  -r "${PIPELINE_VERSION}" \
  -profile "${PROFILE}" \
  --input "${INPUT}" \
  --viral_reference "${VIRAL_GENOME}" \
  --genome "${HOST_GENOME}" \
  --outdir "${OUT_DIR}" \
  -work-dir "${WORK_DIR}" \
  --save_viral_alignments true \
  --save_host_alignments true \
  --skip_multiqc false

echo "Viral integration detection pipeline complete."
