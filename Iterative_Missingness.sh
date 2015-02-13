```{bash}

./plink2 \
--bfile dataname_common \
--geno 0.1 \
--make-bed \
--out dataname_common_SNP90

#Remove samples with completeness < 90%

./plink2 \
--bfile dataname_common_SNP90 \
--mind 0.1 \
--make-bed \
--out dataname_common_sample90_SNP90

#Remove SNPs with completeness < 95%

./plink2 \
--bfile dataname_common_sample90_SNP90 \
--geno 0.05 \
--make-bed \
--out dataname_common_sample90_SNP95

#Remove samples with completeness < 95%

./plink2 \
--bfile dataname_common_sample90_SNP95 \
--mind 0.05 \
--make-bed \
--out dataname_common_sample95_SNP95

#Remove SNPs with completeness < 99%

./plink2 \
--bfile dataname_common_sample95_SNP95 \
--geno 0.01 \
--make-bed \
--out dataname_common_sample95_SNP99

#Remove samples with completeness < 99%

./plink2 \
--bfile dataname_common_sample95_SNP99 \
--mind 0.01 \
--make-bed \
--out dataname_filtered

```
