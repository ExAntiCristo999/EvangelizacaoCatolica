if [ -z "$1" ] || [ -z "$2" ]; then
	echo "$0 \"Dispositivo onde está o GRUB. Exemplo: sda1, sdb1, etc.\" \"Nova senha.\""
	exit 1
fi
MontarHdSsdOuPendriveNoCoreLinux.sh $1
tce-load -iwl grub2-multi
SenhaNovaCodificada=`( echo "$2" ; echo "$2" ) | grub-mkpasswd-pbkdf2 | sed -r '/PBKDF2/!d;s/(.*password is )(grub.pbkdf2.sha512.*)/\2/g'`
ConteudoFinal=`sed -r "s/^(password_pbkdf2 admin )(.*)/\1$SenhaNovaCodificada/g" /mnt/$1/boot/grub/grub.cfg`
echo "$ConteudoFinal" > /mnt/$1/boot/grub/grub.cfg
echo "$ConteudoFinal" > /mnt/$1/EFI/BOOT/grub/grub.cfg
