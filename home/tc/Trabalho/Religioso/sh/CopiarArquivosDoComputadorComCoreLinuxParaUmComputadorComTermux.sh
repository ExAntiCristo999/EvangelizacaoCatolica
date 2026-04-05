ajuda(){
	if [ -z "$1" ]; then
		echo "$0 \"Opçoes de multipla escolha: 't' para tudo, e 'r' para religioso.\""
		exit 1
	fi
}
NomeDoProgramaPontoSh="${0##*/}"
NomeDoPrograma="${NomeDoProgramaPontoSh%.sh}"
SegundosAtual=`date +%s`
PastaTemporaria="$PastaComArquivosTemporariosDosProgramasQueCrio/$NomeDoPrograma/$SegundosAtual"
if [ ! -d "$PastaTemporaria" ]; then
        mkdir -p "$PastaTemporaria"
fi
if [ "$1" = "t" ]; then
	filetool.sh -b
else
	filetool.sh -b
	tar -C / -T /opt/.religioso.lst -cjf "$PastaTemporaria/a.tbz"
else
	ajuda "$1"
fi
