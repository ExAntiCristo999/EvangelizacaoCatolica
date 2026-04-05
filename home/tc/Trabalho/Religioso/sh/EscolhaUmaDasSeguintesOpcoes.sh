ajuda(){
	echo "$0 \"'v' de variável, ou 'a' de arquivo.\" \"Variável de outro programa, ou arquivo, contendo as opções, separadas por quebras de linha LF.\" \"Pergunta a ser realizada para a escolha de uma das opções.\" \"'n' para incluir a opção 'Nenhuma das opções anteriores; ou vazio, para escolher somente uma opção, repassadas ao parâmetro 1 deste programa.'\" \"NomeDoProgramaQueChamouEste\""
	exit 1
}

PrincipalDoProgramaEscolhaUmaDasSeguintesOpcoes(){
	if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$5" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
		ajuda
	else
		if [ "$USER" = "tc" ]; then
			busybox="busybox-static"
		elif [ -n "$TERMUX_VERSION" ]; then
			pkg install busybox
			clear
			busybox="busybox"
		else
			echo "Plataforma desconhecida."
			exit 1
		fi
		EncerramentoDaPergunta="Tecle 'q' e depois tecle o código numérico de uma das seguintes opçoes:"
		if [ "$1" = "v" ]; then
			NumeroDeOpcoesEncontradas=`echo -e "$2" | wc -l`
			Opcoes="$2"
		else
			NumeroDeOpcoesEncontradas=`wc -l "$2" | cut -d " " -f 1`
			Opcoes=`cat "$2"`
		fi
		NumeroDaOpcaoEscolhida=""
		until [ -n "$NumeroDaOpcaoEscolhida" ]; do
			if [ "$4" = "n" ]; then
				NumeroDeOpcoesTotal="$(( $NumeroDeOpcoesEncontradas + 1 ))"
				OpcoesASeremEscolhidas=`echo -e "$Opcoes\nNenhuma das anteriores." | eval $busybox nl -b a`
				echo -e "\n$3\n$OpcoesASeremEscolhidas\n\n$EncerramentoDaPergunta" | less
				read NumeroDaOpcaoEscolhida
			elif [ -z "$4" ]; then
				NumeroDeOpcoesTotal="$NumeroDeOpcoesEncontradas"
				OpcoesASeremEscolhidas=`echo -e "$Opcoes" | eval $busybox nl -b a`
				echo -e "\n$3\n$OpcoesASeremEscolhidas\n\n$EncerramentoDaPergunta" | less
				read NumeroDaOpcaoEscolhida
			else
				ajuda
			fi
			NumeroDaOpcaoEscolhida=`echo "$NumeroDaOpcaoEscolhida" | grep -E "^[0-9]{1,5}$"`
			if [ -n "$NumeroDaOpcaoEscolhida" ]; then
				if [ "$NumeroDaOpcaoEscolhida" -le "$NumeroDeOpcoesTotal" ]; then
					ArquivoDeDestino=""
					SegundosAtual=`date +%s`
					PastaDeDestino="$PastaComArquivosTemporariosDosProgramasQueCrio/$NomeDoPrograma/$5"
					if [ ! -d "$PastaDeDestino" ]; then
						sudo mkdir -p "$PastaDeDestino"
						sudo chmod -R 777 "$PastaDeDestino"
					fi
					echo "$Opcoes" | sed -n ${NumeroDaOpcaoEscolhida}p | sed 's/^/OpcaoEscolhida=/' > "$PastaDeDestino/$SegundosAtual"
				else
					echo "O número da opçao escolhida está fora do intervalo. Tente novamente."
				fi
			else
				echo "Você teclou letras, que nao sao aceitas. Tente novamente."
			fi
		done
	fi
}

NomeDoProgramaPontoSh="${0##*/}"
NomeDoPrograma="${NomeDoProgramaPontoSh%.sh}"
PrincipalDoProgramaEscolhaUmaDasSeguintesOpcoes "$1" "$2" "$3" "$4" "$5"
