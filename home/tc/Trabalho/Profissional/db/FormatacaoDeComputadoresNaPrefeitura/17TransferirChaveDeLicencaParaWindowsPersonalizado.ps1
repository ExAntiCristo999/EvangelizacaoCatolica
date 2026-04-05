# Script para extrair chave de licença do Windows do firmware UEFI/BIOS
# Deve ser executado como Administrador no Windows

Write-Host "=== EXTRAÇÃO DE CHAVE DE LICENÇA WINDOWS ===" -ForegroundColor Cyan
Write-Host "Prefeitura Municipal de Toledo-PR" -ForegroundColor Yellow
Write-Host "Departamento de TI - Processo de Migração para Software Livre`n" -ForegroundColor Yellow

# Verificar se está executando como administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "ERRO: Execute este script como Administrador!" -ForegroundColor Red
    Write-Host "Clique com botão direito no PowerShell e selecione 'Executar como Administrador'" -ForegroundColor Yellow
    exit 1
}

# Função para converter chave OA3
function Convert-OA3Key($binaryData) {
    $key = ""
    $chars = "BCDFGHJKMPQRTVWXY2346789"
    
    for ($i = 0; $i < 29; $i++) {
        if ($i -in @(5, 11, 17, 23)) {
            $key += "-"
        } else {
            $accum = 0
            for ($j = 14; $j -ge 0; $j--) {
                $accum = $accum * 256 -bxor $binaryData[$j]
                $binaryData[$j] = [math]::Floor($accum / 24)
                $accum = $accum % 24
            }
            $key += $chars[$accum]
        }
    }
    return $key
}

Write-Host "Buscando chaves de licença do Windows...`n" -ForegroundColor Green

# Método 1: Chave do Registry (instalação atual)
Write-Host "1. Chave do Registro do Windows:" -ForegroundColor Cyan
$regKey = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "DigitalProductId" -ErrorAction SilentlyContinue).DigitalProductId
if ($regKey) {
    $productKey = Convert-OA3Key $regKey[52..66]
    Write-Host "   Chave encontrada: $productKey" -ForegroundColor Green
} else {
    Write-Host "   Nenhuma chave encontrada no registro" -ForegroundColor Yellow
}

# Método 2: Chave do Firmware UEFI/BIOS
Write-Host "`n2. Chave do Firmware (UEFI/BIOS):" -ForegroundColor Cyan
try {
    $wmi = Get-WmiObject -Namespace "root\cimv2" -Class "SoftwareLicensingService" -ErrorAction Stop
    $oemKey = $wmi.OA3xOriginalProductKey
    if ($oemKey) {
        Write-Host "   Chave OEM encontrada: $oemKey" -ForegroundColor Green
    } else {
        Write-Host "   Nenhuma chave OEM encontrada no firmware" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   Não foi possível acessar informações do firmware" -ForegroundColor Yellow
}

# Método 3: Usando o WMIC
Write-Host "`n3. Busca via WMIC:" -ForegroundColor Cyan
$wmicKey = wmic path softwarelicensingservice get OA3xOriginalProductKey 2>$null | Select-String -Pattern "[A-Z0-9]{5}-[A-Z0-9]{5}-[A-Z0-9]{5}-[A-Z0-9]{5}-[A-Z0-9]{5}"
if ($wmicKey) {
    Write-Host "   Chave via WMIC: $($wmicKey.Matches.Value)" -ForegroundColor Green
}

# Método 4: Usando PowerShell Classes
Write-Host "`n4. Busca via Classes PowerShell:" -ForegroundColor Cyan
try {
    $licensing = Get-CimInstance -ClassName SoftwareLicensingProduct -Filter "ApplicationID='55c92734-d682-4d71-983e-d6ec3f16059f' and LicenseStatus=1" -ErrorAction Stop
    foreach ($license in $licensing) {
        if ($license.PartialProductKey) {
            Write-Host "   Produto: $($license.Name)" -ForegroundColor Green
            Write-Host "   ID: $($license.ID)" -ForegroundColor Green
            Write-Host "   Chave parcial: $($license.PartialProductKey)" -ForegroundColor Green
        }
    }
} catch {
    Write-Host "   Não foi possível obter informações" -ForegroundColor Yellow
}

# Informações do sistema
Write-Host "`n=== INFORMAÇÕES DO SISTEMA ===" -ForegroundColor Cyan
Write-Host "Data: $(Get-Date)"
Write-Host "Computador: $env:COMPUTERNAME"
Write-Host "Usuário: $env:USERNAME"
Write-Host "`n=== INSTRUÇÕES ===" -ForegroundColor Cyan
Write-Host "1. Anote TODAS as chaves encontradas acima"
Write-Host "2. Armazene em local seguro com número do patrimônio"
Write-Host "3. Esta chave será necessária para regularização"
Write-Host "4. Após anotar, prossiga com a instalação do Micro Core Linux"

# Gerar relatório
$reportPath = "$env:USERPROFILE\Desktop\Chaves_Windows_$env:COMPUTERNAME.txt"
"=== RELATÓRIO DE CHAVES WINDOWS ===" | Out-File -FilePath $reportPath -Encoding UTF8
"Prefeitura Municipal de Toledo-PR" | Out-File -FilePath $reportPath -Append
"Departamento de TI - Processo de Migração" | Out-File -FilePath $reportPath -Append
"Data: $(Get-Date)" | Out-File -FilePath $reportPath -Append
"Computador: $env:COMPUTERNAME" | Out-File -FilePath $reportPath -Append
"`nCHAVES ENCONTRADAS:" | Out-File -FilePath $reportPath -Append
if ($productKey) { "Registro: $productKey" | Out-File -FilePath $reportPath -Append }
if ($oemKey) { "Firmware: $oemKey" | Out-File -FilePath $reportPath -Append }
if ($wmicKey) { "WMIC: $($wmicKey.Matches.Value)" | Out-File -FilePath $reportPath -Append }

Write-Host "`nRelatório salvo em: $reportPath" -ForegroundColor Green
Write-Host "Pressione qualquer tecla para continuar..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
