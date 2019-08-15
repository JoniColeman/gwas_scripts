source("manhattan_v2_bumblebee.R")
args <- commandArgs(TRUE)

data <- args[1]
chr <- args[2]
bp <- args[3]
p <- args[4]
out <- args[5]
gws <- as.numeric(args[6])

gwas1 <- read.table(data,head=T)
data_to_plot <- data.frame(CHR=gwas1[,chr], BP=gwas1[,bp], P=gwas1[,p])

grey_zone <- gws*0.0001 / 0.00000005 

pdf(out,width=8,height=6)
manhattan(data_to_plot, GWthresh=-log10(gws), GreyZoneThresh=-log10(grey_zone), DrawGWline=TRUE)
dev.off() 
