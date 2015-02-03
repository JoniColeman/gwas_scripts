setwd("/path/to/")
U<-read.table("dataname.genome",head=T) # read in table
V<-with(U, data.frame(FID1, IID1, PI_HAT)) # get variables of interest
W<- aggregate(V$PI_HAT,FUN=mean,by=list(V$FID1, V$IID1)) #calculate average pi hat
names(W)<-c("FID","IID","MEAN_PI_HAT") #rename columns
X<-mean(W$MEAN_PI_HAT) #calculate mean of average pi hats
Y<-sd(W$MEAN_PI_HAT) #calculate standard deviation of average pi hats
Z<-X+(6*Y) # calculate threshold, here 6 SDs from mean
sink("dataname_IBD_INDIV.txt")
W #print average pi hats
sink("dataname_IBD_INDIV_outliers.txt")
subset(W,W$MEAN_PI_HAT>=Z)[,1:2] #print outliers
