# Bioinformática 2024

En este repositorio se encuentra el procesamiento básico de la clase de bioinformática 2024.  Únicamente se trabajarán con 100 muestras, de las cuáles su id se encuentra en [*\scripts\ids.txt*](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/scripts/id.txt).

## Muestras
Estas 100 muestras son un subconjunto de las 613 muestras dadas por el reto gut de CAMDA 2024. Los metadatos proporcionados por CAMDA se encuentran en el archivo [*metadatos.csv*](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/metadatos.csv) .De estas 100 muestras, 94 de ellas eran muestras pareadas y las 6 restantes no lo eran.
Las 94 muestras:
- Fueron realizadas por los proyectos HMP2, PRJEB1220 y PRJNA389280. 
- Poseen alrededor de 14000000 pares de bases.
- Tienen cerca de 50 a 101 de longitud de reads .

Las 6 muestras restantes:
- Tienen por ID ERR210098, ERR210519, ERR210592, ERR210091, ERR210263 y ERR210568. Todas ellas pertenecientes al proyecto PRJEB1220.
- Poseen alrededor de 152000 pares de bases.
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

Como caso especial tenemos a SRR598348 cuyas calidades parecen haberse puesto manualmente.
![Image](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/imagenes/calidades/SRR5983481_2_calidades.png?raw=true)

## Trimming 
Para depurar las muestras se usó el programa [*trimmomatic*](http://www.usadellab.org/cms/?page=trimmomatic).  Se sigue la misma lógica de ejecutar *trimmomatic* separando a las muestras en los dos conjuntos, por lo que solo pondremos una parte del script [*trim.sh*](http://www.usadellab.org/cms/?page=trimmomatic)
