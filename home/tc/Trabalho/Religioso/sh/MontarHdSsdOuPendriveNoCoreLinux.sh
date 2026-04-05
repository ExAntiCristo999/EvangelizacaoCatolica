ajuda(){
	echo "$0 \"Dispositivo dev\" \"Pasta onde serao instalados os TCZ, ou vazio para /mnt/sd??\""
	exit 44
}



principal(){
	if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
		ajuda
	else
		ApenasOSufixo=`echo "$1" | grep -E "^(sd[a-z]{1,3}[0-9]{1,3}|mmcblk[0-9]{1,3}p[0-9]{1,3})$"`
		if [ -n "$ApenasOSufixo" ]; then
			Dispositivo="/dev/$1"
		else
			Dispositivo="$1"
		fi
		if [ -z "$2" ]; then
			PastaASerMontada="/mnt/${Dispositivo##*/}"
		else
			PastaASerMontada="$2"
		fi
		if [ ! -d "$PastaASerMontada" ]; then
			sudo mkdir "$PastaASerMontada"
		fi
		SA=`blkid -s TYPE -o value $Dispositivo`
		if [ "$SA" = "ntfs" ]; then
			tce-load -ilw ntfs-3g
			sudo ntfs-3g $Dispositivo $PastaASerMontada -o iocharset=utf8,umask=0000,gid=50,uid=1001
		elif [ "$SA" = "ext4" ]; then
			sudo mount -t $SA $Dispositivo $PastaASerMontada
		elif [ "$SA" = "vfat" ]; then
			tce-load -ilw dosfstools
			sudo mount -t $SA $Dispositivo $PastaASerMontada -o iocharset=utf8,umask=0000,gid=50,uid=1001
		elif [ "$SA" = "exfat" ]; then
			tce-load -ilw fuse-exfat
			sudo mount -t $SA $Dispositivo $PastaASerMontada -o iocharset=utf8,umask=0000,gid=50,uid=1001
		fi
	fi
}

principal "$1" "$2"
exit 0
