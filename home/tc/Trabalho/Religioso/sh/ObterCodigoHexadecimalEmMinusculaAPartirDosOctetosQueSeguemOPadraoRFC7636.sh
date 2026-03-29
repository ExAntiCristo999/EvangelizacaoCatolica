ajuda(){
	echo "$0 \"Numeros decimais de 0 à 255, separados por um espaço entre eles. Ex: '1 234 21 55'\""
	exit 1
}
if [ -z "$1" ]; then
	ajuda
fi
MesmoValorDoParametro1ExcetoQueOsEspacosForamSubstituidosPorQuebrasDeLinhaLF=`echo "$1" | sed 's/ /\n/g'`
for Octeto in $MesmoValorDoParametro1ExcetoQueOsEspacosForamSubstituidosPorQuebrasDeLinhaLF; do
	if [ "$Octeto" -lt "0" ] || [ "$Octeto" -gt "255" ]; then
		ajuda
	fi
	Hexadecimal=`echo "obase=16; $Octeto" | busybox-static bc | tr 'A-F' 'a-f'`
	NumeroDeCaracteresHexadecimais="${#Hexadecimal}"
	if [ "$NumeroDeCaracteresHexadecimais" -lt "2" ]; then
		Hexadecimal="0${Hexadecimal}"
	fi
	NumerosHexadecimais="$NumerosHexadecimais$Hexadecimal"
done
echo "$NumerosHexadecimais"
