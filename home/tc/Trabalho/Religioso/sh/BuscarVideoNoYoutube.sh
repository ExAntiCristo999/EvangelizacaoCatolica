if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
	echo "$0 \"Termo de pesquisa do vídeo no Youtube, ao qual será baixado o áudio\" \"NomeDoAudioASerBaixadoSemAExtensao\" \"Caminho completo à pasta que conterá a música mp3.\""
	exit 1
fi
if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ]; then
	if [ "$USER" = "tc" ]; then
		tce-load -ilw yt-dlp
	elif [ -n "$TERMUX_VERSION" ]; then
		pkg install python
		pip install yt-dlp
	fi
	Deu="n"
	until [ "$Deu" = "s" ]; do
		DezPrimeirosResultados=`yt-dlp "ytsearch10:$1" --dump-json | jq -r '{id, title, duration: .formats[0].fragments[0].duration}'`
		echo -e "$DezPrimeirosResultados\n\n\nQual dos áudio pretende baixar em mp3? (1 à 10)" | less
		read UmADez
		id=`echo "$DezPrimeirosResultados" | jq -r '.id' | sed -n ${UmADez}p`
		echo "Deu certo a escolha do id do vídeo (s/n)?"
		read Deu
	done
	BaixarAudioDeMelhorQualidadeDoYouTubeETocar.sh "$id" "$2" "$3"
fi
