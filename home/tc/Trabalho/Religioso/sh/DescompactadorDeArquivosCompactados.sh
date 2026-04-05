ajuda(){
	echo "$0 \"Caminho completo até o arquivo compactado a ser descompactado na pasta atual.\""
	exit 2
}

principal(){
	if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
		ajuda
	else
		local FormatoTarGzip=`echo "$1" | grep -i "\.tar\.gz\|\.tgz"`
		local FormatoTarBzip2=`echo "$1" | grep -i "\.tar\.bz2\|\.tbz"`
		local FormatoTarXzip=`echo "$1" | grep -i "\.tar\.xz\|\.txz"`
		local FormatoZip=`echo "$1" | grep -i "\.zip"`
		local Formato7zip=`echo "$1" | grep -i "\.p7zip\|\.7z\|\.7zip"`
		local FormatoCabextract=`echo "$1" | grep -i "\.exe\|\.cab"`
		local FormatoRar=`echo "$1" | grep -i "\.rar"`
		if [ -n "$FormatoTarGzip" ]; then
			local Saida=`tar -xzvf "$1" 2>&1`
			exit $?
		elif [ -n "$FormatoTarBzip2" ]; then
			local Saida=`tar -xjvf "$1" 2>&1`
			exit $?
		elif [ -n "$FormatoTarXzip" ]; then
			local Saida=`tar -xJvf "$1" 2>&1`
			exit $?
		elif [ -n "$FormatoZip" ]; then

			local Saida=`busybox unzip "$1" 2>&1`
			exit $?
		elif [ -n "$Formato7zip" ]; then
			if [ "$USER" = "tc" ]; then
				tce-load -il p7zip
			else
				pkg
			7z x "$1" 2> $ArquivoContendoAErrosGeradosNoComandoDeDescompactacao
			7z l "$1" 1> $ArquivoContendoASaidaDeUmComandoDeDescompactacao
			local SaidaDoComandoDeDescompactacao=`echo "$?"`
			local SaidaDoComandoDescompactador=`cat $ArquivoContendoASaidaDeUmComandoDeDescompactacao | grep "\.\.\.\.A" | cut -c 54- | grep -v "^$"`
			Finalizador "$SaidaDoComandoDeDescompactacao" "7z x \"$1\""
		elif [ -n "$FormatoCabextract" ]; then
			echo "Em desenvolvimento."
			exit 3
			InstalarProgramasNoCoreLinux.sh "cabextract"
			cabextract "$1" 1> $ArquivoContendoASaidaDeUmComandoDeDescompactacao 2> $ArquivoContendoAErrosGeradosNoComandoDeDescompactacao
			SaidaDoComandoDeDescompactacao=`echo "$?"`
			Finalizador "$SaidaDoComandoDeDescompactacao" "cabextract \"${1}\""			
		elif [ -n "$FormatoRar" ]; then
			InstalarProgramasNoCoreLinux.sh "unrar"
			unrar x "$1" 1> $ArquivoContendoASaidaDeUmComandoDeDescompactacao 2> $ArquivoContendoAErrosGeradosNoComandoDeDescompactacao
			SaidaDoComandoDeDescompactacao=`echo "$?"`
			if [ "$SaidaDoComandoDeDescompactacao" -ne "0" ]; then
				InstalarProgramasNoCoreLinux.sh "p7zip"
				7z x "$1" 2> $ArquivoContendoAErrosGeradosNoComandoDeDescompactacao
				7z l "$1" 1> $ArquivoContendoASaidaDeUmComandoDeDescompactacao
				SaidaDoComandoDeDescompactacao=`echo "$?"`
				SaidaDoComandoDescompactador=`cat $ArquivoContendoASaidaDeUmComandoDeDescompactacao | grep "\.\.\.\.A" | cut -c 54- | grep -v "^$"`
				Finalizador "$SaidaDoComandoDeDescompactacao" "7z x \"${1}\""
			else
				echo "Em desenvolvimento."
				exit 3
				SaidaDoComandoDescompactador=`cat $ArquivoContendoASaidaDeUmComandoDeDescompactacao`
				Finalizador "$SaidaDoComandoDeDescompactacao" "unrar x \"${1}\""
			fi			
		fi
	fi
}

principal "$1"
