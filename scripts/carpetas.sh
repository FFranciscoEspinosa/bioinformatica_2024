mkdir ../"$1"
cat id.txt | while read line
do
 mkdir ../"$1"/${line}
done
