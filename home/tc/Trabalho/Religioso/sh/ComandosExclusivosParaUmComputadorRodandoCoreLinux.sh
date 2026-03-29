#!/bin/sh

EnderecoFisicoDaPlacaDeRede=`sed -n 1p /tmp/IdentificacaoDaPlacaDeRedeCabeadaOuWireless.txt`
ArquivoComComandosAposSeConectarAInternet="$PastaDeArquitetura/ArquivoComComandosAposSeConectarAInternet.sh"
ArquivoComComandosQueMudamComFrequencia="$PastaDeArquitetura/ArquivoComComandosQueMudamComFrequencia.sh"
if [ ! -s "$ArquivoComComandosQueMudamComFrequencia" ]; then
	echo -e "#!/bin/sh\necho \"Rodando o programa com comandos que mudam com frequência.\"" > $ArquivoComComandosQueMudamComFrequencia
	sudo chmod 777 $ArquivoComComandosQueMudamComFrequencia
fi
if [ ! -s "$ArquivoComComandosAposSeConectarAInternet" ]; then
	echo -e "SincronizarHoraDoRelogioAtomicoMaisProximoPeloCoreLinux.sh\nif [ \"\$?\" -ne \"0\" ]; then\n\texit \$?\nfi\nAgendaDeCompromissosPessoal.sh v &\nRodarComandosFinaisEssenciaisNoComputadorComTermuxOuComCoreLinuxQueEstaComORelogioEComAInternetRodandoNormalmente.sh\n\$ArquiteturaDoProcessadorDesteComputador/ArquivoComComandosQueMudamComFrequencia.sh" > $ArquivoComComandosAposSeConectarAInternet
	sudo chmod 777 $ArquivoComComandosAposSeConectarAInternet
fi
ApagarArquivosGeradosPeloComandoVim.sh
$SHELL $ArquivoComComandosAposSeConectarAInternet
