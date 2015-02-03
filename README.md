# gwas_scripts
Codebook from my GWAS cookbook

AddChromosomeNumber.sh:  Post-imputation clean-up script to add chromosome number to by-chromosome .impute2 files

DropDuplicatedSNPs.sh:  Post-imputation QC script to remove duplicated positions in the post-imputation file (which are usually indels or multiallelic variants)

ExtractAncestryOutliers.sh:  Pull out outlying samples from PCA (as defined by EIGENSOFT) for removal from PLINK binary.

FilterByInfoAll.sh:  Post-imputation QC script to filter whole-genome impute2_info file by info score, and then keep only these variants from the by-chromosome impute2_info files

Get_Covariates.R:  Script to create covariate file for association analyses in PLINK from the principal components from PCA and an external covariates file.

IdHets.R:  Identify samples with unusual genome-wide heterozygosity (> or < 3SD from mean). Credit: Amos Folarin.

IndividualIBD.R:  In R, calculate and print average identity-by-descent relatedness, and print outliers at > 6 SD from mean

Create MakeChunks.sh:  Generate two sets of 5Mb chunk files for imputation: Chunks_chr... prints a list of chunks for that chromosome, with SNP number; analysis_chunks... prints the input chunk file for Impute2 for that chromosome.

MakeKeepIDs.sh:  Make keepids.txt file for use with T.Flutre's HapMap3 OpenWetWare cookbook

Make_glist.sh:  Script to make a glist-file from the gene file downloaded from UCSC Table Browser, for use in annotation in PLINK

ManhattanPlotinR.R:  Wrapper script for running Mike Weale's manhattan_v2.R script to generate Manhattan plots from association result

Master_imputation_script_posterior_sampled_haps.sh:  Script to control submission of posterior-sampling imputation jobs to a SGE-based cluster. Modified from scripts provided with Impute2

MergeImputedChunks.sh:  Script to move imputed 5Mb chunks to chromosome-specific folders, and merge them into by-chromosome .impute2 and .impute2_info files.

Modified_submit_impute2_jobs_to_cluster.R:  R script for submitting Impute2 jobs to a SGE-controlled cluster. Modified from scripts provided with Impute2.

PC-VS-OUTCOME_IN_R_FULL.R:  Regress 100 PCs step-wise on outcome, print full results of each regression to file

PC-VS-OUTCOME_IN_R_SHORT.R:  Regress 100 PCs step-wise on outcome, print variance explained for each prinicipal component when added to model, and the p-value for this variance explained, to file

PlotPCs.R:  Use qplot option from ggplot2 to plot samples on first two principal components from PCA

Prototype_imputation_job_posterior_sampled_haps.sh:  Posterior-sampling imputation job script for Impute2. Modified from scripts provided with Impute2

QQPlotinR.R:  Wrapper script to generate QQ plots from association results, using Mike Weale's qq_plot_v6.R

README.md:  This file!

ReplaceDots.sh:  Post-imputation clean-up file for Phase1_Integrated 1KG reference. Converts exon variants called "." to "chr/position"

highLDregions4bim_b37.awk:  Awk script to remove regions of high-LD from LD-pruned files. Original script from M.Weale, adapted using Ensembl.

manhattan_v2.R:  Mike Weale's Manhattan plot script

qq_plot_v6.R:  Mike Weale's QQ-plot script

