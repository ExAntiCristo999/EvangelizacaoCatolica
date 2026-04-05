if [ ! -e "$1" ]; then
	echo "$0 \"Caminho até o arquivo TXT com mais de uma página.\""
	exit 1
fi
awk '
BEGIN {
  file_count = 0;
    filename = "Pagina" sprintf("%04d", file_count) ".txt"; # Inicializa o primeiro arquivo com um nome formatado.
}
/^\f$/ {  # Procura linhas que CONTENHAM APENAS "/f" (para maior precisao)
  close(filename);  # Fecha o arquivo atual
    file_count++;       # Incrementa o contador
      filename = "arquivo_parte_" sprintf("%04d", file_count) ".txt"; # Gera o novo nome de arquivo
        next;  # Pula para a próxima linha, evitando imprimir "/f" no arquivo
}
{ print > filename }  # Imprime cada linha no arquivo atual
' "$1"
