if [ -z "$1" ] || [ -z "$2" ]; then
	echo "$0 \"Arquivo com BOM.\" \"Arquivo sem BOM.\""
	exit 1
fi
xxd -p "$1" | sed 's/^efbbbf//' | xxd -r -p > "$2"
