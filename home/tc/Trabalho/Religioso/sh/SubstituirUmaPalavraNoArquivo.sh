ExpressaoRegularPrefixo="$1"
ExpressaoRegularMeio="$2"
ExpressaoRegularSufixo="$3"
NomeDoProgramaSemOPrefixo="${0##*/}"
NomeDoPrograma="${NomeDoProgramaSemOPrefixo%.sh}"
PastaTemporaria="$PastaComArquivosTemporariosDosProgramasQueCrio/$NomeDoPrograma"
if [ ! -d "$PastaTemporaria" ]; then
	mkdir "$PastaTemporaria"
fi
a=`grep -ER "($1|^)($2)($3|$)" * | cut -d ":" -f 1 | sort | uniq`
until [ -z "$a" ]; do
	a=`grep -ER "($1|^)($2)($3|$)" * | cut -d ":" -f 1 | sort | uniq`
	if [ -n "$a" ]; then
		n=`echo "$a" | wc -l`
		for o in $( seq 1 $n ); do
			l=`echo "$a" | sed -n ${o}p`
			sed -r "s/($1|^)($2)($3|$)/\1$4\3/g" "$l" > $PastaTemporaria/ConteudoModificadoPeloComandoSed.tmp
			mv -f $PastaTemporaria/ConteudoModificadoPeloComandoSed.tmp "$l"
		done
	fi
done
