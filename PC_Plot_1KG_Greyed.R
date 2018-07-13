###Author: JRIC
###Date: 2018-07-13
###Purpose: Plot user data projected on 1KG PCs, greying out 1KG individuals

##Load packages
library(ggplot2)
library(colorspace)

##Initialise command line arguments
args <- commandArgs(TRUE)

##Load data
root <- args[1]
PCAEVEC<-read.table(paste(root,".1kg.LD_pop_strat.pca.evec_RENAMED",sep=""), head=T)

##Rename columns
colnames(PCAEVEC) <- c("ID","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10","Pop")

##Define colour palette
ThousandGenomesPalette<-heat_hcl(length(unique(PCAEVEC$Pop)), h = c(300, 75), c. = c(35, 95), l = c(15, 90), power = c(0.8, 1.2), fixup = TRUE, gamma = NULL, alpha = 1)
ThousandGenomesPops<-c("LWK","MXL","PUR","TSI","YRI","ASW","CEU","CHB","CHS","CLM","FIN","GBR","IBS","JPT")

ThousandGenomesPalette[unique(PCAEVEC$Pop) %in% ThousandGenomesPops] <- "#CCCCCC" 
                                                                              
##Print pairwise comparisons of PC1-5 to pdf
pdf(paste(root,"1kg.LD_pop_strat_PCA.pdf",sep=""))
    with(PCAEVEC, qplot(PC1,PC2,colour=Pop) + scale_colour_manual(values = ThousandGenomesPalette))
    with(PCAEVEC, qplot(PC1,PC3,colour=Pop) + scale_colour_manual(values = ThousandGenomesPalette))
    with(PCAEVEC, qplot(PC1,PC4,colour=Pop) + scale_colour_manual(values = ThousandGenomesPalette))
    with(PCAEVEC, qplot(PC1,PC5,colour=Pop) + scale_colour_manual(values = ThousandGenomesPalette))
    with(PCAEVEC, qplot(PC2,PC3,colour=Pop) + scale_colour_manual(values = ThousandGenomesPalette))
    with(PCAEVEC, qplot(PC2,PC4,colour=Pop) + scale_colour_manual(values = ThousandGenomesPalette))
    with(PCAEVEC, qplot(PC2,PC5,colour=Pop) + scale_colour_manual(values = ThousandGenomesPalette))
    with(PCAEVEC, qplot(PC3,PC4,colour=Pop) + scale_colour_manual(values = ThousandGenomesPalette))
    with(PCAEVEC, qplot(PC3,PC5,colour=Pop) + scale_colour_manual(values = ThousandGenomesPalette))
    with(PCAEVEC, qplot(PC4,PC5,colour=Pop) + scale_colour_manual(values = ThousandGenomesPalette))
dev.off()
