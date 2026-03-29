if [ -z "$1" ] || [ -z "$3" ] || [ -z "$4" ]; then
	echo "$0 \"Dispositivo onde será gravado o grub. Ex: sda\" \"URL de onde será baixado os pacotes; ou nada para usar o mydata.tgz\" \"Identificação do computador na rede.\""
	exit 1
fi

Backup(){
	if [ -z "$DispositivoDeArmazenamentoESSD" ]; then
		Backup=`blkid /dev/${1}2 -s PARTLABEL -o value | grep "Micro Core Linux"`
	else
		Backup=`blkid /dev/${1}p2 -s PARTLABEL -o value | grep "Micro Core Linux"`
	fi
	if [ -n "$Backup" ]; then
		if [ -z "$DispositivoDeArmazenamentoESSD" ]; then
			sudo mount /mnt/${1}2
		else
			sudo mount /mnt/${1}p2
		fi
	else
		echo "Plataforma desconhecida."
		exit 2
	fi
}

LibCriarEMontar(){
	sudo rebuildfstab
	sudo mkfs.vfat -F 32 /dev/${1}${2}
	sudo mkfs.ext4 /dev/${1}${3}
	sudo mount /mnt/${1}${2}
	sudo mount /mnt/${1}${3}
}

CriarEMontar(){
	if [ -z "$DispositivoDeArmazenamentoESSD" ]; then
		LibCriarEMontar "$1" "1" "2"
	else
		LibCriarEMontar "$1" "p1" "p2"
	fi
}

UsarMBR(){
	echo -e "o\nn\np\n1\n\n+32M\na\n1\nt\nc\nn\np\n2\n\n\np\nw" | sudo busybox fdisk /dev/$1
	CriarEMontar "$1"
	sudo grub-install --force --target=i386-pc --boot-directory=/mnt/${1}1/boot /dev/$1
	ArquivoLST="/mnt/${1}1/boot/grub/grub.cfg"
}

UsarGPT(){
	tce-load -iwl gdisk
	sudo sgdisk --zap-all /dev/$1
	sudo sgdisk --new=1:0:+1G --typecode=1:ef00 --change-name=1:"EFI System" /dev/$1
	sudo sgdisk --new=2:0:0 --typecode=2:8300 --change-name=2:"Micro Core Linux" /dev/$1
	CriarEMontar "$1"
	if [ -z "$DispositivoDeArmazenamentoESSD" ]; then
		sudo grub-install --target=x86_64-efi --boot-directory=/mnt/${1}1/EFI/BOOT --efi-directory=/mnt/${1}1/ --bootloader-id=grub --removable
		ArquivoLST="/mnt/${1}1/EFI/BOOT/grub/grub.cfg"
	else
		sudo grub-install --target=x86_64-efi --boot-directory=/mnt/${1}p1/EFI/BOOT --efi-directory=/mnt/${1}p1/ --bootloader-id=grub --removable
		ArquivoLST="/mnt/${1}p1/EFI/BOOT/grub/grub.cfg"
	fi
}
DispositivoDeArmazenamentoESSD=`echo "$1" | grep "mmc"`
Backup "$1"
tce-load -ilw dosfstools grub2-multi
NumeroDeBlocosDoDispositivoDeArmazenamento=`cat /sys/block/${1}/size`
NumeroDeBytesDoDispositivoDeArmazenamento="$(( $NumeroDeBlocosDoDispositivoDeArmazenamento * 512 ))"
NumeroDeBytesAcimaDoQualOGPTEObrigatorio="2000000000000"
if [ "$NumeroDeBytesDoDispositivoDeArmazenamento" -ge "$NumeroDeBytesAcimaDoQualOGPTEObrigatorio" ]; then
	UsarGPT
else
	AnoDoBios=`cut -d "/" -f 3 /sys/class/dmi/id/bios_date`
	if [ "$AnoDoBios" -ge "2007" ]; then
		if [ -d "/sys/firmware/efi" ]; then
			UsarGPT "$1"
		else
			UsarMBR "$1"
		fi
	else
		UsarMBR "$1"
	fi	
fi
if [ -z "$DispositivoDeArmazenamentoESSD" ]; then
	UUIDDaParticaoExt4=`blkid /dev/${1}2 | sed -r 's/(.* UUID=")([^"]{36})(".*)/\2/g'`
else
	UUIDDaParticaoExt4=`blkid /dev/${1}p2 | sed -r 's/(.* UUID=")([^"]{36})(".*)/\2/g'`
fi
PatrimonioGabinete="$3"
IdentificadorDoDispositivoDeArmazenamento=`/sbin/fdisk -l /dev/${1} | sed -r '/GUID/!d;s/(.*GUID[)][:] )([0-9a-f-]{36})(.*)/\2/g'`
MAC=`ObterMACDaInterfaceDeRedeMaisRapida.sh 2> /dev/null`
if [ -z "$DispositivoDeArmazenamentoESSD" ]; then
	PastaDePatrimonios="/mnt/${1}2/Patrimonio/$PatrimonioGabinete/$IDDaPlacaMae/$ArquiteturaDoProcessadorDesteComputador/$IdentificadorDoDispositivoDeArmazenamento/$MAC"
else
	PastaDePatrimonios="/mnt/${1}p2/Patrimonio/$PatrimonioGabinete/$IDDaPlacaMae/$ArquiteturaDoProcessadorDesteComputador/$IdentificadorDoDispositivoDeArmazenamento/$MAC"
fi
if [ ! -d "$PastaDePatrimonios" ]; then
	sudo mkdir -p "$PastaDePatrimonios"
	sudo chmod -R 777 "$PastaDePatrimonios"
fi
mkdir -p "$PastaDePatrimonios/boot" "$PastaDePatrimonios/tce/optional"
RemasterizarInitrd.sh "$PastaTCE/../boot/corepure64.gz" "fpt" "$PastaDePatrimonios/boot/corepure64.gz"
cp -pRf "$PastaTCE/../boot/vmlinuz64"  "$PastaDePatrimonios/boot/"
echo -e "set timeout=10\nset default=0\nmenuentry \"Micro Core Linux\" {\n\tinsmod ext2\n\tinsmod part_msdos\n\tsearch --no-floppy --fs-uuid --set=root $UUIDDaParticaoExt4\n\tlinux \"(\${root})/Patrimonio/$PatrimonioGabinete/$IDDaPlacaMae/$ArquiteturaDoProcessadorDesteComputador/$IdentificadorDoDispositivoDeArmazenamento/$MAC/boot/vmlinuz64\" tce=UUID=\"$UUIDDaParticaoExt4/Patrimonio/$PatrimonioGabinete/$IDDaPlacaMae/$ArquiteturaDoProcessadorDesteComputador/$IdentificadorDoDispositivoDeArmazenamento/$MAC/tce\" waitusb=10 showapps blacklist=pcspkr multivt fbcon=font:VGA8x8 lang=pt_BR.UTF-8 tz=TerraDeSantaCruz/Sul\n\tinitrd (\${root})/Patrimonio/$PatrimonioGabinete/$IDDaPlacaMae/$ArquiteturaDoProcessadorDesteComputador/$IdentificadorDoDispositivoDeArmazenamento/$MAC/boot/corepure64.gz\n}" > "$ArquivoLST"
cp -pRf "$PastaTCE/../tce/provides.db" "$PastaDePatrimonios/tce"
if [ -z "$2" ]; then
	cp -pRf "$PastaTCE/../tce/mydata.tgz" "$PastaDePatrimonios/tce"
else
	echo "$2" > /opt/tcemirror
	/bin/tar -C / -T /opt/.religioso.lst -czf "$PastaDePatrimonios/tce/mydata.tgz"
fi
