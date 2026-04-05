#!/bin/sh

ajuda(){
	echo "$0 \"Numero de caracteres da string.\""
	exit 48
}

principal(){
	if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
		ajuda
	else
		ValidacaoDoParametro1=`echo "$1" | grep -E "^[0-9]{1,12}$"`
		if [ -z "$ValidacaoDoParametro1" ]; then
			ajuda
		fi
		c1=`head /dev/urandom | tr -dc A-Za-z\-\_0-9\.\~`
		c2=`head /dev/urandom | tr -dc A-Za-z\-\_0-9\.\~`
		c3=`head /dev/urandom | tr -dc A-Za-z\-\_0-9\.\~`
		c4=`head /dev/urandom | tr -dc A-Za-z\-\_0-9\.\~`
		c5=`head /dev/urandom | tr -dc A-Za-z\-\_0-9\.\~`
		c6=`head /dev/urandom | tr -dc A-Za-z\-\_0-9\.\~`
		c7=`head /dev/urandom | tr -dc A-Za-z\-\_0-9\.\~`
		echo "${c1}${c2}${c3}${c4}${c5}${c6}${c7}" | head -c $1
	fi
}

principal "$1"
exit 0
