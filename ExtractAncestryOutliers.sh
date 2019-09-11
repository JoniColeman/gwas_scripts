source Config.conf

awk '/REMOVED/ {print $3}' $root.pop_strat_outliers_smartpca.log | sed 's/:/ /g' > $root.pop_strat_outliers.outliers
