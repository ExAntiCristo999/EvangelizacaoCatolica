if [ -z "$1" ]; then
	echo "$0 \"IP do Smartphone Android que consegue obter coordenadas geográficas pelo termux-location.\""
	exit 1
fi

if [ "$USER" = "tc" ]; then
	wget -c "http://$1:8080/cgi-bin/ObterLatitudeLongitudeEAltitudeEmSmartphonesQueSuportam.cgi" -qO - -T 40
else
	echo "Plataforma desconhecida."
	exit 2
fi
