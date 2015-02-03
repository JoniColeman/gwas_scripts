#Generic Manhattan plot function for PLINK-formatted data (chr X,Y,XY and MT are represented as 23,24,25,26)
#Wrapper function written by Mike Weale and Richard Gunning.  Internal "wgplot" function written by Matt Settles.
#Version 2 (12 Mar 2013)
#Arguments:
#x				Data frame to be plotted. x$CHR contains chromosome (numeric).  x$BP contains SNP position (numeric).  x$P contains association p-value (numeric)
#GWthresh			Numeric.  Indicates where "genomewide significance" threshold should be drawn
#GreyZoneThresh		Numeric.  Indicates a sub-genomewide-sig "grey zone" where SNPs are shown with a larger point size
#DrawGWline		Boolean.  If TRUE, then a red line at the "genomewide significance" threshold is plotted
#cutoff			Numeric.  Any p-vlaues less than cutoff are forced equal to cutoff
#Example:
#source("manhattan_v2.R")
#d = read.table("myplinkresults.logistic", header=TRUE, as.is=TRUE)
#X=data.frame(CHR=d$CHR, BP=d$BP, P=d$P)
#manhattan( X, DrawGWline=FALSE )

manhattan <- function( x, GWthresh=-log10(5e-8), GreyZoneThresh=-log10(1e-4), DrawGWline=TRUE, cutoff=0 )
{

x$P[ x$P<cutoff ] = cutoff

#Create x2 data frame for use with wgplot
x2=data.frame(CHR=as.character(x$CHR), BP=x$BP, P=x$P, stringsAsFactors=FALSE)
x2$CHR[x2$CHR=="23"]="X"
x2$CHR[x2$CHR=="24"]="Y"
x2$CHR[x2$CHR=="25"]="XY"
x2$CHR[x2$CHR=="26"]="MT"

labels <- unique(x2$CHR)
wgplot(x2, pch=".", color=c(1:25), cutoffs=4:9, labels=labels )

for (i in 4:20) abline(h=i, col="grey", lty="dotted")

#Get my own global SNP pos info
chr  <- x$CHR
pos  <- x$BP
p    <- x$P

ord  <- order(as.numeric(chr),as.numeric(pos))
chr  <- chr[ord]
pos  <- pos[ord]
p    <- p[ord]

lens.chr <- as.vector(table(as.numeric(chr)))
CM <- cumsum(lens.chr)
n.chr <- length(lens.chr)
color=c(1:25)
color <- rep(color,ceiling(n.chr/length(color)))

p <- -log(p,10)

#make positions cumulatve
if ( any(diff(pos) < 0) ) {
  cpos <-  cumsum(c(0,pos[which(!duplicated(chr))-1]))
  pos <- pos + rep(cpos,lens.chr)
  
  mids <- cpos + diff(c(cpos,max(pos)))/2
}

#plot overlay points
for (i in 1:n.chr) {
  u <- CM[i]
  l <- CM[i] - lens.chr[i] + 1
  cat("Overlay Plotting points ", l, "-", u, "\n")
  postmp <- pos[l:u]
  ptmp <- p[l:u]
  points(postmp[(ptmp>GreyZoneThresh)&(ptmp<GWthresh)], ptmp[(ptmp>GreyZoneThresh)&(ptmp<GWthresh)],cex=0.5, pch="x", col=color[i])
  points(postmp[ptmp>GWthresh], ptmp[ptmp>GWthresh], pch=20, col=color[i])
}

#drawthreshold
if (DrawGWline) {
   abline(h=(GWthresh), col="red")
}
}



#From http://bioinfo-mite.crb.wsu.edu/Rcode/wgplot.R
#See also https://stat.ethz.ch/pipermail/r-help/2008-November/180812.html
###############################################################################
###
### Whole Genome Significance plot 
### Matt Settles
### Bioinformatics Core
### Washington State University, Pullman, WA
### 
### Created July 7, 2008
###
### July 8, 2008 - fixed color goof
###############################################################################
##############
### things to add
### marker name on plot for significant markers
##############

### THERE ARE ERRORS IN GAPS MHTPLOT, SO THIS IS A FIX
## data 	a data frame with three columns representing chromosome, position and p values logged or unlogged
## logscale a flag to indicate if p value are to be log-transformed, FALSE means already logtransformed
## base 	the base of the logarithm, when logscale =TRUE
## cutoffs 	the cutt-offs where horizontal line(s) are drawn
## color 	the color for different chromosome(s), and random if unspecified
## labels 	labels for the x-axis, length = number of chromosomes
## xlabel   label to be placed on the X axis
## ylabel   lable to be placed on the Y axis
## ... 	other options in compatible with the R plot function

## USAGE
# source("http://bioinfo-mite.crb.wsu.edu/Rcode/wgplot.R")
## fake example with Affy500k data
# affy <-c(40220, 41400, 33801, 32334, 32056, 31470, 25835, 27457, 22864, 28501, 26273, 
#          24954, 19188, 15721, 14356, 15309, 11281, 14881, 6399, 12400, 7125, 6207)
# CM <- cumsum(affy)
# n.markers <- sum(affy)
# n.chr <- length(affy)
# test <- data.frame(chr=rep(1:n.chr,affy),pos=1:n.markers,p=runif(n.markers))
# png("wgplot.png",units="in",width=8,height=5,res=300)
# par(las="2",cex=0.6,pch=21,bg="white")
# wgplot(test,cutoffs = c(1,3, 5, 7, 9),color=palette()[2:5],labels=as.character(1:22))
# title("Whole Genome Associaton Plot of Significance for Chromosomes 1 to 22")
# dev.off()
##
"wgplot" <-
function (data, 
    logscale = TRUE, 
    base = 10, 
    cutoffs = c(3, 5, 7, 9),
    siglines = NULL,
    sigcolors = "red", 
    color = sample(colors(), 26),
    chrom = as.character(c(1:22,"X","Y","XY","MT")),
    startbp = NULL,
    endbp = NULL,
    labels = as.character(c(1:22,"X","Y","XY","MT")),
    xlabel = "Chromosome",
    ylabel = "-Log10(p-value)", ...) 
{
    if (any(is.na(data)))
        data <- data[-unique(which(is.na(data))%%nrow(data)),]
	keep <- which(data[,1] %in% chrom)
	data <- data[keep,]
    if (!is.null(startbp) & !is.null(endbp) & length(chrom) == 1){
        keep <- which(data[,2] >= startbp & data[,2] <= endbp) 
        data <- data[keep,]       
    }
    
    
    chr  <- data[, 1]
    pos  <- data[, 2]
    p    <- data[, 3]
    
    ### remove any NAs
     which(is.na(data[,2]))
    chr  <- replace(chr,which(chr == "X"),"100")
    chr  <- replace(chr,which(chr == "Y"),"101")
    chr  <- replace(chr,which(chr == "XY"),"102")
    chr  <- replace(chr,which(chr == "MT"),"103")	

    ord  <- order(as.numeric(chr),as.numeric(pos))
    chr  <- chr[ord]
    pos  <- pos[ord]
    p    <- p[ord]
   
    lens.chr <- as.vector(table(as.numeric(chr)))
    CM <- cumsum(lens.chr)
    n.markers <- sum(lens.chr)
    n.chr <- length(lens.chr)
    id <- 1:n.chr
    color <- rep(color,ceiling(n.chr/length(color)))
    if (logscale)
        p <- -log(p,base)        
    if ( any(diff(pos) < 0) ) {
        cpos <-  cumsum(c(0,pos[which(!duplicated(chr))-1]))
        pos <- pos + rep(cpos,lens.chr)

        mids <- cpos + diff(c(cpos,max(pos)))/2
    }

    par(xaxt = "n", yaxt = "n")
    plot(c(pos,pos[1]), c(9,p), type = "n", xlab = xlabel, ylab = ylabel, axes = FALSE,  ...)
    for (i in 1:n.chr) {
        u <- CM[i]
        l <- CM[i] - lens.chr[i] + 1
        cat("Plotting points ", l, "-", u, "\n")
        points(pos[l:u], p[l:u], col = color[i], ...)
    }
    par(xaxt = "s", yaxt = "s")
    axis(1, at = c(0, pos[round(CM)],max(pos)),FALSE)
	text(mids, par("usr")[3] - 0.5, srt = 0, pos=2,cex=0.5,offset= -0.2,
          labels = labels[1:n.chr], xpd = TRUE)
	#axis(side=1, at =  pos[round(CM-lens.chr/2)],tick=FALSE, labels= labels[1:n.chr])
    #abline(h = cutoffs)
    axis(side=2, at = cutoffs )
	if (!is.null(siglines))
    abline(h = -log(siglines,base),col=sigcolors)

    #mtext(eval(expression(cutoffs)), 2, at = cutoffs)
	
}



