#!/bin/bash

# Predefined input and output file paths
INPUT_GTF="/cfs/klemming/home/y/yikxie/Public/camunaslab/resources/human_genome/GRCh38_ensembl-ERCC/Homo_sapiens.GRCh38.82.gtf"
OUTPUT_CSV="/cfs/klemming/home/y/yikxie/Private/hs_gene_type.csv"

# Check if the input GTF file exists
if [ ! -f "$INPUT_GTF" ]; then
    echo "Error: Input GTF file not found at $INPUT_GTF"
    exit 1
fi

# Extract gene_id, gene_name, and gene_type using awk
echo "gene_id,gene_name,gene_type" > "$OUTPUT_CSV" # Add header to CSV
awk -F'\t' '$3 == "gene" {
    match($9, /gene_id "([^"]+)"/, gene_id)
    match($9, /gene_name "([^"]+)"/, gene_name)
    match($9, /(gene_biotype|gene_type) "([^"]+)"/, gene_type)
    print gene_id[1] "," gene_name[1] "," gene_type[2]
}' "$INPUT_GTF" >> "$OUTPUT_CSV"

# Confirmation message
echo "Gene annotations saved to $OUTPUT_CSV"

