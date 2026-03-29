NomeDoProgramaParcial1="${0##*/}"
NomeDoPrograma="${NomeDoProgramaParcial1%.sh}"
NomeDoArquivoXLSXParcial="${1##*/}"
NomeDoArquivoXLSX="${NomeDoArquivoXLSXParcial%.xlsx}"
PastaFinal="$PastaComArquivosTemporariosDosProgramasQueCrio/$NomeDoPrograma/$NomeDoArquivoXLSX"
if [ ! -d "$PastaFinal" ]; then
	mkdir -p "$PastaFinal"
fi
unzip -q "$1" -d "$PastaFinal"
for Arquivo in $PastaFinal/xl/worksheets/sheet*.xml ; do
	sed -r 's/<row/\n<row/g' "$Arquivo" | sed -r 's/<\/row><\/sheetData>/<\/row>\n<\/sheetData>/g' | sed -r '/<row r=/!d;s/<row r="[0-9]{1,10000}" spans="1:[0-9]{1,3}"( | ht="[0-9]{1,4}" )x14ac:dyDescent="0.[0-9]{1,20}">//g' | sed -r 's/(<c[^>]{1,200}>)//g;s/<\/c>//g;s/<\/row>//g;s/^<v>//g;s/<\/v>$//g;s/<\/v><v>/\;/g'
done
