# Instala o módulo PSWindowsUpdate se não estiver instalado
if (-not (Get-Module -Name PSWindowsUpdate -ListAvailable)) {
  Install-Module -Name PSWindowsUpdate -Force -AllowClobber
}

# Importa o módulo PSWindowsUpdate
Import-Module PSWindowsUpdate

# Verifica e instala todas as atualizações disponíveis, incluindo opcionais e drivers
Get-WindowsUpdate -Install -AcceptAll -IgnoreReboot

