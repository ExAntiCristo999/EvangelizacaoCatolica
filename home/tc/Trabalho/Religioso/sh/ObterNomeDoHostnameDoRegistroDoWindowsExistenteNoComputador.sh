#!/bin/sh

FuncaoPrincipalDoProgramaObterNomeDoHostnameDoRegistroDoWindowsExistenteNoComputador(){
	NomeDoProgramaPontoSh="${0##*/}"
	NomeDoPrograma="${NomeDoProgramaPontoSh%.sh}"
	tce-load -il chntpw
	MontarHdSsdOuPendriveNoCoreLinux.sh sda2 &> /dev/null
	LocalizacoesPossiveisDoArquivoSystemQueArmazenaAlgumasInformacoesDoRegistroDoWindows=`while read l ; do echo "/mnt/sda2/Windows/${l}" ; done < "$PastaPadraoDosProgramasQueCrio/BancoDeDados/LocalizacoesPossiveisDoArquivoDeRegistroDoWindowsVirgulaChamadoSystemSemOSufixoBarraMntBarraSdaNumeroDaParticaoContendoAPastaWindows.db"`
	PastaTemporaria="$PastaComArquivosTemporariosDosProgramasQueCrio/$NomeDoPrograma"
	if [ ! -d "$PastaTemporaria" ]; then
		mkdir -p "$PastaTemporaria"
	fi
	for UmaLocalizacaoPossivelDoArquivoSystemQueArmazenaAlgumasInformacoesDoRegistroDoWindows in $LocalizacoesPossiveisDoArquivoSystemQueArmazenaAlgumasInformacoesDoRegistroDoWindows ; do
		if [ -e "$UmaLocalizacaoPossivelDoArquivoSystemQueArmazenaAlgumasInformacoesDoRegistroDoWindows" ]; then
			cp "$UmaLocalizacaoPossivelDoArquivoSystemQueArmazenaAlgumasInformacoesDoRegistroDoWindows" $PastaTemporaria
			chmod 777 "$PastaTemporaria/${UmaLocalizacaoPossivelDoArquivoSystemQueArmazenaAlgumasInformacoesDoRegistroDoWindows##*/}"
			reged -x "$PastaTemporaria/${UmaLocalizacaoPossivelDoArquivoSystemQueArmazenaAlgumasInformacoesDoRegistroDoWindows##*/}" "HKLM\SYSTEM" "ControlSet001\Control\ComputerName" "$PastaTemporaria/hostname.reg" &> /dev/null
			sed -r '/ComputerName"=/!d;s/(.*=")([^"]{1,200})(")/\2/g' "$PastaTemporaria/hostname.reg"
			rm -rf "$PastaTemporaria"
			break
		fi
	done
}

FuncaoPrincipalDoProgramaObterNomeDoHostnameDoRegistroDoWindowsExistenteNoComputador
