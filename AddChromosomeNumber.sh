for i in {1..22}
do
awk -v i=$i '{s=""; for (j=2; j <= NF; j++) s=s $j " "; print i, s}' path/to/results-directory/Chr$i.impute2 > New_Chromosome$i.impute2
done
awk ' NR==1 {print; next}{ s = ""; for (j =2; j <= NF; j++) s = s $j " "; print "X", s }' path/to/results-directory/ChrX.impute2 > New_ChromosomeX.impute2
