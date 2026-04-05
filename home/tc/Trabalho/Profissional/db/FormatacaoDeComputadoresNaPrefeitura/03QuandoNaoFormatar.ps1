function Get-TempoFormatacaoMedio {
  $arquivo = "C:\Users\tiago.costa\Documentos\TempoDeFormatacao.txt"
  $tempos = Get-Content $arquivo | Where-Object { $_ -match '^\d+$' } | ForEach-Object { [int]$_ }
  if ($tempos.Count -eq 0) {
    Write-Host "Arquivo de tempos vazio ou inválido."
    return 0
  }
  $media = ($tempos | Measure-Object -Average).Average
  return [int]$media
}

function Verificar-Formatacao {
  $problema = Read-Host "O problema é em uma aplicação específica? (s/n)"
  while ($problema -notin 's', 'n') {
    $problema = Read-Host "Resposta inválida. Digite 's' para sim ou 'n' para não."
  }

  $opiniaoDepartamento = Read-Host "Opinião do departamento é de não formatar? (s/n)"
  while ($opiniaoDepartamento -notin 's', 'n') {
    $opiniaoDepartamento = Read-Host "Resposta inválida. Digite 's' para sim ou 'n' para não."
  }

  $tempoSolucao = Read-Host "Tempo estimado para solução (em segundos)"
  while ($tempoSolucao -notmatch '^\d+$') {
    $tempoSolucao = Read-Host "Valor inválido. Digite um número inteiro."
  }
  $tempoSolucao = [int]$tempoSolucao

  $tempoFormatacao = Get-TempoFormatacaoMedio
  if ($problema -eq 's' -and $opiniaoDepartamento -eq 's' -and $tempoSolucao -lt $tempoFormatacao) {
    Write-Host "Não formatar: solução alternativa é mais rápida."
    return $false
  } else {
    Write-Host "Formatar: condições não atendem às exceções."
    return $true
  }
}

function Verificar-Discos {
  $discos = Get-PhysicalDisk
  $temSSD = $false
  $temHD = $false
  foreach ($disco in $discos) {
    if ($disco.MediaType -eq 'SSD') {
      $temSSD = $true
    } elseif ($disco.MediaType -eq 'HDD') {
      $temHD = $true
    }
  }
  return @{ SSD = $temSSD; HD = $temHD }
}

# Exemplo de uso
$formatar = Verificar-Formatacao
if ($formatar) {
	$discos = Verificar-Discos
	if ($discos.SSD) {
		Write-Host "Use o teste de BIOS do próprio computador."
	}
	if ($discos.HD) {
		Write-Host "Use o Memtest86+, e Victoria no Hiren's Boot 15.2 (computador antigo) ou no Hiren's Boot PE (computador novo). Se falharem, e o computador for da Lenovo, HP, Dell, ou Positivo; use os testes de hardware da própria BIOS da placa-mãe."
	}
	$hostname = (Get-ComputerInfo).CsName
	$arquivo = "C:\$hostname.txt"
	$serial = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "DigitalProductId").DigitalProductId
	$serial = [System.Text.Encoding]::ASCII.GetString($serial[52..66])
	$serial | Out-File -FilePath $arquivo
	#Instaladores#
	"
	Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName | ForEach-Object { $_.DisplayName } | Out-File -FilePath $arquivo -Append"#DriversDeDispositivosPCI#" | Out-File -FilePath $arquivo -Append
	Get-PnpDevice -Class "PCI" | ForEach-Object {
		$id = $_.HardwareID[0]
		$ven = ($id -split "VEN_")[1] -split "&"
		$dev = ($id -split "DEV_")[1] -split "&"
		"VEN_$ven DEV_$dev" | Out-File -FilePath $arquivo -Append
	}
	#DriversDeDispositivosUSB#
	"
	Get-PnpDevice -Class "USB" | ForEach-Object {
		$id = $_.HardwareID[0]
		$vid = ($id -split "VID_")[1] -split "&"
		$pid = ($id -split "PID_")[1] -split "&"
		"VID_$vid PID_$pid" | Out-File -FilePath $arquivo -Append
	}
	"#ImpressorasEOuScannerDeRede#" | Out-File -FilePath $arquivo -Append
	Get-Printer | Where-Object {$_.PortName -like "*IP*"} | ForEach-Object {
		$nome = $_.Name
		$ip = ($_.PortName -split ":")[0]
		$porta = ($_.PortName -split ":")[1]
		$driver = $_.DriverName
		"$nome;$ip;$porta;$driver" | Out-File -FilePath $arquivo -Append
	}
} else {
	Write-Host "Ainda bem que não irá formatar o computador, pois era apenas uma aplicação do usuário com problema."
}
White-Host "Em caso de setores defeituosos serem exibidos para a memória RAM, HD e/ou SSD, verificar a possibilidade de troca da peça defeituosa, lembrando que:"
White-Host "- Em caso de substituição do HD, instalar um com no mínimo 250GB; Caso tratar-se de um SSD, o mesmo deve possuir no mínimo 120GB, e se o equipamento permitir, deve ser instalado um HD secundário de no mínimo 250GB; se a peça já tiver sido usada, realizar testes para confirmar seu funcionamento antes de instalar o sistema operacional; HDs/SSDs que apresentem bad blocks ou erros de smart devem terem seus arquivos salvos, para em seguida serem descartados!"
White-Host "- Em caso de substituição de memória, manter sempre módulos do mesmo fabricante com a mesma frequência de funcionamento, priorizando o uso de módulos em pares que possuam a mesma capacidade em GigaBytes para Dual Channel!"
White-Host "Obs 2: Do backup à formatação, utilizar apenas pendrives preparados e disponibilizados pelo departamento de informática com ferramentas de diagnóstico e instalações de sistemas operacionais!"

