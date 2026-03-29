NomeDoProgramaPontoSh="${0##*/}"
NomeDoPrograma="${NomeDoProgramaPontoSh%.sh}"
if [ ! -e "/usr/local/bin/busybox-static" ]; then
	tce-load -ilw busybox-static
	sudo rm -f /usr/local/bin/busybox-static
	sudo cp /tmp/tcloop/busybox-static/usr/local/bin/busybox-static /usr/local/bin/
	sudo chmod 777 /usr/local/bin/busybox-static
fi
CarregarConfiguracoesDeTecladoNoCoreLinux.sh
tce-load -ilw gpm
sudo gpm -m /dev/psaux -t ps2
ArquivoComComandosAntesDeLiberarOTerminal="$PastaDeArquitetura/AntesDeLiberarOTerminal.sh"
tce-load -ilw vim
if [ ! -s "$ArquivoComComandosAntesDeLiberarOTerminal" ]; then
	sudo touch "$ArquivoComComandosAntesDeLiberarOTerminal"
	sudo chmod 777 "$ArquivoComComandosAntesDeLiberarOTerminal"
        echo -e "SincronizarHoraDoRelogioAtomicoMaisProximoPeloCoreLinux.sh\nif [ \"\$?\" -ne \"0\" ]; then\n\texit \$?\nfi\nAposConfigurarAInternetEORelogio.sh\nbusybox-static sh ${PastaDeArquitetura}ComandosQueMudamComFrequencia.sh" > $ArquivoComComandosAntesDeLiberarOTerminal
	vim $ArquivoComComandosAntesDeLiberarOTerminal
	echo "echo \"Comandos que mudam com freqüência\"" > ${PastaDeArquitetura}ComandosQueMudamComFrequencia.sh
	vim ${PastaDeArquitetura}ComandosQueMudamComFrequencia.sh
fi
if [ -s "$ArquivoComComandosAntesDeLiberarOTerminal" ]; then
	ApagarArquivosGeradosPeloComandoVim.sh
	sh $ArquivoComComandosAntesDeLiberarOTerminal
fi
if [ "$ArquiteturaDoProcessadorDesteComputador" = "x86_64" ]; then
	sudo mkdir -p /lib64
	sudo ln -s /lib/ld-linux-x86-64.so.2 /lib64/
fi
