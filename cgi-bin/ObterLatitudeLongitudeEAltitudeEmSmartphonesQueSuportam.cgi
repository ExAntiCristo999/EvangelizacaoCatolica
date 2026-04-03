#!/bin/sh



echo "content-type: text/plain"
echo ""


if [ -n "$TERMUX_VERSION" ]; then
	Saida=`pkg install termux-api jq 2>&1`
	SaidaNaoFormatada=`termux-location`
	Latitude=`echo "$SaidaNaoFormatada" | jq -r .latitude | sed -r 's/\-/S/g;s/\./P/g'`
	if [[ "$Latitude" =~ "^[0-9]" ]]; then
		Latitude="N$Latitude"
	fi
	Longitude=`echo "$SaidaNaoFormatada" | jq -r .longitude | sed -r 's/\-/O/g;s/\./P/g'`
	if [[ "$Longitude" =~ "^[0-9]" ]]; then
		Longitude="L$Longitude"
	fi
	Altitude=`echo "$SaidaNaoFormatada" | jq -r .altitude | sed -r 's/\-/D/g;s/\./P/g'`
	if [[ "$Altitude" =~ "^[0-9]" ]]; then
		Altitude="M$Altitude"
	fi
	echo -e "$Latitude$Longitude$Altitude"
else
	echo "Plataforma desconhecida."
	exit 1
fi
