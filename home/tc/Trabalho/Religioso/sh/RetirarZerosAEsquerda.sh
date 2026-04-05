#!/bin/sh

NumeroDeDigitos="${#1}"
NumeroInicial=`echo "$1" | sed -r "/^[0-9,.]{1,500}$/!d;/^0{1,500}$/d"`
if [ -n "$NumeroInicial" ]; then
	echo "$NumeroInicial" | sed -r "s/^([0]{1,${NumeroDeDigitos}})//g"
else
	echo "0"
fi
