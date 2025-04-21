#!/usr/bin/env Rscript

# =============================
# Structural Variant Summary Tool for Multiple VCFs
# =============================

# Load required libraries
suppressMessages({
  library(VariantAnnotation)
  library(GenomicRanges)
  library(ggplot2)
  library(dplyr)
  library(stringr)
})

# -----------------------------
# 1. Setup input/output paths
# -----------------------------

# Directory containing VCF files
vcf_dir <- "vcfs/"  # Change to your actual folder
output_dir <- "sv_plots"
dir.create(output_dir, showWarnings = FALSE)

# Get list of VCF files
vcf_files <- list.files(vcf_dir, pattern = "\\.vcf(\\.gz)?$", full.names = TRUE)

# -----------------------------
# 2. Helper function to parse VCF
# -----------------------------

parse_sv_vcf <- function(vcf_path, genome = "hg38") {
  vcf <- readVcf(vcf_path, genome = genome)
  info_data <- info(vcf)

  svtypes <- as.character(info_data$SVTYPE)
  start_pos <- start(rowRanges(vcf))
  end_pos <- as.numeric(info_data$END)
  svlen <- as.numeric(info_data$SVLEN)
  chrom <- as.character(seqnames(rowRanges(vcf)))

  sample_id <- str_remove(basename(vcf_path), "\\.vcf(\\.gz)?$")

  data.frame(
    sample = sample_id,
    chrom = chrom,
    start = start_pos,
    end = end_pos,
    svlen = svlen,
    type = svtypes,
    stringsAsFactors = FALSE
  )
}

# -----------------------------
# 3. Process all VCF files
# -----------------------------

sv_list <- lapply(vcf_files, parse_sv_vcf)
sv_df <- bind_rows(sv_list)

# Filter for structural variants longer than 100 bp
sv_df <- sv_df %>%
  filter(!is.na(type), !is.na(svlen), abs(svlen) >= 100)

# -----------------------------
# 4. Plot: SV Type Distribution Across All Samples
# -----------------------------

png(file.path(output_dir, "sv_type_distribution.png"), width = 800, height = 600)
ggplot(sv_df, aes(x = type)) +
  geom_bar(fill = "steelblue") +
  labs(title = "SV Type Distribution Across All Samples", x = "SV Type", y = "Count") +
  theme_minimal(base_size = 14)
dev.off()

# -----------------------------
# 5. Plot: SV Lengths by Type
# -----------------------------

png(file.path(output_dir, "sv_lengths_by_type.png"), width = 800, height = 600)
ggplot(sv_df, aes(x = type, y = abs(svlen))) +
  geom_boxplot() +
  scale_y_log10() +
  labs(title = "SV Lengths by Type", x = "SV Type", y = "SV Length (log10 scale)") +
  theme_minimal(base_size = 14)
dev.off()

# -----------------------------
# 6. Plot: SV Count per Sample
# -----------------------------

png(file.path(output_dir, "sv_count_per_sample.png"), width = 1000, height = 600)
ggplot(sv_df, aes(x = sample, fill = type)) +
  geom_bar(position = "stack") +
  labs(title = "SV Counts per Sample", x = "Sample", y = "SV Count", fill = "SV Type") +
  theme_minimal(base_size = 14) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
dev.off()

# -----------------------------
# 7. (Optional) Top Recurrent SV Positions
# -----------------------------

top_sv_loci <- sv_df %>%
  mutate(locus = paste(chrom, start, type, sep = "_")) %>%
  group_by(locus) %>%
  summarise(count = n(), .groups = "drop") %>%
  arrange(desc(count)) %>%
  slice_head(n = 20)

write.csv(top_sv_loci, file = file.path(output_dir, "top_recurrent_sv_loci.csv"), row.names = FALSE)

# Done
cat("Structural variant summary complete. Plots saved to:", output_dir, "\n")
