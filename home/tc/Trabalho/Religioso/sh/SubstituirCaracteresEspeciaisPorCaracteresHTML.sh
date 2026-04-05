#!/bin/sh

ajuda(){
	echo "$0 \"string ou nome de arquivo\" \"'-v' para string ou '-f' para arquivo\""
	exit 1
}

comando_final(){
	${comando} | sed 's/#/\&#34;/g' | sed 's/\&/\&#37;/g' | sed 's/;/\&#59;/g' | sed 's/¡/\&iexcl;/g' | sed 's/¢/\&cent;/g' | sed 's/£/\&pound;/g' | sed 's/¤/\&curren;/g' | sed 's/¥/\&yen;/g' | sed 's/|/\&brvbar;/g' | sed 's/§/\&sect;/g' | sed 's/"/\&uml;/g' | sed 's/C/\&copy;/g' | sed 's/ª/\&ordf;/g' | sed 's/«/\&laquo;/g' | sed 's/¬/\&not;/g' | sed 's/R/\&reg;/g' | sed 's/■/\&macr;/g' | sed 's/°/\&deg;/g' | sed 's/±/\&plusmn;/g' | sed 's/²/\&sup2;/g' | sed 's/■/\&sup3;/g' | sed "s/'/\&acute;/g" | sed 's/µ/\&micro;/g' | sed 's/¶/\&para;/g' | sed 's/·/\&middot;/g' | sed 's/,/\&cedil;/g' | sed 's/■/\&sup1;/g' | sed 's/º/\&ordm;/g' | sed 's/»/\&raquo;/g' | sed 's/¼/\&frac14;/g' | sed 's/½/\&frac12;/g' | sed 's/■/\&frac34;/g' | sed 's/¿/\&iquest;/g' | sed 's/À/\&Agrave;/g' | sed 's/Á/\&Aacute;/g' | sed 's/Â/\&Acirc;/g' | sed 's/Ã/\&Atilde;/g' | sed 's/Ä/\&Auml;/g' | sed 's/Å/\&Aring;/g' | sed 's/Æ/\&AElig;/g' | sed 's/Ç/\&Ccedil;/g' | sed 's/È/\&Egrave;/g' | sed 's/É/\&Eacute;/g' | sed 's/Ê/\&Ecirc;/g' | sed 's/E/\&Euml;/g' | sed 's/Ì/\&Igrave;/g' | sed 's/Í/\&Iacute;/g' | sed 's/Î/\&Icirc;/g' | sed 's/I/\&Iuml;/g' | sed 's/D/\&ETH;/g' | sed 's/Ñ/\&Ntilde;/g' | sed 's/Ò/\&Ograve;/g' | sed 's/Ó/\&Oacute;/g' | sed 's/Ô/\&Ocirc;/g' | sed 's/Õ/\&Otilde;/g' | sed 's/Ö/\&Ouml;/g' | sed 's/Ø/\&Oslash;/g' | sed 's/Ù/\&Ugrave;/g' | sed 's/Ú/\&Uacute;/g' | sed 's/Û/\&Ucirc;/g' | sed 's/Ü/\&Uuml;/g' | sed 's/Y/\&Yacute;/g' | sed 's/■/\&THORN;/g' | sed 's/ß/\&szlig;/g' | sed 's/à/\&agrave;/g' | sed 's/á/\&aacute;/g' | sed 's/â/\&acirc;/g' | sed 's/ã/\&atilde;/g' | sed 's/ä/\&auml;/g' | sed 's/å/\&aring;/g' | sed 's/æ/\&aelig;/g' | sed 's/ç/\&ccedil;/g' | sed 's/è/\&egrave;/g' | sed 's/é/\&eacute;/g' | sed 's/ê/\&ecirc;/g' | sed 's/ë/\&euml;/g' | sed 's/ì/\&igrave;/g' | sed 's/í/\&iacute;/g' | sed 's/î/\&icirc;/g' | sed 's/ï/\&iuml;/g' | sed 's/ð/\&eth;/g' | sed 's/ñ/\&ntilde;/g' | sed 's/ò/\&ograve;/g' | sed 's/ó/\&oacute;/g' | sed 's/ô/\&ocirc;/g' | sed 's/õ/\&otilde;/g' | sed 's/ö/\&ouml;/g' | sed 's/÷/\&divide;/g' | sed 's/ø/\&oslash;/g' | sed 's/ù/\&ugrave;/g' | sed 's/ú/\&uacute;/g' | sed 's/û/\&ucirc;/g' | sed 's/ü/\&uuml;/g' | sed 's/y/\&yacute;/g' | sed 's/■/\&thorn;/g' | sed 's/ÿ/\&yuml;/g' | sed 's/■/\&euro;/g' | sed 's/\"/\&#33;/g' | sed 's/*/\&#41;/g' | sed 's/+/\&#42;/g' | sed 's/,/\&#43;/g' | sed 's/-/\&#44;/g' | sed 's/\./\&#45;/g' | sed 's/\//\&#46;/g' | sed 's/:/\&#58;/g' | sed 's/</\&#60;/g' | sed 's/=/\&#61;/g' | sed 's/>/\&#62;/g' | sed 's/?/\&#63;/g' | sed 's/@/\&#64;/g' | sed 's/\[/\&#91;/g' | sed 's/\\/\&#92;/g' | sed 's/\]/\&#93;/g' | sed -r 's/[\^]/\&#94;/g' | sed 's/_/\&#95;/g' | sed -r 's/[`]/\&#96;/g' | sed -r 's/[{]/\&#123;/g' | sed -r 's/[|]/\&#124;/g' | sed -r 's/[}]/\&#125;/g' | sed 's/■/\&#8211;/g' | sed 's/■/\&#8212;/g' | sed 's/■/\&#8216;/g' | sed 's/■/\&#8217;/g' | sed 's/■/\&#8218;/g' | sed 's/■/\&#8220;/g' | sed 's/■/\&#8221;/g' | sed 's/■/\&#8224;/g' | sed 's/■/\&#8225;/g' | sed 's/•/\&#8226;/g' | sed 's/■/\&#8230;/g' | sed 's/■/\&#8240;/g' | sed 's/■/\&#8364;/g' | sed 's/!/\&#32;/g' | sed 's/\$/\&#35;/g' | sed 's/%/\&#36;/g' | sed 's/)/\&#40;/g' | sed "s/'/\&#38;/g" | sed 's/(/\&#39;/g' | sed 's/\./\&#47;/g' | sed 's/~/\&#126;/g' | sed 's/■/\&#338;/g' | sed 's/■/\&#339;/g' | sed 's/■/\&#352;/g' | sed 's/■/\&#353;/g' | sed 's/■/\&#376;/g' | sed 's/ƒ/\&#402;/g' | sed 's/■/\&#8482;/g'
}

principal(){
	if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ] || ([ "$2" != "-v" ] && [ "$2" != "-f" ]); then
		ajuda
	else
		if [ "$2" = "-v" ]; then
			comando=`echo "echo ${1}"`
			comando_final
		elif [ "$2" = "-f" ]; then
			comando=`echo "cat ${1}"`
			comando_final
		fi
	fi
}

principal "$1" "$2"
exit 0
