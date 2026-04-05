AjudaDoProgramaDigiteOsCodigosNumericosNoFormatoCutCorrespodenteAsOpcoesDeDoisPontos(){
	echo "$0 \"Variável de outro programa, contendo as opções, separadas por quebras de linha LF.\" \"Pergunta a ser realizada para a escolha das opções.\" \"'n' para incluir a opção 'Nenhuma das opções anteriores'; ou vazio, para escolher somente as opções, repassadas ao parâmetro 1 deste programa.\" \"Arquivo onde será armazenada a opção escolhida\" \"'b' para tocar o beep, ou vazio.\""
	exit 1
}

PrincipalDoProgramaDigiteOsCodigosNumericosNoFormatoCutCorrespodenteAsOpcoesDeDoisPontos(){
	if [ -z "$1" ] || [ -z "$2" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
		AjudaDoProgramaDigiteOsCodigosNumericosNoFormatoCutCorrespodenteAsOpcoesDeDoisPontos
	else
		if [ -s "$4" ]; then
			rm -f "$4"
		fi
		NumeroDeOpcoesEncontradas=`echo "$1" | wc -l`
		if [ "$5" = "b" ]; then                                            beep.sh 2 1
                fi
		NumerosDasOpcoesEscolhidasNoFormatoCut=""
		while [ -z "$NumerosDasOpcoesEscolhidasNoFormatoCut" ]; do
			if [ "$3" = "n" ]; then
                        	NumeroDeOpcoesTotal="$(( $NumeroDeOpcoesEncontradas + 1 ))"
	                        OpcoesASeremEscolhidas=`echo -e "${1}\nNenhuma das anteriores." | nl -b a`
				echo -e "\n\033[1;33m${2}\033[0m\n\033[0;32m${OpcoesASeremEscolhidas}\033[0m" | less
				read NumerosDasOpcoesEscolhidasNoFormatoCut
	                elif [ -z "$3" ]; then
        	                NumeroDeOpcoesTotal="$NumeroDeOpcoesEncontradas"
				OpcoesASeremEscolhidas=`echo -e "${1}" | nl -b a`
				echo -e "\n\033[1;33m${2}\033[0m\n\033[0;32m${OpcoesASeremEscolhidas}\033[0m" | less
				read NumerosDasOpcoesEscolhidasNoFormatoCut
        	        else
				AjudaDoProgramaDigiteOsCodigosNumericosNoFormatoCutCorrespodenteAsOpcoesDeDoisPontos
			fi
        	        NumerosDasOpcoesEscolhidasNoFormatoCut=`echo "$NumerosDasOpcoesEscolhidasNoFormatoCut" | sed -r '/^([0-9]{1,4})([,-][0-9]{1,4}){0,200}$/!d'`
			if [ -n "$NumerosDasOpcoesEscolhidasNoFormatoCut" ]; then
				echo "$1" | sed ':a;$!N;s/\n/\#/;ta' | cut -d "#" -f "$NumerosDasOpcoesEscolhidasNoFormatoCut" | sed 's/\#/\n/g' | sed 's/^/UmaDasOpcoesEscolhidas=/' > "$4"
			else
				echo "Digite o os numeros no formato cut. Ex: 1,2 1,3-15 4-8,2-29,31,34"
			fi
		done
	fi
}

PrincipalDoProgramaDigiteOsCodigosNumericosNoFormatoCutCorrespodenteAsOpcoesDeDoisPontos "$1" "$2" "$3" "$4" "$5"
