#!/bin/sh


echo "content-type: text/plain"
echo ""

TempoUniversalCoordenadoEmSegundosAtual=`date +%s`
ArquiteturaDoProcessador=`uname -m`
PastaDeDestino="/$ArquiteturaDoProcessador/uploads/AnotacoesPublicasRealizadasNoTempoUniversalCoordenadoEmSegundos"
if [ ! -d "$PastaDeDestino" ]; then
	mkdir -p "$PastaDeDestino"
fi
ArquivoDeDestino="$PastaDeDestino/$TempoUniversalCoordenadoEmSegundosAtual"
cat > "${ArquivoDeDestino}.tmp"
NumeroDeLinhas=`sed -n $= ${ArquivoDeDestino}.tmp`
PenultimaLinha="$(( $NumeroDeLinhas - 1))"
sed -n '4,'$PenultimaLinha'p' ${ArquivoDeDestino}.tmp > $ArquivoDeDestino
rm -f ${ArquivoDeDestino}.tmp
