FuncaoAjudaDoProgramaAgendaDeCompromissosPessoal(){
	echo "$0 \"'a' para adicionar novo compromisso; 'd' para deletar compromisso; 'v' para exibir os compromissos mais próximo, desligando o PC, dependendo dos casos.\" \"Caso o primeiro parâmetro seje igual à 'a', este conterá o que vai fazer no compromisso?; caso o primeiro parâmetro seje 'd', este parâmetro receberá o código numérico do compromisso.\" \"Data e Hora:Minuto\" \"Minutos de antecedência, separados por vírgula.\" \"'d' para desligar o computador no primeiro minuto de antecedência, ou vazio ',' Repetição.\""
	exit 1
}

AdicionarCompromisso(){
	MinutosDeAntecedenciaSeparadosPorQuebraDeLinhaLF=`echo "$3" | sed 's/,/\n/g'`
	ContadorDeMinutosDeAntecedencia="0"
	SegundosDoTempoUniversalCoordenadoDeUmNovoCompromisso=`ValidarData.sh "$2" "+%s"`
	if [ -f "$BancoDeDados" ]; then
		ConteudoTotalDoBancoDeDados=`grep ";" "${BancoDeDados}"`		
	fi
	CodigoNumericoDoAgendamento=`date +%s`
	CompromissosNovos=""
	for MinutosDeAntecedencia in $MinutosDeAntecedenciaSeparadosPorQuebraDeLinhaLF ; do
		ContadorDeMinutosDeAntecedencia="$(( $ContadorDeMinutosDeAntecedencia + 1 ))"
		OpcaoDesligar=`echo "$4" | cut -d "," -f ${ContadorDeMinutosDeAntecedencia}`
		SegundosDoTempoUniversalCoordenadoDeUmNovoCompromissoMenosSegundosDeAntecedencia="$(( $SegundosDoTempoUniversalCoordenadoDeUmNovoCompromisso - $MinutosDeAntecedencia * 60 ))"
		CompromissosNovos=`echo -e "${CompromissosNovos}\n${CodigoNumericoDoAgendamento};${1};${SegundosDoTempoUniversalCoordenadoDeUmNovoCompromissoMenosSegundosDeAntecedencia};${OpcaoDesligar}"`
	done
	echo -e "${ConteudoTotalDoBancoDeDados}\n${CompromissosNovos}" | sort -k "1,1" -t ";" > "$BancoDeDados"
}

Lib1(){
	SegundosDoTempoUniversalCoordenadoAtual=`date +%s`
	Compromissos=`while read l ; do echo "$l" ; done < "$BancoDeDados"`
	NumeroTotalDeCompromissos=`echo "$Compromissos" | wc -l`
	if [ "$1" = "p" ]; then
		CompromissosMaisRecentesApenas=""
	fi
	for OrdemNumerica1 in $( seq 1 $NumeroTotalDeCompromissos ); do
		Compromisso=`echo "$Compromissos" | sed -n ${OrdemNumerica1}p`
		CompromissoSemD="${Compromisso%;*}"
		SegundosDoTempoUniversalCoordenadoDeUmNovoCompromissoMenosSegundosDeAntecedencia="${CompromissoSemD##*;}"
		IntervaloEmSegundosEntreAHorarioAtualEODoCompromisso="$(( $SegundosDoTempoUniversalCoordenadoDeUmNovoCompromissoMenosSegundosDeAntecedencia - $SegundosDoTempoUniversalCoordenadoAtual ))"
		if [ "$1" = "v" ] && ([ "$IntervaloEmSegundosEntreAHorarioAtualEODoCompromisso" -gt "0" ] && [ "$IntervaloEmSegundosEntreAHorarioAtualEODoCompromisso" -le "86400" ]); then
			Comando="${Compromisso##*;}"
			CompromissoSemHorarioED="${CompromissoSemD%;*}"
			TituloDoCompromisso="${CompromissoSemHorarioED##*;}"
			ExisteTemporizador=`psaux.sh | sed -r "/Temporizador.sh \"${SegundosDoTempoUniversalCoordenadoDeUmNovoCompromissoMenosSegundosDeAntecedencia}\" \"${TituloDoCompromisso}\" \"${Comando}\"/!d;/sed/d"`
			if [ -z "$ExisteTemporizador" ]; then
				$SHELL Temporizador.sh "$SegundosDoTempoUniversalCoordenadoDeUmNovoCompromissoMenosSegundosDeAntecedencia" "$TituloDoCompromisso" "$Comando"
			fi
		else
			if [ "$IntervaloEmSegundosEntreAHorarioAtualEODoCompromisso" -gt "0" ]; then
				CompromissosMaisRecentesApenas=`echo -e "${CompromissosMaisRecentesApenas}\n${Compromisso}"`
			fi
		fi
	done
	if [ "$1" = "p" ]; then
		echo "$CompromissosMaisRecentesApenas" | sort -k "1,1" -t ";" > "$BancoDeDados"
	fi
}

VerOsCompromissosDoDia(){
	Lib1 "p"
	Lib1 "v"
}

DeletarCompromisso(){
	ConteudoTotalDoBancoDeDados=`grep -v "^${1};" "${BancoDeDados}"`
	echo "$ConteudoTotalDoBancoDeDados" | sort -k "1,1" -t ";" > "$BancoDeDados"
}


FuncaoPrincipalDoProgramaAgendaDeCompromissosPessoal(){
	if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
		FuncaoAjudaDoProgramaAgendaDeCompromissosPessoal
	else
		until [ -s "$PastaPadraoDosProgramasQueCrio/../db/AgendaDeCompromissos.db" ]; do
			echo "Erro no programa ${0}: sincronize o arquivo n.tar.7z da nuvem para o computador com Termux, ou deste para o computador com Core Linux, para que o programa ${0} volte a funcionar normalmente."
			sleep 10
		done
		if [ "$USER" = "tc" ]; then
			BancoDeDados="/home/tc/Trabalho/PropositosIntegrados/$TemperamentoBigFive/$Apelido/QualquerLugar/db/AgendaDeCompromissos.db"
		elif [ -n "$TERMUX_VERSION" ]; then
			BancoDeDados="~/home/tc/Trabalho/PropositosIntegrados/$TemperamentoBigFive/$Apelido/QualquerLugar/db/AgendaDeCompromissos.db"
		else
			echo "Plataforma desconhecida."
			exit 2
		fi
		ValidacaoDoParametro1=`echo "$1" | grep -E "^[adv]$"`
		if [ -z "$ValidacaoDoParametro1" ]; then
			FuncaoAjudaDoProgramaAgendaDeCompromissosPessoal
		fi
		ValidacaoDoParametroSobreOQueVaiFazerNoCompromisso=`echo "$2" | grep -E "^[a-zA-ZáéíóúÁÉÍÓÚâêôÂÊÔçÇãõÃÕàÀ:0-9/,\. ]{1,200}$"`
		if [ -z "$ValidacaoDoParametroSobreOQueVaiFazerNoCompromisso" ] && ([ "$1" = "a" ] || [ "$1" = "d" ]); then
			FuncaoAjudaDoProgramaAgendaDeCompromissosPessoal
		fi
		ValidacaoDoParametroSobreADataHoraMinuto=`ValidarData.sh "$3" "+%d/%m/%Y%%%H:%M" | sed 's/%/ /g'`
		if [ -z "$ValidacaoDoParametroSobreADataHoraMinuto" ] && [ "$1" = "a" ]; then
			FuncaoAjudaDoProgramaAgendaDeCompromissosPessoal
		fi
		if [ -n "$4" ]; then
			MinutosDeAntecedenciaPrimario="$4"
		else
			MinutosDeAntecedenciaPrimario="1430,1383,1323,1263,1203,1143,1083,1023,963,903,843,783,723,663,603,543,483,423,363,303,243,183,123,63,53,43,33"
		fi
		ValidacaoDosMinutosDeAntecedencia=`echo "$MinutosDeAntecedenciaPrimario" | grep -E "^[0-9]{1,4}([,][0-9]{1,4}){0,30}$"`
		if [ -z "$ValidacaoDosMinutosDeAntecedencia" ] && [ "$1" = "a" ]; then
			FuncaoAjudaDoProgramaAgendaDeCompromissosPessoal
		fi
		NumeroDeVirgulaDosMinutosDeAntecedencia=`echo "$MinutosDeAntecedenciaPrimario" | sed -r 's/([^,])//g'`
		if [ -n "$5" ]; then
			VirgulasContendoOuNaoAOpcaoDesligar="$5"
		else
			VirgulasContendoOuNaoAOpcaoDesligar=",,,,,,,,,,,,,,,,,,,,,,,,,,"
		fi
		NumeroDeVirgulaDaOpcaoDeDesligarOuNao=`echo "$VirgulasContendoOuNaoAOpcaoDesligar" | sed -r 's/([^,])//g'`
		if [ "${#NumeroDeVirgulaDosMinutosDeAntecedencia}" -ne "${#NumeroDeVirgulaDaOpcaoDeDesligarOuNao}" ] && [ "$1" = "a" ]; then
			FuncaoAjudaDoProgramaAgendaDeCompromissosPessoal
		elif [ "${#NumeroDeVirgulaDaOpcaoDeDesligarOuNao}" -eq "0" ] && [ "$1" = "a" ]; then
			if [ -n "$VirgulasContendoOuNaoAOpcaoDesligar" ] && [ "$VirgulasContendoOuNaoAOpcaoDesligar" != "d" ]; then
				FuncaoAjudaDoProgramaAgendaDeCompromissosPessoal
			fi
		elif [ "${#NumeroDeVirgulaDaOpcaoDeDesligarOuNao}" -ge "1" ] && [ "${#NumeroDeVirgulaDaOpcaoDeDesligarOuNao}" -le "10" ] && [ "$1" = "a" ]; then
			NumeroDeParametrosSeparadosPorVirgula="$(( ${#NumeroDeVirgulaDaOpcaoDeDesligarOuNao} + 1 ))"
			for OrdemNumerica in $( seq 1 ${NumeroDeParametrosSeparadosPorVirgula} ); do
				UmDosParametrosSeparadosPorVirgula=`echo "$VirgulasContendoOuNaoAOpcaoDesligar" | cut -d "," -f ${OrdemNumerica}`
			done
		fi
		if [ "$1" = "v" ]; then
			until [ "2" -eq "1" ]; do
				VerOsCompromissosDoDia
				sleep 90
			done
		elif [ "$1" = "a" ]; then
			AdicionarCompromisso "$2" "$3" "$MinutosDeAntecedenciaPrimario" "$VirgulasContendoOuNaoAOpcaoDesligar"
		else
			ValidarParametroDeCodigoNumericoDoCompromisso=`echo "$2" | grep -E "^[0-9]{1,50}$"`
			DeletarCompromisso "$2"
		fi
	fi
}

FuncaoPrincipalDoProgramaAgendaDeCompromissosPessoal "$1" "$2" "$3" "$4" "$5" "$6" "$7"
