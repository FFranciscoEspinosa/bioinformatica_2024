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

