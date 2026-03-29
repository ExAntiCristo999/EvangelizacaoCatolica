

echo "content-type: text/html"
echo ""


NomeDoProgramaSemAsPastasQueAntecedem="${0##*/}"
NomeDoPrograma="${NomeDoProgramaSemAsPastasQueAntecedem%.*}"
PastaDeUploads="$PastaDeArquitetura/uploads/$NomeDoPrograma"
if [ ! -d "$PastaDeUploads" ]; then
	mkdir -p "$PastaDeUploads"
fi
SegundosDoTempoUniversalCoordenado=`date +%s`
set > $PastaDeUploads/$SegundosDoTempoUniversalCoordenado
