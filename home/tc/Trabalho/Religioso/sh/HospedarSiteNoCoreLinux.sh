ConfiguracoesDeIP=`ifconfig`
echo "$ConfiguracoesDeIP" | grep -B 1 "addr:" | sed -r 's/^lo/Se for acessar o site no mesmo computador que o hospeda, digite no Navegador Web: /g;s/eth0/Se usar um computador, ligado pelo cabo ethernet diretamente ou por intermédio de um hub ao computador que hospeda o site, digite no Navegador Web:/g;s/wlan0/Se usar um computador, conectado via wifi ad hoc ou por roteador wifi, ao computador que hospeda o site, digite no Navegador Web: /g;s/eth1/Se usar um computador, conectado via computador com Android, ao computador que hospeda o site, digite no Navegador Web: /g' | sed -r ':a;$!N;s/\n//;ta' | sed -r 's/Se/\nSe/g' | sed -r 's#(Se.*Web:)(.* addr:)([^ ]{7,15})( .*)#\1 http://\3:8080#g'
PastaFinal="/cgi-bin/"
sudo mkdir -p "$PastaFinal"
sudo chmod -R 777 "$PastaFinal"
for ArquivoCGI in $PastaPadraoDosProgramasQueCrio/../cgi-bin/*.cgi ; do
	echo "#!/bin/sh" > "$PastaFinal/${ArquivoCGI##*/}"
	cat "$ArquivoCGI" >> "$PastaFinal/${ArquivoCGI##*/}"
done
sudo chmod -R 777 "$PastaFinal"
psaux.sh | sed -r '/busybox httpd/!d;/sed /d;s/^ //g;s/([0-9]{1,23} )([0-9]{1,12})( .*)/sudo kill -9 \2"/g' | sh
sudo busybox-static httpd -v -h / -u "tc:staff" -p 8080
