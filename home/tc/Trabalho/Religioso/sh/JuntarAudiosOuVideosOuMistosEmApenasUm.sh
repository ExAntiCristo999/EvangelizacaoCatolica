#!/bin/sh

ajuda(){
	echo "$0 \"Caminho absoluto até a Multimídia de destino.\" \"Multimímia 1\" ... \"Multimídia 9\""
	exit 48
}



principal(){
	if [ -z "$1" ] || [ -z "$2" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
		ajuda
	else
		ArquiteturaDoProcessador=`uname -m`
		PastaTemporaria="${ArquiteturaDoProcessador}/tmp/JuntarMultimidiasEmUmApenas"
		if [ ! -d "$PastaTemporaria" ]; then
			mkdir -p "$PastaTemporaria"
		fi
		CaminhoAbsoluto=`echo "$1" | grep "/"`
		if [ -z "$CaminhoAbsoluto" ]; then
			ajuda
		fi
		echo -e "file ${2}\nfile ${3}\nfile ${4}\nfile ${5}\nfile ${5}\nfile ${6}\nfile ${7}\nfile ${7}\nfile ${8}\nfile ${9}\nfile ${10}" | sed -r '/^file $/d' > "${PastaTemporaria}/${1##*/}.txt"
		InstalarProgramasNoCoreLinux.sh ffmpeg4
		cd "${PastaTemporaria}"
		ffmpeg -f concat -safe 0 -i "${1##*/}.txt"  -c copy "$1"
		rm -f *.txt
	fi
}

principal "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "${10}"
exit 0
