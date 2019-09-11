for i in {1..22} 
do	
  mkdir results-directory/Chr$i
  mv gwas_data_chr$i* Chr$i
  cat Chr$i/*.impute2 > Chr$i/Chr$i.impute2
  cat Chr$i/*.impute2_info > Chr$i/Chr$i.impute2_info	
  mv Chr$i/Chr$i.impute2* results-directory/
done
mkdir results-directory/ChrX
mv gwas_data_chrX* ChrX
cat ChrX/*.impute2 > ChrX/ChrX.impute2
cat ChrX/*.impute2_info > ChrX/ChrX.impute2_info	
mv ChrX/ChrX.impute2* results-directory/
