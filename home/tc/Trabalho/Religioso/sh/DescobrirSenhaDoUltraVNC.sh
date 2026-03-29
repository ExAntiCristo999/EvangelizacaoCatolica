#!/bin/sh

FuncaoPrincipalDoProgramaDescobrirSenhaDoUltraVNC(){
	MontarHdSsdOuPendriveNoCoreLinux.sh sda2 2> /dev/null
	sed -r '/passwd/!d;s/(.*=)(.*)/\2/g' /mnt/sda2/Arquivos\ de\ Programas/UltraVNC/ultravnc.ini | xxd -r -p | openssl enc -des-cbc --nopad --nosalt -K e84ad660c4721ae0 -iv 0000000000000000 -d 2> /dev/null
}

FuncaoPrincipalDoProgramaDescobrirSenhaDoUltraVNC 
exit 0
