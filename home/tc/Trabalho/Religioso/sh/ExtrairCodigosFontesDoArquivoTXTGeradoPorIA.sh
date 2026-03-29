ajuda(){
	if [ -z "$1" ] || [ -z "$2" ]; then
		echo "$0 \"Arquivo gerado pela IADoGemini.sh\" \"Pasta onde serão salvos os códigos fontes extraídos do arquivo do parâmetro 1\""
		exit 1
	fi
}
ajuda "$1" "$2"

ArquivoDeEntrada="$1"
PastaDeSaida="$2"
if [ ! -d "$PastaDeSaida" ]; then
	mkdir -p "$PastaDeSaida"
fi
Contador=0
sed -n '/^```/{
:loop
N
/^```$/!b loop
s/^```\(.*\)\n\(.*\)\n```/\1@@@\2/
p
}' "$ArquivoDeEntrada" | while IFS='@@@' read -r SiglaDaLinguagemDeProgramacao ConteudoDelimitadoPorDuasLinhasContendoApenasTresCrasesUsadasPelaIAParaArmazenarCodigosFontesDeProgramasDeComputador; do
if [ -n "$SiglaDaLinguagemDeProgramacao" ]; then
	ExtensaoDoArquivo=".$SiglaDaLinguagemDeProgramacao"
	SegundosAtual=`date +%s`
	NomeDeUmArquivoDeCodigoFonte="$PastaDeSaida/CodigoFonteExtraidoDeUmArquivoGeradoPorIANoTempoUTCIgualA${SegundosAtual}${ExtensaoDoArquivo}"
else
	NomeDeUmArquivoDeCodigoFonte="$PastaDeSaida/CodigoFonteExtraidoDeUmArquivoGeradoPorIANoTempoUTCIgualA${SegundosAtual}.txt"
fi
SiglaDaLinguagemDeProgramacao=$(echo "$SiglaDaLinguagemDeProgramacao" | tr -d ' ')
echo "$ConteudoDelimitadoPorDuasLinhasContendoApenasTresCrasesUsadasPelaIAParaArmazenarCodigosFontesDeProgramasDeComputador" > "$NomeDeUmArquivoDeCodigoFonte"
done
