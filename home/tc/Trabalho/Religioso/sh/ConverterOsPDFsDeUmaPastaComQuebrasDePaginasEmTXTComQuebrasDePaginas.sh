if [ "$USER" = "tc" ]; then
	tce-load -ilw poppler23-bin poppler-data
elif [ -n "$TERMUX_VERSION" ]; then
	pkg install poppler
else
	echo "Plataforma desconhecida."
	exit 1
fi
pdftotext "$1"
