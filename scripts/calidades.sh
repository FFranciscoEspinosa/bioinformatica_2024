#Se lee el nombre todas las muestras con reds pareados
ls ../reads_par | grep _1.fastq.gz | while read line
do
base=$(basename ${line} _1.fastq.gz)
#Utilizamos fatqc para obtener las calidades de los reads pareados asocioados a la muestra y se guardan
#los resultados en el directorio calidades/nombre_muestra
fastqc ../reads_par/${base}_1.fastq.gz -o ../calidades/${base}
fastqc ../reads_par/${base}_2.fastq.gz -o ../calidades/${base}
done

#Análogamente se lee el nombre de las muestras cuyos reads no son pareados
ls ../reads_no_par | while read line
do
base=$(basename ${line} .fastq.gz)
fastqc ../reads_no_par/${line} -o ../calidades/${base}
done
