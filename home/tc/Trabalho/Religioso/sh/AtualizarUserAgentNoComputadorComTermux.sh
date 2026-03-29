Pasta="$PastaDeErrosDosProgramasQueCrio/../uploads/ExibirVariaveisESalvarNoSite"
if [ ! -d "$Pasta" ]; then
	mkdir -p "$Pasta"
fi
cd "$Pasta"
termux-open-url http://127.0.0.1:8080/cgi-bin/ExibirVariaveisESalvarNoSite.cgi
sed -r '/HTTP_USER_AGENT/!d' * | sed -r "s/(.*ENT=['])([^']{1,560})(['])/\2/g" > /home/tc/Trabalho/Humanitario/E24A26C44N42O48/ExAntiCristo/QualquerLugar/db/UserAgent.db
