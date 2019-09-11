data_dir <- getwd()
setwd(data_dir)
args <- commandArgs(TRUE)
root <- args[1]
# default
ibc_file=paste(root,".ibc",sep="")
sdcut=3 # number of sds at which to impose cut offs
# get args
t=commandArgs()
if (charmatch("-args",t,nomatch=-1)>=0) args = t[((1:length(t))[t=="-args"]+1):length(t)] else args=""
if (charmatch("ibc_file=",args,nomatch=-1)>=0) ibc_file = strsplit(args[charmatch("ibc_file=",args)],split="=")[[1]][2]
if (charmatch("sdcut=",args,nomatch=-1)>=0) sdcut = strsplit(args[charmatch("sdcut=",args)],split="=")[[1]][2]
##
d <- read.table(ibc_file,head=T);
het_outliers_3sd <- abs(scale(d$Fhat2))>3
write.table(d[het_outliers_3sd,],file=paste(root,".LD_het_outliers.txt",sep=""), sep="\t",quote=F,row.names=F);
write.table(d[het_outliers_3sd,c(1,2)],file=paste(root,".LD_het_outliers_sample_exclude",sep=""), sep="\t",quote=F,row.names=F,col.names=F);
