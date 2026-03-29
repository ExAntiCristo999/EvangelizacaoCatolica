#!/bin/sh

ajuda(){
	echo "$0 \"Caminho completo até o pacote TCZ.\""
	exit 48
}



principal(){
	if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
		ajuda
	else
		Validacao=`echo "$1" | grep ".tcz$"`
		if [ -z "$Validacao" ]; then
			ajuda
		fi
		PacoteOriginal=`echo "$1" | rev | cut -d "/" -f 1 | rev`
		Pasta=`echo "$1" | rev | cut -d "/" -f 2- | rev`
		cd "$Pasta"
		d="1"
		PacoteTCZParcial1="$PacoteOriginal"
		PacoteTCZ=""
		until [ -z "$PacoteTCZParcial1" ]; do
			for l in $PacoteTCZParcial1 ; do
				PacoteTCZParcial=`/bin/grep -r "$l" *.dep | cut -d ":" -f 1 | sed 's/.dep//g' | sort | uniq`
				PacoteTCZ=`echo -e "${PacoteTCZ}\n${l}\n${PacoteTCZParcial}" | grep -v "^$" | sort | uniq`
				PacoteTCZParcial1=`echo -e "${PacoteTCZParcial1}\n${PacoteTCZParcial}" | grep -v "$l"`
			done			
		done
		echo "$PacoteTCZ" | grep -v "$PacoteOriginal"
	fi
}

principal "$1"
exit 0
