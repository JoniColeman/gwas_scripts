for pop in {CEU, CHB, JPT, YRI}
do
head -1 genotypes_chr22_{pop}_r28_nr.b36_fwd.txt | sed 's/ /\n/g' | sort | sed '1,5d' > keepIDs{pop}
done
cat keepIDs* > keepids.txt
