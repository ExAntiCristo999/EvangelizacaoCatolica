#!/bin/sh

ajuda(){
	echo "$0 \"String ou nome do arquivo\" \"'-v' para string, '-f' para arquivo\""
	exit 1
}

RetirarAcentuacaoDasLetras(){
	sed 's/á/a/g;s/é/e/g;s/í/i/g;s/ó/o/g;s/ú/u/g;s/Á/A/g;s/É/E/g;s/Í/I/g;s/Ó/O/g;s/Ú/U/g;s/â/a/g;s/ê/e/g;s/ô/o/g;s/Â/A/g;s/Ê/E/g;s/Ô/O/g;s/ã/a/g;s/õ/o/g;s/Ã/A/g;s/Õ/O/g;s/ç/c/g;s/Ç/C/g;s/à/a/g;s/À/A/g;s/ü/u/g;s/Ü/U/g;s/Ö/O/g;s/ö/o/g' "$1"
	exit 12
}

principal(){
	if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ] || [ -z "$2" ] || ([ "$2" != "-v" ] && [ "$2" != "-f" ]); then
		ajuda
	else
		if [ "$2" = "-v" ]; then
			echo "${1}" | sed 's/á/a/g;s/é/e/g;s/í/i/g;s/ó/o/g;s/ú/u/g;s/Á/A/g;s/É/E/g;s/Í/I/g;s/Ó/O/g;s/Ú/U/g;s/â/a/g;s/ê/e/g;s/ô/o/g;s/Â/A/g;s/Ê/E/g;s/Ô/O/g;s/a/a/g;s/o/o/g;s/Ã/A/g;s/Õ/O/g;s/ç/c/g;s/Ç/C/g;s/à/a/g;s/À/A/g;s/ü/u/g;s/Ü/U/g;s/Ö/O/g;s/ö/o/g'
			exit 13
		else
			RetirarAcentuacaoDasLetras "$1"
		fi
	fi
}

principal "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
exit 0
