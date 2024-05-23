# Bioinformática 2024

En este repositorio se encuentra el procesamiento básico de la clase de bioinformática 2024.  Únicamente se trabajarán con 100 muestras, de las cuáles su id se encuentra en [*\scripts\ids.txt*](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/scripts/id.txt).

## Muestras
De estas 100 muestras, 96 de ellas eran muestras pareadas y las 4 restantes eran únicas. Además , algunas de las muestras pareadas contenían un tercer archivo *.fastq* que no se tomó en cuenta.  Debido a lo anterior se separaron las muestras en dos directorios [*\reads_par*](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/reads_par) y [*\reads_no_par*](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/reads_no_par), esto se logró con el script [*obtener_reads.sh*](https://github.com/FFranciscoEspinosa/bioinformatica_2024/blob/main/scripts/obtener_reads.sh), que se muestra a continuación.
```{shell}
cat id.txt | while read line
do
a=$(ls /files/camda2024/gut/scripts/ | grep ${line} |wc -l)
if [ $a -gt 1 ]
then
ln -s /files/camda2024/gut/scripts/${line}_* ../reads_par/
else
ln -s /files/camda2024/gut/scripts/${line}* ../reads_no_par/
fi
done
```
