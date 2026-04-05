#!/bin/sh

ajuda(){
	echo "$0 \"Caminho completo até o pacote TCZ.\""
	exit 48
}

principal(){
	if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
		ajuda
	else
		PacoteTCZ=`echo "$1" | grep ".tcz" | rev | cut -d "/" -f 1 | rev`
		if [ -z "$PacoteTCZ" ]; then
			ajuda
		fi
		tce-load -il $PacoteTCZ
		l3=`ArvoreDeDependencias.sh "$1"`
		echo "$l3" | sed 's/.tcz//g' | sed 's/^/du -sb \/tmp\/tcloop\//' | sh | sed 's/\t/ /g' | cut -d " " -f 1 | sed ':a;$!N;s/\n/ + /;ta;' | sed 's/^/expr /' | sh
	fi
}

principal "$1"
