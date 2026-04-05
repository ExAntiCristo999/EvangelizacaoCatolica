
$IPDaImpressora = Read-Host "Digite o IP da impressora"


Add-PrinterPort -Name "IP:$IPDaImpressora" -PrinterHostAddress $IPDaImpressora
Add-PrinterPort -Name "IP:$IPDaImpressora" -PrinterHostAddress $IPDaImpressora -PortType TcpIp

# Verifica se a impressora tem um escaneador
$impressora = Get-Printer -Name "MinhaImpressora"
if ($impressora | Get-PrinterProperty -Name "ScanTo" -ErrorAction SilentlyContinue) {
  # Verifica se a impressora está configurada para enviar documentos digitalizados para uma pasta do servidor
  $configuracao = $impressora | Get-PrinterProperty -Name "ScanToFolder"
  if ($configuracao.Value -notlike "\\servidor\M:\*") {
    Write-Host "A impressora tem um escaneador, mas não está configurada para enviar documentos digitalizados para a pasta M:\ do servidor."
    Write-Host "Por favor, instale o driver completo do fabricante para instalar o aplicativo do escaneamento e configure a impressora para enviar documentos digitalizados para a pasta M:\ do servidor."
  }
} else {
  Write-Host "A impressora não tem um escaneador ou não foi possível verificar."
}