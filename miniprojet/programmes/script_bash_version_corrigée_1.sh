

if [ $# -ne 2 ]; then
    echo "Ce programme demande deux arguments (le fichier contenant les URLs et le fichier TSV de sortie)"
    exit 1
fi

OCC=0
FICHIER_URLS=$1
TSV_FILE=$2


while read -r line; do
    if [ -z "$line" ];
    then
        continue
    fi
    OCC=$((OCC + 1))
    CODE=$(curl -s -o "tmp.txt" -w "%{http_code}" "$line")
    ENCODAGE=$(curl -sI "$line" | grep -i "content-type" | grep -o -E "charset=[^ ]+" | tr -d '\r\n' | cut -d= -f2)
    if [ -z "$ENCODAGE" ];
    then
        ENCODAGE="Erreur";
    fi
    WC=$(cat "tmp.txt" | lynx -dump -stdin -nolist | wc -w)

    echo -e "$OCC\t$line\t$CODE\t$ENCODAGE\t${WC}"
    echo -e "$OCC\t$line\t$CODE\t$ENCODAGE\t${WC}" >> $TSV_FILE
done < "$FICHIER_URLS"
