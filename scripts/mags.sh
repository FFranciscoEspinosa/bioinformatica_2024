#De la carpeta de los reads pareados, se lee el nombre de las muestras con terminación _1.fastq.gz
ls ../reads_par | grep _1.fastq.gz | while read line
#Posteriormente para cada muestra leida se toma el nombre de la muestra
do
base=$(basename ${line} _1.fastq.gz)
#Finalmente para cada muestra se corre Maxbin con 8 núcleos, se le pasan los contigs obtenidos y ambos pares de reads
#ya trimmeados. La salidas e deposita en el directorio mags/nombre_muestra

run_MaxBin.pl -thread 8 -contig ../assembly/${base}/final.contigs.fa -reads ../trimming/${base}/trimmed/${base}_1.trim.fastq.gz \
-reads2 ../trimming/${base}/trimmed/${base}_2.trim.fastq.gz -out ../mags/${base}/${base}

done

/trimming/SRR5946737/trimmed$ ls
SRR5946737_1.trim.fastq.gz


#Se realiza el procedimiento análogo para las muestras no pareadas.
ls ../reads_no_par | while read line
do
#Se toma el nombre de la muestra y se corre Maxbin
base=$(basename ${line} .fastq.gz)
run_MaxBin.pl -thread 8 -contig ../assembly/${base}/final.contigs.fa -reads ../trimming/${base}/trimmed/${base}.trim.fastq.gz \
-out ../mags/${base}/${base}
done
