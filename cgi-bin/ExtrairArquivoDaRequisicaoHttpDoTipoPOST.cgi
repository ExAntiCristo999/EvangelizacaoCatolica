#!/bin/sh


echo "content-type: text/html"
echo ""

ArquiteturaDoProcessador=`uname -m`
# Define PastaPadraoDosProgramasQueCrio (não estava definido no script)
PastaFinal="${PastaPadraoDosProgramasQueCrio%/home*}/${ArquiteturaDoProcessador}/uploads"
# Certifique-se de que o diretório de uploads exista
mkdir -p "$PastaFinal" 
file="$PastaFinal/$$-$RANDOM" # Altere o local para PastaFinal

# CGI output must start with at least empty line (or headers)
#!/bin/sh

# O diretório de destino
dd bs=1 count="$CONTENT_LENGTH" of="$file" 2> /dev/null
