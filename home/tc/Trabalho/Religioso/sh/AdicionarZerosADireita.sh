#!/bin/sh

ajuda(){
	echo "$0 \"Número a ser adicionado(s) zero(s) à direita, com ponto ou vírgula separando o número inteiro dos decimais, não devendo ser maior do que 9999999999,9999999999 ou menor do que -9999999999,9999999999.\" \"Ponto ou Vírgula, seguido de um número, que corresponde ao número de casas decimais que o número do primeiro parâmetro deverá possuir, não devendo exceder à 999 casas decimais, e ser menor do que o número de casas decimais do número do primeiro parâmetro.\""
	exit 3
}

GerarZeros(){
	Zeros=""
	for OrdemNumerica in $( seq 1 "$NumeroDeZerosASeremAdicionadosADireita" ); do
		Zeros=`echo "${Zeros}0"`
	done
}

principal(){
	if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
		ajuda
	fi
	NumeroASerAdicionadoZerosADireita=`echo "$1" | grep -E "^([-]|)[0-9]{1,10}(([\.,]|)[0-9]{0,10}|)$"`
	PontoOuVirgulaSeguidoDeUmNumeroQueCorrespondeAoNumeroDeCasasDecimaisQueONumeroDeveraPossuir=`echo "$2" | grep -E "^[\.,][0-9]{1,3}$"`
	if [ -n "$NumeroASerAdicionadoZerosADireita" ] && [ -n "$PontoOuVirgulaSeguidoDeUmNumeroQueCorrespondeAoNumeroDeCasasDecimaisQueONumeroDeveraPossuir" ]; then
		TemPontoOuVirgula=`echo "$NumeroASerAdicionadoZerosADireita" | grep -E "[\.,]"`
		PontoOuVirgulaDoNumeroDoPrimeiroParametro=`echo "$NumeroASerAdicionadoZerosADireita" | sed -r 's/[0-9]//g'`
		if [ -n "$TemPontoOuVirgula" ]; then
			CasasDecimaisDoNumeroEspecificadoNoPrimeiroParametro=`echo "$NumeroASerAdicionadoZerosADireita" | sed 's/\./,/g' | cut -d "," -f 2`
		else
			CasasDecimaisDoNumeroEspecificadoNoPrimeiroParametro=""
		fi
		NumeroDeCasasDecimaisDoNumeroEspecificadoNoPrimeiroParametro=`echo "${#CasasDecimaisDoNumeroEspecificadoNoPrimeiroParametro}"`
		PontoOuVirgula=`echo "$PontoOuVirgulaSeguidoDeUmNumeroQueCorrespondeAoNumeroDeCasasDecimaisQueONumeroDeveraPossuir" | cut -c 1`
		NumeroCorrespondenteAoNumeroDeCasasDecimaisQueONumeroDoPrimeiroParametroDeveraPossuirAposAConversao=`echo "$PontoOuVirgulaSeguidoDeUmNumeroQueCorrespondeAoNumeroDeCasasDecimaisQueONumeroDeveraPossuir" | sed 's/\./,/g' | cut -d "," -f 2`
		if [ -n "$NumeroDeCasasDecimaisDoNumeroEspecificadoNoPrimeiroParametro" ] && [ -n "$NumeroCorrespondenteAoNumeroDeCasasDecimaisQueONumeroDoPrimeiroParametroDeveraPossuirAposAConversao" ]; then
			if [ "$NumeroDeCasasDecimaisDoNumeroEspecificadoNoPrimeiroParametro" -lt "$NumeroCorrespondenteAoNumeroDeCasasDecimaisQueONumeroDoPrimeiroParametroDeveraPossuirAposAConversao" ]; then
				if [ "$NumeroDeCasasDecimaisDoNumeroEspecificadoNoPrimeiroParametro" -gt "0" ]; then
					PontoOuVirgulaDoNumeroDoPrimeiroParametro=`echo "$NumeroASerAdicionadoZerosADireita" | sed -r 's/([0-9])//g' | sed 's/\./\\\./g'`
					NumeroDeZerosASeremAdicionadosADireita=`expr $NumeroCorrespondenteAoNumeroDeCasasDecimaisQueONumeroDoPrimeiroParametroDeveraPossuirAposAConversao - $NumeroDeCasasDecimaisDoNumeroEspecificadoNoPrimeiroParametro`
					if [ "$?" -ne "0" ]; then echo "Erro $0: expr $NumeroCorrespondenteAoNumeroDeCasasDecimaisQueONumeroDoPrimeiroParametroDeveraPossuirAposAConversao - $NumeroDeCasasDecimaisDoNumeroEspecificadoNoPrimeiroParametro" ; exit 2 ; fi
					GerarZeros
					Resultado=`echo "${NumeroASerAdicionadoZerosADireita}${Zeros}" | sed "s/${PontoOuVirgulaDoNumeroDoPrimeiroParametro}/${PontoOuVirgula}/g"`
				else
					NumeroDeZerosASeremAdicionadosADireita="$NumeroCorrespondenteAoNumeroDeCasasDecimaisQueONumeroDoPrimeiroParametroDeveraPossuirAposAConversao"
					AdicionarPontoOuVirgula="$PontoOuVirgula"
					GerarZeros "$NumeroDeZerosASeremAdicionadosADireita"
					Resultado=`echo "${NumeroASerAdicionadoZerosADireita}${AdicionarPontoOuVirgula}${Zeros}"`
				fi				
			elif [ "$NumeroDeCasasDecimaisDoNumeroEspecificadoNoPrimeiroParametro" -eq "$NumeroCorrespondenteAoNumeroDeCasasDecimaisQueONumeroDoPrimeiroParametroDeveraPossuirAposAConversao" ]; then
				if [ -n "$PontoOuVirgulaDoNumeroDoPrimeiroParametro" ] && [ -n "$PontoOuVirgula" ]; then
					PontoOuVirgulaDoNumeroDoPrimeiroParametro=`echo "$PontoOuVirgulaDoNumeroDoPrimeiroParametro" | sed 's/^/\\\\/'`
					PontoOuVirgula=`echo "$PontoOuVirgula" | sed 's/^/\\\\/'`
					Resultado=`echo "$NumeroASerAdicionadoZerosADireita" | sed "s/${PontoOuVirgulaDoNumeroDoPrimeiroParametro}/${PontoOuVirgula}/g"`
				else
					Resultado="$NumeroASerAdicionadoZerosADireita"
				fi
			else
				ajuda	
			fi
		else
			ajuda
		fi
	else
		ajuda
	fi
	echo "$Resultado"
}
principal "$1" "$2"
