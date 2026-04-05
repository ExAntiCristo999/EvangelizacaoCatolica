if [ -z "$1" ]; then
	echo "$0 \"Pasta onde estão os PDF a serem convertidos em TXT sem quebras de páginas.\""
	exit 1
fi
tce-load -iwl poppler23-bin
for f in *.pdf; do
	pdftotext -nopgbrk "$f" "${f%.pdf}.txt"
done
