if [ -z "$1" ]; then
	echo "Nome do local de onde vem o computador à ser formatado."
	exit 1
fi

criar_pasta_backup() {
	endereco caminho="$1"
	if [ ! -d "$caminho" ]; then
		mkdir -p "$caminho"
	fi
}

copiar_arquivo() {
	endereco origem="$1"
	endereco destino="$2"
	endereco tentativa=0
	while [ $tentativa -lt $tentativas ]; do
		if cp -p "$origem" "$destino" 2>/dev/null; then
			return 0
		else
			((tentativa++))
		fi
	done
	return 1
}

#ExcluirBackupComMaisDe2MesesAposADevolucaoDoComputadorAoDestino(){

#}

tce-load -ilw dmidecode efibootmgr ntfs-3g ntfsprogs smartmontools e2fsprogs dosfstools util-linux partclone bash chntpw cifs-utils wimlib bcd-sys
sudo mount -t efivarfs efivarfs /sys/firmware/efi/efivars/
ObterInformacoesDosDiscos=`ObterInformacoesDosDiscos.sh`
NumeroDeDispositivosUSB=`echo "$ObterInformacoesDosDiscos" | sed -n 1p | cut -d ";" -f 4`
if [ "$NumeroDeDispositivosUSB" -ne "1" ]; then
	echo "Só deverá existir um HD externo plugado no computador."
	exit 2
fi
InformacaoDeDiscoUSB=`echo "$ObterInformacoesDosDiscos" | grep USB | cut -d ";" -f 2`
InformacoesDosDiscosNaoUSBs=`echo "$ObterInformacoesDosDiscos" | grep -v USB | cut -d ";" -f 1-2`
ParticoesNaoUSBs=`for UmaParticaoComUmPontoDeMontagem in $InformacoesDosDiscosNaoUSBs ; do echo "${UmaParticaoComUmPontoDeMontagem:0:8}" ; done`
ParticoesNaoUSBs=`echo "$ParticoesNaoUSBs" | sort | uniq`
sudo mount "$InformacaoDeDiscoUSB"
TempoParcial=`date +%d-%m-%y%%%Y-%m-%d-%H%M`
DDMMYY="${TempoParcial%\%*}"
YYYYMMDDHHmm="${TempoParcial#*\%}"
Patrimonio="PCEmAnalise"
for UmDiscoNaoUSB in $ParticoesNaoUSBs ; do
	IncorrigivelOffline=`sudo smartctl -A $UmDiscoNaoUSB | grep "Offline_Uncorrectable" | cut -d "-" -f 2 | sed -r 's/[\t ]+//g' | grep "^0$"`
	SetorPendenteAtual=`sudo smartctl -A $UmDiscoNaoUSB | grep "Current_Pending_Sector" | cut -d "-" -f 2 | sed -r 's/[\t ]+//g' | grep "^0$"`
	logfile="/tmp/badblocks_$(basename $UmDiscoNaoUSB)_$(date +%Y%m%d_%H%M%S).log"
	sudo badblocks -s -v -o "$logfile" "$UmDiscoNaoUSB"
	sudo sfdisk -d "$UmDiscoNaoUSB" "$InformacaoDeDiscoUSB/TabelaDeParticoes.img"
done
SegundosUTC=`date +%s`
for UmaParticaoComUmPontoDeMontagem in $ObterInformacoesDosDiscos ; do
	PontoDeMontagem=`echo "$UmaParticaoComUmPontoDeMontagem" | cut -d ";" -f 2`
	ParticaoUSBDoHDExterno=`echo "$PontoDeMontagem" | grep "$InformacaoDeDiscoUSB"`
	if [ -z "$ParticaoUSBDoHDExterno" ]; then
		TipoDeParticao=`echo "$UmaParticaoComUmPontoDeMontagem" | cut -d ";" -f 7`
		Particao="${UmaParticaoComUmPontoDeMontagem%%;*}"
		UUID=`echo "$UmaParticaoComUmPontoDeMontagem" | cut -d ";" -f 6`
		if [ "$TipoDeParticao" = "n" ]; then
			IMAGEM_PART="$InformacaoDeDiscoUSB/Backup ${1} ${Patrimonio} ${DDMMYY}/imagem/${YYYYMMDDHHmm}-img-partclone/${PontoDeMontagem##*/}.ntfs-ptcl-img"
			sudo ntfsfix "$Particao"
			sudo partclone.ntfs -c -s "$Particao" &> "$LOG_PART" | gzip -c | split -b 4G - "${IMAGEM_PART}.gz."
		elif [ "$TipoDeParticao" = "e" ]; then
			IMAGEM_PART="$InformacaoDeDiscoUSB/Backup ${1} ${Patrimonio} ${DDMMYY}/imagem/${YYYYMMDDHHmm}-img-partclone/${PontoDeMontagem##*/}.ext4-ptcl-img"
			sudo fsck.ext4 -v -f -p "$Particao"
			sudo partclone.ext4 -c -s "$Particao" &> "$LOG_PART" | gzip -c | split -b 4G - "${IMAGEM_PART}.gz."
		elif [ "$TipoDeParticao" = "f" ]; then
			IMAGEM_PART="$InformacaoDeDiscoUSB/Backup ${1} ${Patrimonio} ${DDMMYY}/imagem/${YYYYMMDDHHmm}-img-partclone/${PontoDeMontagem##*/}.vfat-ptcl-img"
			sudo fsck.vfat -v -a "$Particao"
			sudo partclone.vfat -c -s "$Particao" &> "$LOG_PART" | gzip -c | split -b 4G - "${IMAGEM_PART}.gz."
		else
			IMAGEM_PART="$InformacaoDeDiscoUSB/Backup ${1} ${Patrimonio} ${DDMMYY}/imagem/${YYYYMMDDHHmm}-img-partclone/${PontoDeMontagem##*/}.dd-ptcl-img"
			sudo dd if=$Particao bs=4M &> "$LOG_PART" | gzip -c | split -b 4G - "${IMAGEM_PART}.gz."
		fi
		sudo mount "$PontoDeMontagem"
		test_file="$PontoDeMontagem/MeDeleta.bin"
		sudo dd if=/dev/zero of="$test_file" bs=1M count=1024 conv=fdatasync 2>&1 | grep -E "copiados|bytes"
		rm -f "$test_file"
		Software="$PontoDeMontagem/Windows/System32/config/SOFTWARE"
		if [ -e "$Software" ]; then
			ParticaoDoWindows="$PontoDeMontagem"
			PatrimonioAntigo="$Patrimonio"
			Patrimonio=`LibChavesDeRegistroWindowsImportantes.sh h "$Software"`
			if [ -d "$InformacaoDeDiscoUSB/Backup ${1} ${Patrimonio}" ]; then
				mv "$InformacaoDeDiscoUSB/Backup ${1} ${PatrimonioAntigo}" "$InformacaoDeDiscoUSB/Backup ${1} ${Patrimonio}"
			fi
			pastasCopiar=("Desktop" "Documentos" "Downloads" "Favoritos" "Músicas" "Fotos" "Vídeos")
			pastasIgnorar=("Administrador" "tiago.costa" "Public" "Default")
			pastasIgnorarUsuario=("AppData")
			pastasEspeciais=("SISGEP")
			pastaBackup="$InformacaoDeDiscoUSB/Backup ${1} ${Patrimonio} ${DDMMYY}/"
			pastaC="$InformacaoDeDiscoUSB/Backup ${1} ${Patrimonio} ${DDMMYY}/C"
			tentativas=2
			for usuario_path in "$PontoDeMontagem"/Users/*; do
				usuario=$(basename "$usuario_path")
				if [[ " ${pastasIgnorar[@]} " =~ " ${usuario} " ]]; then
					continue
				fi
				if [ -d "$usuario_path" ]; then
    					pastaUsuarioDestino="$pastaBackup/$usuario"
					criar_pasta_backup "$pastaUsuarioDestino"
					for pasta in "${pastasCopiar[@]}"; do
						origem="$usuario_path/$pasta"
						destino="$pastaUsuarioDestino/$pasta"
						if [ -d "$origem" ]; then
							criar_pasta_backup "$destino"
							cp -rp "$origem/." "$destino/" || echo "$origem" >> "$pastaBackup/erros.txt"
		    				fi
					done
					for pasta in "${pastasEspeciais[@]}"; do
						origem="$usuario_path/$pasta"
						destino="$pastaC/$pasta"
						if [ -d "$origem" ]; then
							criar_pasta_backup "$destino"
							cp -rp "$origem/." "$destino/" || echo "$origem" >> "$pastaBackup/erros.txt"
						fi
					done
					for item in "$usuario_path"/*; do
						pasta_nome=$(basename "$item")
				    		if [[ ! " ${pastasCopiar[@]} " =~ " ${pasta_nome} " ]] && [[ ! " ${pastasIgnorarUsuario[@]} " =~ " ${pasta_nome} " ]] && [[ ! " ${pastasEspeciais[@]} " =~ " ${pasta_nome} " ]] && [ -d "$item" ]; then
							read -p "Copiar pasta $pasta_nome? (s/n): " resposta
								if [ "$resposta" == "s" ]; then
									destino="$pastaC/$pasta_nome"
									criar_pasta_backup "$destino"
									cp -rp "$item/." "$destino/" || echo "$item" >> "$pastaBackup/erros.txt"
							fi
						fi
					done
				fi
			done
		elif [ "$TipoDeParticao" = "n" ]; then
			PastaFinal="$InformacaoDeDiscoUSB/Backup ${1} ${Patrimonio}/$UUID"
			if [ ! -d "$PastaFinal" ]; then
				mkdir -p "$PastaFinal"
			fi
			cp -pRf "$PontoDeMontagem"/* "$InformacaoDeDiscoUSB/Backup ${1} ${Patrimonio}/$UUID"
		elif [ "$TipoDeParticao" = "f" ]; then
			ArquivoEFI="$PontoDeMontagem/EFI/Microsoft/Boot/bootmgfw.efi"
			if [ -e "$ArquivoEFI" ]; then
				ParticaoEFIvFAT="$PontoDeMontagem"
			else
				cp -pRf "$PontoDeMontagem"/* "$InformacaoDeDiscoUSB/Backup ${1} ${Patrimonio}/$UUID"
			fi
		fi
	fi
done
#ExcluirBackupComMaisDe2MesesAposADevolucaoDoComputadorAoDestino
SoquetesDeRAM=`sudo dmidecode -t memory`
SoqueteSemRAM=`echo "$SoquetesDeRAM" | grep "Size: No Module Installed"`
SoqueteComRAM=`echo "$SoquetesDeRAM" | grep -v "Size: No Module Installed" | grep "Size: " | sed -r 's/(.*Size: )([0-9]{1,8} )(MB)/\2+/g' | sed ':a;$!N;s/\n/ /;ta;' | sed 's/\+$//g'`
MemoriaRAMTotal="$(( $SoqueteComRAM ))"
CPUInfo=`cat /proc/cpuinfo`
i3i5i7=`echo "$CPUInfo" | grep "i3\|i5\|i7"`
AnoDeFabricacaoDoSoftwareDaBios=`cut -d "/" -f 3 /sys/class/dmi/id/bios_date`
if [ "$MemoriaRAMTotal" -ge "8192" ] && [ -n "$i3i5i7" ]; then		
	InstalarMicrosoftWindows.sh "${ParticaoDoWindows//mnt/dev}" "$ParticaoDoWindows" "/mnt/cifs/Patrimonio/PCTestesCPD/LENOVO#NOK##PE08AYQ3#PE08AYQ3/x86_64/fdc610f0-c200-469f-a8e3-424072a29a62/641C67DEDA3C/WIMs/Win11ProPerso.wim" "$ParticaoEFIvFAT"
elif [ -n "$i3i5i7" ] && [ "$MemoriaRAMTotal" -gt "8192" ]; then
	echo -e "Complete o computador com 8GB de RAM se possível para rodar o Windows 11. Tecle a opção desejada:\n\n1) Vou atualizar para 8GB;\n2) Vou instalar Windows 10."
	read opcao
	opcao=`echo "$opcao" | grep -E "^[1-2]$"`
	if [ "$opcao" -eq "1" ]; then
		echo "Desligue o computador e faça isso."
		exit 1
	else
		InstalarMicrosoftWindows.sh "${ParticaoDoWindows//mnt/dev}" "$ParticaoDoWindows" "/mnt/cifs/Patrimonio/PCTestesCPD/LENOVO#NOK##PE08AYQ3#PE08AYQ3/x86_64/fdc610f0-c200-469f-a8e3-424072a29a62/641C67DEDA3C/WIMs/Win10ProPerso.wim" "$ParticaoEFIvFAT"
	fi
else
	if [ -n "$Patrimonio" ]; then
		NumeroDePatrimonio="${Patrimonio//PC/}"
		if [ "$NumeroDePatrimonio" -ge "50000" ]; then
			InstalarMicrosoftWindows.sh 
		else
			echo "Com a autorização do chefe, selecione uma das seguintes opções:\n1) Windows 10;\n2) Linux;\n3) Ou dar baixa."
			read opcao
			opcao=`echo "$opcao" | grep "^[1-3]$"`
			if [ "$opcao" -eq "1" ]; then
				InstalarMicrosoftWindows.sh "${ParticaoDoWindows//mnt/dev}" "$ParticaoDoWindows" "/mnt/cifs/Patrimonio/PCTestesCPD/LENOVO#NOK##PE08AYQ3#PE08AYQ3/x86_64/fdc610f0-c200-469f-a8e3-424072a29a62/641C67DEDA3C/WIMs/Win10ProPerso.wim" "$ParticaoEFIvFAT"
			elif [ "$opcao" -eq "2" ]; then
				InstalarCoreLinux.sh
			else
				echo "Verifique a documentação de baixa com o chefe."
			fi
		fi
	fi
fi
