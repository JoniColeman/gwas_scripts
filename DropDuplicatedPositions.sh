awk '{print $2}' $root.post_imputation_final_rs_only.bim | \
sort | \ 
uniq –d > More_Duplicates_Removed

./plink2 \
--bfile $root.post_imputation_final \
--exclude More_Duplicates_Removed \
--make-bed \
--out $root.post_imputation_final

awk 'BEGIN {OFS = "\t"} $2 ~ /^rs/{gsub(":.*", "", $2) }1' $root.post_imputation_final.bim > $root.post_imputation_final_rs_only.bim
cp $root.post_imputation_final.bed $root.post_imputation_final_rs_only.bed
cp $root.post_imputation_final.fam $root.post_imputation_final_rs_only.fam
