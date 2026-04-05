ajuda(){
	echo "$0 \"String gerada pelo comando \"busybox xxd -ps | sed -r ':a;\$!N;s/\\n//;ta;'\".\""
	exit 1
}
if [ -z "$1" ]; then
	ajuda
fi
NumeroDeCaracteres="${#1}"
CaracteresMaiusculasENumeros=`echo "$1" | tr 'a-f' 'A-F'`
for OrdemNumerica in $( seq 1 $NumeroDeCaracteres ); do
	CaracterAtual=`echo "$CaracteresMaiusculasENumeros" | cut -c $OrdemNumerica`
	Resto="$(( $OrdemNumerica % 2 ))"
	if [ "$Resto" -eq "0" ]; then
		if [ "$OrdemNumerica" -eq "2" ]; then
			CaracterPar="$CaracterImpar$CaracterAtual"
			NumerosDecimais=`echo "ibase=16; $CaracterPar" | busybox-static bc`
		else
			CaracterPar=`echo "$CaracterImpar$CaracterAtual" | sed -r 's/(.*[0-9A-F][ ])([0-9A-F]{2})/\2/g'`
			NumeroDecimalParcial1=`echo "$CaracterImpar$CaracterAtual" | sed -r 's/(.*[0-9A-F][ ])([0-9A-F]{2})/\1/g'`
			NumeroDecimalParcial2=`echo "ibase=16; $CaracterPar" | busybox-static bc`
			NumerosDecimais="$NumeroDecimalParcial1$NumeroDecimalParcial2"
		fi
	else
		if [ "$OrdemNumerica" -eq "1" ]; then
			CaracterImpar="$CaracterAtual"
		else
			CaracterImpar="$NumerosDecimais $CaracterAtual"
		fi
	fi
done
echo "$NumerosDecimais"
