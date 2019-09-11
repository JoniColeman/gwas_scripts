source Config.conf

awk '{print $0, $1":"$4}' $root.post_imputation_updated.bim > $root.post_imputation_updated_positions
awk '{print $1":"$4}' $root.post_imputation_updated.bim | sort | uniq -d | $root.post_imputation_updated_duplicated_positions 
grep -w -f  $root.post_imputation_updated_duplicated_positions $root.post_imputation_updated_positions | awk ‘{print $2}’ > $root.post_imputation_updated_duplicated_IDs
