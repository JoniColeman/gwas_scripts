source Config.conf

gunzip $root.whole_genome.impute2_info.gz
awk '$5 >= 0.8' $root.whole_genome.impute2_info > $root.whole_genome_filtered.impute2_info
gzip $root.whole_genome.impute2_info
for i in {1..22}
do
awk 'FNR==NR { a[$2]; next } $2 in a' $root.whole_genome_filtered.impute2_info New_Chromosome$i.impute2 > Filtered_Chromsome$i.impute2
done
awk 'FNR==NR { a[$2]; next } $2 in a' $root.whole_genome_filtered.impute2_info New_ChromosomeX.impute2 > Filtered_ChromsomeX.impute2
