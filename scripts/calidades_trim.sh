ls ../reads_par | grep _1.fastq.gz | while read line
do
base=$(basename ${line} _1.fastq.gz)
fastqc ../trimming/${base}/trimmed/${base}_1.trim.fastq.gz -o ../calidades_trim/${base}
fastqc ../trimming/${base}/trimmed/${base}_2.trim.fastq.gz -o ../calidades_trim/${base}
done

ls ../reads_no_par | while read line
do
base=$(basename ${line} .fastq.gz)
fastqc ../trimming/${base}/trimmed/${base}.trim.fastq.gz -o ../calidades_trim/${base}
done
