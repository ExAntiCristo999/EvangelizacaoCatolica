Dispositivos=`ls /sys/block/ | grep -v "loop\|ram"`
DispositivosUSBs=`echo "$Dispositivos" | sed -r 's/^/ls -l \/sys\/block\//g;s/$/ \| grep "device" | grep -i "usb"/g' | sh | sed -r 's/(.*block[/])([a-z]{3,4})( .*)/\2/g'`
NumeroDeDispositivosUSB=`echo "$DispositivosUSBs" | wc -l`
DispositivosSATAs=`echo "$Dispositivos" | sed -r 's/^/ls -l \/sys\/block\//g;s/$/ \| grep "device" | grep -i "ata"/g' | sh | sed -r 's/(.*block[/])([a-z]{3,4})( .*)/\2/g'`
NumeroDeDispositivosSATA=`echo "$DispositivosSATAs" | wc -l`
ColecaoDeParticoes=""
Blkid=`blkid`
USBOuSATA(){
	for ParticoesNTFS in $1 ; do
		DispositivoComParticaoNtfs=`echo "$Blkid" | sed -r "/$ParticoesNTFS/!d;/ntfs/!d;s/(.*)(:.*)/\1/g"`
		UUID=`echo "$Blkid" | sed -r "/$ParticoesNTFS/!d;/ntfs/!d;s/(.* UUID=[\"])([^\"]{1,48})([\"].*)/\2/g"`
		if [ -n "$DispositivoComParticaoNtfs" ]; then
			ColecaoDeParticoes=`echo -e "${ColecaoDeParticoes}\n${DispositivoComParticaoNtfs};${DispositivoComParticaoNtfs//dev/mnt};$2;$NumeroDeDispositivosUSB;$NumeroDeDispositivosSATA;$UUID;n"`
		fi
	done
	for ParticoesBitLocker in $1 ; do
		DispositivoComParticaoBitLocker=`echo "$Blkid" | sed -r "/$ParticoesBitLocker/!d;/BitLocker/!d;s/(.*)(:.*)/\1/g"`
		UUID=`echo "$Blkid" | sed -r "/$ParticoesNTFS/!d;/BitLocker/!d;s/(.* UUID=[\"])([^\"]{1,48})([\"].*)/\2/g"`
	    	if [ -n "$DispositivoComParticaoBitLocker" ]; then
			ColecaoDeParticoes=`echo -e "${ColecaoDeParticoes}\n${DispositivoComParticaoBitLocker};${DispositivoComParticaoBitLocker//dev/mnt};$2;$NumeroDeDispositivosUSB;$NumeroDeDispositivosSATA;$UUID;b"`
		fi
	done
	for ParticoesExt4 in $1 ; do
		UUID=`echo "$Blkid" | sed -r "/$ParticoesNTFS/!d;/ext4/!d;s/(.* UUID=[\"])([^\"]{1,48})([\"].*)/\2/g"`
		DispositivoComParticaoExt4=`echo "$Blkid" | sed -r "/$ParticoesExt4/!d;/ext4/!d;s/(.*)(:.*)/\1/g"`
		if [ -n "$DispositivoComParticaoExt4" ]; then
			ColecaoDeParticoes=`echo -e "${ColecaoDeParticoes}\n${DispositivoComParticaoExt4};${DispositivoComParticaoExt4//dev/mnt};$2;$NumeroDeDispositivosUSB;$NumeroDeDispositivosSATA;$UUID;e"`
		fi
	done
	for ParticoesCryptoLUKS in $1 ; do
		UUID=`echo "$Blkid" | sed -r "/$ParticoesNTFS/!d;/crypto_LUKS/!d;s/(.* UUID=[\"])([^\"]{1,48})([\"].*)/\2/g"`
		DispositivoComParticaoCryptoLUKS=`echo "$Blkid" | sed -r "/$ParticoesCryptoLUKS/!d;/crypto_LUKS/!d;s/(.*)(:.*)/\1/g"`
		if [ -n "$DispositivoComParticaoCryptoLUKS" ]; then
			ColecaoDeParticoes=`echo -e "${ColecaoDeParticoes}\n${DispositivoComParticaoCryptoLUKS};${DispositivoComParticaoCryptoLUKS//dev/mnt};$2;$NumeroDeDispositivosUSB;$NumeroDeDispositivosSATA;$UUID;c"`
		fi
	done
	for ParticoesFAT in $1 ; do
		UUID=`echo "$Blkid" | sed -r "/$ParticoesNTFS/!d;/vfat/!d;s/(.* UUID=[\"])([^\"]{1,48})([\"].*)/\2/g"`
		DispositivoComParticaoFAT=`echo "$Blkid" | sed -r "/$ParticoesFAT/!d;/vfat/!d;s/(.*)(:.*)/\1/g"`
		if [ -n "$DispositivoComParticaoFAT" ]; then
			ColecaoDeParticoes=`echo -e "${ColecaoDeParticoes}\n${DispositivoComParticaoFAT};${DispositivoComParticaoFAT//dev/mnt};$2;$NumeroDeDispositivosUSB;$NumeroDeDispositivosSATA;$UUID;c"`
		fi
	done
}
USBOuSATA "$DispositivosUSBs" "USB"
USBOuSATA "$DispositivosSATAs" "SATA"
echo "$ColecaoDeParticoes" | grep -v "^$"
