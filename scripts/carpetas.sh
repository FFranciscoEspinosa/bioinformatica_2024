##Este script recibe el nombre de un nuevo directorio y lo crea
mkdir ../"$1"
#Después, para cada muestra crea una directorio dentro del anteriormente creado.
cat id.txt | while read line
do
 mkdir ../"$1"/${line}
done
