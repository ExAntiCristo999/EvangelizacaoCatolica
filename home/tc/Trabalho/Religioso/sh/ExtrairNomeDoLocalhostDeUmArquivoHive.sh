if [ -z "$1" ]; then
	echo "Interface do dispositivo de armazenamento. Ex: sda3, mmcblk0p3"
	exit 1
fi
bash /usr/local/bin/hivexget /mnt/${1}/Windows/System32/config/SYSTEM '\ControlSet001\Control\ComputerName\ComputerName' @
