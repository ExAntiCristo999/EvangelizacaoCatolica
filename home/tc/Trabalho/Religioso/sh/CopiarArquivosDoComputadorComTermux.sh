ajuda(){
	if [ -z "$1" ]; then
		echo "$0 \"Opçoes de multipla escolha: 't' para todos; 'r' de religioso.\""
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
cd $HOME
pkg install busybox
if [ "$1" = "t" ]; then
	busybox tar -C $HOME -T opt/.filetool.lst -X opt/.xfiletool.lst -cjf "$PastaTemporaria/a.tbz" 
else
	busybox tar -C $HOME -T opt/.religioso.lst -cjf "$PastaTemporaria/a.tbz"
fi
