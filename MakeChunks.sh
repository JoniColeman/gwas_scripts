awk -v const=5000000 -v max=51 '{a[$1,int($4/const)]++; b[$1]} END{for (i in b) {for (j=0; j<max; j++) print i, j*const +1, (j+1)*const, a[i,j]}}' file.bim > Chunks
awk '$4 != "" {print $2, $3 > "analysis_chunks_5Mb_chr"$1".txt"} ' < Chunks
awk '$4 != "" {print > "Chunks_chr"$1".txt"}' < Chunks
