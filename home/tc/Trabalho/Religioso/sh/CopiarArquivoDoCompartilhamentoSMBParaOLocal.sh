FuncaoAjudaDoProgramaCopiarArquivoDoCompartilhamentoSMBParaOLocal(){
	echo "$0 \"Identificacao do compartilhamento SMB, localizado no arquivo de senhas.db. Ex: 'ad', 'ad1', etc.\" \"Caminho até o arquivo na pasta compartilhada. Exemplo: 'SAUDE/ATENCAOBASICA/Tiago_DAB/c.txt'.\" \"Arquivo de destino onde ele será baixado.\""
	exit $?
}

FuncaoPrincipalDoProgramaCopiarArquivoDoCompartilhamentoSMBParaOLocal(){
	if [ -z "$1" ] || [ -z "$2" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
		FuncaoAjudaDoProgramaCopiarArquivoDoCompartilhamentoSMBParaOLocal
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
		ArquivoDeSenhas="$PastaPadraoDosProgramasQueCrio/BancoDeDados/senhas.db"
		UsuarioESenha=`sed -r "/^${1}=/!d;s/(.*=)([^\]{1,200})([\])([^:]{1,200})([:])([^;]{1,200})([;].*)/\2\3\3\4%\6/g" "$ArquivoDeSenhas"`
		Compartilhamento=`sed -r "/^${1}=/!d;s/^(.*smb[:])([^;]{1,100})$/\2/g" "$ArquivoDeSenhas"`
		PastaCompartilhadaOndeEstaOArquivo="${2%/*}"
		ArquivoASerBaixado="${2##*/}"
		PastaOndeSeraBaixadoOArquivo="${3%/*}"
		cd "$PastaOndeSeraBaixadoOArquivo"
		smbclient -U $UsuarioESenha $Compartilhamento -c "prompt ; cd $PastaCompartilhadaOndeEstaOArquivo ; mget $ArquivoASerBaixado"
		exit $?
	fi
}

FuncaoPrincipalDoProgramaCopiarArquivoDoCompartilhamentoSMBParaOLocal "$1" "$2" "$3"
