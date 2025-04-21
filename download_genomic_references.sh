#!/usr/bin/env bash
set -euo pipefail

# Create a directory to store the downloaded files
mkdir -p genomic_references
cd genomic_references

echo "Starting download of genomic reference files..."

# Download HTLV-1 genome (FASTA)
echo "Downloading HTLV-1 genome..."
wget -O HTLV-1.fasta "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/437/GCA_000001437.1_ASM143v1/GCA_000001437.1_ASM143v1_genomic.fna.gz"
gunzip -f HTLV-1.fasta.gz

# Download BLV genome (FASTA)
echo "Downloading BLV genome..."
wget -O BLV.fasta "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/435/GCA_000001435.1_ASM143v1/GCA_000001435.1_ASM143v1_genomic.fna.gz"
gunzip -f BLV.fasta.gz

# Download Homo sapiens genome (FASTA and GTF) from Ensembl
echo "Downloading Homo sapiens genome and annotation..."
wget -O Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz "https://ftp.ensembl.org/pub/release-113/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz"
wget -O Homo_sapiens.GRCh38.113.gtf.gz "https://ftp.ensembl.org/pub/release-113/gtf/homo_sapiens/Homo_sapiens.GRCh38.113.gtf.gz"
gunzip -f Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
gunzip -f Homo_sapiens.GRCh38.113.gtf.gz

# Download Ovis aries genome (FASTA and GTF) from Ensembl
echo "Downloading Ovis aries genome and annotation..."
wget -O Ovis_aries.Oar_rambouillet_v1.0.dna.toplevel.fa.gz "https://ftp.ensembl.org/pub/release-113/fasta/ovis_aries/dna/Ovis_aries.Oar_rambouillet_v1.0.dna.toplevel.fa.gz"
wget -O Ovis_aries.Oar_rambouillet_v1.0.113.gtf.gz "https://ftp.ensembl.org/pub/release-113/gtf/ovis_aries/Ovis_aries.Oar_rambouillet_v1.0.113.gtf.gz"
gunzip -f Ovis_aries.Oar_rambouillet_v1.0.dna.toplevel.fa.gz
gunzip -f Ovis_aries.Oar_rambouillet_v1.0.113.gtf.gz

echo "All downloads completed successfully."
