$opcao = Read-Host "Digite 's' para seguir a rotina de instalação ou 'n' para mostrar a lista de programas"

if ($opcao -eq "s") {
  $hostname = (Get-ComputerInfo).CsName
  $isNotebookEducacao = $false
  $usaSCP = $false

  # Verifica se é notebook da educação
  if ($hostname -like "*EDU*") {
    $isNotebookEducacao = $true
  }

  # Verifica se usa SCP
  if (Test-Path "C:\SCP") {
    $usaSCP = $true
  }

  # Instala os programas
  $programas = @(
    "\\192.168.25.55\Instaladores\ROTINA - INSTALADORES\necessarios\1 - Administracao.exe",
    "\\192.168.25.55\Instaladores\VNC\VNC - novo.exe",
    "\\192.168.25.55\Instaladores\ROTINA - INSTALADORES\necessarios\3 - LibreOffice_25.2.4_Win_x86-64.msi",
    "\\192.168.25.55\Instaladores\ROTINA - INSTALADORES\necessarios\6 - java-8u461.exe"
  )

  if (!$isNotebookEducacao -or $usaSCP) {
    $programas += "\\192.168.25.55\Instaladores\Oracle\oracle_11gR2_client 32\client\setup.exe"
  }

  $programas += "\\instaladores\Instaladores\TEAMVIEWER\TeamViewer Host\TeamViewer_Host_Setup.exe"

  foreach ($programa in $programas) {
    Write-Host "Instalando $programa..."
    Start-Process -FilePath $programa -Wait
  }
} else {
  $hostname = (Get-ComputerInfo).CsName
  $arquivo = "C:\$hostname.txt"

  if (Test-Path $arquivo) {
    Write-Host "Conteúdo do arquivo $arquivo:"
    Get-Content -Path $arquivo
  } else {
    Write-Host "Arquivo $arquivo não encontrado."
  }
}