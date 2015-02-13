

# gwas_scripts
###### Codebook from my GWAS cookbook (Coleman et al, In Preparation), version 0.1
##### Please address questions, comments and improvements to Joni Coleman, jonathan[dot]coleman[at]kcl[dot]ac[dot]uk


**The scripts in this repo are referenced in the publication referenced above, which provides a straight-forward guide to the quality control, imputation and analysis of genome-wide genotype data. Scripts can be tested using the toy PLINK dataset kindly provided by Shaun Purcell on the PLINK 1.07 website: [example.zip](http://pngu.mgh.harvard.edu/~purcell/plink/dist/example.zip).


# Contents


#### README.md:  This file!


## Quality Control


#### Iterative_Missingness.sh:  Remove SNPs missing in more than 10% of samples, then samples missing more than 10% of SNPs, then repeat for 5% and 1%.

**Usage: Iterative_Missingness.sh**
```{bash}
Iterative_Missingness.sh 
```


#### highLDregions4bim_b37.awk:  Awk script to remove regions of high-LD from LD-pruned files. Original script from M.Weale, adapted using Ensembl.

**Usage: highLDregions4bim_b37.awk**
```{awk}
awk –f highLDregions4bim_b37.awk input.file > output.file
```


#### IndividualIBD.R:  In R, calculate and print average identity-by-descent relatedness, and print outliers at > 6 SD from mean

**Usage: IndividualIBD.R**
```{R}
R --file=IndividualIBD.R
```


#### parfile.par:  Provide parameters to the Convertf programme from the EIGENSOFT suite, to convert files from PLNIK format to EIGENSOFT format. 

**Usage: parfile.par**
```{bash}
convertf -p parfile.par
```


#### PC-VS-OUTCOME_IN_R_FULL.R:  Regress 100 PCs step-wise on outcome, print full results of each regression to file

**Usage: PC-VS-OUTCOME_IN_R_FULL.R**
```{R}
R --file=PC-VS_OUTCOME_IN_R_FULL.R
```


#### PC-VS-OUTCOME_IN_R_SHORT.R:  Regress 100 PCs step-wise on outcome, print variance explained for each prinicipal component when added to model, and the p-value for this variance explained, to file

**Usage: PC-VS-OUTCOME_IN_R_SHORT.R**
```{R}
R --file=PC-VS_OUTCOME_IN_R_SHORT.R
```


#### PlotPCs.R:  Use qplot option from ggplot2 to plot samples on first two principal components from PCA

**Usage: PlotPCs.R**
```{R}
R --file=PlotPCs.R
```


#### ExtractAncestryOutliers.sh:  Pull out outlying samples from PCA (as defined by EIGENSOFT) for removal from PLINK binary.

**Usage: ExtractAncestryOutliers.sh**
```{bash}
ExtractAncestryOutliers.sh
```


#### MakeKeepIDs.sh:  Make keepids.txt file for use with T.Flutre's HapMap3 OpenWetWare cookbook

**Usage: MakeKeepIDs.sh**
```{bash}
MakeKeepIDs.sh
```


#### IdHets.R:  Identify samples with unusual genome-wide heterozygosity (> or < 3SD from mean). Credit: Amos Folarin.

**Usage: IDHets.R**
```{R}
R --file=Id_hets.R
```


## Imputation in Impute2


#### MakeChunks.sh:  Generate two sets of 5Mb chunk files for imputation: Chunks_chr... prints a list of chunks for that chromosome, with SNP number; analysis_chunks... prints the input chunk file for Impute2 for that chromosome.

**Usage: MakeChunks.sh**
```{bash}
MakeChunks.sh
```


#### Master_imputation_script_posterior_sampled_haps.sh:  Script to control submission of posterior-sampling imputation jobs to a SGE-based cluster. Modified from scripts provided with Impute2
#### Modified_submit_impute2_jobs_to_cluster.R: R script for submitting Impute2 jobs to a SGE-controlled cluster. Modified from scripts provided with Impute2.
#### Prototype_imputation_job_posterior_sampled_haps.sh:  Posterior-sampling imputation job script for Impute2. Modified from scripts provided with Impute2

**Usage Master_imputation_script_posterior_sampled_haps.sh**
```{bash}
Master_imputation_script_posterior_sampled_haps.sh
```
>This runs multiple instances of
  **Prototype_imputation_job_posterior_sampled_haps.sh**
  ```{bash}
  Prototype_imputation_job_posterior_sampled_haps.sh <Chr> <Start BP> <End BP>
  ```


## Post-imputation quality control


#### MergeImputedChunks.sh:  Script to move imputed 5Mb chunks to chromosome-specific folders, and merge them into by-chromosome .impute2 and .impute2_info files.

**Usage: MergeImputedChunks.sh**
```{bash}
MergeImputedChunks.sh
```


#### AddChromosomeNumber.sh:**  Post-imputation clean-up script to add chromosome number to by-chromosome .impute2 files

**Usage: AddChromosomeNumber.sh**
```{bash}
AddChromosomeNumber.sh <OPTIONS>
```


#### ReplaceDots.sh:  Post-imputation clean-up file for Phase1_Integrated 1KG reference. Converts exon variants called "." to "chr/position"

**Usage: ReplaceDots.sh**
```{bash}
ReplaceDots.sh
```


#### FilterByInfoAll.sh:  Post-imputation QC script to filter whole-genome impute2_info file by info score, and then keep only these variants from the by-chromosome impute2_info files

**Usage: FilterByInfoAll.sh**
```{bash}
FilterByInfo.sh
```


#### DropDuplicatedSNPs.sh:  Post-imputation QC script to remove duplicated positions in the post-imputation file (which are usually indels or multiallelic variants)

**Usage: DropDuplicatedSNPs.sh**
```{bash}
DropDuplicatedSNPs.sh
```


#### Relabel_rs.sh: Relabel imputed SNPs with an rs id with the rs id only

**Usage: DropDuplicatedSNPs.sh**
```{bash}
Relabel_rs.sh
```


## Association testing


#### Get_Covariates.R:  Script to create covariate file for association analyses in PLINK from the principal components from PCA and an external covariates file.

**Usage: Get_Covariates.sh**
```{R}
R --file=Get_Covariates.R
```


## Post-GWAS


#### Make_glist.sh:  Script to make a glist-file from the GeneList file downloaded from UCSC Table Browser, for use in annotation in PLINK

**Usage: Make_glist.sh**
```{bash}
Make_glist.sh <GeneList> <output.file>
```


#### ManhattanPlotinR.R:  Wrapper script for running Mike Weale's manhattan_v2.R script to generate Manhattan plots from association result
#### manhattan_v2.R:  Mike Weale's Manhattan plot script

**Usage: ManhattanPlotinR.R**
```{R}
R --file=ManhattanPlotinR.R
```

#### QQPlotinR.R:  Wrapper script to generate QQ plots from association results, using Mike Weale's qq_plot_v7.R
#### qq_plot_v7.R:  Mike Weale's QQ-plot script

**Usage: QQPlotinR.R**
```{R}
R --file=QQPlotinR.R
```


# Valuable web resources

[Genotype recalling pipeline](http://confluence.brc.iop.kcl.ac.uk:8090/x/4AAm)

[Rare varaint recalling pipeline](http://core.brc.iop.kcl.ac.uk/2013/04/08/exome-chip-rare-caller-pipeline/)

[PLINK 1.07](http://pngu.mgh.harvard.edu/~purcell/plink/)

[PLINK 1.9](https://www.cog-genomics.org/plink2/)

[R](http://www.r-project.org/)

[EIGENSOFT](http://www.hsph.harvard.edu/alkes-price/software/)

[IMPUTE2](https://mathgen.stats.ox.ac.uk/impute/impute_v2.html)

[IMPUTE2 Cookbook](http://genome.sph.umich.edu/wiki/IMPUTE2:_1000_Genomes_Imputation_Cookbook)

[William Rayner's strand files for microarrays](http://www.well.ox.ac.uk/~wrayner/strand/)

[Mike Weale's Page](https://sites.google.com/site/mikeweale)

[Tim Flutre's OpenWetWare script for HapMap3 PC plot](http://openwetware.org/wiki/User:Timothee_Flutre/Notebook/Postdoc/2012/01/22)

[GWASRAP - Post-GWAS annotation](http://jjwanglab.org/gwasrap)


# Acknowledgements

Thank you to the following people for their advice and input on the contents of this cookbook:
  * Gerome Breen
  * Steve Newhouse
  * Amos Folarin
  * Richard Dobson
  * Jack Euesden
  * Jemma Walker
  * Niamh Mullins
