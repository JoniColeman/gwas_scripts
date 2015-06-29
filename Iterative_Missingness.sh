genomind=(1-($1/100))

./plink2 \
--bfile $root.common \
--geno $genomind_1 \
--make-bed \
--out $root.common_SNP$1

#Remove samples with completeness < 90%

./plink2 \
--bfile $root.common_SNP90 \
--mind $genomind_initial \
--make-bed \
--out $root.common_sample$1.SNP$1

for i in ${seq(($1+$3), $2, $3)}

do

genomind=(1-($i/100))

./plink2 \
--bfile $root.common_sample($i-$3).SNP($i-$3) \
--geno $genomind \
--make-bed \
--out $root.common_sample($i-$3).SNP$i

#Remove samples with completeness < 90%

./plink2 \
--bfile $root.common_sample($i-$3).SNP$i \
--mind $genomind \
--make-bed \
--out $root.common_sample$i.SNP$i
 
done
