$processador = Get-WmiObject -Class Win32_Processor
$memoriaRAM = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory
$memoriaRAMGB = [math]::Round($memoriaRAM / 1GB)

if (($processador.Name -like "*i3*" -or $processador.Name -like "*i5*" -or $processador.Name -like "*i7*") -and $memoriaRAMGB -ge 8) {
  Write-Host "Instale o Windows 11 Pro 64 bits UEFI, ative o secure Boot na BIOS se disponível"
} elseif ($processador.Name -like "*i3*" -or $processador.Name -like "*i5*" -or $processador.Name -like "*i7*") {
  Write-Host "Complete os 8GB de RAM que o computador precisa para o Windows 11 Pro 64 bits UEFI, e se a BIOS suportar ative o secure Boot. As memórias RAM devem ser do mesmo fabricante, com a mesma frequência de funcionamento, com a mesma capacidade e em pares, para trabalharem em dual channel."
} else {
	$processador = Get-WmiObject -Class Win32_Processor
	$anoFabricacao = $processador.Manufacturer + " " + $processador.Name
	$dataFabricacao = Get-Date -Year ($processador.ReleaseDate.Substring(0,4)) -Month ($processador.ReleaseDate.Substring(4,2)) -Day ($processador.ReleaseDate.Substring(6,2))
	$idadeProcessador = (Get-Date) - $dataFabricacao
	if ($idadeProcessador.Days -gt 3650) {
		Write-Host "Verifique se é possível substituir o computador por outro mais recente, faça backup dos arquivos, gere a imagem do HD com o Rescuezilla, e encaminhe o computador substituído para baixa"
		Read-Host "Pressione Enter para continuar...E instale o Windows 10, caso não seja encaminhado pars baixa."
	}
}
White-Host "Se o computador saiu de fábrica com Windows 11, reinstalar e manter o mesmo sistema."
