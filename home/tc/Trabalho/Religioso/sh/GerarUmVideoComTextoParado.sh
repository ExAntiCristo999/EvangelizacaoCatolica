if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ]; then
	echo "$0 \"Arquivo TXT\" \"Arquivo de vídeo MP4\" \"Resolução usada.\" \"Tamanho da fonte TTF usada.\" \"Segundos de vídeo.\""
	exit 1
fi
NomeDoProgramaSh="${0##*/}"
NomeDoPrograma="${NomeDoProgramaSh%.sh}"
Pasta="$PastaComArquivosTemporariosDosProgramasQueCrio/$NomeDoPrograma"
if [ ! -d "$Pasta" ]; then
	mkdir -p "$Pasta"
fi
ConverterTextoEmImagem.sh "$1" "$Pasta/a.png" "$3" "$4"
ConverterFotoParaUmVideoSemAudio.sh "$Pasta/a.png" "$2" "$5"
rm -f "$Pasta/a.png"
