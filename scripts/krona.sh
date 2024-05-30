#Leemos el nombre de las  muestras.
cat id.txt | while read line
do
#Para cada muestra, se seleccionan las columnas 2 y 3 del archivo .kraken y se depositan en krona/inputs
cut -f2,3 ../taxonomy/${line}.kraken > ../krona/inputs/${line}.krona.input
#Se ejecuta krona y se depositan las salidas en /krona
ktImportTaxonomy ../krona/inputs/${line}.krona.input -o ../krona/${line}.krona.out.html
done
