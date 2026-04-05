NumeroDePaginas=`sed -r '/NumberOfPages:/!d;s/(.* )(.*)/\2/g' doc_data.txt`
ListaNaoFormatada=`sed -r '/BookmarkTitle:/!d;s/(.*: )(.*)/\2/g' doc_data.txt | sed 's/&#13;//g;s/&#205;/i/g;s/&#211;/o/g;s/&#201;/e/g;s/&#195;/a/g;s/&#193;/a/g;s/&#199;/c/g;s/&#213;/o/g;s/&#202;/e/g;s/&#218;/u/g;s/&#212;/o/g;s/&#194;/a/g;s/\.//g;s/,//g'`
NumerosDePaginasDeCapitulos=`sed -r '/BookmarkPageNumber:/!d;s/(.*: )(.*)/\2/g' doc_data.txt`
NumeroTotalDeCapitulos=`echo "$ListaNaoFormatada" | wc -l`
for OrdemNumerica0 in $( seq 1 $NumeroTotalDeCapitulos ); do
	titulo=`echo "$ListaNaoFormatada" | sed -n ${OrdemNumerica0}p`
	NumeroDaPaginaInicialDeUmCapitulo=`echo "$NumerosDePaginasDeCapitulos" | sed -n ${OrdemNumerica0}p`
	if [ "$OrdemNumerica0" -lt "$NumeroTotalDeCapitulos" ]; then
		OrdemNumerica0Mais1="$(( $OrdemNumerica0 + 1 ))"
		NumeroDaPaginaInicialDoCapituloSeguinte=`echo "$NumerosDePaginasDeCapitulos" | sed -n ${OrdemNumerica0Mais1}p`
		NumeroFinalDoCapituloAtual="$(( $NumeroDaPaginaInicialDoCapituloSeguinte - 1 ))"
	else
		NumeroFinalDoCapituloAtual="$NumeroDePaginas"
	fi
	capitalizacao="s"
	resultado=""
	for OrdemNumerica in $( seq 0 ${#titulo} ); do
		if [ "${titulo:$OrdemNumerica:1}" != " " ]; then
			if [ "$capitalizacao" = "n" ]; then
				Letra=`echo "${titulo:$OrdemNumerica:1}" | tr 'A-Z' 'a-z'`
				resultado="$resultado$Letra"
			else
				resultado="$resultado${titulo:$OrdemNumerica:1}"
				capitalizacao="n"
			fi
		else
			resultado="$resultado"
			capitalizacao="s"
		fi
	done
	if [ -n "$resultado" ]; then
		mkdir -p "$resultado"
	fi
	for OrdemNumerica1 in $( seq $NumeroDaPaginaInicialDeUmCapitulo $NumeroFinalDoCapituloAtual ); do
		PaginaAtual=`AdicionarZerosAEsquerdaDoNumero.sh "$OrdemNumerica1" 4`
		if [ -d "$resultado" ]; then
			cp "pagina_${PaginaAtual}.txt" "$resultado"
		fi
	done
done
