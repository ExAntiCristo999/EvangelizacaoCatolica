if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
	echo "$0 \"Interface do dispositivo de armazenamento onde está a pasta Windows. Ex: /dev/sda3, /dev/mmcblk0p3.\" \"Ponto de montagem onde está a pasta Windows.\" \"Pasta onde está o arquivo WIM.\" \"Ponto de montagem onde contem a pasta EFI e os arquivos de inicialização do Microsoft Windows.\"\n\nObservação importante: verifique se já existem partições FAT e NTFS criadas e com os badblocks demarcados."
	exit 1
fi

LibInstalarWindows(){
	Patrimonio=`LibChavesDeRegistroWindowsImportantes.sh h "$2/Windows/System32/config/SOFTWARE"`
	sed "s/PCWINDOWS/$Patrimonio/g" "/home/tc/Trabalho/Profissional/db/autounattend.xml" > "$4/autounattend.xml"
	sudo rm -rf $4/* $2/*
	PastaCIFS="/mnt/cifs"
	if [ ! -d "$PastaCIFS" ]; then
		mkdir -p "$PastaCIFS"
	fi
	sudo mount.cifs //0.0.0.0/Compartilhado/ $PastaCIFS -o username=guest,guest,sec=none
	sudo ntfs-3g $1 $2
	wimapply "$PastaCIFS"/$3 1 $2
	sudo bcd-sys $4 -f UEFI -s $2
}

LibInstalarWindows "$1" "$2" "$3" "$4"
