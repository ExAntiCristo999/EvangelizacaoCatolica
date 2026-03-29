#!/bin/sh

ajuda(){
	echo "$0 \"'f' para protocolar 30 dias de Férias no final do outono e no começo do inverno; 'cf' para compensar horas no último dia útil do ano, e dias anteriores; ou 'c' para compensar horas num determinado dia do ano.\" \"Se o primeiro parâmetro for 'f', aqui conterá o dia do início das Férias em segundos desde 01/01/1970 00:00:00 UTC0; se o primeiro parâmetro for 'cf', aqui conterá os segundos à compensar no último dia útil do ano, e dias anteriores; se o primeiro parâmetro for 'c' aqui conterá os segundos a compensar em um dia, não devendo exceder o equivalente à 8 horas.\" \"Se o primeiro parâmetro for 'c', aqui conterá o dia e hora inicial à compensar as horas, no formato DD/MM/AAAA HH:MM; ou vazio.\""
	exit 48
}

principal(){
	if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
		ajuda
	fi
	Segundos=`echo "$2" | grep -E "^[0-9]{1,12}$"`
	if [ "$1" = "f" ] && [ -n "$Segundos" ]; then
		PastaPadraoDosProgramasQueCrio=`PastaPadraoDosProgramasQueCrio.sh`
		FimDasFerias=`expr $2 + 2591999`
		AnoAtual=`date --date="@${2}" +%Y`
		DataDoInicioDasFerias=`date --date="@${2}" +%d/%m/%Y`
		DataDoFimDasFerias=`date --date="${FimDasFerias}" +%d/%m/%Y`
	       	echo "${2};${FimDasFerias};SN;${AnoAtual};férias" > "${PastaPadraoDosProgramasQueCrio}/BancoDeDados/ProtocolosDeDiasACompensarOuFerias.db"
		echo "Agora imprima o requerimento de férias e coloque manualmente o período de férias de $DataDoInicioDasFerias à ${DataDoFimDasFerias} num total de 30 dias, protocolando em seguida."
	elif [ "$1" = "c" ] && [ -n "$Segundos" ]; then
		PastaPadraoDosProgramasQueCrio=`PastaPadraoDosProgramasQueCrio.sh`
		ValidacaoDoTerceiroParametro=`ValidarData.sh "$3" +%s`
		if [ -z "$ValidacaoDoTerceiroParametro" ]; then
			ajuda
		fi
		DataEHoraInicial=`date --date="@${3}" +%d/%m/%Y%%%H:%M | sed 's/%/ /g'`
		FinalDasHorasACompensarEmSegundosDesde01011970AMeiaNoiteUTC0=`expr $3 + $2`
		DataEHoraFinal=`date --date="@${FinalDasHorasACompensarEmSegundosDesde01011970AMeiaNoiteUTC0}" +%d/%m/%Y%%%H:%M | sed 's/%/ /g'`
		HorasACompensar=`expr $2 / 3600`
		echo "Agora imprima o requerimento pedindo $HorasACompensar horas à compensar, à partir do dia ${DataEHoraInicial}, protocolando em seguida."
		echo "${3};${FinalDasHorasACompensarEmSegundosDesde01011970AMeiaNoiteUTC0};SN;compensar variável" >> "${PastaPadraoDosProgramasQueCrio}/BancoDeDados/ProtocolosDeDiasACompensarOuFerias.db"
	elif [ "$1" = "cf" ] && [ -n "$Segundos" ]; then
		PastaPadraoDosProgramasQueCrio=`PastaPadraoDosProgramasQueCrio.sh`
		DiasACompensar=`expr $2 / 28800`
		HorasACompensar=`expr $2 % 28800`
		echo "Você tem $DiasACompensar dias e $HorasACompensar horas à compensar nos últimos dias do ano. Imprima o requerimento e protocole em seguida."
		echo "ÚltimosDiasDoAno;ÚltimoDiaÚtilDoAno;SN;compensarfimdeano" >> "${PastaPadraoDosProgramasQueCrio}/BancoDeDados/ProtocolosDeDiasACompensarOuFerias.db"
	else
		ajuda
	fi
}

principal "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
exit 0
