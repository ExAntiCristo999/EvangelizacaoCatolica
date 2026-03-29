#!/bin/sh

ajuda(){
	echo "$0 \"Arquivo com o texto, cuja codificação da acentuação será detectada.\" \"Texto como seria em UTF-8\""
	exit 48
}



principal(){
	if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
		ajuda
	else
		CodificacoesSuportadas=`iconv --list | sed 's/, /\n/g;s/\/\///g;/UTF8/d'`
		for CodificacaoASerTestada in $CodificacoesSuportadas ; do
			cat "$1" | iconv -f ${CodificacaoASerTestada} -t UTF8 2> /dev/null | grep "$2"
			if [ "$?" -eq "0" ]; then
				echo "Codificação do texto: $CodificacaoASerTestada"
				exit 0
			fi
		done
		echo "A codificação testada não é suportada pelo comando iconv."
		exit 3
	fi
}

principal "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
exit 0
