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


## Evaluación de calidades. 
Para evaluar la calidad de las muestras, se usó [*trimmomatic*](http://www.usadellab.org/cms/?page=trimmomatic). Se usó el siguiente script para aplicar el programa para las muestras con reads pareadas y no pareadas:

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


<img title="a title" alt="Alt text" src="/images/boo.svg">

