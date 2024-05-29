#Se leen las muestras que tienen reads pareados
ls ../reads_par | grep _1.fastq.gz | while read line
do
base=$(basename ${line} _1.fastq.gz)
#Se crean los directorios trimmed y untrimmed en trimming/nombre_muestra
mkdir ../trimming/${base}/trimmed
mkdir ../trimming/${base}/untrimmed
#Se corre trimmomatic con 4 núcleos y con el archivo TrueSeq3-PE.fa que se encuentra en el directorio scripts
#la salida trim se deposita en trimming/nombre_muestra/trimmed,
#la untrimmed en /trimming/nombre_muestra/untrimmed
trimmomatic PE -threads 4 ../reads_par/${base}_1.fastq.gz ../reads_par/${base}_2.fastq.gz \
../trimming/${base}/trimmed/${base}_1.trim.fastq.gz ../trimming/${base}/untrimmed/${base}_1un.trim.fastq.gz \
../trimming/${base}/trimmed/${base}_2.trim.fastq.gz ../trimming/${base}/untrimmed/${base}_2un.trim.fastq.gz \
#Se guarda la información del proceso en summary
-summary ../trimming/${base}/summary.txt SLIDINGWINDOW:4:20 MINLEN:35 ILLUMINACLIP:TruSeq3-PE.fa:2:40:15
done

#Se leen los nombres de las muestras de reads no pareados
ls ../reads_no_par | while read line
do
base=$(basename ${line} .fastq.gz)
#Se crean los directorios trimmed y untrimmed como antes
mkdir ../trimming/${base}/trimmed
mkdir ../trimming/${base}/untrimmed
#Se corre trimmomatic como antes
trimmomatic SE -threads 4 ../reads_no_par/${base}.fastq.gz \
../trimming/${base}/trimmed/${base}.trim.fastq.gz \
-summary ../trimming/${base}/summary.txt SLIDINGWINDOW:4:20 MINLEN:35 ILLUMINACLIP:TruSeq3-PE.fa:2:40:15
done
