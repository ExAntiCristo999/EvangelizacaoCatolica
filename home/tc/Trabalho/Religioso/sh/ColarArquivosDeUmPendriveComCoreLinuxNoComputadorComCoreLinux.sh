ajuda(){
	if [ -z "$1" ] || [ -z "$2" ]; then
		echo "$0 \"Identificação do pendrive.\" \"Arquitetura do Core Linux instalado no pendrive.\""
		exit 1
	fi
}
if [ -n "$1" ] && [ -n "$2" ]; then
	Pasta="/mnt/$1/ParaUso/$2/tce"
	if [ -d "$Pasta" ]; then
		NomeDoProgramaPontoSh="${0##*/}"
		NomeDoPrograma="${NomeDoProgramaPontoSh%.sh}"
		SegundosUTCAtual=`date +%s`
		PastaBase="$PastaComArquivosTemporariosDosProgramasQueCrio/$NomeDoPrograma/$SegundosUTCAtual"
		if [ ! -d "$PastaBase" ]; then
			mkdir -p "$PastaBase"
		fi
		cd "$PastaBase"
		cp $Pasta/mydata.tgz .
		/bin/tar -C / -xf mydata.tgz --overwrite
	fi
else
	ajuda "$1" "$2"
fi
