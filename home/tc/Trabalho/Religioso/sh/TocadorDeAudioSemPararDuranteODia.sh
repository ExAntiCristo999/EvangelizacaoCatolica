Tocador(){
	if [ "$USER" = "tc" ]; then
		ConfigurarSom.sh
		tce-load -ilw alsa alsa-config mpg123
		mpg123 "$1"
	elif [ -n "$TERMUX_VERSION" ]; then
		pkg install termux-api
		termux-media-player play "$1"
		SemMusicaTocando=""
		until [ -n "$SemMusicaTocando" ]; do	
			Informacao=`termux-media-player info`
			SemMusicaTocando=`echo "$Informacao" | grep "No track currently!"`
			sleep 10
		done
	else
		echo "Plataforma desconhecida."
		exit 1
	fi
}
while [ "2" -eq "2" ]; do
	Tocador "$1"
done
