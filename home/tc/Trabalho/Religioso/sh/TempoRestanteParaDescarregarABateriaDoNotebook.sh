#!/bin/sh

until [ "2" = "3" ]; do
	if [ -f "/proc/acpi/battery/BAT0/state" ]; then
		state="/proc/acpi/battery/BAT0/state"	
	else
		RespostaSeTemNobreakLigadoOuNao=""
		until [ "$RespostaSeTemNobreakLigadoOuNao" = "s" ] || [ "$RespostaSeTemNobreakLigadoOuNao" = "n" ]; do
			echo -e "O computador utilizado não tem bateria.\nSe ele tiver um Nobreak ligado, vai ao teclado e aperte as teclas:\n"
			read RespostaSeTemNobreakLigadoOuNao
			RespostaSeTemNobreakLigadoOuNao="${RespostaSeTemNobreakLigadoOuNao/S/s}"
			RespostaSeTemNobreakLigadoOuNao="${RespostaSeTemNobreakLigadoOuNao/N/n}"
			if [ 

			
		done
	fi
	restante=`cat "$state" | sed -r 's/[\t ]+/ /g' | grep "remaining" | cut -d " " -f 3`
	taxa=`cat "$state" | sed -r 's/[\t ]+/ /g' | grep "present rate" | cut -d " " -f 3`
	TempoTotal=`expr 1000000000 \* ${restante} / ${taxa}`
	Horas=`echo "${TempoTotal}" | rev | cut -c 10- | rev`
	FracaoDeHorasParcial=`echo "${TempoTotal}" | rev | cut -c 1-9 | rev`
	TempoInferiorAUmaHora=`expr ${FracaoDeHorasParcial} \* 60`
	Minutos=`echo "$TempoInferiorAUmaHora" | rev | cut -c 10- | rev`
	FracaoDeMinutos=`echo "$TempoInferiorAUmaHora" | rev | cut -c 1-9 | rev`
	Segundos=`expr ${FracaoDeMinutos} \* 60`
	if [ -z "$Horas" ]; then
		TempoEmHoras=""
	else
		TempoEmHoras=`echo " ${Horas} hora(s)"`
	fi
	if [ -z "$Minutos" ]; then
		TempoEmMinutos=""
	else
		TempoEmMinutos=`echo " ${Minutos} minuto(s)"`
	fi
	TempoEmMinutosParaEsgotar=`expr ${TempoTotal} \* 60`
	if [ "$TempoEmMinutosParaEsgotar" -le "17" ]; then
		SiteDuckDuckGo=`ComandoCurlDoDuckDuckGo.sh 2>&1 | grep "site\-wrapper"`
		if [ -n "$SiteDuckDuckGo" ]; then
			desligar.sh
		else
			filetool.sh -b
			exitcheck.sh halt
		fi
	fi
	clear
	echo "Restam aproximadamente:${TempoEmHoras}${TempoEmMinutos} e ${Segundos} segundo(s) para esgotar a bateria do notebook."
done
