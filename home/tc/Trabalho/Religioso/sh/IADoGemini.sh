if [ -z "$1" ]; then
	echo "$0 \"Texto à ser enviado.\""
	exit 1
fi
if [ "$?" -ne "0" ]; then
	exit 2
fi
NomeDoProgramaSh="${0##*/}"
NomeDoPrograma="${NomeDoProgramaSh%.sh}"
SegundosUTC=`date +%s`
Pasta="$PastaComArquivosTemporariosDosProgramasQueCrio/$NomeDoPrograma/$SegundosUTC"
if [ ! -d "$Pasta" ]; then
	sudo mkdir -p "$Pasta"
	sudo chown -R tc:staff "$Pasta"
fi
ArquivoFinal=`date +%s`
Mensagem=`echo -ne "$1"`
ArquivoPOST="$Pasta/POST.txt"
if [ "$USER" = "tc" ]; then
	ArquivoDoGeminiKey="/home/tc/Trabalho/PropositosIntegrados/db/GeminiAPIKey.db"
elif [ -n "$TERMUX_VERSION" ]; then
	ArquivoDoGeminiKey="$HOME/home/tc/Trabalho/PropositosIntegrados/db/GeminiAPIKey.db"
else
	echo "Plataforma desconhecida."
	exit 3
fi
if [ ! -s "$ArquivoDoGeminiKey" ]; then
	if [ "$USER" = "tc" ]; then
		less "/home/tc/Trabalho/PropositosIntegrados/db/SOS.db"
	elif [ -n "$TERMUX_VERSION" ]; then
		less "$HOME/home/tc/Trabalho/PropositosIntegrados/db/SOS.db"
	else
		echo "Plataforma desconhecida."
		exit 4
	fi
fi
GEMINI_API_KEY=`cat "$ArquivoDoGeminiKey"`
echo -ne "{\"contents\": [{\"parts\": [{\"text\": \"$Mensagem\"}]}]}" > "$ArquivoPOST"
Tamanho=`wc -c < "$ArquivoPOST"`
Arquivo=`cat "$ArquivoPOST"`
Arquivo=`echo "$Arquivo" | tr -d '\n'`
REQUISICAO="POST /v1beta/models/gemini-2.5-flash-lite:generateContent?key=$GEMINI_API_KEY HTTP/1.1\r\n"
REQUISICAO="${REQUISICAO}Host: generativelanguage.googleapis.com\r\n"
REQUISICAO="${REQUISICAO}Content-Type: application/json\r\n"
REQUISICAO="${REQUISICAO}Content-Length: $Tamanho\r\n"
REQUISICAO="${REQUISICAO}Connection: close\r\n"
REQUISICAO="${REQUISICAO}\r\n"
REQUISICAO="${REQUISICAO}$Arquivo\r\n"
( echo -ne "$REQUISICAO" ; sleep 5 ) | openssl s_client -connect generativelanguage.googleapis.com:443 -quiet -ign_eof 2> /dev/null | sed -r '/^            "text": "/!d;s/\\\"/\"/g;s/\\n/\n/g' | sed -r 's/            "text": "/    /g'  
