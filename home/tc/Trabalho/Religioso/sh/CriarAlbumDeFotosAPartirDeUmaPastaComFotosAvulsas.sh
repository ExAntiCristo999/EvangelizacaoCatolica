cd "$1"
NomeDoProgramaPontoSh="${0##*/}"
NomeDoPrograma="${NomeDoProgramaPontoSh%}"
PastaBase="$PastaComArquivosTemporariosDosProgramasQueCrio/$NomeDoPrograma"
if [ ! -d "$PastaBase" ]; then
	mkdir -p "$PastaBase"
fi
for a in *.jpg ; do
	Terminou="n"
	until [ "$Terminou" = "s" ]; do
		fbv "$a"
		clear
		echo "A foto que tu viu será apagada (s/n)?"
		read apagado
		apagado=`echo "$apagado" | sed 's/S/s/g'`
		if [ "$apagado" = "s" ]; then
			rm -f "$a"
		else
			Pastas=`ls | grep "/"`
			EscolhaUmaDasSeguintesOpcoes.sh v "$Pastas" "Qual das pastas será movida a foto." "n" "$NomeDoPrograma"
			Arquivo=`find $PastaComArquivosTemporariosDosProgramasQueCrio/EscolhaUmaDasSeguintesOpcoes/$NomeDoPrograma/ -type f`
			Album=`sed -r 's/([^=]{1,20}[=])(.*)/\2/g' "$Arquivo"`
			if [ -z "$Album" ]; then
				Terminou2="n"
				until [ "$Terminou2" = "s" ]; do
					echo "Digite o Nome para o novo álbum no seguinte formato: AlbumDeFamiliaApenasComNumerosLetrasMaiusculasEMinusculas"
					read Album
					Album=`echo "$Album" | grep -E "^[a-zA-Z0-9]{1,1000}$"`
					if [ -n "$Album" ]; then
						Terminou2="s"
					fi
				done
			fi
			cp "$a" "$PWD/$Album"
			rm -f "$a"
		fi
		Terminou="s"
	done
	Encerrar="n"
	until [ "$Encerrar" = "s" ] || [ "$Encerrar" = "n" ]; do
		echo "Pretende encerrar o programa para organizar o álbum de fotos outro dia? (s/n)"
		read Encerrar
		Encerrar=`echo "$Encerrar" | sed 's/S/s/g;s/N/n/g'`
	done
	if [ "$Encerrar" = "s" ]; then
		exit 0
	fi
done
