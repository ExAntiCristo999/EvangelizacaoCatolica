#!/bin/sh

if [ -z "$1" ]; then
	echo "$0 \"Identificação da sessão.\""
	exit 1
fi

echo -e "GET /session/$1/url HTTP/1.1\r\nHost: localhost:4444\r\nUser-Agent: curl/7.67.0\r\nAccept: */*\r\n\r\n" | nc -v localhost 4444
