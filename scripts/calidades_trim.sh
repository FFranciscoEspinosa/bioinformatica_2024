#Leemos los nombres de las muestras que tienen reads pareados
ls ../reads_par | grep _1.fastq.gz | while read line
do
base=$(basename ${line} _1.fastq.gz)
#Corremos fastqc a las muestras trimmeadas que se encuentran en /trimming/nombre_muestra
fastqc ../trimming/${base}/trimmed/${base}_1.trim.fastq.gz -o ../calidades_trim/${base}
fastqc ../trimming/${base}/trimmed/${base}_2.trim.fastq.gz -o ../calidades_trim/${base}
done

#Realizamos lo análogo para las muestras cuyos reads no son pareados.
ls ../reads_no_par | while read line
do
base=$(basename ${line} .fastq.gz)
fastqc ../trimming/${base}/trimmed/${base}.trim.fastq.gz -o ../calidades_trim/${base}
done
