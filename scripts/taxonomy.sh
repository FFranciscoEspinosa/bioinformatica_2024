#Se leen los nombres de las muestras que tienen reads pareados
ls ../reads_par | grep _1.fastq.gz | while read line
do
base=$(basename ${line} _1.fastq.gz)
#Se corre kraken con la base de datos almacenada en /files/db_kraken2 , con 4 núcleos para los reads trimmeados
# Las salidas se almacenan en el directorio taxonomy y los reporten en taxonomy/reports
kraken2 --db /files/db_kraken2 --threads 4 --paired ../trimming/${base}/trimmed/${base}_1.trim.fastq.gz ../trimming/${base}/trimmed/${base}_2.trim.fastq.gz \
--output ../taxonomy/${base}.kraken \
--report ../taxonomy/reports/${base}.report
done


#Se leen los nombres de las muestras con reads no pareados
ls ../reads_no_par | while read line
do
base=$(basename ${line} .fastq.gz)
#Se corre kraken con los reads trimmeados y la almacena la salida en taxonomy. Los reportes se almacenan en
# taxonomy/reports
kraken2 --db /files/db_kraken2 --threads 4 ../trimming/${base}/trimmed/${base}.trim.fastq.gz \
--output ../taxonomy/${base}.kraken \
--report ../taxonomy/reports/${base}.report
done
