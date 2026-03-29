ajuda(){
	if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
		echo "$0 \"Identificação do pendrive.\" \"Opções de multipla escolha: 't' para todos; 'r' de religioso.\" \"Arquitetura do Core Linux no pendrive.\""
		exit 1
	fi
}
ajuda "$1" "$2" "$3"
NomeDoProgramaPontoSh="${0##*/}"
NomeDoPrograma="${NomeDoProgramaPontoSh%.sh}"
SegundosUTC=`date +%s`
filetool.sh -b
PastaTemporaria="$PastaComArquivosTemporariosDosProgramasQueCrio/$NomeDoPrograma/$SegundosUTC"
if [ ! -d "$PastaTemporaria" ]; then
	mkdir -p "$PastaTemporaria"
fi
Pasta="/mnt/$1/ParaUso/$3/tce"
if [ ! -d "$Pasta" ]; then
        mkdir -p "$Pasta"
fi
if [ "$2" = "t" ]; then
	filetool.sh -b
	/bin/tar -C / -T /opt/.filetool.lst -X "$PastaTemporaria/.xfiletool.lst" -czf "$Pasta/mydata.tgz" --overwrite
else
	filetool.sh -b
	/bin/tar -C / -T /opt/.religioso.lst -czf "$Pasta/mydata.tgz" --overwrite
fi
