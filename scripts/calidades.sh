ls ../reads_par | grep _1.fastq.gz | while read line
do
base=$(basename ${line} _1.fastq.gz)
fastqc ../reads_par/${base}_1.fastq.gz -o ../calidades/${base}
fastqc ../reads_par/${base}_2.fastq.gz -o ../calidades/${base}
done

ls ../reads_no_par | while read line
do
base=$(basename ${line} .fastq.gz)
fastqc ../reads_no_par/${line} -o ../calidades/${base}
done
