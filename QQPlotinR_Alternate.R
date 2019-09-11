library(data.table)
source("~/Desktop/gwas_scripts/qq_plot_v7.R")
gwas1<-fread("daner_PGC_BIP32b_mds7a_0416a_INFO3_AF1",data.table=F)
x1<-gwas1$P
png("daner_PGC_BIP32b_mds7a_0416a_INFO3_AF1.png",width=2400,height=3000, res=300)
qq.plot(x1, alpha=0.05, datatype="pvalue", scaletype="pvalue", df=1, plot.concentration.band=TRUE, one.sided=FALSE,frac=1, print=F, xat=NULL, yat=NULL, main="QQ Plot", xlab=NULL, ylab=NULL, pch="x", cex=1, col="black", cex.lab=1.5, cex.main=1.5)
text(x=20,y=4,paste(expression(lambda[median]),"=", format((median(qchisq(p=1-x1,df=1)))/0.4549,digits=3),sep=" "), cex=1.5)
dev.off()

# gwas2<-fread("daner_PGC_BIP32b_mds7a_0416a_INFO6_AF1",data.table=F)
# x2<-gwas2$P
# png("daner_PGC_BIP32b_mds7a_0416a_INFO6_AF1.png",width=4800,height=6000, res=300)
# qq.plot(x2, alpha=0.05, datatype="pvalue", scaletype="pvalue", df=1, plot.concentration.band=TRUE, one.sided=FALSE,frac=0.1, print=F, xat=NULL, yat=NULL, main=NULL, xlab=NULL, ylab=NULL, pch="x", cex=0.5, col="black")
# text(x=12,y=4,paste("lambda-median=", format((median(qchisq(p=1-x1,df=1)))/0.4549,digits=3),sep=""))
# dev.off()

###This version of the QQ plot wrapper also writes values of lambda median on the plot, using p--values for all SNPs plotted.###
