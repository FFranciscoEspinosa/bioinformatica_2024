ls ../reads_par | grep _1.fastq.gz | while read line
do
base=$(basename ${line} _1.fastq.gz)
megahit -1 ../trimming/${base}/trimmed/${base}_1.trim.fastq.gz -2 ../trimming/${base}/trimmed/${base}_2.trim.fastq.gz -o ../assembly/${base}
done


ls ../reads_no_par | while read line
do
base=$(basename ${line} .fastq.gz)
megahit -r ../trimming/${base}/trimmed/${base}.trim.fastq.gz -o ../assembly/${base}
done
