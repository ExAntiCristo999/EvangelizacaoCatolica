#!/bin/sh
ArquivoDeConfiguracoesParticulares="$PastaDeArquitetura/Rede.sh"
if [ ! -s "$ArquivoDeConfiguracoesParticulares" ]; then
	sudo touch "$ArquivoDeConfiguracoesParticulares"
	sudo chmod 777 "$ArquivoDeConfiguracoesParticulares"
	echo -e "sudo killall udhcpc\n#sudo ifconfig eth0 192.168.24.24 netmask 255.255.255.0 up\n#route del default\n#route add default\nsudo ifconfig eth1 up\nsudo udhcpc -i eth1" > "$ArquivoDeConfiguracoesParticulares"
	vim "$ArquivoDeConfiguracoesParticulares"
fi
if [ -s "$ArquivoDeConfiguracoesParticulares" ]; then
	sh "$ArquivoDeConfiguracoesParticulares"
fi
