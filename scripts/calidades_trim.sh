#Leemos los nombres de las muestras que tienen reads pareados
ls ../reads_par | grep _1.fastq.gz | while read line
do
base=$(basename ${line} _1.fastq.gz)
#Corremos fastqc a las muestras trimmeadas que se encuentran en /trimming/nombre_muestra
fastqc ../trimming/${base}/trimmed/${base}_1.trim.fastq.gz -o ../calidades_trim/${base}
fastqc ../trimming/${base}/trimmed/${base}_2.trim.fastq.gz -o ../calidades_trim/${base}

#Se descomprimen los directorios obtenidos
unzip ../calidades_trim/${base}/${base}_1.trim_fastqc.zip -d ../calidades_trim/${base}
unzip ../calidades_trim/${base}/${base}_2.trim_fastqc.zip -d ../calidades_trim/${base}
# Se buscan las pruebas no superadas y se almacenan en el archivo failed_test.txt
grep FAIL ../calidades_trim/${base}/${base}_1.trim_fastqc/summary.txt >> ../calidades_trim/failed_test.txt
grep FAIL ../calidades_trim/${base}/${base}_2.trim_fastqc/summary.txt >> ../calidades_trim/failed_test.txt
#Se buscan el número de secuencias con poca calidad y se anota en p_qual.txt
grep "Sequences flagged as poor quality" ../calidades_trim/${base}/${base}_1.trim_fastqc/fastqc_data.txt >> ../calidades_trim/p_qual.txt
grep "Sequences flagged as poor quality" ../calidades_trim/${base}/${base}_2.trim_fastqc/fastqc_data.txt >> ../calidades_trim/p_qual.txt
#Se borran los directorios descomprimidos
rm -r ../calidades_trim/${base}/${base}_1.trim_fastqc
rm -r ../calidades_trim/${base}/${base}_2.trim_fastqc
done

#Realizamos lo análogo para las muestras cuyos reads no son pareados.
ls ../reads_no_par | while read line
do
base=$(basename ${line} .fastq.gz)
fastqc ../trimming/${base}/trimmed/${base}.trim.fastq.gz -o ../calidades_trim/${base}

#Se hace el procedimiento de anotación de pruebas y número de secuencias de manera análoga que para las muestras pareadas
unzip ../calidades_trim/${base}/${base}.trim_fastqc.zip -d ../calidades_trim/${base}

grep FAIL ../calidades_trim/${base}/${base}.trim_fastqc/summary.txt >> ../calidades_trim/failed_test.txt

grep "Sequences flagged as poor quality" ../calidades_trim/${base}/${base}.trim_fastqc/fastqc_data.txt >> ../calidades_trim/p_qual.txt

rm -r ../calidades_trim/${base}/${base}.trim_fastqc
done
