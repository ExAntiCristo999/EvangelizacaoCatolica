if [ ! -e "$1" ]; then
	echo "$0 \"Caminho completo até o arquivo.\""
	exit 1
fi

vim "+ normal G $" "$1"
