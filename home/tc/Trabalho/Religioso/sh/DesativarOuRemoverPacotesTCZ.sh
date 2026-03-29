ajuda(){
	echo "$0 \"Nome do pacote, sem a extensão TCZ; ou nomes dos pacotes, sem a extensão TCZ, separados por vírgula. Ex: 'bc', 'grep,sed'.\""
	exit 1
}

DesativarPacote(){
	for UmPacoteTCZ in $1 ; do
		for UmResultadoDeBusca in $( find $PastaOndeOTCZEMontado/$UmPacoteTCZ/ -type f | sed 's/ /_ogait_/g' | cut -d "/" -f ${NumeroDePastasADesconsiderar}- | sed 's/^/\//' ); do
			ArquivoAchado=`echo "$UmResultadoDeBusca" | sed 's/_ogait_/ /g'`
			if [ -f "$ArquivoAchado" ]; then
				NomeDoProcesso=`echo "$ArquivoAchado" | sed -r '/(.*bin[/])/!d;s/(.*bin[/])([^/]{1,140})$/\2/g'`
				ps | sed -r "/$NomeDoProcesso/!d;/sed/d;s/ +/ /g;s/(.* )(tc|root)(.*)/\1/g;s/^/(sed -n 2p /home/tc/Trabalho/Profissional/db/senhas.db | cut -d ":" -f 2) | su root -c \"kill -9 /g" | sh
				sudo rm -f "$ArquivoAchado"
			fi
		done
		sudo umount "$PastaOndeOTCZEMontado/$UmPacoteTCZ"
		sudo rm -f "/usr/local/tce.installed/$UmPacoteTCZ"
		sudo rm -rf "$PastaOndeOTCZEMontado/$UmPacoteTCZ"
	done
}

principal(){
	if [ -z "$1" ]; then
		ajuda
	fi
	PacotesSeparadosPorQuebrasDeLinha=`echo "$1" | sed 's/,/\n/g'`
	PastaOndeOTCZEMontado="/tmp/tcloop"
	NumeroDePastasADesconsiderar="5"
	DesativarPacote "$PacotesSeparadosPorQuebrasDeLinha"	
}
principal "$1" "$2"
