if [ -n "$TERMUX_VERSION" ]; then
	busybox="busybox"
elif [ "$USER" = "tc" ]; then
	busybox="busybox-static"
else
	echo "Plataforma desconhecida."
	exit 1
fi

awk -F';' 'NR==1 {
    # Cria linha com numeração das colunas
    for(i=1; i<=NF; i++) {
        printf "%d%s", i, (i==NF ? "\n" : FS)
    }
    # Imprime a linha original do cabeçalho
    print $0
    next
}
{ print $0 }' "$1" | "$busybox" nl -b a -v 0 
