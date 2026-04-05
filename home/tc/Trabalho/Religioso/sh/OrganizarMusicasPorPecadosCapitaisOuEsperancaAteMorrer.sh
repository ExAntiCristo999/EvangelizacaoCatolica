ajuda(){
	if [ -z "$1" ]; then
		echo "$0 \"Caminho completo onde serão organizados os txt.\""
		exit 1
	fi
}
ajuda "$1"
if [ ! -d "$1" ]; then
	mkdir -p "$1"
fi
NomeDoProgramaPontoSh="${0##*/}"
NomeDoPrograma="${NomeDoProgramaPontoSh%.sh}"
PastaBase="$PastaComArquivosTemporariosDosProgramasQueCrio/$NomeDoPrograma/"
if [ ! -d "$PastaBase" ]; then
	mkdir -p "$PastaBase"
fi
rm -rf $PastaBase/*
cookie="$PastaBase/cookie.txt"
Terminou="n"
until [ "$Terminou" = "s" ]; do
	echo "Digite o caractere inicial da banda musical."
	read Caractere
	Caractere=`echo "$Caractere" | tr 'a-z' 'A-Z'`
	echo "Terminou o caractere $Caractere (s/n)?"
	read Terminou
done
CaracterInicialDoNomeDosArtistas=`curl -b $cookie -c $cookie -s "https://www.letras.mus.br/letra/$Caractere/artistas.html" -H "User-Agent: $UserAgent" 2>&1`
SubDominio=`echo "$CaracterInicialDoNomeDosArtistas" | sed -r 's/<li>/\n<li>/g' | sed -r 's/<\/li></<\/li>\n</g' | sed -r '/<li><a href="\//!d' | cut -d "\"" -f 2 | grep -B 10000 "/mais-acessadas/" | grep -v "/mais-acessadas/"`
SegundosAtual1=`date +%s`
echo "$SubDominio" > "$PastaBase/$SegundosAtual1"
EscolhaUmaDasSeguintesOpcoes.sh "a" "$PastaBase/$SegundosAtual1" "Qual dos subdomínios pertencem à banda desejada?" "" "$NomeDoPrograma"
NomeDoArquivoDeEscolha=`find "$PastaComArquivosTemporariosDosProgramasQueCrio/EscolhaUmaDasSeguintesOpcoes/$NomeDoPrograma/" -type f`
BandaMusical=`cut -d "=" -f 2 "$NomeDoArquivoDeEscolha"`
rm -f "$NomeDoArquivoDeEscolha"
Todas=`curl -s -b $cookie -c $cookie "https://www.letras.mus.br$BandaMusical" -H "User-Agent: $UserAgent" 2>&1`
PastaDestinoDeTodasAsLetrasDeUmaBanda="$PastaBase/$BandaMusical"
if [ ! -d "$PastaDestinoDeTodasAsLetrasDeUmaBanda" ]; then
	mkdir -p "$PastaDestinoDeTodasAsLetrasDeUmaBanda"
fi
Terminou="n"
until [ "$Terminou" = "s" ]; do
	echo "Quer todas as letras de músicas ou uma discografia (t/d)?"
	read td
	td=`echo "$td" | tr 'A-Z' 'a-z'`
	echo "Terminou o caractere $td (s/n)?"
	read Terminou
done
if [ "$td" = "t" ]; then
	echo "$Todas" | sed -r 's/<div id="A" class="cnt-list-alp--letter/\n<div id="A" class="cnt-list-alp--letter/g' | sed -r 's/<div id="songList-overflowOptions"/\n<div id="songList-overflowOptions"/g' | sed '/<div id="A" class="cnt-list-alp--letter/!d' | sed 's/<a/\n<a/g' | sed -r '/<a/!d' | cut -d "\"" -f 4,6 > "$PastaDestinoDeTodasAsLetrasDeUmaBanda/Todas.csv"
	if [ "$2" = "d" ]; then
		PastaDeErro="$PastaDeErrosDosProgramasQueCrio/$NomeDoPrograma"
		if [ ! -d "$PastaDeErro" ]; then
			mkdir -p "$PastaDeErro"
		fi
		echo "$Todas" > "$PastaDeErro/$SegundosAtual1"
		exit 1
	fi
	ArquivoCSV="$PastaDestinoDeTodasAsLetrasDeUmaBanda/Todas.csv"
elif [ "$td" = "d" ]; then
	Discografia=`curl -s -b $cookie -c $cookie "https://www.letras.mus.br$BandaMusical" -H "User-Agent: $UserAgent" 2>&1 | sed -r 's/https/\nhttps/g' | sed -r 's/([^"]{1,400})(["].*)/\1/g' | sed -r '/^https/!d;/discografia/!d' | sort | uniq`
	EscolhaUmaDasSeguintesOpcoes.sh "v" "$Discografia" "Qual a discografia que tu quer?" "" "$NomeDoPrograma"
	NomeDoArquivoDeEscolha=`find "$PastaComArquivosTemporariosDosProgramasQueCrio/EscolhaUmaDasSeguintesOpcoes/$NomeDoPrograma/" -type f`
	Discografia=`cut -d "=" -f 2 "$NomeDoArquivoDeEscolha"`
	rm -f "$NomeDoArquivoDeEscolha"
	MusicasDoDisco=`curl -s -b $cookie -c $cookie "$Discografia" -H "User-Agent: $UserAgent" 2>&1`
	URLDaLetraENomeDaLetra=`echo "$MusicasDoDisco" | sed -r 's/\{"\@id":"https/\nhttps/g' | sed 's/}],/\n/g' | grep "MusicRecording" | sed -r 's/([^"]{1,300})(["].*,"name":")([^"]{1,300})(".*)/\1"\3/g'`
	NomeDaDiscografia=`echo "$Discografia" | cut -d "/" -f 5`
	echo "$URLDaLetraENomeDaLetra" > "$PastaDestinoDeTodasAsLetrasDeUmaBanda/${NomeDaDiscografia}.csv"
	ArquivoCSV="$PastaDestinoDeTodasAsLetrasDeUmaBanda/${NomeDaDiscografia}.csv"
else
	echo "Opção $td não é suportada."
	exit 2
fi
NumeroDeURLDaLetraENomeDaLetra=`wc -l "$ArquivoCSV" | cut -d " " -f 1`
until [ -n "$bm" ]; do
	echo "BandaMusical"
	read bm
done
until [ -n "$BandaMusicalPorExtenso" ]; do
	echo "Banda Musical"
	read BandaMusicalPorExtenso
done
until [ -n "$DenominacaoReligiosaDaBandaMusical" ]; do
	Gemini "Qual é a denominaçao religiosa da banda musical $BandaMusicalPorExtenso?" | jq -r .candidates[0].content.parts[0].text | less
	echo "Denominação religiosa da banda musical."
	read DenominacaoReligiosaDaBandaMusical
done
until [ "$inter" = "i" ] || [ "$inter" = "n" ]; do
	echo "'i' se a banda musical for internacional; 'n' se a banda for nacional."
	read inter
done
if [ ! -d "$1/csv" ]; then
	mkdir -p "$1/csv"
fi
for OrdemNumerica1 in $( seq 1 $NumeroDeURLDaLetraENomeDaLetra ); do
	Linha=`sed -n ${OrdemNumerica1}p "$ArquivoCSV"`
	URLDaLetra=`echo "$Linha" | cut -d "\"" -f 1`
	NomeDaLetra=`echo "$Linha" | cut -d "\"" -f 2`
	if [ "$inter" = "i" ]; then
		echo "https://www.letras.mus.br${URLDaLetra}traducao.html;$NomeDaLetra;$BandaMusicalPorExtenso;$bm;$DenominacaoReligiosaDaBandaMusical" >> "$1/csv/${bm}.csv"
	else
		echo "https://www.letras.mus.br${URLDaLetra};$NomeDaLetra;$BandaMusicalPorExtenso;$bm;$DenominacaoReligiosaDaBandaMusical" >> "$1/csv/${bm}.csv"
	fi
done
rm -f "$ArquivoCSV"
