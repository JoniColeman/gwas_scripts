args <- commandArgs(TRUE)
root <- args[1]
sigma <- as.numeric(args[2])
U<-read.table(paste(root,".IBD.genome",sep=""),head=T) # read in table
V<-with(U, data.frame(FID1, IID1, PI_HAT)) # get variables of interest
W<- aggregate(V$PI_HAT,FUN=mean,by=list(V$FID1, V$IID1)) #calculate average pi hat
names(W)<-c("FID","IID","MEAN_PI_HAT") #rename columns
X<-mean(W$MEAN_PI_HAT) #calculate mean of average pi hats
Y<-sd(W$MEAN_PI_HAT) #calculate standard deviation of average pi hats
Z<-X+(sigma*Y) # calculate threshold, here 6 SDs from mean
sink(paste(root,".IBD_INDIV.txt",sep=""))
W #print average pi hats
sink(paste(root,".IBD_INDIV_outliers.txt",sep=""))
subset(W,W$MEAN_PI_HAT>=Z)[,1:2] #print outliers
