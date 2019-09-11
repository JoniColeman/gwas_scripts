#!/bin/bash
#$ -cwd

for chrom in {1..22}
do
impute2_examples/modified_submit_impute2_jobs_to_cluster.R chr=${chrom} post.avg.impute.run=TRUE
done
sed -i '{s/ qsub/\n\qsub/g}' impute2_examples/qsublist.sh
sed -i '1d' impute2_examples/qsublist.sh

split -l 45 impute2_examples/qsublist.sh impute2_examples/qsub

sed -i '0,/qsub/{s/qsub/qsub --N job1/}' impute2_examples/qsubaa
sed -i '0,/qsub/{s/qsub/qsub --N job2/}' impute2_examples/qsubab
sed -i '0,/qsub/{s/qsub/qsub --N job3/}' impute2_examples/qsubac
sed -i '0,/qsub/{s/qsub/qsub --N job4/}' impute2_examples/qsubad
sed -i '0,/qsub/{s/qsub/qsub --N job5/}' impute2_examples/qsubae
sed -i '0,/qsub/{s/qsub/qsub --N job6/}' impute2_examples/qsubaf ##etc., for as many jobs as are needed

sed -i '{s/qsub/qsub --hold_jid job1/g}' impute2_examples/qsubab
sed -i '{s/qsub/qsub --hold_jid job2/g}' impute2_examples/qsubac
sed -i '{s/qsub/qsub --hold_jid job3/g}' impute2_examples/qsubad
sed -i '{s/qsub/qsub --hold_jid job4/g}' impute2_examples/qsubae
sed -i '{s/qsub/qsub --hold_jid job5/g}' impute2_examples/qsubaf ##etc. for as many jobs as are needed

sh impute2_examples/qsubaa
sh impute2_examples/qsubab
sh impute2_examples/qsubac
sh impute2_examples/qsubad
sh impute2_examples/qsubae
sh impute2_examples/qsubaf
