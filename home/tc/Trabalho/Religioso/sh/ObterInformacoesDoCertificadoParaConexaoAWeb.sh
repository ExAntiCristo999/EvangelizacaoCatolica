if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
	echo "$0 \"Localização do Certificado.\""
	exit 1
fi

FuncaoPrincipalDoProgramaObterInformacoesDoCertificadoX509ParaConexaoAWeb(){
	if [ -z "$TERMUX_VERSION" ]; then
		InstalarProgramasNoCoreLinux.sh ca-certificates
	fi
	openssl x509 -in "$1" -text
}

FuncaoPrincipalDoProgramaObterInformacoesDoCertificadoX509ParaConexaoAWeb "$1"
