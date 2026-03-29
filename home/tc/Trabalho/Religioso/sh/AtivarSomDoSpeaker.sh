#!/bin/sh

PastaPadraoDosProgramasQueCrio=`PastaPadraoDosProgramasQueCrio.sh`
ArquiteturaDoProcessador=`uname -m`
Prefixo="${PastaPadraoDosProgramasQueCrio%/home*}/${ArquiteturaDoProcessador}/tmp/beep"
if [ ! -d "$Prefixo" ]; then
	mkdir -p "$Prefixo"
fi
ArquivoASerDeletado="${Prefixo}/NaoQueroSonsDoSpeaker.spk"
if [ -s "$ArquivoASerDeletado" ]; then
	rm -f "$ArquivoASerDeletado"
fi
