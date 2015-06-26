results=$1
for i in {1..22}
do
awk -v i=$i results=$results '{s=""; for (j=2; j <= NF; j++) s=s $j " "; print i, s}' $results/Chr$i.impute2 > New_Chromosome$i.impute2
done
awk -v results=$results ' NR==1 {print; next}{ s = ""; for (j =2; j <= NF; j++) s = s $j " "; print "X", s }' $results/ChrX.impute2 > New_ChromosomeX.impute2
