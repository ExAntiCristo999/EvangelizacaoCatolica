$patrimonio = Read-Host "Digite o número do patrimônio do computador"
$hostname = "$patrimonio"
Rename-Computer -NewName $hostname -Force
Restart-Computer -Force
