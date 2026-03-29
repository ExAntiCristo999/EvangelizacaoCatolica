FuncaoAjudaDoProgramaCopiarArquivoDoLocalParaOCompartilhamentoSMB(){
	AjudaDoProgramaQueCrieiParaOCoreLinuxOuParaOComputadorRodandoOTermux.sh "$0 \"Caminho completo até o arquivo no local.\" \"Prefixo ad, seguido ou não de um ou mais números, existente no arquivo de senhas. Ex: 'ad', 'ad1', 'ad2'.\" \"Caminho completo até a pasta, sem um prefixo como 'smb://192.168.1.112/Dados', onde será enviado o arquivo. Ex: 'SAUDE/ATENCAOBASICA/Tiago_DAB/'\""
	exit $?
}

FuncaoPrincipalDoProgramaCopiarArquivoDoLocalParaOCompartilhamentoSMB(){
	if [ -z "$1" ] || [ -z "$2" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
		FuncaoAjudaDoProgramaCopiarArquivoDoLocalParaOCompartilhamentoSMB
	else
		if [ -z "$TERMUX_VERSION" ]; then
			if [ "$ArquiteturaDoProcessadorDesteComputador" = "x86_64" ]; then
				tce-load -il samba readline7
			else
				tce-load -il samba3
			fi
		else
			pkg install samba
		fi
		ValidarParametro2=`echo "$2" | grep -E "^[a][d](|[0-9]{1,3})$"`
		if [ -z "$ValidarParametro2" ]; then
			FuncaoAjudaDoProgramaCopiarArquivoDoLocalParaOCompartilhamentoSMB
		fi
		PastaOndeEstaOArquivo="${1%/*}"
		ArquivoASerCopiado="${1##*/}"
		PastaOndeSeraCopiadoOArquivo="$3"
		ArquivoDeSenhas="$PastaPadraoDosProgramasQueCrio/BancoDeDados/senhas.db"
		UsuarioESenha=`sed -r "/^$2=/!d;s/(.*=)([^\]{1,200})([\])([^:]{1,200})([:])([^;]{1,200})([;].*)/\2\3\3\4%\6/g" "$ArquivoDeSenhas"`
		Compartilhamento=`sed -r "/^$2=/!d;s/^(.*smb[:])([^;]{1,100})$/\2/g" "$ArquivoDeSenhas"`
		smbclient -U $UsuarioESenha $Compartilhamento -c "prompt ; lcd $PastaOndeEstaOArquivo ; cd $PastaOndeSeraCopiadoOArquivo ; mput $ArquivoASerCopiado"
	fi
}

FuncaoPrincipalDoProgramaCopiarArquivoDoLocalParaOCompartilhamentoSMB "$1" "$2" "$3"
