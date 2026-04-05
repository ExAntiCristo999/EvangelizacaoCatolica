#!/bin/sh

ajuda(){
	echo "echo \"$0\" \"Dígito numérico da Latitude, acrescido de dois digitos dos Minutos, concluindo com os dois dígitos dos Segundos.\" \"Dígito numérico da Longitude, acrescido de dois digitos dos Minutos, concluindo com os dois dígitos dos Segundos.\" \"Ponto ou vírgula, para separar os dígitos inteiros dos decimais, tanto da Latitude quanto na Longitude.\" \"Número de dígitos decimais da latitude e da longitude, não devendo exceder à 500 dígitos.\""
	exit 48
}

NumeroDeDigitosDecimais(){
	UmSeguidoDeUmDeterminadoNumeroDeZeros="1"
	NumeroDeDigitosDecimaisMaisUm=`expr $1 + 1`
	for OrdemNumerica in $( seq 1 $NumeroDeDigitosDecimaisMaisUm ); do
		UmSeguidoDeUmDeterminadoNumeroDeZeros=`echo "${UmSeguidoDeUmDeterminadoNumeroDeZeros}0"`
	done
}

FuncaoParaConverterLatitudeOuLongitude(){
	LatitudeOuLongitude=`echo "$1" | rev | cut -c 5- | rev`
	MinutosDeLatitude=`echo "$1" | rev | cut -c 3-4 | rev`
	SegundosDeLatitude=`echo "$1" | rev | cut -c 1-2 | rev`
	NumeroDeDigitosDecimais ${3}
	DigitosDecimaisDaLatitudeOuLongitudeSemZerosAEsquerda=`expr \( ${UmSeguidoDeUmDeterminadoNumeroDeZeros} \* ${MinutosDeLatitude} \/ 60 \) + \( ${UmSeguidoDeUmDeterminadoNumeroDeZeros} \* ${SegundosDeLatitude} \/ 3600 \)`
	DigitosDecimaisDaLatitudeOuLongitudeSemZerosAEsquerdaMenosOUltimoDigitoNoFinal=`echo "${DigitosDecimaisDaLatitudeOuLongitudeSemZerosAEsquerda}" | rev | cut -c 2- | rev`
	DigitosDecimaisDaLatitudeComZerosAEsquerda=`AdicionarZerosAEsquerdaDoNumero.sh ${DigitosDecimaisDaLatitudeOuLongitudeSemZerosAEsquerdaMenosOUltimoDigitoNoFinal} ${3}`
	ResultadoFinal=`echo "${ResultadoFinal};${LatitudeOuLongitude}${PontoOuVirgula}${DigitosDecimaisDaLatitudeComZerosAEsquerda}" | sed 's/^;//g'`
}


FuncaoValidacaoDeLatitudeOuLongitude(){
	ValidacaoDaLatitudeOuLongitude=`echo "$1" | grep -E "^([-]|)([0-9]|[1-9][0-9]|1[0-7][0-9]|180)([0-5][0-9]){2}$"`
	if [ -z "$ValidacaoDaLatitudeOuLongitude" ]; then
		ajuda
	fi
}

principal(){
	if [ -z "$1" ] || [ -z "$2" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
		ajuda
	else
		FuncaoValidacaoDeLatitudeOuLongitude "$1"
		FuncaoValidacaoDeLatitudeOuLongitude "$2"
		PontoOuVirgula=`echo "$3" | grep -E "^[\.,]$"`
		if [ -z "$PontoOuVirgula" ]; then
			ajuda
		fi
		ValidacaoDoNumeroDeDigitos=`echo "$4" | grep -E "^([0-9]|[1-9][0-9]|[1-4][0-9]{2}|500)$"`
		ResultadoFinal=""
		FuncaoParaConverterLatitudeOuLongitude $1 $3 $4
		FuncaoParaConverterLatitudeOuLongitude $2 $3 $4
		echo "$ResultadoFinal"
	fi
}

principal "$1" "$2" "$3" "$4"
exit 0
