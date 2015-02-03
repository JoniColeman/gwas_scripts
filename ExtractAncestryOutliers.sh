awk '{print $3}' <(grep –w REMOVED dataname_pop_strat_outliers_smartpca.log) | sed 's/:/ /g' > dataname_pop_strat_outliers.outliers 
