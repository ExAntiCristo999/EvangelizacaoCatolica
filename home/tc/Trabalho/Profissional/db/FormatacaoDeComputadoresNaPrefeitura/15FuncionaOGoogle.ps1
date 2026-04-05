$response = Invoke-WebRequest -Uri "https://www.google.com.br"              
Write-Host $response.Content
$certo = Read-Host "O conteúdo do Google foi exibido corretamente? (s/n)"
if ($certo -eq "s") {
  Write-Host "Tudo certo!"
} else {
  Write-Host "Algo deu errado. Obtendo a identificação do driver de rede."
  Get-PnpDevice -Class Net | ForEach-Object {
  $hardwareID = $_.HardwareID
  $ven = ($hardwareID | Select-String -Pattern "VEN_([A-Z0-9]+)" | ForEach-Object {$_.Matches.Groups[1].Value})
  $dev = ($hardwareID | Select-String -Pattern "DEV_([A-Z0-9]+)" | ForEach-Object {$_.Matches.Groups[1].Value})
  Write-Host "VEN: $ven DEV: $dev"
}

}

