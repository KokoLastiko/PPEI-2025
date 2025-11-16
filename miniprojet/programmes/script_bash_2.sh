

if [ $# -ne 2 ]; then
    echo "Ce programme demande deux arguments (le fichier contenant les URLs et le fichier HTML de sortie)"
    exit 1
fi

OCC=0
FICHIER_URLS=$1
HTML_FILE=$2

cat > "$HTML_FILE" << EOF
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" ref="https://cdn.jsdelivr.net/npm/bulma@1.0.4/css/bulma.min.css"< /> 
    <title>Résultats d’analyse des URLs</title>
    <style>
        body {font-family: Arial, sans-serif; margin: 15px; }
        table {border-collapse: collapse; width: 100%;}
        th, td { border : 1px solid #ddd; padding: 8px; text-align: left;}
        th {background-color: f8f8f8;}
        tr:nth-child(even) {background-color: #fafafa;}
    </style>
  </head>
  <body>
   <h1>Résultats d’analyse des URLs</h1>
    <table>
     <tr><th>#</th><th>URL</th><th>Code HTTP</th><th>Encodage</th><th>Nombre de mots</th></tr>
EOF

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

    cat >> "$HTML_FILE" << EOF
<tr>
    <td>$OCC</td>
    <td><a href="$line">$line</a></td>
    <td>$CODE</td>
    <td>$ENCODAGE</td>
    <td>$WC</td>
</tr>
EOF
done < "$FICHIER_URLS"

cat >> "$HTML_FILE" << EOF
  </table>
 </body>
</html>
EOF

