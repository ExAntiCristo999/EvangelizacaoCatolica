# Exemplo de como codificar usuário e senha em Base64 para o payload SOAP (se necessário)
USUARIO="tiago.costa@toledo.pr.gov.br"
SENHA="1ssdl2512@"
#
CODIFICADO_USUARIO=$(echo -n "$USUARIO" | openssl base64)
CODIFICADO_SENHA=$(echo -n "$SENHA" | openssl base64)
#
# # Construa o XML com as credenciais codificadas (se o Zimbra esperar isso)
XML_SOAP_LOGIN="<?xml version=\"1.0\" encoding=\"utf-8\"?>
<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">
<soap:Header>
<context xmlns=\"urn:zimbra\">
<userAgent name=\"$UserAgent\"/>
</context>
</soap:Header>
<soap:Body>
<AuthRequest xmlns=\"urn:zimbra\">
<accountBy>name</accountBy>
<email>$USUARIO</email>
<password>$SENHA</password>
</AuthRequest>
</soap:Body>
</soap:Envelope>"

#                                                 # Se for o caso, salve em um arquivo para facilitar
echo "$XML_SOAP_LOGIN"
#
# Para enviar a requisiçao codificada (se for o caso):
CabecalhoDeRequisicao="POST /service/soap/ HTTP/1.1"
CabecalhoDeRequisicao="$CabecalhoDeRequisicao\r\nHost: webmail.toledo.pr.gov.br"
CabecalhoDeRequisicao="$CabecalhoDeRequisicao\r\nSOAPAction: \"urn:zimbra:Auth\""
CabecalhoDeRequisicao="$CabecalhoDeRequisicao\r\nContent-Type: text/xml; charset=utf-8"
CabecalhoDeRequisicao="$CabecalhoDeRequisicao\r\n\r\n$XML_SOAP_LOGIN"
CabecalhoDeRequisicao="$CabecalhoDeRequisicao\r\n"
( echo -ne "$CabecalhoDeRequisicao" ; sleep 4 ) | openssl s_client -connect webmail.toledo.pr.gov.br:443 -quiet -ign_eof 2> /dev/null 
