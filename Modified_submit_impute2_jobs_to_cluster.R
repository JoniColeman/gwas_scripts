#!/usr/bin/Rscript --vanilla

root.dir <- "."
data.dir <- paste(root.dir,"Data/", sep="")

# default settings; can change on command line
chr <- 10
chunk.size <- 5  # chunk size in Mb

# exactly one of the following must be set to TRUE on the command line
phasing.run <- FALSE  # is this a phasing run?
best.guess.impute.run <- FALSE  # is this an imputation run using best-guess haplotypes?
post.avg.impute.run <- FALSE  # is this an imputation run using posterior--sampled haplotypes?

## process command--line arguments
args <- strsplit(commandArgs(TRUE), split='=')
keys <- vector("character")

if (length(args) > 0) {
  for (i in 1:length(args)) {
    key <- args[[i]][1]
    value <- args[[i]][2]
    keys <- c(keys, key)

    if (exists(key)) {
      # replace default value of key with input value
      assign(key, value)
    }
    else {
      cat("\n")
      stop(paste("Unrecognized option [",key,"].\n\n", sep=""))
    }
  }
}

# housekeeping
phasing.run <- as.logical(phasing.run)
best.guess.impute.run <- as.logical(best.guess.impute.run)
post.avg.impute.run <- as.logical(post.avg.impute.run)

# exit the script if it is not clear what type of IMPUTE2 job we want to run
stopifnot(phasing.run + best.guess.impute.run + post.avg.impute.run == 1)


# read in file with chunk boundary definitions
chunk.file <- paste(data.dir,"analysis_chunks_",chunk.size,"Mb_chr",chr,".txt", sep="")
chunks <- read.table(chunk.file, head=T, as.is=T)

# submit a job to the cluster for each analysis chunk on this chromosome
sink(paste(root.dir,"qsublist.sh", sep = ""),append=T)
for (i in 1:nrow(chunks)) {
  system.call <- paste(" qsub ",
                       ifelse(phasing.run,"./prototype_phasing_job.sh ",""),
                       ifelse(best.guess.impute.run,"./prototype_imputation_job_best_guess_haps.sh ",""),
                       ifelse(post.avg.impute.run,"/root/to/impute2_examples/prototype_imputation_job_posterior_sampled_haps.sh ",""),
                       chr," ",chunks[i,1]," ",chunks[i,2],
                       sep="")
  cat( system.call )
}
