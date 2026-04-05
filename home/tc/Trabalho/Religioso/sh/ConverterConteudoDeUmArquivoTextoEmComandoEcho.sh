if [ ! -e "$1" ]; then
	echo "$0 \"Caminho completo até o arquivo.\" \"'i' para AI; ou vazio para outros programas.\""
	exit 1
fi
if [ "$2" = "i" ]; then
	sed -r ':a;$!N;s/\n/\\n/;ta;' "$1" | sed -r ':a;$!N;s/\r/\\r/;ta;' | sed -r ':a;$!N;s/\t/\\t/;ta;' | sed -r 's/\"/\\\\\\\"/g' | sed -r 's/\{/\\\\\\\{/g' | sed -r 's/\}/\\\\\\\}/g' | sed -r 's/\]/\\\\\\\]/g' | sed -r 's/\[/\\\\\\\[/g' | sed -r 's/\)/\\\\\\\)/g' | sed -r 's/\(/\\\\\\\(/g'
else
	sed -r ':a;$!N;s/\n/\\n/;ta;' "$1" | sed -r ':a;$!N;s/\r/\\r/;ta;' | sed -r ':a;$!N;s/\t/\\t/;ta;' | sed -r 's/\"/\\"/g'
fi
