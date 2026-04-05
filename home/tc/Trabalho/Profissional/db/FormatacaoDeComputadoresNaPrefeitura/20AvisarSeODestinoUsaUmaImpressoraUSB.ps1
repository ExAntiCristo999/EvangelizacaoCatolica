# Define as variáveis
$hostname = (Get-ComputerInfo).CsName
$arquivo = "C:\$hostname.txt"

# Verifica se o arquivo existe
if (Test-Path $arquivo) {
  # Lê o conteúdo do arquivo
  $conteudo = Get-Content -Path $arquivo

  # Verifica se existe uma impressora de rede USB
  if ($conteudo | Select-String -Pattern "USB") {
    Write-Host "Trocar a impressora USB por uma de rede sempre que possível."
  }
} else {
  Write-Host "Arquivo $arquivo não encontrado."
}