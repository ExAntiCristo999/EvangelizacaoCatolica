FuncaoAjudaDoProgramaAlterarSenhaDoUsuarioNoServidorQueRodaOActiveDirectory(){
	echo "$0 \"Usuário AD\" \"Senha antiga\" \"Senha nova\" \"Perfil do usuário. Ex: Profissional.\""
	exit $?
}

FuncaoPrincipalDoProgramaAlterarSenhaDoUsuarioNoServidorQueRodaOActiveDirectory(){
	if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ] || [ -z "$2" ] || [ -z "$3" ]; then
		FuncaoAjudaDoProgramaAlterarSenhaDoUsuarioNoServidorQueRodaOActiveDirectory
	else
		if [ -z "$TERMUX_VERSION" ]; then
			tce-load -il samba
		else
			SaidaDoComandoPkg=`( echo Y ) | pkg install samba`
			SaidaDoComandoPkg=""
			PastaDeConfiguracaoDoSamba="${PastaPadraoDosProgramasQueCrio%%/home*}/usr/etc/samba"
			if [ ! -d "$PastaDeConfiguracaoDoSamba" ]; then
				mkdir -p "$PastaDeConfiguracaoDoSamba"
			fi
			cp "${PastaPadraoDosProgramasQueCrio%%/home*}/usr/share/doc/samba/smb.conf.example" "$PastaDeConfiguracaoDoSamba/smb.conf"
		fi
		ArquivoDeSenhas="$PastaPadraoDosProgramasQueCrio/../../$4/db/"
		DominioOndeTrabalho=`sed -r '/search/!d;s/(search )(.*)/\2/g' /etc/resolv.conf`
		IPDoServidorAD=`nslookup $DominioOndeTrabalho | sed -r '/Server/!d;s/(.* )([0-9.]{7,25})/\2/g'`
		if [ -n "$2" ] && [ -n "$3" ] && [ -n "$IPDoServidorAD" ] && [ -n "$1" ]; then
			( echo $2 ; echo $3 ; echo $3 ) | smbpasswd -r $IPDoServidorAD -U $1 -s
			VariavelComOConteudoAtualizadoDasSenhas=`sed "s/$1:$2/$1:$3/g" $ArquivoDeSenhas`
			echo "$VariavelComOConteudoAtualizadoDasSenhas" > $ArquivoDeSenhas
		else
			echo -e "Erro no programa $0: falta um dos parâmetros após o igual:\nUsuario=$1\nSenhaAntiga=$2\nSenhaNova=$3\nIPDoServidorAD=$IPDoServidorAD\n"
			exit 2
		fi
	fi
}

FuncaoPrincipalDoProgramaAlterarSenhaDoUsuarioNoServidorQueRodaOActiveDirectory "$1" "$2" "$3" "$4"
