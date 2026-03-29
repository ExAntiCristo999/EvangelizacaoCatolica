

echo "content-type: text/plain"
echo ""

ArquiteturaDoProcessador=`uname -m`
if [ -z "$TERMUX_VERSION" ]; then
	rm -f /$ArquiteturaDoProcessador/r.tar.bz2
	tar -cjf /$ArquiteturaDoProcessador/r.tar.bz2 /$ArquiteturaDoProcessador/Relatorios
else
	rm -f /data/data/com.termux/files/home/$ArquiteturaDoProcessador/r.tar.bz2
	tar -cjf /data/data/com.termux/files/home/$ArquiteturaDoProcessador/r.tar.bz2 /data/data/com.termux/files/home/$ArquiteturaDoProcessador/Relatorios
fi
