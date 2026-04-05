#!/bin/sh

ajuda(){
	echo "$0 \"string ou nome de arquivo\" \"'-v' para string ou '-f' para arquivo\""
	exit 0
}

comando_final(){
	${comando} | sed 's/%C3%BF/ÿ/g' | sed 's/%C3%BE/þ/g' | sed 's/%C3%BD/ý/g' | sed 's/%C3%BC/ü/g' | sed 's/%C3%BB/û/g' | sed 's/%C3%BA/ú/g' | sed 's/%C3%B9/ù/g' | sed 's/%C3%B8/ø/g' | sed 's/%C3%B7/÷/g' | sed 's/%C3%B6/ö/g' | sed 's/%C3%B5/õ/g' | sed 's/%C3%B4/ô/g' | sed 's/%C3%B3/ó/g' | sed 's/%C3%B2/ò/g' | sed 's/%C3%B1/ñ/g' | sed 's/%C3%B0/ð/g' | sed 's/%C3%AF/ï/g' | sed 's/%C3%AE/î/g' | sed 's/%C3%AD/í/g' | sed 's/%C3%AC/ì/g' | sed 's/%C3%AB/ë/g' | sed 's/%C3%AA/ê/g' | sed 's/%C3%A9/é/g' | sed 's/%C3%A8/è/g' | sed 's/%C3%A7/ç/g' | sed 's/%C3%A6/æ/g' | sed 's/%C3%A5/å/g' | sed 's/%C3%A4/ä/g' | sed 's/%C3%A3/ã/g' | sed 's/%C3%A2/â/g' | sed 's/%C3%A1/á/g' | sed 's/%C3%A0/à/g' | sed 's/%C3%9F/ß/g' | sed 's/%C3%9E/Þ/g' | sed 's/%C3%9D/Ý/g' | sed 's/%C3%9C/Ü/g' | sed 's/%C3%9B/Û/g' | sed 's/%C3%9A/Ú/g' | sed 's/%C3%99/Ù/g' | sed 's/%C3%98/Ø/g' | sed 's/%C3%97/×/g' | sed 's/%C3%96/Ö/g' | sed 's/%C3%95/Õ/g' | sed 's/%C3%94/Ô/g' | sed 's/%C3%93/Ó/g' | sed 's/%C3%92/Ò/g' | sed 's/%C3%91/Ñ/g' | sed 's/%C3%90/Ð/g' | sed 's/%C3%8F/Ï/g' | sed 's/%C3%8E/Î/g' | sed 's/%C3%8D/Í/g' | sed 's/%C3%8C/Ì/g' | sed 's/%C3%8B/Ë/g' | sed 's/%C3%8A/Ê/g' | sed 's/%C3%89/É/g' | sed 's/%C3%88/È/g' | sed 's/%C3%87/Ç/g' | sed 's/%C3%86/Æ/g' | sed 's/%C3%85/Å/g' | sed 's/%C3%84/Ä/g' | sed 's/%C3%83/Ã/g' | sed 's/%C3%82/Â/g' | sed 's/%C3%81/Á/g' | sed 's/%C3%80/À/g' | sed 's/%C2%BF/¿/g' | sed 's/%C2%BE/¾/g' | sed 's/%C2%BD/½/g' | sed 's/%C2%BC/¼/g' | sed 's/%C2%BB/»/g' | sed 's/%C2%BA/º/g' | sed 's/%C2%B9/¹/g' | sed 's/%C2%B8/¸/g' | sed 's/%C2%B7/·/g' | sed 's/%C2%B6/¶/g' | sed 's/%C2%B5/µ/g' | sed 's/%C2%B4/´/g' | sed 's/%C2%B3/³/g' | sed 's/%C2%B2/²/g' | sed 's/%C2%B1/±/g' | sed 's/%C2%B0/°/g' | sed 's/%C2%AF/¯/g' | sed 's/%C2%AE/®/g' | sed 's/%C2%AD/­/g' | sed 's/%C2%AC/¬/g' | sed 's/%C2%AB/«/g' | sed 's/%C2%AA/ª/g' | sed 's/%C2%A9/©/g' | sed 's/%C2%A8/¨/g' | sed 's/%C2%A7/§/g' | sed 's/%C2%A6/¦/g' | sed 's/%C2%A5/¥/g' | sed 's/%C2%A4/¤/g' | sed 's/%C2%A3/£/g' | sed 's/%C2%A2/¢/g' | sed 's/%C2%A1/¡/g' | sed 's/%C5%B8/Ÿ/g' | sed 's/%C5%BE/ž/g' | sed 's/%C5%93/œ/g' | sed 's/%C5%A1/š/g' | sed 's/%E2%84/™/g' | sed 's/%CB%9C/˜/g' | sed 's/%E2%80%94/—/g' | sed 's/%E2%80%93/–/g' | sed 's/%E2%80%A2/•/g' | sed 's/%E2%80%9D/”/g' | sed 's/%E2%80%9C/“/g' | sed 's/%E2%80%99/’/g' | sed 's/%E2%80%98/‘/g' | sed 's/%C5%BD/Ž/g' | sed 's/%E2%80%B9/‹/g' | sed 's/%C5%A0/Š/g' | sed 's/%CB%86/ˆ/g' | sed 's/%E2%80%A1/‡/g' | sed 's/%E2%80%A0/†/g' | sed 's/%E2%80%9E/„/g' | sed 's/%C6%92/ƒ/g' | sed 's/%E2%80%9A/‚/g' | sed 's/%E2%80/›/g' | sed 's/%7E/~/g' | sed 's/%7D/\}/g' | sed 's/%7C/\|/g' | sed 's/%7B/\{/g' | sed 's/%7A/z/g' | sed 's/%79/y/g' | sed 's/%78/x/g' | sed 's/%77/w/g' | sed 's/%76/v/g' | sed 's/%75/u/g' | sed 's/%74/t/g' | sed 's/%73/s/g' | sed 's/%72/r/g' | sed 's/%71/q/g' | sed 's/%70/p/g' | sed 's/%6F/o/g' | sed 's/%6E/n/g' | sed 's/%6D/m/g' | sed 's/%6C/l/g' | sed 's/%6B/k/g' | sed 's/%6A/j/g' | sed 's/%69/i/g' | sed 's/%68/h/g' | sed 's/%67/g/g' | sed 's/%66/f/g' | sed 's/%65/e/g' | sed 's/%64/d/g' | sed 's/%63/c/g' | sed 's/%62/b/g' | sed 's/%61/a/g' | sed 's/%5F/_/g' | sed 's/%5E/^/g' | sed 's/%3B//g' | sed 's/%5A/Z/g' | sed 's/%59/Y/g' | sed 's/%58/X/g' | sed 's/%57/W/g' | sed 's/%56/V/g' | sed 's/%55/U/g' | sed 's/%54/T/g' | sed 's/%53/S/g' | sed 's/%52/R/g' | sed 's/%51/Q/g' | sed 's/%50/P/g' | sed 's/%4F/O/g' | sed 's/%4E/N/g' | sed 's/%4D/M/g' | sed 's/%4C/L/g' | sed 's/%4B/K/g' | sed 's/%4A/J/g' | sed 's/%49/I/g' | sed 's/%48/H/g' | sed 's/%47/G/g' | sed 's/%46/F/g' | sed 's/%45/E/g' | sed 's/%44/D/g' | sed 's/%43/C/g' | sed 's/%42/B/g' | sed 's/%41/A/g' | sed 's/%40/@/g' | sed 's/%3F/\?/g' | sed 's/%3D/=/g' | sed 's/%3A/:/g' | sed 's/%39/9/g' | sed 's/%38/8/g' | sed 's/%37/7/g' | sed 's/%36/6/g' | sed 's/%35/5/g' | sed 's/%34/4/g' | sed 's/%33/3/g' | sed 's/%32/2/g' | sed 's/%31/1/g' | sed 's/%30/0/g' | sed 's/%2F/\//g' | sed 's/%2E/\./g' | sed 's/%2D/-/g' | sed 's/%2C/,/g' | sed 's/%2B/+/g' | sed 's/%2A/*/g' | sed 's/%29/\)/g' | sed 's/%28/\(/g' | sed 's/%25/%/g' | sed 's/%24/\$/g' | sed "s/%27/'/g" | sed 's/%22/"/g' | sed 's/%21/!/g' | sed 's/%20/ /g' | sed 's/%26/\&/g'
}

principal(){
	if [ "$2" = "-v" ]; then
		comando=`echo "echo -e ${1}" | sed 's/ -e//g;s/\r//g' | sed ':a;$!N;s/\n/\\\n/;ta;'`
		comando_final
	elif [ "$2" = "-f" ]; then
		comando=`echo "cat ${1}"`
		comando_final
	else
		ajuda
	fi
}

principal "$1" "$2"
