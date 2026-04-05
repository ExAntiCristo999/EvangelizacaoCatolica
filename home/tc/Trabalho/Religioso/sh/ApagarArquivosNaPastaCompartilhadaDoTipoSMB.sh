FuncaoAjudaDoProgramaListarArquivosNaPastaCompartilhadaDoTipoSMB(){
	echo "$0 \"Prefixo ad, seguido ou não de um ou mais números, existente no arquivo de senhas. Ex: 'ad', 'ad1', 'ad2'.\" \"Caminho completo até a pasta, sem um prefixo como 'smb://192.168.1.112/Dados', onde será mostrado os arquivos e pastas existentes. Ex: 'SAUDE/ATENCAOBASICA/Tiago_DAB/'\""
	exit 1
}

FuncaoPrincipalDoProgramaListarArquivosNaPastaCompartilhadaDoTipoSMB(){
	if [ -z "$1" ] || [ -z "$2" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
		FuncaoAjudaDoProgramaListarArquivosNaPastaCompartilhadaDoTipoSMB
	else
		if [ -z "$TERMUX_VERSION" ]; then
			tce-load -il samba readline7
			sed 's/ISO-8859-1/UTF-8' /usr/local/etc/samba/smb.conf > /tmp/smb.conf
			sudo mv /tmp/smb.conf /usr/local/etc/samba/smb.conf
		else
			pkg install samba
		fi
		ValidarParametro1=`echo "$1" | grep -E "^[a][d](|[0-9]{1,3})$"`
		if [ -z "$ValidarParametro1" ]; then
			FuncaoAjudaDoProgramaListarArquivosNaPastaCompartilhadaDoTipoSMB
		fi
		ArquivoDeSenhas="$PastaPadraoDosProgramasQueCrio/BancoDeDados/senhas.db"
		UsuarioESenha=`sed -r "/^$1=/!d;s/(.*=)([^\]{1,200})([\])([^:]{1,200})([:])([^;]{1,200})([;].*)/\2\3\3\4%\6/g" "$ArquivoDeSenhas"`
		Compartilhamento=`sed -r "/^$1=/!d;s/^(.*smb[:])([^;]{1,100})$/\2/g" "$ArquivoDeSenhas"`
		smbclient -U $UsuarioESenha $Compartilhamento -c "rm $2"
	fi
}

FuncaoPrincipalDoProgramaListarArquivosNaPastaCompartilhadaDoTipoSMB "$1" "$2"
