source Config.conf

awk '{print $3}' <(grep -w REMOVED $root.pop_strat_outliers_smartpca.log) | sed 's/:/ /g' > $root._pop_strat_outliers.outliers 
