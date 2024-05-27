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

