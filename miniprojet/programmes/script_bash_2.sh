

if [ $# -ne 1 ];
    then
        echo "Ce programme demande un argument";
        exit
fi


OCC=0
FICHIER_URLS=$1
TSV_FILE="tableau-fr.tsv"

while read -r line;
do
        OCC=$(expr $OCC + 1);
        CODE=$(curl -s -o /dev/null -w "%{http_code}" "$line");
        ENCODAGE=$(curl -sI $line | grep -i "content-type" | grep -o -E "charset=[^ ]+" | tr -d '\r\n' | cut -d= -f2);
         if [ -z "$ENCODAGE" ];
         then
                ENCODAGE="Vide"
        fi
        WC=$(curl -s $line | wc -w)
         if [ $WC = "0" ];
         then
                WC="Pas de"
        fi
        echo "$OCC    $line    $CODE    $ENCODAGE    ${WC} mots";
        echo -e "$OCC\t$line\t$CODE\t$ENCODAGE\t$WC" >> "$TSV_FILE"
done < $FICHIER_URLS;
