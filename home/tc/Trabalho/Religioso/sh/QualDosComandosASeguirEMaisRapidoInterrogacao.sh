#!/bin/sh

Rodar(){
	ti=`date +%s%N`
	eval $1
	tf=`date +%s%N`
	d=`expr $tf - $ti`
}

RodarNVezes(){
	tt="0"
	ndt="20"
	for odt in $( seq 1 $ndt ); do
		Rodar "$1"
		tt=`expr $tt + $d`	
	done
	if [ "$2" -eq "1" ]; then
		m1=`expr $tt \/ $ndt`
	else
		m2=`expr $tt \/ $ndt`
		if [ "$m1" -gt "$m2" ]; then
			echo "$1"
		elif [ "$m1" -lt "$m2" ]; then
			echo "$3"
		else
			echo "Igual"
		fi
	fi
}

RodarNVezes "$1" "1"
RodarNVezes "$2" "2" "$1"
