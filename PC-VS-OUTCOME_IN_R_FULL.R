PCAEVEC<-read.table("file.pca.evec",head=T)
PHENOTYPE<-read.table("path/to/phenotypes.phe",head=T)
PCAPHENO<-merge(PCAEVEC,PHENOTYPE)
sink("path/to/PC_Output_Associations.txt")
for (i in 1:100) {
DATA<-PCAPHENO[,c(3:(i+2),103)]
print(summary(lm(Outcome ~ ., DATA)))
}
sink()
