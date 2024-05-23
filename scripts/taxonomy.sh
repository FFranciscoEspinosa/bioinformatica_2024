ls ~/camda2024/reads_par | grep _1.fastq.gz | while read line
do
base=$(basename ${line} _1.fastq.gz)
kraken2 --db /files/db_kraken2 --threads 4 --paired ~/camda2024/trimming/${base}/trimmed/${base}_1.trim.fastq.gz ~/camda2024/trimming/${base}/trimmed/${base}_2.trim.fastq.gz \
--output ~/camda2024/taxonomy/${base}.kraken \
--report ~/camda2024/taxonomy/reports/${base}.report
done


ls ~/camda2024/reads_no_par | while read line
do
base=$(basename ${line} .fastq.gz)
kraken2 --db /files/db_kraken2 --threads 4 ~/camda2024/trimming/${base}/trimmed/${base}.trim.fastq.gz \
--output ~/camda2024/taxonomy/${base}.kraken \
--report ~/camda2024/taxonomy/reports/${base}.report
done
