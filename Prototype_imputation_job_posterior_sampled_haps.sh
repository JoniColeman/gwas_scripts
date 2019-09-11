#!/bin/bash
#$-S /bin/sh

CHR=$1 
CHUNK_START=`printf "%.0f" $2`
CHUNK_END=`printf "%.0f" $3`

# directories
ROOT_DIR="./"
DATA_DIR=${ROOT_DIR}downloaded_references/
RESULTS_DIR=${ROOT_DIR}results_directory/

# executable
IMPUTE2_EXEC=bin/impute2

# parameters
NE=20000
iter=30
burnin=10
k=80
k_hap=500

# reference data files
GENMAP_FILE=${DATA_DIR}genetic_map_chr${CHR}_combined_b37.txt
HAPS_FILE=${DATA_DIR} ALL.chr${CHR}.integrated_phase1_v3.20101123.snps_indels_svs.genotypes.nomono.haplotypes.gz
LEGEND_FILE=${DATA_DIR} ALL.chr${CHR}.integrated_phase1_v3.20101123.snps_indels_svs.genotypes.nomono.legend.gz
STRAND_FILE=${DATA_DIR}dataname_{CHR}.strand

# GWAS data files
GWAS_GTYPE_FILE=${DATA_DIR}Chr${CHR}.gen

# main output file
OUTPUT_FILE=${RESULTS_DIR}gwas_data_chr${CHR}.pos${CHUNK_START}-${CHUNK_END}.posterior_sampled_haps_imputation.impute2

## impute genotypes from posterior--sampled GWAS haplotypes
$IMPUTE2_EXEC \
    -m $GENMAP_FILE \
    -g $GWAS_GTYPE_FILE \
    -strand_g $STRAND_FILE \
    -h $HAPS_FILE \
    -l $LEGEND_FILE \
    -Ne $NE \
    -iter $iter \
    -burnin $burnin \
    -k $k \
    -k_hap $k_hap \
    -int $CHUNK_START $CHUNK_END \
    -allow_large_regions \
    -o $OUTPUT_FILE
