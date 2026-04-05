Start-Process -FilePath "X:\Path\To\Victoria.exe" -Wait

while ($true) {
  $resposta = Read-Host "Verifique o relatório do Victoria e tecle: 'o' para OK, 'p' para problemas no HD"
  switch ($resposta) {
    'o' {
      Write-Host "Relatório do Victoria OK. Prosseguindo..."
      & "f:\minhaPasta\BackupNoHirenBoot15-2OuPEOuUbuntu.ps1"
      break
    }
    'p' {
      Write-Host "Relatório do Victoria aponta problemas no HD. Verifique o HD antes de prosseguir."
      break
    }
    default {
      Write-Host "Opção inválida. Por favor, tente novamente."
    }
  }
  if ($resposta -eq 'o' -or $resposta -eq 'p') {
    break
  }
}

