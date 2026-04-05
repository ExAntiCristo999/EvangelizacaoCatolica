# Carregar configurações
if [ -f /home/tc/.config/glpi/glpi.conf ]; then
    . /home/tc/.config/glpi/glpi.conf
fi

# Exemplo de script para verificar chamados do usuário
check_my_tickets() {
    if [ -z "$GLPI_USER" ] || [ -z "$GLPI_PASS" ]; then
        echo "Erro: Configurações não encontradas"
        exit 1
    fi
    
    # Fazer login
    token=$(curl -vs -X GET \
        -H "Content-Type: application/json" \
        -H "Authorization: Basic $(echo -n "$GLPI_USER:$GLPI_PASS" | busybox-static base64)" \
	"${GLPI_URL}/initSession") # | jq -r '.session_token')
    echo "$token"
   exit 2 
    if [ "$token" = "null" ] || [ -z "$token" ]; then
        echo "Falha na autenticação"
        exit 1
    fi
    
    # Buscar ID do usuário
    user_id=$(curl -s -X GET \
        -H "Content-Type: application/json" \
        -H "Session-Token: $token" \
        -H "Authorization: Basic $(echo -n "$GLPI_USER:$GLPI_PASS" | busybox-static base64)" \
        "${GLPI_URL}/search/User?criteria[0][field]=1&criteria[0][searchtype]=contains&criteria[0][value]=$GLPI_USER" | \
        jq -r '.data[0].2')
    
    # Buscar chamados do usuário
    curl -s -X GET \
        -H "Content-Type: application/json" \
        -H "Session-Token: $token" \
        -H "Authorization: Basic $(echo -n "$GLPI_USER:$GLPI_PASS" | busybox-static base64)" \
        "${GLPI_URL}/search/Ticket?criteria[0][field]=4&criteria[0][searchtype]=equals&criteria[0][value]=$user_id" | \
        jq -r '.data[] | "\(.2): \(.1) - \(.12)"'
    
    # Encerrar sessão
    curl -s -X GET \
        -H "Content-Type: application/json" \
        -H "Session-Token: $token" \
        -H "Authorization: Basic $(echo -n "$GLPI_USER:$GLPI_PASS" | busybox-static base64)" \
        "${GLPI_URL}/killSession" > /dev/null
}

check_my_tickets
