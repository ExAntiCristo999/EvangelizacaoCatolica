if [ -z "$1" ]; then
	echo "$0 \"URL\" \"O nome do arquivo após ser transferido da web ou intranet para o computador.\""
	exit 1
fi
tce-load -ilw curl
curl --limit-rate=7128 --continue-at - "$1" -o "$2"
