awk 'BEGIN {OFS = "\t"} $2 ~ /^rs/{gsub(":.*", "", $2) }1' dataname_post_imputation_final.bim > dataname_post_imputation_final_rs_only.bim
cp dataname_post_imputation_final.bed dataname_post_imputation_final_rs_only.bed
cp dataname_post_imputation_final.fam dataname_post_imputation_final_rs_only.fam
