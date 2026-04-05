# Verifica se a conexão Ethernet está disponível e funcionando
$ethernet = Get-NetAdapter -Name "Ethernet" | Where-Object {$_.Status -eq "Up"}
if ($ethernet) {
  # Desativa o WiFi
  Get-NetAdapter -Name "Wi-Fi" | Disable-NetAdapter -Confirm:$false
  echo "WiFi desativado. Conexão Ethernet disponível e funcionando."
} else {
  # Conecta ao WiFi PMTOLEDO
  netsh wlan connect name="PMTOLEDO"
  echo "Conectado ao WiFi PMTOLEDO."
}