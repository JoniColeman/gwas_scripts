awk '{print $0, $1":"$4}' dataname_post_imputation_updated.bim > dataname_post_imputation_updated_positions
awk '{print $1":"$4}' dataname_post_imputation_updated.bim | sort | uniq -d | dataname_post_imputation_updated_duplicated_positions 
grep -w -f  dataname_post_imputation_updated_duplicated_positions dataname_post_imputation_updated_positions | awk ‘{print $2}’ > dataname_post_imputation_updated_duplicated_IDs
