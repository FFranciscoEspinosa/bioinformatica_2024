ls ../reads_par | grep _1.fastq.gz | while read line
do
base=$(basename ${line} _1.fastq.gz)
mkdir ../trimming/${base}/trimmed
mkdir ../trimming/${base}/untrimmed
trimmomatic PE -threads 4 ../reads_par/${base}_1.fastq.gz ../reads_par/${base}_2.fastq.gz \
../trimming/${base}/trimmed/${base}_1.trim.fastq.gz ../trimming/${base}/untrimmed/${base}_1un.trim.fastq.gz \
../trimming/${base}/trimmed/${base}_2.trim.fastq.gz ../trimming/${base}/untrimmed/${base}_2un.trim.fastq.gz \
SLIDINGWINDOW:4:20 MINLEN:35 ILLUMINACLIP:TruSeq3-PE.fa:2:40:15
done


ls ../reads_no_par | while read line
do
base=$(basename ${line} .fastq.gz)
mkdir ../trimming/${base}/trimmed
mkdir ../trimming/${base}/untrimmed
trimmomatic SE -threads 4 ../reads_no_par/${base}.fastq.gz \
../trimming/${base}/trimmed/${base}.trim.fastq.gz \
SLIDINGWINDOW:4:20 MINLEN:35 ILLUMINACLIP:TruSeq3-PE.fa:2:40:15
done
