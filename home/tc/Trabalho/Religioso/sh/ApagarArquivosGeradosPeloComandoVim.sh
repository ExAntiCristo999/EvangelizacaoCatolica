if [ "$USER" = "tc" ]; then
	cd /
elif [ -n "$TERMUX_VERSION" ]; then
	cd $HOME
else
	echo "Plataforma desconhecida."
	exit 1
fi
ArquiteturaDoProcessadorDesteComputador=`uname -m`
find home/ $PastaDeArquitetura/ opt/ SantissimaTrindade/ -iname "*~" -exec rm -f {} +
find home/ $PastaDeArquitetura/ opt/ SantissimaTrindade/ -iname ".*~" -exec rm -f {} +
