#!/bin/sh

FuncaoAjudaDoProgramaDocxParaTXT(){
	echo "$0 \"Pasta onde estão os arquivos do tipo docx.\" \"Pasta onde será gerada os arquivos com o mesmo nome, mas de extensao txt. Caso não exista a pasta, será criada uma nova.\""
	exit 48
}

FuncaoPrincipalDoProgramaDocxParaTXT(){
	if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
		FuncaoAjudaDoProgramaDocxParaTXT
	else
		for ArquivoDoTipoDocx in "${1}"/*.docx ; do
			NomeDoArquivoSemAsPastasQueAntecedem="${ArquivoDoTipoDocx##*/}"
			ConteudoDoArquivoJaConvertidoParaTXT=`unzip -p "$ArquivoDoTipoDocx" word/document.xml | sed -e ':a;$!N;s/<w:rPr>/\r\n/;ta' | sed -r 's/([<][^>]{1,5000}[>])//g'`
			echo "$ConteudoDoArquivoJaConvertidoParaTXT" > "${2}/${NomeDoArquivoSemAsPastasQueAntecedem%.docx}.txt"
		done
	fi
}

if [ ! -d "$2" ]; then
	mkdir -p "$2"
fi

FuncaoPrincipalDoProgramaDocxParaTXT "$1" "$2"
exit 0
