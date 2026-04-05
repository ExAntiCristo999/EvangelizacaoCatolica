#!/bin/sh

ajuda(){
	echo "$0 \"Faixa de IP da rede.\" \"Pasta onde serao instalados os TCZ, ou vazio, caso seje o /tmp/tcloop \""
	exit 48
}



principal(){
	if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
		ajuda
	else
		InstalarProgramasNoCoreLinux.sh "nmap,pcre" "$2"
		FaixaDeIP=`echo "$1" | grep -E "^([0-9]{1,3}[.]){3}[0-9]{1,3}[-][0-9]{1,3}$"`
		until [ -n "$IPsLivres" ]; do
			nmap -sT -Pn ${FaixaDeIP} -p 80,5900 2>&1 | sed ':a;$!N;s/\n/ /;ta;' | sed 's/Nmap scan report for/\n/g' | grep -v "open" | sed -r 's/ +/ /g' | grep -v "Starting Nmap" | cut -d " " -f 2 | grep -E "^([0-9]{1,3}[.]){3}[0-9]{1,3}$" &> /tmp/IPsLivres.log &
			sleep 5
			IPsLivres=`cat /tmp/IPsLivres.log`
			if [ -z "$IPsLivres" ]; then
				FecharProcessosComExcessaoDoVim.sh "nmap"
			else
				rm -f /tmp/IPsLivres.log
			fi
		done
		NumeroDeIPsLivres=`echo "$IPsLivres" | grep -E [0-9] | wc -l`
		NumeroRandomico=`NumeroRandomicoEntre.sh 1 "$NumeroDeIPsLivres"`
		echo "$IPsLivres" | sed -n "${NumeroRandomico}p"
	fi
}

principal "$1" "$2"
exit 0
