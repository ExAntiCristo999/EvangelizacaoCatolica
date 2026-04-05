#!/bin/sh

ajuda(){
	echo "$0 \"string ou nome de arquivo\" \"'-v' para string ou '-f' para arquivo\""
	exit 1
}

comando_final(){
	${comando} | sed 's/&iexcl;/¡/g' | sed 's/&brvbar;/|/g' | sed 's/&sect;/§/g' | sed 's/&uml;/"/g' | sed 's/&copy;/C/g' | sed 's/&ordf;/ª/g' | sed 's/&laquo;/«/g' | sed 's/&reg;/R/g' | sed 's/&macr;/■/g' | sed 's/&deg;/°/g' | sed 's/&sup2;/²/g' | sed 's/&sup3;/■/g'	| sed "s/&acute;/'/g" | sed 's/&micro;/µ/g' | sed 's/&para;/¶/g' | sed 's/&middot;/·/g' | sed 's/&cedil;/,/g' | sed 's/&sup1;/■/g' | sed 's/&ordm;/º/g' | sed 's/&raquo;/»/g' | sed 's/&frac14;/¼/g' | sed 's/&frac12;/½/g' | sed 's/&frac34;/■/g' | sed 's/&iquest;/¿/g' | sed 's/&Agrave;/A/g' | sed 's/&Aacute;/A/g' | sed 's/&Acirc;/A/g' | sed 's/&Atilde;/A/g' | sed 's/&Auml;/Ä/g' | sed 's/&AElig;/Æ/g' | sed 's/&Ccedil;/Ç/g' | sed 's/&Egrave;/E/g' | sed 's/&Eacute;/É/g' | sed 's/&Ecirc;/E/g' | sed 's/&Euml;/E/g' | sed 's/&Igrave;/I/g' | sed 's/&Iacute;/I/g' | sed 's/&Icirc;/I/g' | sed 's/&Iuml;/I/g' | sed 's/&ETH;/D/g' | sed 's/&Ntilde;/Ñ/g' | sed 's/&Ograve;/O/g' | sed 's/&Oacute;/O/g' | sed 's/&Ocirc;/O/g' | sed 's/&Otilde;/O/g' | sed 's/&Ouml;/Ö/g' | sed 's/&times;/x/g' | sed 's/&Oslash;/Ø/g' | sed 's/&Ugrave;/U/g' | sed 's/&Uacute;/U/g' | sed 's/&Ucirc;/U/g' | sed 's/&Uuml;/Ü/g' | sed 's/&Yacute;/Y/g' | sed 's/&THORN;/■/g' | sed 's/&szlig;/ß/g' | sed 's/&agrave;/à/g' | sed 's/&aacute;/á/g' | sed 's/&acirc;/â/g' | sed 's/&atilde;/a/g' | sed 's/&auml;/ä/g' | sed 's/&aelig;/æ/g' | sed 's/&ccedil;/ç/g' | sed 's/&egrave;/è/g' | sed 's/&eacute;/é/g' | sed 's/&ecirc;/ê/g' | sed 's/&euml;/ë/g' | sed 's/&igrave;/ì/g' | sed 's/&iacute;/í/g' | sed 's/&icirc;/î/g' | sed 's/&iuml;/ï/g' | sed 's/&eth;/ð/g' | sed 's/&ograve;/ò/g' | sed 's/&oacute;/ó/g' | sed 's/&ocirc;/ô/g' | sed 's/&otilde;/o/g' | sed 's/&ouml;/ö/g' | sed 's/&divide;/÷/g' | sed 's/&oslash;/ø/g' | sed 's/&ugrave;/ù/g' | sed 's/&uacute;/ú/g' | sed 's/&ucirc;/û/g' | sed 's/&uuml;/ü/g' | sed 's/&yacute;/y/g' | sed 's/&yuml;/ÿ/g' | sed 's/&\#37;/&/g' | sed 's/&\#41;/*/g' | sed 's/&\#42;/+/g' | sed 's/&\#43;/,/g' | sed 's/&\#44;/-/g' | sed 's/&\#45;/./g' | sed 's/&\#46;/\//g' | sed 's/&\#58;/:/g' | sed 's/&\#59;/;/g' | sed 's/&\#60;/</g' | sed 's/&\#61;/=/g' | sed 's/&\#62;/>/g' | sed 's/&\#63;/?/g' | sed 's/&\#64;/@/g' | sed 's/&\#91;/[/g' | sed 's/&#92;//g' | sed 's/&#93;/]/g' | sed 's/&\#94;/^/g' | sed 's/&\#95;/_/g' | sed 's/&\#96;/`/g' | sed 's/&\#123;/{/g' | sed 's/&\#124;/|/g' | sed 's/&\#125;/}/g' | sed 's/&\#8211;/■/g' | sed 's/&\#8212;/■/g' | sed 's/&\#8216;/■/g' | sed 's/&\#8217;/■/g' | sed 's/&\#8218;/■/g' | sed 's/&\#8220;/■/g' | sed 's/&\#8221;/■/g' | sed 's/&\#8224;/■/g' | sed 's/&\#8225;/■/g' | sed 's/&\#8226;/•/g' | sed 's/&\#8230;/■/g' | sed 's/&\#8240;/■/g' | sed 's/&\#34;/\#/g' | sed 's/&\#35;/$/g' | sed 's/&\#36;/%/g' | sed 's/&\#39;/(/g' | sed 's/&\#47;/./g' | sed 's/&\#126;/~/g' | sed 's/&\#338;/■/g' | sed 's/&\#339;/■/g' | sed 's/&\#352;/■/g' | sed 's/&\#353;/■/g' | sed 's/&\#376;/■/g' | sed 's/&\#402;/ƒ/g' | sed 's/&\#8482;/■/g' | sed 's/&\#33;/\"/g' | sed 's/&\#32;/\!/g' | sed "s/&#38;/'/g" | sed 's/\&euro;/■/g' | sed 's/&\#8364;/■/g' | sed 's/&\#40;/\)/g' | sed 's/&nbsp;/ /g'
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
