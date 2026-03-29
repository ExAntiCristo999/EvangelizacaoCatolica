#!/bin/sh
# Script para detectar informações do BIOS/UEFI e sistema Windows
# Compatível com BusyBox

echo "=== COLETA DE INFORMAÇÕES DO SISTEMA ==="
echo "Data/hora: $(date)"
echo "Município: Toledo-PR"
echo "Departamento: TI da Prefeitura"
echo ""

# Detectar se é BIOS ou UEFI
if [ -d /sys/firmware/efi ]; then
    echo "Firmware: UEFI"
    FW_TYPE="UEFI"
else
    echo "Firmware: BIOS Legado"
    FW_TYPE="BIOS"
fi

# Tentar obter data do BIOS/UEFI
echo -n "Data do BIOS/UEFI: "
if command -v dmidecode >/dev/null 2>&1; then
    dmidecode -s bios-release-date 2>/dev/null || echo "Não disponível"
elif [ -f /sys/class/dmi/id/bios_date ]; then
    cat /sys/class/dmi/id/bios_date
else
    echo "Informação não acessível"
fi

# Detectar informações do Windows
echo ""
echo "=== DETECÇÃO DE INSTALAÇÃO WINDOWS ==="

# Método 1: Procurar por partições Windows
if fdisk -l 2>/dev/null | grep -q "NTFS\|FAT32"; then
    echo "Sistema de arquivos Windows detectado"
    
    # Tentar determinar versão do Windows
    if [ -d "/mnt/windows" ] || [ -d "/mnt/c" ]; then
        WIN_MOUNT="/mnt/windows"
        [ -d "/mnt/c" ] && WIN_MOUNT="/mnt/c"
        
        # Verificar arquivos de sistema Windows
        if [ -f "${WIN_MOUNT}/Windows/System32/winver.exe" ]; then
            echo "Windows instalado encontrado em: ${WIN_MOUNT}"
            
            # Tentar encontrar versão via arquivos de sistema
            if [ -f "${WIN_MOUNT}/Windows/System32/license.rtf" ]; then
                echo "Possível Windows 10/11 (baseado em license.rtf)"
                ESTIMATED_WIN="10/11"
            elif [ -f "${WIN_MOUNT}/Windows/explorer.exe" ]; then
                # Análise básica do tamanho do explorer.exe para estimativa
                EXPL_SIZE=$(stat -c%s "${WIN_MOUNT}/Windows/explorer.exe" 2>/dev/null || echo "0")
                if [ "$EXPL_SIZE" -gt 4000000 ]; then
                    echo "Possível Windows 10/11 (explorer.exe grande)"
                    ESTIMATED_WIN="10/11"
                elif [ "$EXPL_SIZE" -gt 2000000 ]; then
                    echo "Possível Windows 7/8"
                    ESTIMATED_WIN="7/8"
                else
                    echo "Possível Windows anterior ao 7"
                    ESTIMATED_WIN="XP/Vista"
                fi
            fi
        fi
    fi
else
    echo "Nenhuma partição Windows detectada"
fi

# Método 2: Verificar dados SMBIOS/DMI
echo ""
echo "=== INFORMAÇÕES SMBIOS/DMI ==="
if [ -f /sys/class/dmi/id/sys_vendor ]; then
    echo "Fabricante: $(cat /sys/class/dmi/id/sys_vendor 2>/dev/null)"
    echo "Produto: $(cat /sys/class/dmi/id/product_name 2>/dev/null)"
    echo "Versão: $(cat /sys/class/dmi/id/product_version 2>/dev/null)"
fi

# Método 3: Verificar data de fabricação pelo serial
echo ""
echo "=== ESTIMATIVA DE IDADE DO EQUIPAMENTO ==="
if [ -f /sys/class/dmi/id/product_serial ]; then
    SERIAL=$(cat /sys/class/dmi/id/product_serial 2>/dev/null)
    echo "Número de série: $SERIAL"
    
    # Análise básica do serial para estimar idade
    case "$SERIAL" in
        *201[0-4]*|*201[0-4])
            echo "Estimativa: Fabricado ~2010-2014 (Possível Windows 7/8)"
            REC_WIN_VER="7/8"
            ;;
        *201[5-7]*|*201[5-7])
            echo "Estimativa: Fabricado ~2015-2017 (Possível Windows 10)"
            REC_WIN_VER="10"
            ;;
        *201[8-9]*|*201[8-9])
            echo "Estimativa: Fabricado ~2018-2019 (Windows 10)"
            REC_WIN_VER="10"
            ;;
        *202[0-9]*|*202[0-9])
            echo "Estimativa: Fabricado ~2020+ (Possível Windows 10/11)"
            REC_WIN_VER="10/11"
            ;;
        *)
            echo "Estimativa: Idade indeterminada pelo serial"
            REC_WIN_VER="Desconhecida"
            ;;
    esac
fi

echo ""
echo "=== RECOMENDAÇÃO PARA MIGRAÇÃO ==="
if [ "$ESTIMATED_WIN" = "10/11" ] || [ "$REC_WIN_VER" = "10/11" ]; then
    echo "ESTE EQUIPAMENTO PROVAVELMENTE VEIO COM WINDOWS 10/11"
    echo "AÇÃO REQUERIDA: Extrair chave de licença antes de qualquer procedimento"
    echo "RECOMENDAÇÃO: Use o script PowerShell abaixo para extrair a chave"
else
    echo "Equipamento mais antigo detectado"
    echo "RECOMENDAÇÃO: Migração direta para Micro Core Linux"
fi

echo ""
echo "Script executado para fins de migração para software livre"
echo "Prefeitura Municipal de Toledo-PR"
