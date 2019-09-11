#Generic QQ plot function with concentration bands, for either P-values or chi-sq values
#Function written by Mike Weale and Tom Price, King's College London.
#Version 7 (23 Feb 2013) (a) fixes plots issues if p=0 values in the dataset; (b) allows "iplot" vector giving indices of sorted quantiles (O vector - largest values first) to be plotted)
#Concentration bands are plotted using the pointwise method of Quesenberry & Hale (1980) J. Statist. Comput. Simul. 11:41-53
#The method proceeds from noting that the kth order statistic from a sample of n i.i.d. U(0,1) statistics has a Beta(k,n+1-k) distribution.
#Arguments:
#x		the data vector to be plotted
#alpha	the alpha level for the concentration band (if plotted)
#datatype	"pvalue" (default) indicates x contains p-values.  "chisq" indicates x contains chi-square values.  "stdnorm" indicates x contains z values.
#scaletype	"pvalue" (default) indicates x- and y-axis scale to be in -log10(p-value) units.  "quantile" indicates x- and y-axis scale to be in quantile units (=chisq units for pvalues).  Note if datatype="stdnorm" then scaletype is forced ="quantile"
#df		degrees of freedom for chi-square scale used in Q-Q plot.  Default=1 (as this is the most common test type)
#plot.concentration.band	Flag to indicate whether concentration band is to be plotted.  Default=TRUE.
#one.sided				Flab to indicate if one-sided (upper) or two-sided concentration band required.  Default=FALSE
#frac=1	Fraction of total data to be plotted.  E.g. set frac=0.1 to plot only the top 10% of data points
#iplot	If set, a vector of indices for which ordered quantiles (O vector - largest values first) to be plotted.
#		e.g. set iplot=c( (1:1e4), sort(sample((1e4:length(x)),1e4)) ) to select all of 1st 10k values + random set of remaining 10k values
#		Note if iplot is set, then frac is forced=1
#print	If set, a dataframe of O and E values are returned.  Default=FALSE
#xat		If set, a vector seting x tick positions. For p-values, sets 10^x positions
#yat		If set, a vector seting y tick positions. For p-values, sets 10^y positions
# ...		other graphical parameters to be passed to plot function
#Returns (if print==TRUE):
#Dataframe with two columns: $O=sorted observed values, $E=sorted expected values
#e.g.
#p = pnorm(c(rnorm(1e4),rnorm(10)-5))  #mixture of 'null' and 'hit' p-values
#qq.plot(p)
#
qq.plot <- function( x, alpha=0.05, datatype="pvalue", scaletype="pvalue", df=1, plot.concentration.band=TRUE, one.sided=FALSE, frac=1, iplot=NULL, print=FALSE, xat=NULL, yat=NULL, main=NULL, xlab=NULL, ylab=NULL, pch="x", cex=0.5, col="black", ... )
{
  pname <- paste(deparse(substitute(x), 500), collapse="\n")   #Name of vector passed as "x" to be used in plot title etc.
  if (!is.null(iplot)) frac=1            #Forces frac=1 if "iplot" used to chose points to plot
  #Some validity checks on x
  if (!is.numeric(x))
    stop("'x' must be numeric")
  nmissing = sum(is.na(x))
  x <- x[ !is.na(x) ]                 #To deal with missing data values (these don't get plotted)
  if ((datatype=="pvalue")&((min(x)<0)|(max(x)>1)))
    stop("'x' must be >=0 and <=1")
  if ((datatype=="chisq")&(min(x)<0))
    stop("'x' must be >=0")
  nzero = sum(x==0)
  #Some warnings on missing values (and, if pvalues, on x=0) 
  if (nmissing>0)
    warning(nmissing, " missing values (excluded)")
  if ((nzero>0)&(datatype=="pvalue")) {
    warning(nzero, " zero values (plotted with same value as lowest non-zero p-value)")
    x[x==0] <- min(x[x>0])
  }
  if (datatype=="stdnorm") {df=0; scaletype="ordinal"}
  n <- length(x)
  starti = floor((n-1)*(1-frac)) +1         			#i for the first sorted datapoint to be plotted.
  lena = n-starti+1			               			#Number of datapoints to be plotted
  if (!is.null(iplot)) a2=iplot else a2=(1:lena)          #indices to be plotted
  b <- n+1-a2                                             #indices used in determining concentration band
  #Find E and O under relevant inv. chisq transformation
  if ((df==2)&(datatype!="stdnorm")) {                                  #short-cut for df=2 (chisq or pval data): use -2log-transformed expected U(0,1) order statistics (high values first)
    E <- -2*log(a2/(n+1))                                               
    if (datatype=="pvalue") O <- -2*log(sort(x)[a2])                    #Note obs data no need to transform if already chisq or z value (high values first)
  } else {
    if (datatype=="stdnorm") E <- qnorm(a2/(n+1),lower.tail=FALSE)              #invnorm-transformed expected U(0,1) order statistics (put high scores first)
    if (datatype!="stdnorm") E <- qchisq(a2/(n+1),df=df,lower.tail=FALSE)       #invchisq-transformed expected U(0,1) order statistics (put high scores first)
    if (datatype=="pvalue") O <- qchisq(sort(x)[a2],df=df,lower.tail=FALSE)     #Take lowest pvalues, transform to chisq (highest/most interesting values first)
  }
  if (datatype!="pvalue") O <- sort(x, decreasing=TRUE)[a2]                     #Sort x (chisq or norm), highest (most interesting) values first
  #Derive "pretty" tick places for log10 p-value scale, if necessary
  #Note that by this stage, O/E will either contain chisq-scale or normal-scale values, and both are sorted
  if (scaletype=="pvalue") {                                              #Note scaletype forced="quantile" for stdnorm data, so here all data is on chisq scale
    if (!is.null(xat)) x4Lx=xat  else x4Lx = pretty( -log10( pchisq(c(E[1],E[length(E)]),df=df,lower.tail=FALSE) ) )
    if (!is.null(yat)) y4Ly=yat  else y4Ly = pretty( -log10( pchisq(c(O[1],O[length(O)]),df=df,lower.tail=FALSE) ) )
    xnums = qchisq(10^-x4Lx,df=df,lower.tail=FALSE)                       #Get same locations on actual chisq scale
    ynums = qchisq(10^-y4Ly,df=df,lower.tail=FALSE)                       #Get same locations on actual chisq scale
    Lx <- parse( text=paste("10^-",x4Lx,sep="") )
    Ly <- parse( text=paste("10^-",y4Ly,sep="") )
  } else {                                                                #"Else" covers both chisq and stdnorm-scaled data
    if (!is.null(xat)) xnums=xat else xnums=pretty(c(E[1],E[length(E)]))
    if (!is.null(yat)) ynums=yat else ynums=pretty(c(O[1],O[length(O)]))
    Lx <- parse( text=as.character(xnums) )
    Ly <- parse( text=as.character(ynums) )
  }
  #Do Q-Q plot
  if (is.null(main)) {
    if (datatype=="stdnorm") main=paste("Q-Q plot (on stdnorm) of " ,pname, sep="")
    else main=paste("Q-Q plot (on chisq[",df,"]) of " ,pname, sep="")
  }
  if (is.null(xlab)) {
    if (scaletype=="pvalue") xlab="Expected p-value"
    else xlab="Expected quantile"
  }
  if (is.null(ylab)) {
    if (scaletype=="pvalue") ylab="Observed p-value"
    else ylab="Observed quantile"
  }
  plot( c(E[1],E[length(E)]), c(O[1],O[length(O)]), main = main, xlab = xlab, ylab = ylab, type = "n", xaxt = "n", yaxt = "n", ... )       #Just plots the outside box
  axis(1, at=xnums, labels=Lx )
  axis(2, at=ynums, labels=Ly )
  if (plot.concentration.band==TRUE) {        #Note that conc band won't draw if x has too many datapoints
    if (one.sided==FALSE) {
      upper <- qbeta( 1-alpha/2, a2, b )      #Exp. upper CL for 'a'th U(0,1) order statistic (becomes 'lower')
      lower <- qbeta( alpha/2, a2, b )        #Exp. lower CL for 'a'th U(0,1) order statistic (becomes 'upper')
    } else {
      upper <- rep(1,length(E))                    #Exp. upper CL for 'a'th U(0,1) order statistic (becomes 'lower')
      lower <- qbeta( alpha, a2, b )          #Exp. lower CL for 'a'th U(0,1) order statistic (becomes 'upper')
    }
    if (df==2) {
      polygon( c( E, rev(E) ), c( -2*log(upper), rev(E) ), col="grey", border = NA )  #'lower' band after trans
      polygon( c( E, rev(E) ), c( -2*log(lower), rev(E) ), col="grey", border = NA )  #'upper' band after trans
    } else {
      if (datatype=="stdnorm") {
        polygon( c( E, rev(E) ), c( qnorm(upper,lower.tail=FALSE), rev(E) ), col="grey", border = NA )
        polygon( c( E, rev(E) ), c( qnorm(lower,lower.tail=FALSE), rev(E) ), col="grey", border = NA )
      } else {
        polygon( c( E, rev(E) ), c( qchisq(upper,df=df,lower.tail=FALSE), rev(E) ), col="grey", border = NA ) #'lower' band
        polygon( c( E, rev(E) ), c( qchisq(lower,df=df,lower.tail=FALSE), rev(E) ), col="grey", border = NA ) #'upper' band
      }
    }
  }
  abline( 0, 1, col="red" )                                          #plot 1:1 line
  abline(h=ynums, v=xnums, col="lightgray", lty="dotted")            #plot grid
  points( E, O, pch=pch, cex=cex, col=col )                          #Finally, plot points
  if (print==TRUE) return( data.frame( O=O, E=E ) )
}
