if [ "$USER" = "tc" ]; then
	PastaBase="/home/tc/Trabalho/PropositosIntegrados/$TemperamentoBigFive/$Apelido/QualquerLugar/db"
elif [ -n "$TERMUX_VERSION" ]; then
	PastaBase="~/home/tc/Trabalho/PropositosIntegrados/$TemperamentoBigFive/$Apelido/QualquerLugar/db"
else
	echo "Plataforma desconhecida."
	exit 1
fi
ClientID=`sed -r 's/(.*client_id":")([^"]{1,150})(".*)/\2/g' $PastaBase/ClienteESegredoAPIGoogleGMail.db`
ClientSecret=`sed -r 's/(.*client_secret":")([^"]{1,150})(".*)/\2/g' $PastaBase/ClienteESegredoAPIGoogleGMail.db`
RedirectURI=`sed -r 's/(.*redirect_uris":\[")([^"]{1,150})(".*)/\2/g;s/:/%3A/g;s/\//%2F/g' $PastaBase/ClienteESegredoAPIGoogleGMail.db`
TokenDeAtualizacao=`cat $PastaBase/TokenDeAtualizacaoGmailAPI.db`
POST="client_id=$ClientID&client_secret=$ClientSecret&refresh_token=$TokenDeAtualizacao&grant_type=refresh_token"
ConteudoFinal=`curl -s https://oauth2.googleapis.com/token -H "Host: oauth2.googleapis.com" -H "Content-type: application/x-www-form-urlencoded" -d "$POST"`
SegundosUTC=`date +%s`
echo "$ConteudoFinal" | sed -r '/access_token/!d;s/(.*token": ")([^"]{1,500})(".*)/\2/g' > "$PastaBase/TokenDeAcessoAoGmailAPI.db"
TempoDeExpiracao=`echo "$ConteudoFinal" | sed -r '/expires_in/!d;s/(.*_in": )([^,]{1,500})(,.*)/\2/g'`
echo "$(( $SegundosUTC + $TempoDeExpiracao - 8 ))" > "$PastaBase/SegundosUTCDeExpiracaoDoTokenDeAcessoAoGmailAPI.db"
