Hostname(){
	Host="$2/hostname.reg"
	if [ -e "$Host" ]; then
		rm -f "$Host"
	fi
	reged.static -x "$1" "HKLM\SOFTWARE" "Microsoft\Windows\CurrentVersion\Group Policy\DataStore\Machine\0" "$Host"
	Patrimonio=`sed -r '/szTargetName/!d;s/(.*Name"=")([^"]{1,34})(".*)/\2/g' "$Host"`
	echo "$Patrimonio"
}

PastaComOsRegistros="$PastaComArquivosTemporariosDosProgramasQueCrio/chntpw"
if [ ! -d "$PastaComOsRegistros" ]; then
	mkdir -p "$PastaComOsRegistros"
fi
if [ "$1" = "h" ]; then
	Hostname "$2" "$PastaComOsRegistros"
fi
