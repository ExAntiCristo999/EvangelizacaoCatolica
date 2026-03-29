#!/bin/sh

ajuda(){
	echo "$0 \"Arquivo TCZ a ser selecionado para exibir todas as suas dependências.\" \"Pasta de destino onde as dependências serão copiadas, ou nada para exibir as dependências.\""
	exit 300
}

ConteudoDoArquivoDEP(){
	if [ "$NumeroDeArquivosASeremExibidosDepoisDaChecagem" -ne "0" ]; then
		NumeroDeArquivosASeremExibidosAntesDaChecagem="$NumeroDeArquivosASeremExibidosDepoisDaChecagem"
		ListaDeArquivosASeremPesquisados="$ListaDeArquivosNoDEP"
	else
		ListaDeArquivosASeremPesquisados="$ListadeArquivosASeremExibidos"
	fi
	ListaDeArquivosNoDEP=""
	for ArquivoTCZDaLista in ${ListaDeArquivosASeremPesquisados} ; do
		if [ -s "${ArquivoTCZDaLista}.dep" ]; then
			KernelDoLinux=`uname -r`
			ConteudoDoArquivoDEPSemOCaminhoCompleto=`sed "s/KERNEL/${KernelDoLinux}/g" ${ArquivoTCZDaLista}.dep`
			ConteudoDoArquivoDEP=""
			for ArquivoTCZDentroDoDEP in $ConteudoDoArquivoDEPSemOCaminhoCompleto ; do
				if [ -n "$1" ]; then
					ConteudoDoArquivoDEP=`echo -e "${ConteudoDoArquivoDEP}\nsudo cp \"${PastaAbsolutaDoTCZNoHD}\"/${ArquivoTCZDentroDoDEP} ${1}/" | grep -E "[.][t][c][z]"`
				else
					ConteudoDoArquivoDEP=`echo -e "${ConteudoDoArquivoDEP}\n${ArquivoTCZDentroDoDEP}" | grep -E "[.][t][c][z]"`
				fi
			done
			ListadeArquivosASeremExibidos=`echo -e "${ListadeArquivosASeremExibidos}\n${ConteudoDoArquivoDEP}" | grep -E "[.][t][c][z]" | sort | uniq`
			ListaDeArquivosNoDEP=`echo -e "${ListaDeArquivosNoDEP}\n${ConteudoDoArquivoDEP}" | grep -E "[.][t][c][z]" | sort | uniq`
		fi
	done
	NumeroDeArquivosASeremExibidosDepoisDaChecagem=`echo "$ListadeArquivosASeremExibidos" | wc -l`
	DiferencaEntreAListaAntesEDepois=`expr ${NumeroDeArquivosASeremExibidosDepoisDaChecagem} - ${NumeroDeArquivosASeremExibidosAntesDaChecagem}`
}

principal(){
	if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
		ajuda
	fi
	PastaInicial="${PWD}"
	CaminhoDoArquivoTCZ=`echo "$1" | grep -E "[a-zA-Z0-9]{1,100}[.][t][c][z]$"`
	if [ -n "$CaminhoDoArquivoTCZ" ]; then

		PastaRelativaDoTCZ="${1%/*}"
		if [ -n "$PastaRelativaDoTCZ" ]; then
			cd "$PastaRelativaDoTCZ"
			PastaAbsolutaDoTCZNoHD="$PWD"
		fi
		PastaAbsoluta="$PWD"
		NumeroDeArquivosASeremExibidosAntesDaChecagem="1"
		NumeroDeArquivosASeremExibidosDepoisDaChecagem="0"
		DiferencaEntreAListaAntesEDepois="100"
		ArquivoTCZ="${1##*/}"
		if [ -n "$2" ]; then
			ListadeArquivosASeremExibidos=`echo "sudo cp \"${PastaAbsolutaDoTCZNoHD}\"/${ArquivoTCZ} ${2}/"`
		else
			ListadeArquivosASeremExibidos=`echo "$ArquivoTCZ"`
		fi
		until [ "$DiferencaEntreAListaAntesEDepois" -eq "0" ]; do
			ConteudoDoArquivoDEP "$2"
		done
	else
		ajuda
	fi
	if [ -n "$2" ]; then
		echo "${ListadeArquivosASeremExibidos}" | sh
	else
		echo "${ListadeArquivosASeremExibidos}"
	fi
	cd "${PastaInicial}"
	exit 0
}

principal "$1" "$2"
