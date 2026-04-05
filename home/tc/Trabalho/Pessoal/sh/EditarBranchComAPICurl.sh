if [ "$USER" = "tc" ]; then
	tce-load -iwl curl jq
	ChaveGHPDoGithub=`cat /home/tc/.config/gh/chave.ghp`
elif [ -n "$TERMUX_VERSION" ]; then
	pkg install jq
	ChaveGHPDoGithub=`cat $HOME/home/tc/.config/gh/chave.ghp`
else
	echo "Plataforma desconhecida."
	exit 1
fi
AlgumasInformacoes=`curl -s -H "Authorization: token $ChaveGHPDoGithub" https://api.github.com/repos/ExAntiCristo999/EvangelizacaoCatolica/git/refs/heads/main`
SHA=`echo "$AlgumasInformacoes" | jq -r .object.sha`


