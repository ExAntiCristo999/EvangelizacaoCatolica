ajuda(){
	if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
		echo "$0 \"IP do computador contendo arquivos pessoais.\" \"Arquitetura do computador, obtido via uname -m deste.\" \"'t' para todos; 'r' para religioso.\""
		exit 1
	fi
}
ajuda "$1" "$2" "$3"

if [ -n "$TERMUX_VERSION" ]; then
	pkg install busybox
	busybox="busybox"
elif [ "$USER" = "tc" ]; then
	tce-load -il busybox-static
	busybox="busybox-static"
else
	echo "Plataforma desconhecida."
	exit 2
fi
Descompactar(){
        if [ -n "$TERMUX_VERSION" ]; then
		busybox tar -C $HOME -xf a.tbz --overwrite
	elif [ "$USER" = "tc" ]; then
		/bin/tar -C / -xf a.tbz --overwrite
	fi
}

NomeDoProgramaPontoSh="${0##*/}"
NomeDoPrograma="${NomeDoProgramaPontoSh%.sh}"
SegundosUTC=`date +%s`
Pasta="$PastaComArquivosTemporariosDosProgramasQueCrio/$NomeDoPrograma/$SegundosUTC"
if [ ! -d "$Pasta" ]; then
        mkdir -p "$Pasta"
fi
if [ "$3" = "t" ]; then
	Pasta2="CopiarArquivosDoComputadorComTermux"
	CabecalhoDeRequisicao="GET /$2/tmp/$Pasta2/ HTTP/1.1"
	CabecalhoDeRequisicao="$CabecalhoDeRequisicao\r\nHost: $1:8080"
	CabecalhoDeRequisicao="$CabecalhoDeRequisicao\r\n"
	PastaContendoAUltimaCopiaDeSeguranca=`echo -ne "$CabecalhoDeRequisicao" | busybox nc -w 5 $1 8080 | sed -r '/>[0-9]{1,29}[/]</!d;s/(.*["])([0-9]{1,29})([/].*)/\2/g' | sort | tail -1`
	if [ -n "$PastaContendoAUltimaCopiaDeSeguranca" ]; then
		CabecalhoDeRequisicao="GET /$2/tmp/$Pasta2/$PastaContendoAUltimaCopiaDeSeguranca/a.tbz HTTP/1.1"
		CabecalhoDeRequisicao="$CabecalhoDeRequisicao\r\nHost: $1:8080"
		CabecalhoDeRequisicao="$CabecalhoDeRequisicao\r\n"
		cd "$Pasta"
		echo -ne "$CabecalhoDeRequisicao" | nc -w 150 $1 8080 > a.hex && sed '1,/^\r$/d' a.hex > a.tbz
		Descompactar
	fi
else
	CabecalhoDeRequisicao="GET /etc/sysconfig/tcedir/mydata.tgz HTTP/1.1"
	CabecalhoDeRequisicao="$CabecalhoDeRequisicao\r\nHost: $1:8080"
	CabecalhoDeRequisicao="$CabecalhoDeRequisicao\r\n"
	cd "$Pasta"
	echo -ne "$CabecalhoDeRequisicao" | nc -w 150 $1 8080 > a.hex && sed '1,/^\r$/d' a.hex > a.tbz
	Descompactar
fi
