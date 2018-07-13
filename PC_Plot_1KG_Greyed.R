###Author: JRIC
###Date: 2018-07-13
###Purpose: Plot user data projected on 1KG PCs, greying out 1KG individuals

##Load packages
library(ggplot2)

##Initialise command line arguments
args <- commandArgs(TRUE)

##Load data
root <- args[1]
PCAEVEC<-read.table(paste(root,".1kg.LD_pop_strat.pca.evec_RENAMED",sep=""), head=T)

##Rename columns
colnames(PCAEVEC) <- c("ID","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10","Pop")

##Define colour palette
ThousandGenomesPalette<-

##Print pairwise comparisons of PC1-5 to pdf
pdf(paste(root,"1kg.LD_pop_strat_PCA.pdf",sep=""))
    with(PCAEVEC, qplot(PC1,PC2,colour=Pop))
    with(PCAEVEC, qplot(PC1,PC3,colour=Pop))
    with(PCAEVEC, qplot(PC1,PC4,colour=Pop))
    with(PCAEVEC, qplot(PC1,PC5,colour=Pop))
    with(PCAEVEC, qplot(PC2,PC3,colour=Pop))
    with(PCAEVEC, qplot(PC2,PC4,colour=Pop))
    with(PCAEVEC, qplot(PC2,PC5,colour=Pop))
    with(PCAEVEC, qplot(PC3,PC4,colour=Pop))
    with(PCAEVEC, qplot(PC3,PC5,colour=Pop))
    with(PCAEVEC, qplot(PC4,PC5,colour=Pop))
dev.off()
