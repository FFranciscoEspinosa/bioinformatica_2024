# Bioinformática 2024

En este repositorio se encuentra el procesamiento básico de la clase de bioinformática 2024.  Únicamente se trabajarán con 100 muestras, de las cuáles su id se encuentra en [*\scripts\ids.txt*](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/scripts/id.txt).

## Muestras
Estas 100 muestras son un subconjunto de las 613 muestras dadas por el reto gut de CAMDA 2024. Los metadatos proporcionados por CAMDA se encuentran en el archivo [*metadatos.csv*](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/metadatos.csv) .De estas 100 muestras, 94 de ellas eran muestras pareadas y las 6 restantes no lo eran.
Las 94 muestras:
- Fueron realizadas por los proyectos HMP2, PRJEB1220 y PRJNA389280. 
- Poseen alrededor de 12823825 pares de bases.
- Tienen cerca de 50 a 101 de longitud de reads .

Las 6 muestras restantes:
- Tienen por ID ERR210098, ERR210519, ERR210592, ERR210091, ERR210263 y ERR210568. Todas ellas pertenecientes al proyecto PRJEB1220.
- Poseen alrededor de 2198481 pares de bases.
- Contienen cerca de 30 a 90 de longitud de reads .

Para el procesamiento de estas muestras, se dividieron en dos directorios [*\reads_par*](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/reads_par) y [*\reads_no_par*](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/reads_no_par), esto se logró con el script [*obtener_reads.sh*](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/scripts/obtener_reads.sh), que se muestra a continuación.
```{shell}
#Leemos el nombre de las  muestras.
cat id.txt | while read line
do
#Para cada muestra, se buscan las coincidencias dentro del directorio que contiene las 613 muestras.
#l numero de coincidencias de la muestra se guarda en la variable a
a=$(ls /files/camda2024/gut/scripts/ | grep ${line} |wc -l)
if [ $a -gt 1 ]
then #Si la muestra tiene mas de nua coincidencia, entonces es una muestra pareada y se crean links
#simbolicos para ambos archivos en la carpeta reads_par
ln -s /files/camda2024/gut/scripts/${line}_* ../reads_par/
else
#De lo contrario, si la muestra tiene una sola coincidencia, se crea el link simbolico a este archivo en reads_no_par
ln -s /files/camda2024/gut/scripts/${line}* ../reads_no_par/
fi
done
```
Algunas de las muestras pareadas contenían un tercer archivo *.fastq* que no se tomó en cuenta.


## Calidades. 
Para evaluar la calidad de las muestras, se usó [*fastqc*](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) con encoding   
Sanger / Illumina 1.9. Las calidades de cada muestra se almacenaron en calidades/nombre_ muestra.

Se usó el siguiente script para correr *fastqc* con todas las muestras y posteriormente generar un dos archivos *.txt*, el primero para almacenar las pruebas de calidad que alguna muestra no superó y el siguiente para medir la cantidad de secuencias cuya calidad era muy pobre.

```{shell}
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
```
Las muestras que no superaron alguna prueba se encuentran en el archivo [*failed_test.txt*](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/calidades/failed_test.txt) y le número de secuencias marcadas como de pobre calidad en [*p_qual.txt*](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/calidades/p_qual.txt).
Observamos que de las 1940 pruebas a las que se sometieron todas las muestras, solo 160 de ellas no fueron superadas de las cuales la mayoría de ellas fue *Per base sequence content*. Además, todas las muestras tuvieron un total de 0 secuencias marcadas como de pobre calidad.
A continuación mostramos algunas gráficas de la prueba *Per base sequence quality*.
De las muestras pareadas mostramos a SRR5946931_1.

![Image](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/imagenes/calidades/SRR5946931_1_calidades.png?raw=true)

De las muestras no pareadas elegimos a ERR210098 para observar su calidad.

![Image](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/imagenes/calidades/ERR210098_calidades.png?raw=true)

Como caso especial tenemos a SRR598348_2 cuyas calidades parecen haberse puesto manualmente.
![Image](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/imagenes/calidades/SRR5983481_2_calidades.png?raw=true)

## Trimming 
Para depurar las muestras se usó el programa [*trimmomatic*](http://www.usadellab.org/cms/?page=trimmomatic).  Se sigue la misma lógica que antes para ejecutar *trimmomatic*, separando a las muestras en los dos conjuntos, por lo que solo pondremos una parte del script [*trim.sh*](http://www.usadellab.org/cms/?page=trimmomatic). 

```{shell}
#Se corre trimmomatic para las muestras pareadas
#con 4 núcleos y con el archivo TrueSeq3-PE.fa que se encuentra en el directorio scripts
#la salida trim se deposita en trimming/nombre_muestra/trimmed,
#la untrimmed en /trimming/nombre_muestra/untrimmed
trimmomatic PE -threads 4 ../reads_par/nombre_muestra_1.fastq.gz ../reads_par/nombre_muestra_2.fastq.gz \
../trimming/nombre_muestra/trimmed/nombre_muestra_1.trim.fastq.gz ../trimming/nombre_muestra/untrimmed/nombre_muestra_1un.trim.fastq.gz \
../trimming/nombre_muestra/trimmed/nombre_muestra_2.trim.fastq.gz ../trimming/nombre_muestra/untrimmed/nombre_muestra_2un.trim.fastq.gz \
#Se guarda la información del proceso en summary
-summary ../trimming/nombre_muestra/summary.txt SLIDINGWINDOW:4:20 MINLEN:35 ILLUMINACLIP:TruSeq3-PE.fa:2:40:15
```

```{shell}
#Se corre trimmomatic como antes pero para reads no pareados
trimmomatic SE -threads 4 ../reads_no_par/nombre_muestra.fastq.gz \
../trimming/nombre_muestra/trimmed/nombre_muestra.trim.fastq.gz \
-summary ../trimming/nombre_muestra/summary.txt SLIDINGWINDOW:4:20 MINLEN:35 ILLUMINACLIP:TruSeq3-PE.fa:2:40:15
```
Al analizar los archivos *summary.txt* que se pueden encontrar en *trimming/nombre_muestra*, obtuvimos que en promedio las muestras pareadas conservan en promedio un 94.58% de reads después del proceso, mientras que las muestras no pareadas un promedio de 65.61%.

Como antes, la muestra SRR598348 fue algo especial y *trimmomatic* no realizó ningún proceso y por lo tanto se tomará a la misma como ya trimmeada.

## Calidades después del trimming
De manera similar a antes, se evaluaron las calidades pero ahora de las muestras ya trimmeadas. El script usado fue [*calidades_trim.sh*](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/scripts/calidades_trim.sh), que es muy parecido al anteriormente usado para obtener calidades, por lo que no detallaremos sus especificaciones.

Al igual que antes se obtuvieron los reportes [_failed_test.txt_](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/calidades_trim/failed_test.txt) y [_p_qual.txt_](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/calidades_trim/p_qual.txt). A diferencia de antes, solo 149 de las 1940 pruebas no fueron superadas. Pero, como antes, las muestras tuvieron cero secuencias marcadas como de pobre calidad.

Comparando con las gráficas anteriores, para SRR5946931_1 no hubo muchos cambios, pues como mencionamos antes en el trimming, se conservó cerca del 94% de reads.

![Image](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/imagenes/calidades_trim/SRR5946931_1_trim_calidades.png?raw=true)

Para ERR210098 sí hubo unas pequeñas diferencias que se pueden notar, mejorando un poco la calidad de los reads.

![Image](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/imagenes/calidades_trim/ERR210098_trim_calidades.png?raw=true)


## Ensamblaje
Para el ensamblaje de las muestras, se utilizó el programa [*megahit*](https://github.com/voutcn/megahit).  Se siguió la lógica de los scripts anteriores con la siguientes dos instrucciones. Para las muestras pareadas se pasan los pares con las flags -1 y -2, posteriormente las salidas se almacenan en assembly/nombre_muestra

```{shell}
megahit -1 ../trimming/nombre_muestra/trimmed/nombre_muestra_1.trim.fastq.gz -2 \
../trimming/nombre_muestra/trimmed/nombre_muestra_2.trim.fastq.gz -o \
../assembly/nombre_muestra.
```
Para las muestras no pareadas se usa la bandera -r y de igual manera, las salidas se almacenan en assembly/nombre_muestra
```{shell}
megahit -r ../trimming/nombre_muestra/trimmed/nombre_muestra.trim.fastq.gz \
-o ../assembly/nombre_muestra
```
Como las muestra SRR5983481 no generó archivos después del trimming, su ensamblaje fue hecho aparte del script.
## Binning
Para obtener los MAGs de cada muestra, se usó [*MaxBin*](https://sourceforge.net/projects/maxbin/). La orden genérica para las muestras pareadas fue la siguiente:
```{shell}
run_MaxBin.pl -thread 8 -contig ../assembly/nombre_muestra/final.contigs.fa \
-reads ../trimming/nombre_muestra/trimmed/nombre_muestra_1.trim.fastq.gz \
-reads2 ../trimming/nombre_muestra/trimmed/nombre_muestra_2.trim.fastq.gz \
-out ../mags/nombre_muestra/nombre_muestra
```
Para las no pareadas la orden es idéntica, solo se debe retirar el input de *-reads2*. El script que se usó se encuentra en [*\scripts\mags.sh*](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/scripts/mags.sh). El script no funcionó para la muestra SRR5983481, por lo que se manejó aparte esta muestra.

Los MAGs obtenidos se encuentran en el directorio *mags/*. Se elaboró un reporte [*summary.txt*](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/mags/summary.txt), en el que se encuentran las completitudes, longitudes y contenido GC de cada MAG obtenido. En total se obtuvieron 1211 MAGs, los cuales tienen en promedio un 65.06% de completitud del genoma, poseen genomas desde 105791 de longitud hasta 10379340 y en promedio tienen 45.80% de contenido GC.



## Asignación taxonómica
La asignación taxonómica se realizó con [*kraken2*](https://ccb.jhu.edu/software/kraken2/), tomando la base de datos almacenada en 
*/files/db_kraken2* del servidor betterlab. Para kraken, se usaron las muestras trimmeadas, las salidas *.kraken* se almacenaron en el directorio *taxonomy* y los reportes se encuentran en [*taxonomy/reports*](https://github.com/FFranciscoEspinosa/bioinformatica_2024/tree/main/taxonomy/reports). El script usado se encuentra en [*scripts/taxonomy.sh*](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/scripts/taxonomy.sh).

La instrucción usual para las muestras pareadas es:
```{shell}
kraken2 --db /files/db_kraken2 --threads 4 --paired ../trimming/nombre_muestra/trimmed/nombre_muestra_1.trim.fastq.gz ../trimming/nombre_muestra/trimmed/nombre_muestra_2.trim.fastq.gz \
--output ../taxonomy/nombre_muestra.kraken \
--report ../taxonomy/reports/nombre_muestra.report
```
Para las no pareadas se quita la flag --paired y se pasa el archivo *.trim.fastq.gz*.


Para las muestras no pareadas se usa la bandera -r y de igual manera, las salidas se almacenan en assembly/nombre_muestra
```{shell}
megahit -r ../trimming/nombre_muestra/trimmed/nombre_muestra.trim.fastq.gz \
-o ../assembly/nombre_muestra
```

