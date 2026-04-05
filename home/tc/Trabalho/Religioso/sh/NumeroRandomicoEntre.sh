

FuncaoPrincipalDoProgramaNumeroRandomicoEntre(){
	if [ "$USER" = "tc" ]; then
		busybox="busybox-static"
	elif [ -n "$TERMUX_VERSION" ]; then
		busybox="busybox"
	else
		echo "Plataforma desconhecida"
		exit 1
	fi
	if [ "$ArquiteturaDoProcessadorDesteComputador" = "x86_64" ] || [ "$ArquiteturaDoProcessadorDesteComputador" = "aarch64" ]; then
		NumeroMaximo="100000000"
		Randomico=`eval $busybox shuf -i 1-100000000 -n 1`
	else
		NumeroMaximo="65536"
		Randomico=`eval $busybox shuf -i 1-65536 -n 1`
	fi
	NumeroAleatorio=`echo "$Randomico ^ 8" | eval $busybox bc`
	NumeroEscolhido=`echo "$1 * 100 + ( 100 * $NumeroAleatorio / ( $NumeroMaximo ^ 8 ) ) * ( $2 - $1 ) + 99 * ( $NumeroAleatorio / ( $NumeroMaximo ^ 8 ) )" | eval $busybox bc`
	ResultadoReverso=`echo "$NumeroEscolhido" | rev`
	ResultadoReversoSemAsCasasDecimais=`echo "$ResultadoReverso" | cut -c 3-`
	Resultado=`echo "${ResultadoReversoSemAsCasasDecimais%-}" | rev`
	if [ -z "$3" ]; then
		if [ -n "$Resultado" ]; then
			echo "$Resultado"
		else
			echo "0"
		fi
	else
		if [ -n "$Resultado" ]; then
			AdicionarZerosAEsquerdaDoNumero.sh "$Resultado" "${#2}"
		else
			AdicionarZerosAEsquerdaDoNumero.sh "0" "${#2}"
		fi
	fi
}

FuncaoPrincipalDoProgramaNumeroRandomicoEntre "$1" "$2" "$3"
