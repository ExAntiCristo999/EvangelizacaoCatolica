ArquivoPDF="$1"
if [ "$USER" = "tc" ]; then
	tce-load -ilw poppler23-bin busybox-static
	busybox="busybox-static"
elif [ -n "$TERMUX_VERSION" ]; then
	pkg install poppler
	busybox="busybox"
else
	echo "Plataforma desconhecida."
	exit 1
fi
pdftotext -layout "$1" "${1%.pdf}.txt"
if [ "$2" = "d" ]; then
	rm -f "$1"
fi
