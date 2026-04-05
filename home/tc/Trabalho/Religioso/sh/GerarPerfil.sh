Perfil=`echo -e "Profissional\nPessoal\nReligioso"`
EscolhaUmaDasSeguintesOpcoes.sh v "$Perfil" "Selecione um dos perfis à ser usado." "" "GerarPerfil"
Arquivo=`find $PastaComArquivosTemporariosDosProgramasQueCrio/EscolhaUmaDasSeguintesOpcoes/GerarPerfil/*`
Pasta=`cut -d "=" -f 2- "$Arquivo"`
rm -f "$Arquivo"
if [ "$USER" = "tc" ]; then
	mkdir -p "/home/tc/Trabalho/$Pasta"
elif [ -n "$TERMUX_VERSION" ]; then
	mkdir -p "$HOME/home/tc/Trabalho/$Pasta"
else
	echo "Plataforma desconhecida."
	exit 1
fi
