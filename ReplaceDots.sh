source Config.conf

for i in {1..22}
do
awk '$2=="." {$2= $1 ":" $3} {print}' < New_Chromosome$i.impute2 > Temp1
mv Temp1 New_Chromosome$i.impute2

done

awk -v i=$i '$2=="." {$2= $1 ":" $3} {print}' < $root.whole_genome.impute2_info > Temp2
mv Temp2 $root.whole_genome.impute2_info
