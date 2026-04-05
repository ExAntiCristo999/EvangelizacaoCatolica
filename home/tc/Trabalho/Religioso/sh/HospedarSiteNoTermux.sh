Busybox=`busybox ls 2>&1`
until [ -n "$Busybox" ]; do
	VariavelTemporaria=`( echo Y ) | pkg install busybox 2>&1`
	if [ "$?" -eq "0" ]; then
		Busybox="s"
	else
		echo "Erro no Programa $0: Conecte-se ao wifi com acesso à Internet."
	fi
	VariavelTemporaria=""
	sleep 20
done
PastaFinal="$HOME"
PastaDeUploads=$PastaFinal/uploads
PastaDosCGIs=$PastaFinal/cgi-bin
if [ ! -d $PastaDosCGIs ]; then
	mkdir -p $PastaDosCGIs
fi
for ArquivoCGI in $PastaPadraoDosProgramasQueCrio/../cgi-bin/*.cgi ; do
	echo "#!/data/data/com.termux/files/usr/bin/busybox sh" > "$PastaDosCGIs/${ArquivoCGI##*/}"
	cat "$ArquivoCGI" >> "$PastaDosCGIs/${ArquivoCGI##*/}"
done
chmod -R 777 "$PastaDosCGIs"
psaux.sh | sed -r '/busybox httpd/!d;/sed /d;s/^ //g;s/([0-9]{1,23} )([0-9]{1,12})( .*)/kill -9 \2/g' | sh
busybox httpd -p 8080 -h $HOME
