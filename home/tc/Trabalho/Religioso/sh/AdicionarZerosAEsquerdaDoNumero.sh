

ajuda(){
	echo "$0 \"Número inteiro ao qual será adicionado os zeros à esquerda dele\" \"Número de dígitos final\""
	exit 1
}

ValidacaoDoNumeroDoPrimeiroParametro=`echo "$1" | grep -E "^[0-9]{1,100}$"`
ValidacaoDoNumeroDoSegundoParametro=`echo "$2" | grep -E "^[0-9]{1,100}$"`
if [ -z "$ValidacaoDoNumeroDoPrimeiroParametro" ] || [ -z "$ValidacaoDoNumeroDoSegundoParametro" ]; then
	ajuda
fi
NumeroAtual="${1}"
NumeroFinal="${2}"
NumeroDeDigitosDoNumeroFinal=`echo "${NumeroFinal}"`
NumeroDeDigitosDoNumeroAtual=`echo "${#NumeroAtual}"`
NumeroDeZerosAEsquerda=`expr ${NumeroDeDigitosDoNumeroFinal} - ${NumeroDeDigitosDoNumeroAtual}`
if [ "$NumeroDeZerosAEsquerda" -gt "0" ]; then
	Zeros=""
	for OrdemDoDigito in $( seq 1 "$NumeroDeZerosAEsquerda" ); do
		Zeros=`echo "${Zeros}0"`
	done
	echo "${Zeros}${NumeroAtual}"
else
	echo "$NumeroAtual"
fi
