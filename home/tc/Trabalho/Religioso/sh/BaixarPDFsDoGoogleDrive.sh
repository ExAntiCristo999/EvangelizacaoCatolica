ajuda(){
	if [ -z "$1" ]; then
		echo "$0 \"URL do arquivo PDF no Google Drive, que o proprietário compartilhou.\" \"Local onde será salvo o arquivo; ou vazio caso deseje apenas saber o nome do arquivo no servidor.\""
		exit 1
	fi
}

ajuda "$1"
ConteudoDaPaginaQueCarregaOPDF=`wget -c "$1" -qO - 2>&1`
NomeDoArquivoDadoPeloProprietario=`echo "$ConteudoDaPaginaQueCarregaOPDF" | sed -r 's/</\n</g' | sed -r '/<title>/!d;s/(<title>)([^<]{1,1200})/\2/g;s/ - Google Drive//g'`
if [ -z "$2" ]; then
	echo "$NomeDoArquivoDadoPeloProprietario"
else
	URLParaExportarParaPDF=`echo "$ConteudoDaPaginaQueCarregaOPDF" | sed -r 's/</\n</g' | sed -r '/download/!d;s/\"/\n/g' | sed -r '/download/!d;s/\\\u003d/=/g;s/\\\u0026/\&/g'`
	wget -c "$URLParaExportarParaPDF" -qO "$NomeDoArquivoDadoPeloProprietario"
fi
