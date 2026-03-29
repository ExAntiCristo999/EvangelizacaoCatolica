if [ ! -e "$1" ]; then
	echo "$0 \"Caminho até o arquivo TXT.\""
	exit 1
fi

arquivo="$1"  # Substitua pelo nome do seu arquivo

# Tentativa com grep
contagem=$(grep -c $'\f' "$arquivo")
#
# # Verificaçao se grep funcionou
if [ "$contagem" -eq 0 ]; then
 	contagem=$(wc -l \u003c "$arquivo")
fi
paginas=$((contagem + 1))
echo "$paginas"
