if [ -z "$1" ]; then
	echo "$0 \"Arquivo PDF original.\""
	exit 1
fi

tce-load -iwl pdftk
pdftk "$1" burst output pagina_%04d.pdf
