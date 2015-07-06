source("manhattan_v2.R")
args <- commandArgs(TRUE)
root <- args[1]
gwas1 <- read.table(paste(root,".post_imputation_final_analysis_FOR_MP",sep=""),head=T)
data_to_plot <- data.frame(CHR=gwas1$CHR, BP=gwas1$BP, P=gwas1$P)
pdf(paste(root,".post_imputation_final_analysis_MP.pdf",sep=""),width=8,height=6)
manhattan(data_to_plot, GWthresh=5e-8, GreyZoneThresh=1e-4, DrawGWline=T)
dev.off() 
