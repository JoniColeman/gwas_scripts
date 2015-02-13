awk '{print $2}' dataname_post_imputation_final_rs_only.bim | \
sort | \ 
uniq –d > More_Duplicates_Removed

./plink2 \
--bfile dataname_post_imputation_final \
--exclude More_Duplicates_Removed \
--make-bed \
--out dataname_post_imputation_final

