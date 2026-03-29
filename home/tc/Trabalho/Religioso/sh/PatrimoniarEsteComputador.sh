Arquivo="$PastaDeArquitetura/Patrimonio.txt"
if [ ! -e "$Arquivo" ]; then
	echo "Digite a identificação do computador, que será usado quando ele estiver em rede."
	read patrimonio
	echo "$patrimonio" > "$Arquivo"
fi
if [ -e "$Arquivo" ]; then
	if [ -z "$patrimonio" ]; then
		patrimonio=`cat "$Arquivo"`
	fi
	export patrimonio
fi
