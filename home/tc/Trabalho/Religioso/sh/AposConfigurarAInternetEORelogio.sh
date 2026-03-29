
FuncaoRodarServidorHttpNoComputadorComTermux(){
	SaidaDoComandoPkg=`( echo Y ) | pkg install busybox vim 2>&1`
	SaidaDoComandoPkg=""
	echo -e "termux-wake-lock\nPS1='\e[36m \u@ \$( date \"+%a, %d/%m/%Y às %T, ou seja, %s segundos desde 01/01/1970 às 00:00:00 do fuso horário UTC0, atribuído como referência à Londres, Inglaterra\" | sed -r \"s/Sun/Domingo/g;s/Mon/Segunda/g;s/Tue/Terça/g;s/Wed/Quarta/g;s/Thu/Quinta/g;s/Fri/Sexta/g;s/Sat/Sábado/g\" ) : \$PWD\/ : \?§ªº° : SaidaDoComandoAnterior=\$? : \$ \e[0m \\n'\nPastaDeArquitetura=\"\$HOME/Patrimonio\"\nexport PastaDeArquitetura\nPATH=\$HOME/home/tc/Trabalho/Religioso/sh:\$PATH\nexport PS1 PATH\nexport PastaPadraoDosProgramasQueCrio=\$HOME/home/tc/Trabalho/Religioso/sh\nArquiteturaDoProcessadorDesteComputador=\`uname -m\`\nexport PastaDeDadosDeConexoesHttpOuHttps=\$HOME/\$ArquiteturaDoProcessadorDesteComputador/HttpOuHttps\nexport PastaDeErrosDosProgramasQueCrio=\$HOME/\$ArquiteturaDoProcessadorDesteComputador/Erros\nVersaoDoNucleoDoSistemaOperacional=\`uname -r\`\nexport VersaoDoNucleoDoSistemaOperacional\nexport PastaComArquivosTemporariosDosProgramasQueCrio=\$HOME/\$ArquiteturaDoProcessadorDesteComputador/tmp\nmkdir -p \$HOME/\$ArquiteturaDoProcessadorDesteComputador/HttpOuHttps \$HOME/\$ArquiteturaDoProcessadorDesteComputador/Erros \$HOME/\$ArquiteturaDoProcessadorDesteComputador/tmp\nPropositosIntegrados=\"\$HOME/home/tc/Trabalho/PropositosIntegrados/db\"\nif [ ! -d \"\$PropositosIntegrados\" ]; then\n\tmkdir -p \"\$PropositosIntegrados\"\nfi" > ~/.profile
	PastaDeConfiguracoes="$HOME/$ArquiteturaDoProcessadorDesteComputador/tmp"
	if [ ! -d $PastaDeConfiguracoes ]; then
		mkdir -p $PastaDeConfiguracoes
	fi
	echo "Modo servidor"
}

FuncaoRodarClienteHttpNoComputadorComCoreLinux(){
	echo "Modo cliente"
}

FuncaoPrincipalDoProgramaRodarComandosFinaisEssenciaisNoComputadorComTermuxOuComCoreLinuxQueEstaComORelogioEComAInternetRodandoNormalmente(){
	if [ -z "$TERMUX_VERSION" ]; then
		FuncaoRodarClienteHttpNoComputadorComCoreLinux
	else
		FuncaoRodarServidorHttpNoComputadorComTermux
	fi
}


ArquiteturaDoProcessadorDesteComputador=`uname -m`
FuncaoPrincipalDoProgramaRodarComandosFinaisEssenciaisNoComputadorComTermuxOuComCoreLinuxQueEstaComORelogioEComAInternetRodandoNormalmente
