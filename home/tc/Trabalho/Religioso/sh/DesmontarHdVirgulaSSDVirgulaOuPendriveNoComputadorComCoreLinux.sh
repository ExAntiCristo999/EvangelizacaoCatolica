#!/bin/sh

ajuda(){
	echo "$0 \"Dispositivo a ser desmontado.\""
	exit 44
}
principal(){
	if [ -z "$1" ]; then
		ajuda
	fi
	cd ~
	sync
	SufixoApenas=`echo "$1" | grep -E "^sd[a-z]{1,3}[0-9]{1,3}$"`
	if [ -n "$SufixoApenas" ]; then
		PontoDeMontagem="/mnt/${1}"
	else
		PontoDeMontagem="$1"
	fi
	DispositivoASerDesmontado=`echo "$PontoDeMontagem" | sed 's/mnt/dev/g;s/\/$//g' | grep -E "^[/]dev[/][^/]{1,13}$"`
	if [ -n "$DispositivoASerDesmontado" ]; then
		fdisk=`blkid -s TYPE -o value "$DispositivoASerDesmontado"`
		sudo umount "$PontoDeMontagem"
		if [ "$fdisk" = "vfat" ]; then
			tce-load -ilw dosfstools
			sudo fsck.vfat -y "$DispositivoASerDesmontado"
		elif [ "$fdisk" = "ext4" ]; then
			sudo fsck.ext4 -y "$DispositivoASerDesmontado"
		elif [ "$fdisk" = "ntfs" ]; then
			tce-load -ilw ntfsprogs
			sudo fsck.ntfs -y "$DispositivoASerDesmontado"
		elif [ "$fdisk" = "exfat" ]; then
			tce-load -ilw exfat-utils
			sudo fsck.exfat -y "$DispositivoASerDesmontado"
		fi
		DiscoASerDesligado=`echo "$DispositivoASerDesmontado" | cut -c 1-8`
		ParticoesDoDiscoMontadas=`mount | grep "$DiscoASerDesligado"`
		if [ -z "$ParticoesDoDiscoMontadas" ]; then
			tce-load -ilw udisks || exit 2
			sudo /usr/local/etc/init.d/dbus start
			sudo cp /home/tc/.config/udisks/mount_options.conf /usr/local/etc/udisks2/
			sudo /usr/local/lib/udisks/udisks2/udisksd --debug --uninstalled --force-load-modules &> /dev/null &
			UdiskdRodando=`psaux.sh | grep "udisksd" | grep -v "grep"`
			until [ -n "$UdiskdRodando" ]; do
				sleep 2
				UdiskdRodando=`psaux.sh | grep "udisksd" | grep -v "grep"`
			done
			sudo udisksctl power-off --block-device $DiscoASerDesligado &> /dev/null
			sudo killall udisksd
			IdentificacaoDasOutrasParticoesPertencentesAoMesmoDispositivo=`grep -E " ${1:0:3}[0-9]{1,3}$" /proc/partitions`
			if [ -n "$IdentificacaoDoisPontosDoPendriveVirgulaSSDVirgulaOuPendrivePontoEVirgulaOuDasOutrasParticoesPertencentesAoMesmoDispositivoCitadoAnteriormente" ]; then
				echo "Não remova fisicamente o dispositivo SSD, pendrive, ou HD, correspondente ao ${1:0:3}."
			fi
		fi
	else
		ajuda
	fi
}

principal "$1"
