# Define as variáveis
$hdExterno = "E:"  # Substitua pelo drive do HD externo
$destino = "C:\Backup"
$atalho = "C:\Users\Public\Desktop\Backup.lnk"

# Verifica se o HD externo está conectado
if (Test-Path $hdExterno) {
  # Cópia os arquivos do HD externo para a pasta de destino
  Get-ChildItem -Path $hdExterno -Recurse -Exclude "RedoRescue" | Copy-Item -Destination $destino -Recurse -Force

  # Crea o atalho para a pasta de destino
  $WScriptShell = New-Object -ComObject WScript.Shell
  $Shortcut = $WScriptShell.CreateShortcut($atalho)
  $Shortcut.TargetPath = $destino
  $Shortcut.Save()

  Write-Host "Backup copiado e atalho criado com sucesso!"
} else {
  Write-Host "HD externo não encontrado."
}