PCAEVEC<-read.table("file.pca.evec",head=T)
PHENOTYPE<-read.table("path/to/phenotypes.phe",head=T)
PCAPHENO<-merge(PCAEVEC,PHENOTYPE)
sink("path/to/PC_Output_Associations.txt")
writeLines(c(" PC P  R-squared"))
options(scipen=999)
for (i in 1:100) {
DATA<-PCAPHENO[,c(3:(i+2),103)]
DATA2<-PCAPHENO[,c(3:(i+1),103)]
print(c(i, summary(lm(Outcome ~ ., DATA))$coefficients[(i+1),4], summary(lm(Outcome ~ ., DATA))$r.squared - summary(lm(Outcome ~ ., DATA2))$r.squared))
}
sink()
