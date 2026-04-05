NomeDoProgramaPontoSh="${0##*/}"
NomeDoPrograma="${NomeDoProgramaPontoSh%.sh}"
TerminouAConfiguracaoDoTeclado="n"
PastaDoTeclado="$PastaComArquivosTemporariosDosProgramasQueCrio/Teclado"
if [ ! -d "$PastaDoTeclado" ]; then
	sudo mkdir -p \"$PastaDoTeclado\"
	sudo chmod -R 777 \"$PastaDoTeclado\"
fi
tce-load -ilw kmaps
until [ "$TerminouAConfiguracaoDoTeclado" = "s" ]; do
	ArquivoComComandosParaReconhecerTeclado="$PastaDeArquitetura/Teclado.sh"
	if [ ! -s "$ArquivoComComandosParaReconhecerTeclado" ]; then
		Listao="$PastaDoTeclado/Listao.txt"
		find -L /usr/share/kmap/ -type f > "$Listao"
		EscolhaUmaDasSeguintesOpcoes.sh "a" "$Listao" "Escolha um mapa de teclado compatível ou que apresente o maior número de teclas funcionando, caso seja um teclado multimídia ou de notebook." "" "$NomeDoPrograma"
		ArquivoDeLocalizacaoDoKmap=`find $PastaComArquivosTemporariosDosProgramasQueCrio/EscolhaUmaDasSeguintesOpcoes/$NomeDoPrograma -type f`
		ComandoParaCarregarOMapaDeTeclado=`sed -r 's/(.*=)(.*)/sudo loadkmap < \2"/g' $ArquivoDeLocalizacaoDoKmap`
		rm -f $ArquivoDeLocalizacaoDoKmap
		sudo touch \"$ArquivoComComandosParaReconhecerTeclado\"
		sudo chmod 777 \"$ArquivoComComandosParaReconhecerTeclado\"
		echo -e "#busybox-static showkey\n#tce-load -il kbd\n#edite um MapaDeUmPais.map com os códigos do teclado incomum\n#loadkeys MapaDeUmPais.map\n#dumpkmap > MapaDeTecladoIncomum.kmap\n#(sed -n 2p /home/tc/Trabalho/Profissional/db/senhas.db | cut -d ":" -f 2) | su root -c \"loadkmap < MapaDeTecladoIncomum.kmap\"\n$ComandoParaCarregarOMapaDeTeclado" > "$ArquivoComComandosParaReconhecerTeclado"
	fi
	if [ -s "$ArquivoComComandosParaReconhecerTeclado" ]; then
		sh "$ArquivoComComandosParaReconhecerTeclado"																			
	fi
	TerminouAConfiguracaoDoTeclado="s"
	ArquivoDeOcultarPerguntasDoTeclado="$PastaDeArquitetura/Trava.txt"
	if [ ! -e "$ArquivoDeOcultarPerguntasDoTeclado" ]; then
		echo "Teste as teclas do teclado aqui"
		read TesteTeclado
		PerguntaTeclado=`echo -e "Sim.\nNão.\nTeclado com algumas teclas funcionando."`
		EscolhaUmaDasSeguintesOpcoes.sh "v" "$PerguntaTeclado" "O teclado esta funcionando todas as teclas." "" "$NomeDoPrograma"
		ArquivoDeResposta=`find $PastaComArquivosTemporariosDosProgramasQueCrio/EscolhaUmaDasSeguintesOpcoes/$NomeDoPrograma -type f`
		Resposta2DoTeclado=`sed -r 's/(.*=)(.*)/\2/g' $ArquivoDeResposta`
		rm -f $ArquivoDeResposta
		if [ "$Resposta2DoTeclado" = "Sim." ]; then
			TerminouAConfiguracaoDoTeclado="s"
		elif [ "$Resposta2DoTeclado" = "Não." ]; then
			TerminouAConfiguracaoDoTeclado="n"
		elif [ "$Resposta2DoTeclado" = "Teclado com algumas teclas funcionando." ]; then
			CorrecaoDeTeclas="n"
			tce-load -ilw kbd-dev
			wget -c "http://www.tinycorelinux.net/11.x/x86_64/tcz/src/kbd/kbd-2.2.0.tar.xz" -O "$PastaDeArquitetura/kbd-2.2.0.tar.xz"
			cd "$PastaComArquivosTemporariosDosProgramasQueCrio/MapaDeTeclado"
			tar -xf kbd-2.2.0.tar.xz
			until [ "$CorrecaoDeTeclas" = "s" ]; do
				cd kbd
				MapasDeTeclados=`find . -iname "*.map"`
				EscolhaUmaDasSeguintesOpcoes.sh "v" "$MapasDeTeclados" "Escolha um mapa de teclado, que será alterado." "" "$NomeDoPrograma"
				ArquivoComOMapaDeTecladoEscolhido=`find $PastaComArquivosTemporariosDosProgramasQueCrio/EscolhaUmaDasSeguintesOpcoes/$NomeDoPrograma -type f`
				echo "Selecione uma tecla que ainda não funciona."
				PastaBase="$PastaComArquivosTemporariosDosProgramasQueCrio/$NomeDoPrograma"
				if [ ! -d "$PastaBase" ]; then
					sudo mkdir -p \"$PastaBase\""
					sudo chmod -R 777 \"$PastaBase\""
				fi
				busybox-static showkey &> "$PastaBase/TeclaQueNaoFunciona.txt"
				MapaDeTecladoSelecionadoParaEdicao=`sed -r 's/(.*=)(.*)/\2/g' $ArquivoComOMapaDeTecladoEscolhido`
				rm -f "$ArquivoComOMapaDeTecladoEscolhido"
				vim "$MapaDeTecladoSelecionadoParaEdicao"
				loadkeys "$MapaDeTecladoSelecionadoParaEdicao"
				echo "Teste as teclas que não funcionavam antes"
				read Teste2
				echo "Digite o nome do mapa de teclado personalizado. Recomendo colocar o nome do teclado multimídia ou do notebook."
				read MapaDeTeclado
				sudo dumpkmap > ${MapaDeTeclado}.kmap"
				sudo loadkmap < ${MapaDeTeclado}.kmap"
				echo "O teclado funciona todas as teclas agora?"
				read CorrecaoDeTeclas
				CorrecaoDeTeclas=`echo "$CorrecaoDeTeclas" | sed 'y/SN/sn/'`
				echo "sudo loadkmap < $PWD/${MapaDeTeclado}.kmap" > "$ArquivoComComandosParaReconhecerTeclado"
			done
			TerminouAConfiguracaoDoTeclado="s"
		else
			TerminouAConfiguracaoDoTeclado="n"
		fi
		echo "Terminou" > "$ArquivoDeOcultarPerguntasDoTeclado"
	fi
done	
