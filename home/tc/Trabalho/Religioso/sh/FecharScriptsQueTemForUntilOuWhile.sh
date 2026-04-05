#!/bin/sh

FuncaoScriptsQueCrieiComForUntilOuWhileRodando(){
	until [ -s "$BancoDeDadosContendoOsProgramasQueContemWhileOuUntil" ]; do
		sleep 2
	done
	ScriptsQueCrieiContendoForUntilOuWhileCadastrados=`sed -r ':a;$!N;s/\n/\\\|/;ta;' "$BancoDeDadosContendoOsProgramasQueContemWhileOuUntil"`
	ScriptsQueCrieiComForUntilOuWhileRodando=`ps aux | grep "$ScriptsQueCrieiContendoForUntilOuWhileCadastrados" | grep -v grep`
}


principal(){
	until [ -n "$PastaPadraoDosProgramasQueCrio" ]; do
		PastaPadraoDosProgramasQueCrio=`PastaPadraoDosProgramasQueCrio.sh 2>&1 | grep "/"`
		sleep 2
	done
	ArquiteturaDoProcessador=`uname -m`
	CaminhoCompletoAoProgramaSemOSufixoPontoSh="${0%.sh}"
	NomeDoPrograma="${CaminhoCompletoAoProgramaSemOSufixoPontoSh##*/}"
	PastaOndeFicaOArquivoTMP="${PastaPadraoDosProgramasQueCrio%/home*}/${ArquiteturaDoProcessador}/tmp/${NomeDoPrograma}"
	if [ ! -d "$PastaOndeFicaOArquivoTMP" ]; then
		mkdir -p "$PastaOndeFicaOArquivoTMP"
	fi
	BancoDeDadosContendoOsProgramasQueContemWhileOuUntil="${PastaPadraoDosProgramasQueCrio}/BancoDeDados/ScriptsQueCrieiContendoForUntilOuWhileCadastrados.db"
	echo "e" > "${PastaOndeFicaOArquivoTMP}/${NomeDoPrograma}.tmp"
	FuncaoScriptsQueCrieiComForUntilOuWhileRodando
	until [ -z "$ScriptsQueCrieiComForUntilOuWhileRodando" ]; do
		FuncaoScriptsQueCrieiComForUntilOuWhileRodando
		sleep 5
	done
	if [ -s "${PastaOndeFicaOArquivoTMP}/${NomeDoPrograma}.tmp" ]; then
		rm -f "${PastaOndeFicaOArquivoTMP}/${NomeDoPrograma}.tmp"
	fi
}

principal
exit 0
