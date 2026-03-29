if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
	echo "$0 \"Arquivo TXT.\" \"Arquivo PNG.\" \"Resolução da foto.\" \"Tamanho da fonte TTF usada.\""
	exit 1
fi
if [ "$USER" = "tc" ]; then
	tce-load -iwl imagemagick
	Fonte="/home/tc/.fonts/arialbd.ttf"
elif [ -n "$TERMUX_VERSION" ]; then
	pkg install imagemagick
	Fonte="$HOME/home/tc/.fonts/arialbd.ttf"
else
	echo "Plataforma desconhecida."
	exit 2
fi
convert -size $3 -background white -fill black -font "$Fonte" -pointsize $4 label:@"$1" "$2"
