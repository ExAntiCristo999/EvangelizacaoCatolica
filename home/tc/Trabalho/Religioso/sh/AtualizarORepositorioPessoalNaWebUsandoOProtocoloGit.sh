if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
	echo "$0 \"Pasta que será sincronizada com o site contendo o protocolo git.\" \"Mensagem descritiva das alterações efetuadas.\" \"Repositório remoto já criado por ti num site que suporte o protocolo git.\" \"Email cadastrado no site que usa o protocolo git.\""
	exit 1
fi

if [ "$USER" = "tc" ]; then
	tce-load -wil git
	Token=`cat /home/tc/.config/gh/chave.ghp`
elif [ -n "$TERMUX_VERSION" ]; then
	pkg install git
	Token=`cat $HOME/home/tc/.config/gh/chave.ghp`
else
	echo "Plataforma desconhecida."
	exit 1
fi
if [ -z "$Token" ]; then
	IADoGemini.sh "Como faço para obter o token de acesso pessoal no Github no dia de hoje? Pretendo usar a resposta para ajudar PcDs como eu." | less
	exit 1
fi
cd "$1"
if [ ! -d "$1/.git" ]; then
	git init
fi
if [ "$USER" = "tc" ]; then
	filetool.sh -b
elif [ -n "$TERMUX_VERSION" ]; then
	busybox tar -C $HOME -T $HOME/opt/.filetool.lst -X $HOME/opt/.xfiletool.lst -czf ~/mydata.tgz home opt RodarEsteProgramaPelaPrimeiraVezNoTermux.sh .gitignore
fi
git add .
git commit -m "$2"
git remote remove origin
git remote add origin "$3"
#( echo "$4" | echo "$Token" ) | git push
#if [ ! -d "$1/.git" ]; then
	#git pull origin main --rebase
	(echo "$4" | echo "$Token" ) | git push -f -u origin main
#fi
#if [ -d "$1/.git" ]; then
#	( echo "$4" | echo "$Token" ) | git push
#fi
