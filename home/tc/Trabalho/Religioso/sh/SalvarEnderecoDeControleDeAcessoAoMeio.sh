DesligarAInterfaceEthernet(){
	for OrdemNumerica in $( seq 0 5 ); do
		if [ "eth$OrdemNumerica" != "$IdentificacaoDaRedeUSB" ]; then
			sudo ifconfig eth$OrdemNumerica down
		fi
	done
}

SalvarEnderecoDeControleDeAcessoAoMeio(){
	DadosDoIfconfig=`ifconfig 2>&1`
	if [ "$USER" = "tc" ]; then
		usbParcial=`IdentificarSmartphoneAndroidNoCoreLinux.sh`
		usb="${usbParcial%%;*}"
		IdentificacaoDaRedeUSB="${usbParcial##*;}"
		if [ -n "$usb" ]; then
			EnderecoDeControleDeAcessoAoMeioFinal="$usb"
			sudo ifconfig wlan0 down
			DesligarAInterfaceEthernet
		else
			wlan0=`echo "$DadosDoIfconfig" | sed -r '/wlan0/!d;s/ +/ /g;s/ $//g;y/ABCDEF/abcdef/;s/(.* )((([a-f0-9]{2}([:]){0,1})){6,8})/\2/g;s/://g'`
			if [ -n "$wlan0" ]; then
				EnderecoDeControleDeAcessoAoMeioFinal="$wlan0"
				DesligarAInterfaceEthernet
				sudo ifconfig usb0 down
			else
				eth0=`echo "$DadosDoIfconfig" | sed -r '/eth0/!d;s/ +/ /g;s/ $//g;y/ABCDEF/abcdef/;s/(.* )((([a-f0-9]{2}([:]){0,1})){6,8})/\2/g;s/://g'`
				if [ -n "$eth0" ]; then
					EnderecoDeControleDeAcessoAoMeioFinal="$eth0"
					sudo ifconfig wlan0 down
					(sed -n 2p /home/tc/Trabalho/Profissional/db/senhas.db | cut -d ":" -f 2) | su root -c ifconfig eth$IdentificacaoDaRedeUSB down
				else
					echo "Erro no programa $0, função 'SalvarEnderecoDeControleDeAcessoAoMeio': não encontro nenhuma interface de rede."
					exit 1
				fi
			fi
		fi
	elif [ -n "$TERMUX_VERSION" ]; then
		ArquivoDoSmartphone="$PastaPadraoDosProgramasQueCrio/BancoDeDados/EnderecoDeControleDeAcessoAoMeio/Misto.db"
		EnderecoDeControleDeAcessoAoMeioFinal=`cat $ArquivoDoSmartphone`
		until [ -n "$EnderecoDeControleDeAcessoAoMeioFinal" ]; do
			echo "Inclua o Endereço de Controle de Acesso do Computador que roda o aplicativo Termux. Ex: 123456789012"
			read EnderecoDeControleDeAcessoAoMeioFinal
			EnderecoDeControleDeAcessoAoMeioFinal=`echo "$EnderecoDeControleDeAcessoAoMeioFinal" | grep -E "^[0-9a-f]{12,100}$"`
		done
	else
		echo "Erro no programa $0, função 'SalvarEnderecoDeControleDeAcessoAoMeio': ele não roda em outros programas, que não sejam o Termux, ou o Core Linux."
		exit 2
	fi
	PastaComEnderecoDeControleDeAcessoAoMeios="$PastaPadraoDosProgramasQueCrio/BancoDeDados/EnderecoDeControleDeAcessoAoMeio"
	if [ ! -d "$PastaComEnderecoDeControleDeAcessoAoMeios" ]; then
		mkdir -p "$PastaComEnderecoDeControleDeAcessoAoMeios"
	fi
	AveriguarEnderecoDeControleDeAcessoAoMeioAtualParcial=`grep -lR "$EnderecoDeControleDeAcessoAoMeioFinal" $PastaComEnderecoDeControleDeAcessoAoMeios/* 2> /dev/null`
	AveriguarEnderecoDeControleDeAcessoAoMeioAtual="${AveriguarEnderecoDeControleDeAcessoAoMeioAtualParcial%.*}"
	PastaTemporaria="$PastaComArquivosTemporariosDosProgramasQueCrio/$1"
	if [ ! -d "$PastaTemporaria" ]; then
		mkdir -p "$PastaTemporaria"
	fi
	TipoDeLocalDoPC="${AveriguarEnderecoDeControleDeAcessoAoMeioAtual##*/}"
	if [ -z "$TipoDeLocalDoPC" ]; then
		CasaTrabalhoOuMisto=`echo -e "Casa\nTrabalho\nMisto"`
		ArquivoTemporario="$PastaTemporaria/EscolhaOLocalParaEsteEnderecoDeControleDeAcessoAoMeio.tmp"
		EscolhaUmaDasSeguintesOpcoes.sh "$CasaTrabalhoOuMisto" "Este PC será usado onde?:" "" "$ArquivoTemporario"
		Conteudo=`while read l ; do echo "$l" ; done < "$ArquivoTemporario"`
		LocalEscolhido="${Conteudo#*=}"
		rm -f "$ArquivoTemporario"
		TipoDeLocalDoPC="$LocalEscolhido"
		echo "$EnderecoDeControleDeAcessoAoMeioFinal" >> "$PastaComEnderecoDeControleDeAcessoAoMeios/$LocalEscolhido.db"
	fi
	rm -f $PastaTemporaria/*
	echo "$EnderecoDeControleDeAcessoAoMeioFinal" > "$PastaTemporaria/$TipoDeLocalDoPC"
}

CaminhoAteOProgramaSemOSufixoPontoSh="${0%.sh}"
NomeDoPrograma="${CaminhoAteOProgramaSemOSufixoPontoSh##*/}"
SalvarEnderecoDeControleDeAcessoAoMeio "$NomeDoPrograma"
