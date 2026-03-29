# Importa o módulo PnPDevice
Import-Module -Name Microsoft.PowerShell.Management

# Verifica os dispositivos não identificados em "Outros dispositivos"
$dispositivos_nao_identificados = Get-PnpDevice -Class "Unknown" -Status "Error"

if ($dispositivos_nao_identificados) {
  Write-Host "Hardware não identificado em 'Outros dispositivos':"
  $dispositivos_nao_identificados | Select-Object -ExpandProperty FriendlyName
} else {
  Write-Host "Nenhum hardware não identificado encontrado."
}

# Verifica o adaptador de vídeo
$adaptador_video = Get-PnpDevice -Class "Display" | Where-Object {$_.FriendlyName -like "*Adaptador de vídeo básico da Microsoft*"}

if ($adaptador_video) {
  Write-Host "Adaptador de vídeo:"
  $adaptador_video | Select-Object -ExpandProperty FriendlyName
  Write-Host "Instale os drivers mais recentes dos fabricantes"
}

