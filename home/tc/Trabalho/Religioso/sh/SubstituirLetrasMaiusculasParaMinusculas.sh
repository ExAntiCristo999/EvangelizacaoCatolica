ajuda(){
	echo "$0 \"Arquivo.\""
}
if [ -z "$1" ]; then
	ajuda
fi
cat "$1" | tr 'A-Z' 'a-z' | sed -r 's/Á/á/g;s/É/é/g;s/Í/í/g;s/Ú/ú/g;s/Â/â/g;s/Ê/ê/g;s/Ô/ô/g;s/Ã/ã/g;s/Õ/õ/g;s/À/à/g;s/Ç/ç/g'
exit 14
