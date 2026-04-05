if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
	echo "$0 \"Arquivo PNG\" \"Arquivo de vídeo MP4\" \"Segundos de vídeo.\""
	exit 1
fi
NomeDoProgramaSh="${0##*/}"
NomeDoPrograma="${NomeDoProgramaSh%.sh}"
Pasta="$PastaComArquivosTemporariosDosProgramasQueCrio/$NomeDoPrograma"
if [ ! -d "$Pasta" ]; then
	mkdir -p "$Pasta"
fi
if [ "$USER" = "tc" ]; then
	tce-load -iwl ffmpeg5
	Fonte="/home/tc/.fonts/arialbd.ttf"
elif [ -n "$TERMUX_VERSION" ]; then
	pkg install ffmpeg
	Fonte="$HOME/home/tc/.fonts/arialbd.ttf"
else
	echo "Plataforma desconhecida."
	exit 2
fi
ffmpeg -loop 1 -i "$1" -t $3 "$2"
