source("qq_plot_v7.R")
args <- commandArgs(TRUE)
root <- args[1]
gwas1<-read.table(paste(root, sep=""),head=T)
x1<-gwas1$P
pdf(paste(root,".QQ.pdf",sep=""),width=8,height=6)
qq.plot(x1, alpha=0.05, datatype="pvalue", scaletype="pvalue", df=1, plot.concentration.band=TRUE, one.sided=FALSE,frac=0.1, print=F, xat=NULL, yat=NULL, main=NULL, xlab=NULL, ylab=NULL, pch="x", cex=0.5, col="black")
text(x=12,y=4,paste("lambda--median=", format((median(qchisq(p=1-x1,df=1)))/0.4549,digits=3),sep=""))
dev.off()

###This version of the QQ plot wrapper also writes values of lambda median on the plot, using p--values for all SNPs plotted.###
