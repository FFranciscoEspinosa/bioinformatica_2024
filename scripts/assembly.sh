#De la carpeta de los reads pareados, se lee el nombre de las muestras con terminación _1.fastq.gz
ls ../reads_par | grep _1.fastq.gz | while read line
#Posteriormente para cada muestra leida se toma el nombre de la muestra
do
base=$(basename ${line} _1.fastq.gz)
#Finalmente para cada muestra se corre megahit para los dos archivos pareados ya depurados y se crea
#la carpeta output tiene el nombre de la muestra y se encuentra en assembly/
megahit -1 ../trimming/${base}/trimmed/${base}_1.trim.fastq.gz -2 ../trimming/${base}/trimmed/${base}_2.trim.fastq.gz -o ../assembly/${base}
done

#Se realiza el procedimiento análogo para las muestras no pareadas.
ls ../reads_no_par | while read line
do
#Se toma el nombre de la muestra y se corre megahit con la bandera -r para reads no pareados
base=$(basename ${line} .fastq.gz)
megahit -r ../trimming/${base}/trimmed/${base}.trim.fastq.gz -o ../assembly/${base}
done
