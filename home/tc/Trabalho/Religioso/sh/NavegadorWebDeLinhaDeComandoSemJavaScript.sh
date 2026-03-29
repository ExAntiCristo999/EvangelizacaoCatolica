NomeDoProgramaPontoSh="${0##*/}"
NomeDoPrograma="${NomeDoProgramaPontoSh%.sh}"
if [ -z "$1" ]; then
	echo "Sem URL não navegarei."
	exit 1
fi
Protocolo=`echo "$1" | cut -d "/" -f 1-2`
PastaComNomeDeProtocolo="${Protocolo%%:/*}"
Dominio=`echo "$1" | cut -d "/" -f 3`
DominioSomenteComAsLetrasENumeros=`echo "$Dominio" | sed -r 's/([^a-zA-Z0-9])//g'`
SubDominios=`echo "$1" | cut -d "/" -f 4- | cut -d "?" -f 1`
Arquivo=`echo "$1" | cut -d "/" -f 4- | cut -d "?" -f 2-`
SegundosAtualUTC=`date +%s`
PastaContendoArquivoDeCookie="$PastaDeDadosDeConexoesHttpOuHttps/$NomeDoPrograma/$PastaComNomeDeProtocolo/$DominioSomenteComAsLetrasENumeros"
if [ ! -d "$PastaContendoArquivoDeCookie" ]; then
	mkdir -p "$PastaContendoArquivoDeCookie"
fi
sleep $(( $RANDOM % 20 + 5))
cookie="$PastaContendoArquivoDeCookie/cookie.txt"
if [ ! -e "$cookie" ]; then
	touch "$cookie"
fi
PastaContendoArquivosDoSite="$PastaContendoArquivoDeCookie/$SegundosAtualUTC"
if [ ! -d "$PastaContendoArquivosDoSite" ]; then
	mkdir -p "$PastaContendoArquivosDoSite"
fi
if [ -z "$2" ] || [ -z "$3" ]; then
	curl -c "$cookie" -b "$cookie" -vs "$1" -H "User-Agent: $UserAgent" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" -H "Accept-Language: pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7" -o "$PastaContendoArquivosDoSite/index.html" &> "$PastaContendoArquivosDoSite/CabecalhosDeResposta.log"
	echo "$PastaContendoArquivosDoSite"
else
	curl -c "$cookie" -b "$cookie" -vs "$1" -H "User-Agent: $UserAgent" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" -H "Accept-Language: pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7" -H "Content-Type: $2" --data "$3" -o "$PastaContendoArquivosDoSite/index.html" &> "$PastaContendoArquivosDoSite/CabecalhosDeResposta.log"
	echo "$PastaContendoArquivosDoSite"
fi
