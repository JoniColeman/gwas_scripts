source ./Config.conf

aspercent=$(echo $1 " / 100" | bc -l)
genomind_1=$(echo "1-"$aspercent | bc -l)

$plink \
--bfile $root.common \
--geno $genomind_1 \
--make-bed \
--out $root.common_SNP$1

#Remove samples with completeness < 90%

$plink \
--bfile $root.common_SNP90 \
--mind $genomind_1 \
--make-bed \
--out $root.common_sample$1.SNP$1

newstep=$(($1+$3))

for i in $(seq $newstep $3 $2)

do

aspercent=$(echo $i " / 100" | bc -l)
genomind=$(echo "1-"$aspercent | bc -l)
prefix=$(($i-$3))

$plink \
--bfile $root.common_sample$prefix.SNP$prefix \
--geno $genomind \
--make-bed \
--out $root.common_sample$prefix.SNP$i

$plink \
--bfile $root.common_sample$prefix.SNP$i \
--mind $genomind \
--make-bed \
--out $root.common_sample$i.SNP$i

done

$plink \
--bfile $root.common_sample$2.SNP$2 \
--make-bed \
--out $root.filtered 
