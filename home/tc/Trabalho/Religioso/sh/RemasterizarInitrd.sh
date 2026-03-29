if [ ! -e "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
	echo "$0 \"Arquivo core.gz ou corepure64.gz de origem.\" \"'f' para incluir firmware; 'p' para incluir as personalizações; e/ou 't' para incorporar os TCZs no arquivo core.gz ou corepure64.gz.\" \"Arquivo core.gz ou corepure64.gz de destino.\""
	exit 1
fi

Personalizacoes(){
	sudo cp -pRf /home/tc/.initrd/* /tmp/core_extract/
	Pasta1="/tmp/core_extract/etc/skel/Trabalho/Religioso"
	if [ ! -d "$Pasta1" ]; then
		mkdir -p "$Pasta1"
	fi
	sudo chown -R tc:staff /tmp/core_extract/etc/skel/
	cp -pRf /home/tc/Trabalho/Religioso/* "$Pasta1"
	cp -pRf /home/tc/.ash_history /tmp/core_extract/etc/skel/
	cp -pRf /home/tc/.ashrc /tmp/core_extract/etc/skel/
	cp -pRf /home/tc/.profile /tmp/core_extract/etc/skel/
	Pasta2="/tmp/core_extract/opt/"
	if [ ! -d "$Pasta2" ]; then
		mkdir -p "$Pasta2"
	fi
	cp -pRf /opt/bootlocal.sh "$Pasta2"
	cp -pRf /opt/bootsync.sh "$Pasta2"
	cp -pRf /opt/shutdown.sh "$Pasta2"
	cp -pRf /opt/.filetool.lst "$Pasta2"
	cp -pRf /opt/.religioso.lst "$Pasta2"
	cp -pRf /opt/.xfiletool.lst "$Pasta2"
	cp -pRf /opt/tcemirror "$Pasta2"
	Pasta3="/tmp/core_extract/home/tc/Trabalho/PropositosIntegrados/db/"
	if [ ! -d "$Pasta3" ]; then
		mkdir -p "$Pasta3"
	fi
	cp -pRf /home/tc/Trabalho/PropositosIntegrados/db/IPXE.db "$Pasta3"
}

TCZs(){
	if [ ! -d "/tmp/core_extract/usr/local/tce.installed" ]; then
		mkdir -p "/tmp/core_extract/usr/local/tce.installed"
	fi
	for Pacote in /tmp/tcloop/* ; do
		sudo cp -pRf "$Pacote"/. /tmp/core_extract/ 2>/dev/null
		sudo cp "/usr/local/tce.installed/${Pacote##*/}" "/tmp/core_extract/usr/local/tce.installed"
	done
	sudo cp /usr/local/bin/busybox-static /tmp/core_extract/usr/local/bin/
	sudo chmod 777 /tmp/core_extract/usr/local/bin/busybox-static
}

Firmware(){
	FirmwarePasta="/tmp/core_extract/usr/local/lib/firmware/"
	if [ ! -d "$FirmwarePasta" ]; then
		sudo mkdir -p "$FirmwarePasta"
	fi
	sudo cp -pRf /usr/local/lib/firmware/. "$FirmwarePasta"
}

tce-load -ilw core-remaster
cp $1 /tmp/
( echo "" ; echo "e" ; echo "" ) | core-remaster
Personalizacoes=`echo "$2" | grep "p"`
TCZs=`echo "$2" | grep "t"`
Firmware=`echo "$2" | grep "f"`

if [ -n "$Personalizacoes" ]; then
	Personalizacoes
fi
if [ -n "$TCZs" ]; then
	TCZs
fi
if [ -n "$Firmware" ]; then
	Firmware
fi
( echo "" ; echo "p" ; echo "" ) | core-remaster
sudo cp "/tmp/core_package/${1##*/}" "$3"
