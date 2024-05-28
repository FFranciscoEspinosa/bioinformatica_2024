#Se lee el nombre todas las muestras con reds pareados
ls ../reads_par | grep _1.fastq.gz | while read line
do
base=$(basename ${line} _1.fastq.gz)
#Utilizamos fatqc para obtener las calidades de los reads pareados asocioados a la muestra y se guardan
#los resultados en el directorio calidades/nombre_muestra
fastqc ../reads_par/${base}_1.fastq.gz -o ../calidades/${base}
fastqc ../reads_par/${base}_2.fastq.gz -o ../calidades/${base}
#Se descomprimen los directorios obtenidos
unzip ../calidades/${base}/${base}_1_fastqc.zip -d ../calidades/${base}
unzip ../calidades/${base}/${base}_2_fastqc.zip -d ../calidades/${base}
# Se buscan las pruebas no superadas y se almacenan en el archivo failed_test.txt
grep FAIL ../calidades/${base}/${base}_1_fastqc/summary.txt >> ../calidades/failed_test.txt
grep FAIL ../calidades/${base}/${base}_2_fastqc/summary.txt >> ../calidades/failed_test.txt
#Se buscan el número de secuencias con poca calidad y se anota en p_qual.txt
grep "Sequences flagged as poor quality" ../calidades/${base}/${base}_1_fastqc/fastqc_data.txt >> ../calidades/p_qual.txt
grep "Sequences flagged as poor quality" ../calidades/${base}/${base}_2_fastqc/fastqc_data.txt >> ../calidades/p_qual.txt
#Se borran los directorios descomprimidos 
rm -r ../calidades/${base}/${base}_1_fastqc
rm -r ../calidades/${base}/${base}_2_fastqc
done

#Análogamente se lee el nombre de las muestras cuyos reads no son pareados
ls ../reads_no_par | while read line
do
base=$(basename ${line} .fastq.gz)
fastqc ../reads_no_par/${line} -o ../calidades/${base}

#Se hace el procedimiento de anotación de pruebas y número de secuencias de manera análoga que para las muestras pareadas
unzip ../calidades/${base}/${base}_fastqc.zip -d ../calidades/${base}

grep FAIL ../calidades/${base}/${base}_fastqc/summary.txt >> ../calidades/failed_test.txt

grep "Sequences flagged as poor quality" ../calidades/${base}/${base}_fastqc/fastqc_data.txt >> ../calidades/p_qual.txt

rm -r ../calidades/${base}/${base}_fastqc
done
