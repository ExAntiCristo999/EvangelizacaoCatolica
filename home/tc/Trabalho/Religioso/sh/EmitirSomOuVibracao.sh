FuncaoAjudaDoProgramaEmitirSomOuVibracao(){
	AjudaDoPrograma.sh "$0 \"Número de beeps\" \"Segundos entre os beeps\" \"Mensagem a ser mostrada na tela.\""
	exit $?
}

FuncaoPrincipalDoProgramaEmitirSomOuVibracao(){
	if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
		FuncaoAjudaDoProgramaEmitirSomOuVibracao
	else
		CaminhoCompletoAoProgramaSemOSufixoPontoSh="${0%.sh}"
		NomeDestePrograma="${CaminhoCompletoAoProgramaSemOSufixoPontoSh##*/}"
		NumeroDeBeeps=`echo "$1" | grep -E "^[0-9]{1,3}$"`
		SegundosEntreBeeps=`echo "$2" | grep -E "^[0-9]{1,3}$"`
		until [ -n "$PastaPadraoDosProgramasQueCrio" ]; do
			PastaPadraoDosProgramasQueCrio=`PastaPadraoDosProgramasQueCrio.sh 2>&1 | grep "/"`
			sleep 1
		done
		ArquiteturaDoProcessador=`uname -m`
		if [ -z "${PastaPadraoDosProgramasQueCrio%/home*}" ]; then
			sudo modprobe pcspkr
		fi
		Prefixo="${PastaPadraoDosProgramasQueCrio%/home*}/${ArquiteturaDoProcessador}/tmp/${NomeDestePrograma}"
		if [ ! -d "$Prefixo" ]; then
			mkdir -p "$Prefixo"
		fi
		for OrdemNumerica in $( seq 1 "$NumeroDeBeeps" ); do
			echo "$3"
			if [ ! -s "${Prefixo}/NaoQueroSonsDoSpeaker.spk" ]; then
				echo -ne '\007'
			fi
			sleep $SegundosEntreBeeps
		done
		if [ -z "${PastaPadraoDosProgramasQueCrio%/home*}" ]; then
			sudo modprobe -r pcspkr
		fi
	fi
}

FuncaoPrincipalDoProgramaEmitirSomOuVibracao "$1" "$2" "$3"
exit 0
