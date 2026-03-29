ServidoresNTP=`while read l ; do echo "$l" ; done < "$PastaPadraoDosProgramasQueCrio/../db/ServidoresNTP.db"`
ServidoresNTPSeparadosPorUmEspacoMenosPEEspacoEntreEles=`echo "$ServidoresNTP" | sed ':a;$!N;s/\n/ -p /;ta;'`
sudo zic "$PastaPadraoDosProgramasQueCrio/../db/HorarioDeVerao.zic"
FusoHorarioDeToledoParana="TerraDeSantaCruz/Sul"
export TZ="$FusoHorarioDeToledoParana"
echo "TZ=$TZ" | sudo tee /etc/sysconfig/timezone
ProcessoRodando=`ps aux | sed '/ntpd -p/!d;/sed/d'`
if [ -z "$ProcessoRodando" ]; then
	sudo ntpd -p $ServidoresNTPSeparadosPorUmEspacoMenosPEEspacoEntreEles
fi
