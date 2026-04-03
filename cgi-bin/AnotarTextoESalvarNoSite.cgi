#!/bin/sh


echo "content-type: text/html"
echo ""

FiltrarPorIPRemoto(){
	IPRemoto=`echo "$SERVER_ADDR" | grep "${REMOTE_ADDR%.*}"`
	if [ -z "$IPRemoto" ] && [ "$1" = "lo" ]; then
		SERVER_ADDR=""
	fi
}

until [ -n "$SERVER_ADDR" ]; do
	if [ -s "/home/tc" ]; then
		if [ -z "$SERVER_ADDR" ]; then
			sudo ifconfig lo up
			SERVER_ADDR=`ifconfig | grep -A 1 lo | sed -r '/addr:/!d;s/(.*addr:)([^ ]{7,50})( .*)/\2/g;s/$/:8080/g'`
			FiltrarPorIPRemoto lo
		fi
		if [ -z "$SERVER_ADDR" ]; then
			sudo ifconfig eth0 up
			SERVER_ADDR=`ifconfig | grep -A 1 eth0 | sed -r '/addr:/!d;s/(.*addr:)([^ ]{7,50})( .*)/\2/g;s/$/:8080/g'`
			FiltrarPorIPRemoto eth0
		fi
		if [ -z "$SERVER_ADDR" ]; then
			sudo ifconfig usb0 up
			SERVER_ADDR=`ifconfig | grep -A 1 usb0 | sed -r '/addr:/!d;s/(.*addr:)([^ ]{7,50})( .*)/\2/g;s/$/:8080/g'`
			FiltrarPorIPRemoto usb0
		fi
		if [ -z "$SERVER_ADDR" ]; then
			sudo ifconfig wlan0 up
			SERVER_ADDR=`ifconfig | grep -A 1 wlan0 | sed -r '/addr:/!d;s/(.*addr:)([^ ]{7,50})( .*)/\2/g;s/$/:8080/g'`
			FiltrarPorIPRemoto wlan0
		fi
	else
		if [ -z "$SERVER_ADDR" ]; then
			SERVER_ADDR=`ifconfig 2>&1 | grep -A 1 lo | sed -r '/inet/!d;s/(.*inet )([^ ]{7,50})( .*)/\2/g;s/$/:8080/g'`
			FiltrarPorIPRemoto lo
		fi
		if [ -z "$SERVER_ADDR" ]; then
			SERVER_ADDR=`ifconfig 2>&1 | grep -A 1 rndis0 | sed -r '/inet/!d;s/(.*inet )([^ ]{7,50})( .*)/\2/g;s/$/:8080/g'`
			FiltrarPorIPRemoto rndis0
		fi
		if [ -z "$SERVER_ADDR" ]; then
			SERVER_ADDR=`ifconfig 2>&1 | grep -A 1 wlan0 | sed -r '/inet/!d;s/(.*inet )([^ ]{7,50})( .*)/\2/g;s/$/:8080/g'`
			FiltrarPorIPRemoto wlan0
		fi
	fi
done
echo -e "<!DOCTYPE html><html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /></head><body><form enctype=\"multipart/form-data\" action=\"http://${SERVER_ADDR}/cgi-bin/BlocoDeNotas.cgi\" method=\"post\" ><textarea id=\"w3review\" name=\"w3review\" rows=\"7000\" cols=\"300\"></textarea><input type=\"submit\" value=\"Submit\"></form></body></html>"
