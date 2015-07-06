args <- commandArgs(TRUE)
root <- args[1]
pheno <- args[2]
PCAEVEC<-read.table(paste(root,".pca.evec",sep=""),head=T)
PHENOTYPE<-read.table(pheno,head=T)
PCAPHENO<-merge(PCAEVEC,PHENOTYPE)
sink("path/to/PC_Output_Associations.txt")
for (i in 1:100) {
DATA<-PCAPHENO[,c(3:(i+2),103)]
print(summary(lm(Outcome ~ ., DATA)))
}
sink()
