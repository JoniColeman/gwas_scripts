

# gwas_scripts
###### GWAS codebook (Coleman et al, Under Review), version 0.1.1
##### Please address questions, comments and improvements to Joni Coleman, jonathan[dot]coleman[at]kcl[dot]ac[dot]uk


The scripts in this repo are referenced in the publication referenced above, which provides a straight-forward guide to the quality control, imputation and analysis of genome-wide genotype data. Scripts can be tested using the toy PLINK dataset kindly provided by Shaun Purcell on the PLINK 1.07 website: [example.zip](http://pngu.mgh.harvard.edu/~purcell/plink/dist/example.zip).

Within this protocol, the following software is used:

•	[PLINK] (http://pngu.mgh.harvard.edu/~purcell/plink/) /  [PLINK2](https://www.cog-genomics.org/plink2)

•	[R] (http://www.r-project.org/)

•	[EIGENSOFT] (http://www.hsph.harvard.edu/alkes-price/software/)

•	[IMPUTE] (https://mathgen.stats.ox.ac.uk/impute/impute_v2.html)


The protocol runs in a UNIX environment, and makes use of some of the basic software of the UNIX operating system. It should run on a Mac, but not in Windows. Most sections are designed to be usable simply by pasting into the command line – variables are set when each command is run, and should be straight-forward to modify.

#Procedure#

#####Recalling and rare-variant calling

Not covered by this protocol, see http://confluence.brc.iop.kcl.ac.uk:8090/x/4AAm, which presents best-practice for recalling the raw genotype data using Illumina GenomeStudio, and https://github.com/KHP-Informatics/chip_gt, which implements and compares the results of [ZCall] (https://github.com/jigold/zCall) and [Opticall] (https://www.sanger.ac.uk/resources/software/opticall/).

#####Reformat of data from the rare caller pipeline

The Human Core Exome array contains some SNPs called "SNP…" In order to make ZCall run effectively, it is necessary to change the name of these SNPs, e.g. to "xxx…" This can be done using the UNIX program sed

```{sed}
sed 's/SNP/xxx/g' < rootname.report > rootname.updated.report
```

Following the implementation of the rare caller pipeline, it is recommended to review the concordance between ZCall and Opticall − concordance is expected to be high (>99%). 
 
#####Define names and locations of important files and software:

```{UNIX}
printf "root=/path/to/rootname
pheno=/path/to/external_pheno.phe
covar=/path/to/covariates.cov
genders=/path/to/external_genders.txt
names=/path/to/external_individual_names.txt
keeps=/path/to/samples_to_keep.txt 
excludes=/path/to/samples_to_exclude.txt
insnps=/path/to/SNPs_to_keep.txt
outsnps=/path/to/SNPs_to_exclude.txt
plink=/path/to/plink2" > Config.conf 
```

File formats are the [PLINK file formats] (http://pngu.mgh.harvard.edu/~purcell/plink/data.shtml).

"rootname" is the prefix of the PLINK binary files obtained from the Exome-chip pipeline (i.e. the .bed file from the ZCall branch has the name "rootname_filt_Zcall_UA.bed"), and "/path/to/" is the location of these files on the computer. 

NB: not all of these files may be relevant to your study.

#####Review the PLINK binary (.bed, .bim, .fam) files from Exome-chip pipeline

_Check individuals_

```{UNIX}
less $root.fam
```

_Check SNPs_ 

```{UNIX}
less $root.bim
```

#####Update files

Phenotypes, individual names, genders, or SNP alleles may be lost in preparatory steps. These can be updated using external files.

_Update phenotype_

```{PLINK}
$plink \
--bfile $root \
--pheno $pheno \
--make-bed \
--out $root.updated_pheno
```

_Update genders_

```{PLINK}
$plink \
--bfile $root \
--update-sex $genders \
--make-bed \
--out $root.updated_genders
```

_Update sample names_

```{PLINK}
$plink \
--bfile $root \
--update-ids $names \
--make-bed \
--out $root.updated_names
```

_Select individuals for analysis_

```{PLINK}
$plink \
--bfile $root \
--keep $keeps \
--make-bed \
--out $root.kept_names
```

Or:

```{PLINK}
$plink \
--bfile $root \
--remove $excludes \
--make-bed \
--out $root.kept_names
```

_Select SNPs for analysis_

```{PLINK}
$plink \
--bfile $root \
--extract $insnps \
--make-bed \
--out $root.kept_samples
```

Or:

```{PLINK}
$plink \
--bfile $root \
--exclude $outsnps \
--make-bed \
--out $root.kept_samples
```

#####Filter for common SNPs

```{PLINK}
$plink \
--bfile $root \
--maf 0.01 \
--make-bed \
--out $root.common
```

This assumes no updates were made, otherwise modify the --bfile command to point to that file (e.g. $root.updated_names).


#####Filter for call rate iteratively 

```{bash}
sh ./Iterative_Missingness.sh [begin] [final] [steps] 
```
_Removes SNPs then samples at increasingly high cut-offs. E.g. To remove at 90% to 99%, in steps of 1%:_

```{bash}
sh ./Iterative_Missingness.sh 90 99 1 
```


#####Review call rates to ensure all missing SNPs and individuals have been dropped

_Generate files for individual call rates and variant vall rates._

```{PLINK}
$plink \
--bfile $root.filtered \
--missing \
--out $root.filtered_missing
```

_Examine the lowest call rates for variants:_ 

```{UNIX}
sort -k 5 -gr $root.filtered_missing.lmiss | head
```

Check no variants above threshold remain in column 5 (proportion missing).

_Examine the lowest call rates for individuals:_ 

```{UNIX}
sort -k 6 -gr $root.filtered_missing.imiss | head
```
Check no individuals above threshold remain in column 6 (proportion missing).

#####Assess SNPs for deviation from Hardy-Weinberg Equilibrium

_--hardy calculates HWE test p-values:_

```{PLINK}
$plink \
--bfile $root.filtered \
--hardy \
--out $root.hw_p_values
```

_--hwe removes deviant SNPs past a given threshold, 1x10^-5 below:_ 

```{PLINK}
$plink \
--bfile $root.filtered \
--hwe 0.00001 \
--make-bed \
--out  $root.hw_dropped
```
NB: in case-control datasets, the default behaviour of hwe is to work on controls only

#####Prune data file for linkage disequilibrium 

_Using a window of 1500 variants and a shift of 150 variants between windows, with an r2 cut-off of 0.2:_

```{PLINK}
$plink \
--bfile $root.hw_dropped \
--indep-pairwise 1500 150 0.2 \
--out $root.LD_one
```

_Extract pruned-in SNPs_

```{PLINK}
$plink \
--bfile $root.hw_dropped \
--extract $root.LD_one.prune.in \
--make-bed \
--out $root.LD_two
```

_Exclude  high-LD and non-autosomal regions from the pruned file (see [Mike Weale's website] (https://sites.google.com/site/mikeweale))_

```{AWK}
awk -f highLDregions4bim_b37.awk $root.LD_two.bim > highLDexcludes
```
```{AWK}
awk '($1 < 1) || ($1 > 22) {print $2}' $root.LD_two.bim > autosomeexcludes
```
```{bash}
cat highLDexcludes autosomeexcludes > highLD_and_autosomal_excludes  
``` 
```{PLINK}
$plink \
--bfile $root.LD_two \
--exclude highLD_and_autosomal_excludes \
--make-bed \
--out $root.LD_three
```

#####Add phenotype to differentiate groups

_E.g. Add site of collection ("Site") from an external pheotype file:_

```{PLINK}
$plink \
--bfile $root.LD_three \
--pheno $pheno \
--pheno-name Site \
--make-bed \
--out  $root.LD_four
```

#####Compare genotypic and phenotypic gender

_Ensure there is a separate XY region for the pseudoautosomal region on X:_ 

Most chips have the pseudoautosomal region mapped separately already.
Requires entry of genome build, below this is hg37 ("b37").

```{PLINK}
$plink \
--bfile $root.LD_two \
--split-x b37 \
--make-bed \
--out $root.LD_split
```

_Compare phenotypic gender to X chromosome heterogeneity and Y chromosome SNP count:_

```{PLINK}
$plink \
--bfile $root.LD_split \
--check-sex ycount 0.2 0.8 0 1 \
--out $root.sex_check
```

IDs identified as discordant (not the phenotypic gender) or for which F is between 0.2 and 0.8 (not assigned a gender by PLINK), should be reviewed with the collection site where possible. This command also takes into account the number of Y chromosome SNPs present, to counteract the unreliable nature of the F statistic in assigning female gender. The number of Y SNPs with calls in females can be set as part of ycount (above females have a maximum of 0, and males a maximum of 1), and will depend on the recalling method used and sample size. An additional check can be made by assessing whole-genome heterogeneity for all samples (see below) at this point – discordant gender may be the result of unusual heterogeneity

_Remove discordant IDs that cannot be resolved:_ 

This command assumes a PLINK-format file of IDs for discordant individuals called "discordant_individuals.txt".

```{PLINK}
$plink \
--bfile $root.LD_four \
--remove discordant_individuals.txt \
--make-bed \
--out $root.LD_five
	
$plink \
--bfile $root.hw_dropped \
--remove discordant_individuals.txt \
--make-bed \
--out $root.sexcheck_cleaned
```

#####Pairwise identical-by-descent (IBD) check

```{PLINK}
$plink \
--bfile $root.LD_five \
--genome \
--make-bed \
--out $root.IBD
```

_Remove one sample from each pair with pi-hat (% IBD) above threshold (0.1875 below):_

```{AWK}
awk '$10 >= 0.1875 {print $1, $2}' $root.IBD.genome > $root.IBD_outliers.txt 
```

```{PLINK}
$plink \
--bfile $root.IBD \
--remove $root.IBD_outliers.txt \
--make-bed \
--out $root.no_close_relatives
```

_Calculate average IBD per individual using R, output outliers (defined as more than ***sigma*** standard deviations above the mean, as provided by the user):_

```{R}
./R --file=IndividualIBD.R $root [sigma]
```

Exclude outliers from both LD-stripped and all SNP binary files

```{PLINK}
$plink \
--bfile $root.LD_five \
--remove $root.IBD_INDIV_outliers.txt \
--make-bed \
--out $root.LD_IBD

$plink \
--bfile $root.sexcheck_cleaned \
--remove $root.IBD_INDIV_outliers.txt \
--make-bed \
--out $root.IBD_cleaned
```

#####Population stratification by principal component analysis in EIGENSOFT

Consult [https://sites.google.com/site/mikeweale/software/eigensoftplus].

___Run EIGENSOFT using LD-pruned binary___

_Convert files to EIGENSOFT format using CONVERTF_

Requires par file to convert from packedped format to eigenstrat format

```{UNIX}
convertf -p <(printf "genotypename: "$root".LD_IBD.bed
snpname: "$root".LD_IBD.bim
indivname: "$root".LD_IBD.fam
outputformat: EIGENSTRAT
genotypeoutname: "$root".pop_strat.eigenstratgeno
snpoutname: "$root".pop_strat.snp
indivoutname: "$root".pop_strat.ind")
```

_Run SmartPCA, removing no outliers_ 

Produces 100 PCs

```{perl}
smartpca.perl \
-i $root.pop_strat.eigenstratgeno \
-a $root.pop_strat.snp \
-b $root.pop_strat.ind \
-o $root.pop_strat.pca \
-p $root.pop_strat.plot \
-e $root.pop_strat.eval \
-l $root.pop_strat_smartpca.log \
-m 0 \
-t 100 \
-k 100 \
-s 6
```

Note that the order of the inputs is important.

Inputs explained:

    -i  is the genotype file
    -a is the SNP names
    -b is the individual names
    -o is the output eigenvectors ( $root.pop_strat.pca.evec)
    -p plots the output file. This is only activated if gnuplot is installed, but is a necessary inclusion for smartpca to run. If gnuplot is not installed, this does not affect the running of smartpca. If gnuplot is installed, this produces a plot of the first component on the second.
    -e is the output eigenvalues
    -l is the log, including a list of individuals defined as outliers. 
    -m sets the number of outlier removal iterations. This is initially set to 0, so no outliers are removed.
    -t sets the number of components from which outliers should be removed. If -m is 0, this value has no effect.
    -k is the number of components to be output
    -s defines the minimum number of standard deviations from the mean of each component an individual must be to be counted as an outlier.
  
_Minor edit to allow import into R_

Remove leading tab. 

```{sed}
sed -i 's/^[ \t]*//' $root.pop_strat.pca.evec
```

_Calculate association between PCs and outcome measure in R_

Both scripts require the same IDs to be in $root.pca.evec and $pheno, and look at 100 PCs by default. 

*Short version (outputs the variance explained by each component and its significance when added to a model including the previous components):*

```{R}	
./R --file=PC--VS--OUTCOME_IN_R_SHORT.R $root.pop_strat $pheno
```

*Long version (outputs the full results of the linear model, adding each component in turn):*

```{R}
./R --file= PC--VS--OUTCOME_IN_R_FULL.R $root.pop_strat $pheno
```

_Run SmartPCA again to remove outliers_ 

Run as above ("Run SmartPCA, removing no outliers"), but change $root suffix to pop_strat_outliers.
Set –m 5 and –t x (where ***x*** is the number of PCs significantly associated with the outcome measure) 

```{perl}
smartpca.perl \
-i $root.pop_strat_outliers.eigenstratgeno \
-a $root.pop_strat_outliers.snp \
-b $root.pop_strat_outliers.ind \
-o $root.pop_strat_outliers.pca \
-p $root.pop_strat_outliers.plot \
-e $root.pop_strat_outliers.eval \
-l $root.pop_strat_outliers_smartpca.log \
-m 5 \
-t x \
-k 100 \
-s 6 \
```

_Plot principal components in R_

Plot before and after outlier exclusion to allow visual inspection of which samples are dropped

Plot first component against second in R and colour by phenotype

```{R}
./R --file=PlotPCs.R PC1 PC2
```

This script can be modified to plot any of the first 100 components against each other by changing PC1 and PC2 above. The design of the plot is extremely modifiable - see [http://docs.ggplot2.org/current/].

_Extract outliers_

```{bash}
sh ./ExtractAncestryOutliers.sh
```

```{PLINK}
$plink \
--bfile $root.LD_IBD \
--remove $root.pop_strat_outliers.outliers \
--make-bed \
--out $root.LD_pop_strat

$plink \
--bfile $root.IBD_cleaned \
--remove $root.pop_strat_outliers.outliers \
--make-bed \
--out $root.pop_strat
```

_Re-run to assess which components to include as covariates in the final analysis_

Run ConvertF

```{perl}
convertf -p parfile_covariates.par
```

Run SmartPCA:

```{perl}
smartpca.perl \
-i $root.PCS_for_covariates.eigenstratgeno \
-a $root.PCS_for_covariates.snp \
-b $root.PCS_for_covariates.ind \
-o $root.PCS_for_covariates.pca \
-p $root.PCS_for_covariates.plot \
-e $root.PCS_for_covariates.eval \
-l $root.PCS_for_covariates_smartpca.log \
-m 0 \
-t 100 \
-k 100 \
-s 6 \
```

Calculate association (short version):

```{R}	
./R --file=PC--VS--OUTCOME_IN_R_SHORT.R $root.PCS_for_covariates
```

Include components significantly associated with outcome as covariates in the final analysis, or add PCs in turn until inflation falls to an accepted level (lambda ≈ 1).

#####Optional (but useful): plot individuals on components drawn from the HapMap reference populations to assess likely ancestry groupings. 

Details of this procedure can be found at [Timothee Flutre's OpenWetWare]
(http://openwetware.org/wiki/User:Timothee_Flutre/Notebook/Postdoc/2012/01/22).

_Manually extract HapMap and own cohort individual names_

```{bash}
sh ./MakeKeepIds.sh
```

_Use keepids.txt at this section:_

    for pop in {CEU,CHB,JPT,YRI}; do echo ${pop}; \
    hapmap2impute.py -i genotypes_CHR_${pop}_r28_nr.b36_fwd.txt.gz -n keepids.txt -o genotypes_hapmap_r28_b37_${pop}.impute.gz -b snps_hapmap_r28_nr_b37.bed.gz -s list_snps_redundant.txt; done
    zcat genotypes_hapmap_r28_b37_CEU.impute.gz | wc -l
    3907899
    zcat genotypes_hapmap_r28_b37_CHB.impute.gz | wc -l
    3933013
    zcat genotypes_hapmap_r28_b37_JPT.impute.gz | wc -l
    3931282
    zcat genotypes_hapmap_r28_b37_YRI.impute.gz | wc -l
    3862842

More populations now exist than those listed in Flutre’s script; these can be obtained in the same manner.	
 
#####Heterozygosity Test

_Test for unusual patterns of genome-wide heterogeneity in LD-pruned data_

```{PLINK}
$plink \
--bfile $root.LD_pop_strat \
--ibc \
--out $root.het
```

_Exclude samples identified as outliers_ 

```{R}
R --file=Id_hets.R
```

```{PLINK}
$plink \
--bfile $root.LD_pop_strat \
--remove $root.LD_het_outliers_sample_exclude \
--make-bed \
--out $root.LD_het_cleaned

$plink \
--bfile $root.pop_strat \
--remove $root.LD_het_outliers_sample_exclude \
--make-bed \
--out $root.het_cleaned
```

#####Imputation

*Consult [http://genome.sph.umich.edu/wiki/IMPUTE2:_1000_Genomes_Imputation_Cookbook] and [https://mathgen.stats.ox.ac.uk/impute/prephasing_and_imputation_with_impute2.tgz]*

*Download reference files from [http://mathgen.stats.ox.ac.uk/impute/impute_v2.html]*

*Copy impute2_examples folder from [https://mathgen.stats.ox.ac.uk/impute/prephasing_and_imputation_with_impute2.tgz] to work folder*

_Download relevant strand file from [http://www.well.ox.ac.uk/~wrayner/strand/] and split by chromosome_

```{AWK}
awk '{print $3, $5 > "$root."$2".strand"}' HumanCoreExome-12v1-0_B-b37.strand
```

_Convert PLINK binary to GEN files (IMPUTE2 input)_ 

```{PLINK}
$plink \
--bfile $root.het_cleaned \
--recode oxford \ 
--out $root.for_impute
```

_Split whole--genome .gen into chromosome .gen_

```{AWK}
awk '{print > "Chr"$1".gen"}' $root.for_impute.gen
```

_Check split has proceeded correctly – total line number of all chromosome .gen files should total $root.for_impute.gen_

```{bash}
wc -l *.gen
```

_Generate chunk files for each chromosome_

```{bash}
sh ./MakeChunks.sh
```

This makes two sets of files:

Chunks_chr[1-23].txt

    30000001 3.5e+07 875 
    35000001 4e+07 500
    40000001 4.5e+07 85
    45000001 5e+07 424
    50000001 5.5e+07 693

These files list the base positions of the edges of each chromosome chunk and the number of SNPs in each chunk.
Consult this file and merge chunks with few SNPs (e.g. less than 100) with neighbouring chunks.

analysis_chunks_5Mb_chr[1-23].txt

    30000001 3.5e+07
    35000001 4e+07
    40000001 5e+07
    50000001 5.5e+07

These files are the input for IMPUTE2

*Modify the submit_impute2_jobs_to_cluster.R script (from impute2_examples) to accept chunk files without headers*

```{bash}
From:
  # read in file with chunk boundary definitions
  chunk.file <- paste(data.dir,"analysis_chunks_",chunk.size,"Mb_chr",chr,".txt", sep="")
  chunks <- read.table(chunk.file, head=T, as.is=T) 

To:

  # read in file with chunk boundary definitions
  chunk.file <- paste(data.dir,"analysis_chunks_",chunk.size,"Mb_chr",chr,".txt", sep="")
  chunks <- read.table(chunk.file, head=F, as.is=T). 
```
*Modify scripts in impute2_examples folder (prototype_imputation_job_posterior_sampled_haps.sh master_imputation_script_posterior_sampled_haps.sh and submit_impute_jobs_to_cluster.R) to fit personal needs.*

Likely to need to limit number of jobs submitted to remain within local SunGridEngine rules – liaise with local system administrator to establish local best practice.

*Submit jobs*

**NB – this runs over 600 jobs on your cluster if not controlled!**

```{bash}
sh ./master_imputation_script_posterior_sampled_haps.sh 
```

_Adapt scripts for imputing X chromosome (running the different X map and legend files), and run_

Consult [http://mathgen.stats.ox.ac.uk/impute/impute_v2.html]

*Merge imputed chunks together (.impute2 and .impute2_info) to form a file for each chromosome*

```{bash}
sh ./MergeImputedChunks.sh 
```

_Add chromosome number to each SNP in each chromosome.impute2 file_

```{bash}
sh ./AddChromosomeNumber.sh
```

_Merge by-chromosome info files to form a file for the whole genome_

```{bash}
cat results-directory/*.impute2_info > path/to/results-directory/$root.whole_genome.impute2_info
```

For December 2013 release of reference data (Phase1 Integrated), there are several aspects that require clean-up - these do not appear to apply to the Phase 3 release. Steps marked in bold are required for the Phase1 Integrated release, but may not be needed for Phase3.

__Exomic variants are named "." It is necessary to make these unique (as chr:position)__

```{bash}
sh ./ReplaceDots.sh
```

_Filter imputed data (.impute2 files) by info metric_ 

```{bash}
sh ./FilterByInfoAll.sh [threshold]
```

_Merge filtered by-chromosome .impute2 files to make a single whole-genome file_

```{bash}
cat results-directory/*_New_filtered.impute2 > \
/results-directory/$root.whole_genome_filtered.impute2
```

__Remove duplicate SNPs from .impute2 file__

```{AWK}
awk '{print $2}' $root.whole_genome_filtered.impute2 | \
sort | uniq –c | awk '$1 !=1 {print $0}' > Duplicates

awk '{print $2}' $root.whole_genome_filtered.impute2 | sort | uniq -d > Duplicates_cleaned
```

These produce two files called Duplicates and Duplicates_cleaned that list the duplicated SNPs in the file with and without the number of instances respectively

```{bash}
grep -vwF -f Duplicates_cleaned $root.whole_genome_filtered.impute2 > Temp1
```

Removes all lines with an instance of a duplicated rs# from $root.whole_genome_filtered.impute2 and outputs to Temp1:

```{AWK}
awk '{print $2}' Temp1 | sort | uniq –d > DuplicatesRemoved
```

Repeats the check for duplicates – this file should now be empty; check with

```{bash}
less DuplicatesRemoved 
```

Compare file lengths; the length of Temp1 should be the length of $root.whole_genome_filtered.impute2 minus the number of duplicated SNPs removed

```{bash}
wc -l Temp1 $root.whole_genome_filtered.impute2
mv Temp1 $root.whole_genome_filtered_cleaned.impute2
```

*Convert IMPUTE2 to hard-called PLINK format*

```{PLINK}
$plink \
--gen $root.whole_genome_filtered_cleaned.impute2 \
--sample $root.for_impute.sample \
--hard-call-threshold 0.8 \
--make-bed \
--out $root.post_imputation
```

***NB: if SNP does not pass threshold, it is set as missing!***

At this point, it is recommended to gzip all IMPUTE2 files - note that this will be a large job.

```{bash}
gzip *impute2* 
```

#####Post-imputation quality control	

*Remove rare SNPs depending on sample size and dataset characteristics*

```{PLINK}
$plink \
--bfile $root.post_imputation \
--maf 0.01 \
--make-bed \
--out $root.post_imputation_common
```

*Remove missing SNPs, including those set as missing above*

```{PLINK}
$plink \
--bfile $root.post_imputation_common \
--geno 0.02 \
--make-bed \
--out $root.post_imputation_updated
```

_Drop duplicated variants from imputation_

```{bash}
sh ./DropDuplicatedSNPs.sh
```
```{PLINK}
$plink \
--bfile $root.post_imputation_updated \
--exclude $root.post_imputation_updated_duplicated_IDs \
--make-bed \
--out $root.post_imputation_final
```

*Convert imputed rs IDs back to rs… format*

```{bash}
sh ./Relabel_rs.sh
```

Some rs IDs are imperfectly mapped, resulting in duplications with imputed IDs, so remove these accidental duplicates.

```{bash}
sh ./DropDuplicatedPositions.sh 
```

#####Association testing in PLINK/PLINK2

*Generate covariates file, merging $covar and $root.dataname_pop_strat_includes.pca.evec (output from SMARTPCA) files*

```{R}
./R --file=Get_Covariates.R $root $covar
```

Relabels header and adds additional covariates (.pca.evec contains all PCs included in the SmartPCA analysis) 
Script assumes a covariate file with the same column names for IDs (FID and IID), but no shared column names with the .pca.evec file, which is assumed to contain 100 PCs).


*Run association against phenotype*

Phenotype here assumed to be in $pheno as the only phenotype (otherwise use --mpheno [column number]) and called "Outcome". 

```{PLINK}
$plink \
--bfile $root.post_imputation_final \
--logistic/--linear (depending whether phenotype of interest is dichotomous or continuous) \
--pheno $pheno  \
--pheno-name Outcome \
--covar $covar
--covar-number 1-10
--hide-covar
--parameters 1-11
--out $root.post_imputation_conc_analysis
```

Consider coding of phenotype – may require the use of --1 as an option if coding is in 0,1 format (rather than 1,2 format)
    
         --covar-number indicates which covariates to include. --covar-name can also be used for this 
         --hide-covar hides results of association tests between phenotype and covariates
         --parameters specifies models to include in the analysis (see www.cog-genomics.org/plink2)
           1.	Allelic dosage additive effect (or homozygous minor dummy variable)
           2.	Dominance deviation, if present
           3.	--condition{-list} covariate(s), if present
           4.	--covar covariate(s), if present
           5.	Genotype x non-sex covariate 'interaction' terms, if present
           6.	Sex, if present
           7.	Sex-genotype interaction(s), if present 

_Investigate further any SNP that is highly associated with the phenotype, and exclude from analysis if justified_

Run BLAT, [available on the UCSC Genome Browser](https://genome.ucsc.edu/cgi-bin/hgBlat?command=start) on the probe sequence (available from the array manifest) for all highly associated genotyped SNPs as a test of how well mapped/unique the sequence is, particularly with regards to similarity to sequences on the sex chromosomes. Discard any associated SNP that does not map uniquely.

All association details here assume an additive model – see PLINK website to implement other models (but see [Knight and Lewis, 2012](http://www.ncbi.nlm.nih.gov/pubmed/22383645) for discussion of statistical issues of performing tests using multiple models). More association tests are available in PLINK and PLINK2.
 
#####Using GCTA for Genomic-relatedness-matrix Restricted Maximum Likelihood (GREML) and Mixed Linear Model Association (MLMA)

_Make GRM_

Thresholds below: MAF 1%, IBD 0.025  

```{GCTA}
./gcta \ 
--bfile $root.post_imputation_final \
--autosome \
--maf 0.01 \
--grm-cutoff 0.025 \
--make-grm \
--out $root.post_imputation_final_grm
```

GRM is created here from imputed data - see text for discussion of the benefits of this.
 

_Generate principal components_

```{GCTA}
./gcta \
--grm $root.post_imputation_final_grm \
--pca \
--out $root.post_imputation_final_pca
```

_Univariate GREML, including principal components as continuous covariates_

```{GCTA}
./gcta \
--grm $root.post_imputation_final_grm \
--pheno $pheno \
--covar $covar \ 
--qcovar $root.post_imputation_final_pca \
--reml \
--out $root.post_imputation_final_greml
```

The number of principal components generated can be varied to assess the effect of their inclusion - if components are included as covariates for population stratification in GWAS, it is suggested to include the same number in GREML.

This script assumes the covariates file contains only discrete covariates – if there are continuous covariates in the covariates file, these should be removed from the $covar file and added to the $root.post imputation_final_pca file. 
 
_Run MLMA-LOCO for autosomes_

```{GCTA}
./gcta \
--bfile $root.post_imputation_final \
--pheno $pheno \ 
--covar $covar \
--qcovar $root.post_imputation_final_pca \ 
--mlma-loco \
--out $root.post_imputation_final_mlma_analysis
```


_Run MLMA for X chromosome_

```{PLINK}
./plink \
--bfile $root.post_imputation_final \
--chr X \
--make-bed \
--out $root.post_imputation_final_X \
```
```{GCTA}
./gcta \
--grm $root.post_imputation_final_grm \
--bfile $root.post_imputation_final_X \ 
--pheno $pheno \
--covar $covar \
--qcovar $root.post_imputation_final_pca \ 
--mlma \
--out $root.post_imputation_final_mlma_analysis_X
```

_Merge results files together_

```{bash}
sed -i '1d' $root.post_imputation_final_mlma_analysis_X.mlma
cat $root.post_imputation_final_mlma_analysis.mlmaloco $root.post_imputation_final_mlma_analysis_X.mlma >  $root.post_imputation_final_mlma_analysis_combined.mlmaloco
```

#####SNP Clumping to identify independent hits

_Limit associations to lowest p-value in each region of linkage disequilibrium_ 

```{PLINK}
$plink \
--bfile $root.post_imputation_final \
--clump $root.post_imputation_final_analysis.assoc.logistic \
--clump-p1 1 \
--clump-p2 1 \
--clump-r2 0.25 \
--clump-kb 250 \
--out $root.post_imputation_final_analysis_clumped
```

    --clump-p1 is the p-value threshold below which to consider SNPs for inclusion as the reported SNP from the clump
    --clump-p2 is the p-value threshold below which to consider SNPs for inclusion in the clump
    --clump-r2 is the LD R2 threshold above which SNPs must be to be included in the same clump 
    --clump-kb is the maximum distance a clump SNP can be from the reported SNP
  
The options given here will generate clumps of all SNPs in LD (above R2 = 0.25), with a maximum size of 500kb, considering all SNPs regardless of p-value  

#####Annotation of Results

*Download all RefSeq genes from [UCSC](https://genome.ucsc.edu/)*

Go to [Table Browser](https://genome.ucsc.edu/cgi-bin/hgTables)

         1.	Pick Group: Genes and Gene Prediction Tracks
         2.	Pick Track: RefSeq Genes
         3.	Pick Table: refGene 
         4.	Pick Region: genome
         5.	Pick Output Format: Selected fields…
         6.	Click Get Output
         7.	Tick Chrom, cdsStart, cdsEnd and name2
         8.	Click GetOutput
 
Transfer output to file GeneList.txt 

_Slight reformat of gene list, then make glist_hg19_

```{bash}
sed -i 's/#chrom/Chrom/g' GeneList.txt 
sed -i 's/chr//g' GeneList.txt
sh ./Make_glist.sh GeneList.txt glist_hg19 
```

_Annotation in PLINK/PLINK2_ 

Annotates variants with genes within 250kb

```{PLINK}
$plink \
--annotate $root.post_imputation_final_analysis_clumped.clumped \
ranges=glist-hg19 \
--border 250 \
--out $root.post_imputation_final_analysis_annotated
```


Alternatively, export results to a web tool such as [http://jjwanglab.org/gwasrap]

#####Plot Manhattan and QQ plots

_Select top million hits for Manhattan plot_

```{bash}
head -1000001 $root.post_imputation_final_analysis.assoc.logisitic >  $root.post_imputation_final_analysis_for_MP
```

_Run Manhattan plot and QQ plot scripts in R_ 

```{R}
./R --file ManhattanPlotinR.R
./R --file QQPlotinR.R 
```

QQ plot currently plots top 10% of the data - this can be altered by changing the "frac" option
Both of these plots can be output in different graphic file formats (.jpeg, .tiff, .png) - please refer to the [R documentation](http://stat.ethz.ch/R-manual/R-devel/library/grDevices/html/00Index.html) 
 
# Files in this GitHub repo


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
AddChromosomeNumber.sh /path/to/results_directory
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

**Usage: Relabel_rs.sh**
```{bash}
Relabel_rs.sh
```


#### DropDuplicatedPositions.sh:	Some rs IDs are imperfectly mapped, resulting in duplications with imputed IDs, so remove these accidental genotyped duplicates.


**Usage: DropDuplicatedPositions.sh**
```{bash}
DropDuplicatedPositions.sh
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
  * Cass Johnston
  * Hamel Patel
  * Jack Euesden
  * Jemma Walker
  * Niamh Mullins
  * Cathryn Lewis
  * Paul O'Reilly
  * Mike Weale

In addition, thank you to the authors of the resources listed above, and the genetics community for their comments.
