#!/bin/sh

FuncaoAjudaDoCopiarCertificadosDoTipoX509EBarraOuChaveMestraDoTipoRsaDeUmSiteParaOComputadorComCoreLinux(){
	echo "$0 \"HOST:443. Exemplo: 'www.toledo.pr.gov.br:443'\" \"Nome do programa, que acessa o site, especificado no parâmetro 1, de até 1000 caracteres, e sem letras acentuadas. Exemplo: 'VerificarProtocoloDeFerias'\""
	exit $?
}

FuncaoVerificarSeOsParametrosDeEntradaVirgulaPassadosAoProgramaCopiarCertificadoDoTipoX509EBarraOuChaveMestraDoTipoRsaDeUmSiteParaOComputadorComCoreLinuxVirgulaAtendemOsRequisitosDesteVirgulaUsandoOMetodoDasExpressoesRegulares(){
	[[ $1 =~ "^[.a-z0-9-]{0,500}[:]443$" ]] || FuncaoAjudaDoCopiarCertificadosDoTipoX509EBarraOuChaveMestraDoTipoRsaDeUmSiteParaOComputadorComCoreLinux
	[[ $2 =~ "^[a-zA-Z0-9]{1,1000}$" ]] || FuncaoAjudaDoCopiarCertificadosDoTipoX509EBarraOuChaveMestraDoTipoRsaDeUmSiteParaOComputadorComCoreLinux
}

FuncaoPrincipalDoProgramaCopiarCertificadosDoTipoX509EBarraOuChaveMestraDoTipoRsaDeUmSiteParaOComputadorComCoreLinux(){
	if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
		FuncaoAjudaDoCopiarCertificadosDoTipoX509EBarraOuChaveMestraDoTipoRsaDeUmSiteParaOComputadorComCoreLinux
	else
		FuncaoVerificarSeOsParametrosDeEntradaVirgulaPassadosAoProgramaCopiarCertificadoDoTipoX509EBarraOuChaveMestraDoTipoRsaDeUmSiteParaOComputadorComCoreLinuxVirgulaAtendemOsRequisitosDesteVirgulaUsandoOMetodoDasExpressoesRegulares $*
		CaminhoCompletoAteEsteProgramaSemOSufixoPontoSh="${0%.sh}"
		NomeDestePrograma="${CaminhoCompletoAteEsteProgramaSemOSufixoPontoSh##*/}"
		Parametro2ContendoONomeDeUmProgramaBusyboxQueCriei="$2"
		AdicionouOsCertificadosNovos="n"
		until [ "$AdicionouOsCertificadosNovos" = "s" ]; do
			NomeDaPastaParaOndeSeraOuSeraoCopiadosOsCertificadosDoTipoX509EBarraOuChavesMestraDoTipoRsaUmSiteParaOComputadorComCoreLinux="$PastaDeArquitetura/PastaComACadeiaDeCertificadosX509/BaixadosPeloPrograma/$NomeDestePrograma/ExecutadoPeloPrograma/$2/ASerExecutadoPeloComandoEmMinusculo/SudoEspacoUpdateHifenCaHifenCertificates"
			if [ ! -d "$NomeDaPastaParaOndeSeraOuSeraoCopiadosOsCertificadosDoTipoX509EBarraOuChavesMestraDoTipoRsaUmSiteParaOComputadorComCoreLinux" ]; then
				mkdir -p "$NomeDaPastaParaOndeSeraOuSeraoCopiadosOsCertificadosDoTipoX509EBarraOuChavesMestraDoTipoRsaUmSiteParaOComputadorComCoreLinux"
			else
				rm -f "$NomeDaPastaParaOndeSeraOuSeraoCopiadosOsCertificadosDoTipoX509EBarraOuChavesMestraDoTipoRsaUmSiteParaOComputadorComCoreLinux"/*
			fi
			ArquivoContendoACadeiaDeCertificados="$NomeDaPastaParaOndeSeraOuSeraoCopiadosOsCertificadosDoTipoX509EBarraOuChavesMestraDoTipoRsaUmSiteParaOComputadorComCoreLinux/$2.crt"
			if [ ! -s "$ArquivoContendoACadeiaDeCertificados" ]; then
				openssl s_client -showcerts -connect $1 </dev/null 2>/dev/null | sed -n '/^-----BEGIN CERT/,/^-----END CERT/p' | sed -r 's/END CERTIFICATE-----/END CERTIFICATE-----\n/g' > $ArquivoContendoACadeiaDeCertificados
				sudo cp -Rf "$NomeDaPastaParaOndeSeraOuSeraoCopiadosOsCertificadosDoTipoX509EBarraOuChavesMestraDoTipoRsaUmSiteParaOComputadorComCoreLinux"/* /usr/local/share/ca-certificates/mozilla/ 2> /dev/null && sudo update-ca-certificates 2> /dev/null && AdicionouOsCertificadosNovos="s"
			fi
		done
	fi
}

FuncaoPrincipalDoProgramaCopiarCertificadosDoTipoX509EBarraOuChaveMestraDoTipoRsaDeUmSiteParaOComputadorComCoreLinux $*
