#!/bin/sh

ajuda(){
	echo "$0 \"Caminho até o PDF de destino.\" \"PDF1\" ... \"PDF 9\""
	exit 1
}
if [ -z "$1" ] || [ -z "$2" ]; then
	ajuda
fi
InstalarProgramasNoCoreLinux.sh ghostscript
gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=${1} $2 $3 $4 $5 $6 $7 $8 $9 ${10}
