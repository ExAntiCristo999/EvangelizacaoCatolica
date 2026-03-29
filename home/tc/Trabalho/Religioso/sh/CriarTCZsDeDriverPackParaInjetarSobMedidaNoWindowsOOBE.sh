if [ "$USER" != "tc" ]; then
	echo "Plataforma desconhecida. Software construído para Micro Core Linux apenas."
	exit 1
fi
TORRENT_URL="$1"
if [ -z "$TORRENT_URL" ]; then
    echo "ERRO: Forneça a URL do arquivo .torrent"
    echo "Uso: $0 \"URL_DO_TORRENT\" \"Pasta de destino que conterá do DriverPack até os arquivos TCZs finais para serem injetados, via Core Linux, para o Windows OOBE.\""
    exit 1
fi

BASE_DIR="${2:-./driverpack_completo}"
TORRENT_DIR="$BASE_DIR/torrent"
DRIVERPACK_DIR="$BASE_DIR/DriverPack"
TCZ_OUTPUT="$BASE_DIR/tcz_drivers"
LOG_FILE="$BASE_DIR/processo.log"

# --- Funções ---
log() { 
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

verificar_ferramentas() {
    log "Verificando ferramentas necessárias..."
    
    # Ferramentas para download
    if ! command -v rtorrent >/dev/null && ! command -v aria2c >/dev/null; then
        log "AVISO: Nem rtorrent nem aria2 encontrados. Tentando instalar..."
        if command -v tce-load >/dev/null; then
            # Estamos no Micro Core
            tce-load -wi aria2
        elif command -v apt-get >/dev/null; then
            # Debian/Ubuntu
            apt-get update && apt-get install -y aria2 rtorrent
        elif command -v yum >/dev/null; then
            # CentOS/RHEL
            yum install -y aria2 rtorrent
        else
            error "Instale aria2 ou rtorrent manualmente"
            exit 1
        fi
    fi
    
    # Ferramentas para squashfs
    if ! command -v mksquashfs >/dev/null; then
        log "Instalando squashfs-tools..."
        if command -v tce-load >/dev/null; then
            tce-load -wi squashfs-tools
        else
            apt-get install -y squashfs-tools || yum install -y squashfs-tools
        fi
    fi
    
    log "Todas as ferramentas disponíveis"
}

# --- INÍCIO ---
mkdir -p "$TORRENT_DIR" "$DRIVERPACK_DIR" "$TCZ_OUTPUT"
log "=== INICIANDO PROCESSO COMPLETO ==="
log "URL do torrent: $TORRENT_URL"
log "Diretório base: $BASE_DIR"

verificar_ferramentas

# --- FASE 1: Download do arquivo .torrent ---
log "FASE 1: Baixando arquivo .torrent..."

TORRENT_FILE="$TORRENT_DIR/driverpack.torrent"
if command -v curl >/dev/null; then
    curl -L "$TORRENT_URL" -o "$TORRENT_FILE"
elif command -v wget >/dev/null; then
    wget -O "$TORRENT_FILE" "$TORRENT_URL"
else
    log "ERRO: curl ou wget não encontrado"
    exit 1
fi

if [ ! -f "$TORRENT_FILE" ] || [ ! -s "$TORRENT_FILE" ]; then
    log "ERRO: Falha ao baixar arquivo .torrent"
    exit 1
fi

log "Arquivo .torrent baixado: $(du -h "$TORRENT_FILE" | cut -f1)"

# --- FASE 2: Download do DriverPack via torrent ---
log "FASE 2: Iniciando download do DriverPack via torrent"
log "ISSO PODE LEVAR HORAS (tamanho ~37 GB)"

cd "$DRIVERPACK_DIR"

# Tenta usar aria2 (mais leve para terminal)
if command -v aria2c >/dev/null; then
    log "Usando aria2 para download..."
    aria2c \
        --seed-time=0 \
        --max-connection-per-server=16 \
        --split=16 \
        --min-split-size=1M \
        --console-log-level=notice \
        --download-result=full \
        --dir="$DRIVERPACK_DIR" \
        --input-file="$TORRENT_FILE"
    
# Fallback para rtorrent
elif command -v rtorrent >/dev/null; then
    log "Usando rtorrent para download..."
    cat > "$TORRENT_DIR/rtorrent.rc" << EOF
directory = $DRIVERPACK_DIR
session = $TORRENT_DIR/session
port_range = 6890-6999
dht = auto
peer_exchange = yes
min_peers = 1
max_peers = 500
max_uploads = 10
upload_rate = 0
download_rate = 0
EOF
    
    screen -dmS driverpack rtorrent -n -o import="$TORRENT_DIR/rtorrent.rc" "$TORRENT_FILE"
    log "rtorrent iniciado em segundo plano (screen -r driverpack para ver progresso)"
    log "Aguardando download completar..."
    
    # Monitora até completar
    while true; do
        if [ -f "$DRIVERPACK_DIR/.torrent/finished" ]; then
            break
        fi
        # Verifica se ainda está rodando
        if ! screen -list | grep -q "driverpack"; then
            log "Download parece ter terminado ou encontrado erro"
            break
        fi
        sleep 60
    done
else
    log "ERRO: Nenhum cliente torrent disponível"
    exit 1
fi

# Verifica se baixou algo
DP_CONTENTS=$(find "$DRIVERPACK_DIR" -type f -name "*.inf" 2>/dev/null | wc -l)
if [ "$DP_CONTENTS" -eq 0 ]; then
    log "ERRO: Nenhum arquivo .inf encontrado. Download pode ter falhado."
    exit 1
fi

log "Download concluído! Encontrados $DP_CONTENTS arquivos .inf"

# --- FASE 3: Processar DriverPack ---
log "FASE 3: Processando DriverPack para Micro Core..."

# Usa o script anterior adaptado para a estrutura real
cat > "$BASE_DIR/processar_driverpack.sh" << 'EOF'
#!/bin/sh
# Script interno de processamento
DRIVERPACK_DIR="$1"
OUTPUT_DIR="$2"

log() { echo "[PROCESS] $1"; }

# Extrai Hardware IDs de arquivos INF (formato Windows)
extrair_hwids() {
    local inf_file="$1"
    local driver_name=$(basename "$(dirname "$inf_file")")
    
    # Procura por seções de hardware no INF
    local in_hw_section=0
    
    while IFS= read -r line; do
        # Remove comentários e espaços extras
        line=$(echo "$line" | sed 's/;.*//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        [ -z "$line" ] && continue
        
        # Detecta início de seção de hardware
        if echo "$line" | grep -q "^\[[^]]*\.NT[^]]*\]"; then
            in_hw_section=1
            continue
        fi
        
        # Detecta fim da seção
        if echo "$line" | grep -q "^\[" && [ $in_hw_section -eq 1 ]; then
            in_hw_section=0
        fi
        
        # Dentro de seção de hardware, procura por IDs
        if [ $in_hw_section -eq 1 ]; then
            if echo "$line" | grep -q "="; then
                # Extrai o ID após o = e antes da vírgula
                hwid=$(echo "$line" | cut -d= -f2- | cut -d, -f1 | tr -d '"' | tr -d ' ')
                if [ -n "$hwid" ]; then
                    # Verifica se parece um hardware ID
                    case "$hwid" in
                        *"PCI\\"*|*"USB\\"*|*"ACPI\\"*)
                            echo "$hwid|$inf_file|$driver_name"
                            ;;
                    esac
                fi
            fi
        fi
    done < "$inf_file"
}

# --- MAIN ---
mkdir -p "$OUTPUT_DIR"
HWID_FILE="$OUTPUT_DIR/hwid_catalog.txt"

log "Extraindo Hardware IDs de todos os INFs..."

# Processa cada INF
find "$DRIVERPACK_DIR" -name "*.inf" -type f | while read -r inf; do
    extrair_hwids "$inf" >> "$HWID_FILE.tmp"
done

# Remove duplicatas e ordena
sort -u "$HWID_FILE.tmp" > "$HWID_FILE"
rm -f "$HWID_FILE.tmp"

total_hwids=$(wc -l < "$HWID_FILE")
log "Extraídos $total_hwids Hardware IDs únicos"

# Cria diretórios por categoria
mkdir -p "$OUTPUT_DIR/"{net,mass,video,audio,chipset,other}

# Função para determinar categoria
get_category() {
    case "$1" in
        *"NET"*|*"Ethernet"*|*"Network"*|*"Lan"*)
            echo "net" ;;
        *"Mass"*|*"STOR"*|*"Disk"*|*"SATA"*|*"RAID"*)
            echo "mass" ;;
        *"Video"*|*"Display"*|*"VGA"*|*"GPU"*)
            echo "video" ;;
        *"Audio"*|*"Sound"*|*"HDAudio"*)
            echo "audio" ;;
        *"Chipset"*|*"SMBus"*|*"PM"*|*"LPC"*)
            echo "chipset" ;;
        *)
            echo "other" ;;
    esac
}

log "Organizando drivers por categoria..."

# Copia drivers para categorias baseado no nome
find "$DRIVERPACK_DIR" -maxdepth 2 -type d | while read -r dir; do
    dirname=$(basename "$dir")
    category=$(get_category "$dirname")
    
    if [ -d "$dir" ] && [ "$dir" != "$DRIVERPACK_DIR" ]; then
        if [ "$(find "$dir" -name "*.inf" 2>/dev/null | wc -l)" -gt 0 ]; then
            cp -r "$dir" "$OUTPUT_DIR/$category/"
            log "  $category <- $dirname"
        fi
    fi
done

log "Organização concluída"

# Gera script de detecção
cat > "$OUTPUT_DIR/detectar_hardware.sh" << 'INNER'
#!/bin/sh
# Detecta hardware e lista drivers necessários
HWID_FILE="/mnt/sda1/tcz_drivers/hwid_catalog.txt"
OUTPUT="/tmp/drivers_necessarios.txt"

log() { echo "[DETECT] $1"; }

log "Detectando hardware PCI..."
lspci -n | while read -r line; do
    ven=$(echo "$line" | grep -o "[0-9a-f]\{4\}:[0-9a-f]\{4\}" | cut -d: -f1 | tr '[:lower:]' '[:upper:]')
    dev=$(echo "$line" | grep -o "[0-9a-f]\{4\}:[0-9a-f]\{4\}" | cut -d: -f2 | tr '[:lower:]' '[:upper:]')
    
    if [ -n "$ven" ] && [ -n "$dev" ]; then
        hwid="PCI\\VEN_$ven&DEV_$dev"
        if grep -q "$hwid" "$HWID_FILE"; then
            log "  Encontrado: $hwid"
            echo "$hwid" >> "$OUTPUT"
        fi
    fi
done

log "Detectando dispositivos USB..."
lsusb | while read -r line; do
    ven=$(echo "$line" | grep -o "[0-9a-f]\{4\}:[0-9a-f]\{4\}" | cut -d: -f1 | tr '[:lower:]' '[:upper:]')
    dev=$(echo "$line" | grep -o "[0-9a-f]\{4\}:[0-9a-f]\{4\}" | cut -d: -f2 | tr '[:lower:]' '[:upper:]')
    
    if [ -n "$ven" ] && [ -n "$dev" ]; then
        hwid="USB\\VEN_$ven&DEV_$dev"
        if grep -q "$hwid" "$HWID_FILE"; then
            log "  Encontrado: $hwid"
            echo "$hwid" >> "$OUTPUT"
        fi
    fi
done

sort -u -o "$OUTPUT" "$OUTPUT"
count=$(wc -l < "$OUTPUT")
log "Total de hardware detectado que possui driver: $count"
echo "$count"
INNER
chmod +x "$OUTPUT_DIR/detectar_hardware.sh"

log "Scripts de detecção criados"
EOF

chmod +x "$BASE_DIR/processar_driverpack.sh"
"$BASE_DIR/processar_driverpack.sh" "$DRIVERPACK_DIR" "$TCZ_OUTPUT"

# --- FASE 4: Gerar extensões .tcz ---
log "FASE 4: Gerando extensões .tcz..."

# Tamanho máximo por .tcz (configurável)
MAX_TCZ_SIZE=30  # MB

for categoria in net mass video audio chipset other; do
    cat_dir="$TCZ_OUTPUT/$categoria"
    if [ -d "$cat_dir" ] && [ "$(ls -A "$cat_dir")" ]; then
        total_size=$(du -sm "$cat_dir" | cut -f1)
        
        if [ "$total_size" -le "$MAX_TCZ_SIZE" ]; then
            # Cabe em um .tcz
            output="$TCZ_OUTPUT/drivers_${categoria}.tcz"
            log "Gerando $output (${total_size}MB)..."
            mksquashfs "$cat_dir" "$output" -comp xz -noappend
            md5sum "$output" > "$output.md5.txt"
        else
            # Precisa dividir
            part=1
            current_dir="/tmp/tcz_build/${categoria}_p${part}"
            mkdir -p "$current_dir"
            current_size=0
            
            find "$cat_dir" -type f | while read -r file; do
                size_mb=$(du -m "$file" | cut -f1)
                [ "$size_mb" -eq 0 ] && size_mb=1
                
                if [ $((current_size + size_mb)) -gt "$MAX_TCZ_SIZE" ] && [ "$current_size" -gt 0 ]; then
                    # Finaliza parte
                    output="$TCZ_OUTPUT/drivers_${categoria}_p${part}.tcz"
                    log "Gerando $output (${current_size}MB)..."
                    mksquashfs "$current_dir" "$output" -comp xz -noappend
                    md5sum "$output" > "$output.md5.txt"
                    
                    # Nova parte
                    part=$((part + 1))
                    current_dir="/tmp/tcz_build/${categoria}_p${part}"
                    mkdir -p "$current_dir"
                    current_size=0
                fi
                
                # Copia arquivo
                rel_path="${file#$cat_dir/}"
                target="$current_dir/$rel_path"
                mkdir -p "$(dirname "$target")"
                cp "$file" "$target"
                current_size=$((current_size + size_mb))
            done
            
            # Última parte
            if [ "$current_size" -gt 0 ]; then
                output="$TCZ_OUTPUT/drivers_${categoria}_p${part}.tcz"
                log "Gerando $output (${current_size}MB)..."
                mksquashfs "$current_dir" "$output" -comp xz -noappend
                md5sum "$output" > "$output.md5.txt"
            fi
        fi
    fi
done

# --- FASE 5: Gerar instruções finais ---
log "FASE 5: Finalizando..."

cat > "$BASE_DIR/INSTRUCOES.txt" << 'EOF'
=== INSTRUÇÕES DE USO ===

1. Copie a pasta 'tcz_drivers' para seu pendrive com Micro Core Linux

2. No Micro Core (no PC alvo), faça:
   cd /mnt/sda1/tcz_drivers  # ajuste o caminho
   ./detectar_hardware.sh     # lista o hardware encontrado

3. Monte apenas os drivers necessários:
   for tcz in drivers_*.tcz; do
       mount -t squashfs "$tcz" "/tmp/tcloop/$(basename $tcz .tcz)" -o loop
   done

4. Os drivers estarão disponíveis em /tmp/tcloop/ para copiar para o Windows

ESTATÍSTICAS:
EOF

# Adiciona estatísticas
echo "Total de arquivos .inf: $(find "$DRIVERPACK_DIR" -name "*.inf" 2>/dev/null | wc -l)" >> "$BASE_DIR/INSTRUCOES.txt"
echo "Hardware IDs catalogados: $(wc -l < "$TCZ_OUTPUT/hwid_catalog.txt")" >> "$BASE_DIR/INSTRUCOES.txt"
echo "Extensões .tcz geradas: $(ls "$TCZ_OUTPUT"/*.tcz 2>/dev/null | wc -l)" >> "$BASE_DIR/INSTRUCOES.txt"
echo "Tamanho total dos .tcz: $(du -sh "$TCZ_OUTPUT" | cut -f1)" >> "$BASE_DIR/INSTRUCOES.txt"

# --- RELATÓRIO FINAL ---
log "=== PROCESSO COMPLETO ==="
log "DriverPack baixado em: $DRIVERPACK_DIR"
log "Extensões .tcz em: $TCZ_OUTPUT"
log "Instruções em: $BASE_DIR/INSTRUCOES.txt"
log ""
log "ESTATÍSTICAS:"
log "- Arquivos .inf: $(find "$DRIVERPACK_DIR" -name "*.inf" 2>/dev/null | wc -l)"
log "- Hardware IDs: $(wc -l < "$TCZ_OUTPUT/hwid_catalog.txt")"
log "- Extensões .tcz: $(ls "$TCZ_OUTPUT"/*.tcz 2>/dev/null | wc -l)"
log "- Espaço total .tcz: $(du -sh "$TCZ_OUTPUT" | cut -f1)"

exit 0
