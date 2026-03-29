Lib(){
	cd "$PastaDeOrigemNaInternet"
	echo "$PWD/linux-firmware"
	IP=`cut -d ";" -f 1 /home/tc/Trabalho/PropositosIntegrados/db/IPXE.db`
	InterfaceIPXE=`cut -d ";" -f 2 /home/tc/Trabalho/PropositosIntegrados/db/IPXE.db`
	IPXE=`ifconfig | grep -A 1 "$InterfaceIPXE" | grep "$IP"`
	if [ ! -d "$PWD/linux-firmware" ] && [ -n "$IPXE" ]; then
		Saida="1"
		until [ "$Saida" -eq "0" ]; do
			git clone https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
			Saida="$?"
		done
	fi
	cd linux-firmware
	ArquivosDeFirmware=`find $PWD -type f`
	NumeroDeFirmwares=`echo "$ArquivosDeFirmware" | wc -l`
	for OrdemNumerica in $( seq 1 $NumeroDeFirmwares ); do
		UmFirmware=`echo "$ArquivosDeFirmware" | sed -n ${OrdemNumerica}p`
		Resultado=`echo "$FirmwaresNaoEncontrados" | grep -E "[/ ]${UmFirmware##*/} "`
		if [ -n "$Resultado" ]; then
			SufixoComArquivo=`echo "$UmFirmware" | cut -d "/" -f 5-`
			Firmware="/usr/local/lib/firmware/${SufixoComArquivo%/*}"
			if [ ! -d "$Firmware" ]; then
				sudo mkdir -p "$Firmware"
				sudo chmod -R 777 "$Firmware"
			fi
			cp -pRf "$UmFirmware" "$Firmware"
		fi
	done
	Terminou="s"
}


ArquivoComFirmware="$PastaDeArquitetura/Firmware.txt"
PastaDeDestino="/usr/local/lib/firmware"
if [ ! -d "$PastaDeDestino" ]; then
	sudo mkdir -p "$PastaDeDestino"
	sudo chmod -R 777 "$PastaDeDestino"
fi
FirmwaresNaoEncontrados=`dmesg 2>&1 | grep -i firmware`
PastaDeOrigemNaInternet="$PastaDeArquitetura/linux-firmware"
if [ ! -d "$PastaDeOrigemNaInternet" ]; then
	Terminou="n"
	until [ "$Terminou" = "s" ]; do
		sudo ifconfig usb0 up
		if [ "$?" -eq "0" ]; then
			sudo udhcpc -i usb0
			if [ "$?" -eq "0" ]; then
				tce-load -ilw git
				sudo mkdir -p "$PastaDeOrigemNaInternet"
				sudo chmod -R 777 "$PastaDeOrigemNaInternet"
				Lib
			fi
		fi
	done
else
	tce-load -ilw git
	Lib
fi
