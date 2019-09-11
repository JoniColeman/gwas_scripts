awk '{
if (!($4 in min)) {
    min[$4]=$2; max[$4]=$3; chrom[$4]=$1
  } else {
    if ($2 < min[$4]) min[$4]=$2
    if ($3 > max[$4]) max[$4]=$3
  }
}
END {
  for (name2 in min)
    print chrom[name2], min[name2], max[name2], name2}' $1 | \
sort -k 1 -n | \
sed '1d' | \
awk '$1 >= 1 && $1 <= 22 || $1 =="X" {print $0}' | \
grep -v _g > $2
