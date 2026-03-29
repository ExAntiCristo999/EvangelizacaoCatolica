PastaDosMonitores="$PastaDeArquitetura/Monitores"
if [ ! -d "$PastaDosMonitores" ]; then
	mkdir -p "$PastaDosMonitores"
fi
Monitor="$PastaDosMonitores/Monitor.txt"
if [ ! -e "$Monitor" ]; then
	NumeroDoMonitor="1"
	tce-load -ilw libdisplay-info
	for EstadoDoConector in $( ls /sys/class/drm/*/status ); do
		cat $EstadoDoConector | grep "^connected$" &> /dev/null
		if [ "$?" -eq "0" ]; then
			sudo di-edid-decode "${EstadoDoConector%/*}/edid" > "$PastaDosMonitores/Monitor${NumeroDoMonitor}.edid"
			echo "Digite a identificaçao do Monitor $Monitor, caso não seja embutido no gabinete. Caso contrário, apenas tecle enter."
			read PatrimonioMonitor
			echo "$PatrimonioMonitor;$NumeroDoMonitor" >> "$Monitor"
			NumeroDoMonitor=$(( $NumeroDoMonitor + 1 ))
		fi
	done
fi
