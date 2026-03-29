# Configurações
$hdExterno = "E:\" # Altere para o caminho do HD externo
$pastasIgnorar = @("Administrador", "tiago.costa", "Public", "Default")
$pastasCopiar = @("Desktop", "Documentos", "Downloads", "Favoritos", "Músicas", "Fotos", "Vídeos")
$pastasIgnorarUsuario = @("AppData")
$pastasEspeciais = @("SISGEP")
$tentativas = 2

# Função para criar pasta de backup
function Criar-PastaBackup {
  param ($caminho)
  if (!(Test-Path $caminho)) {
    New-Item -ItemType Directory -Path $caminho | Out-Null
  }
}

# Função para copiar arquivo com tentativas
function Copiar-Arquivo {
  param ($origem, $destino)
  $tentativa = 0
  while ($tentativa -lt $tentativas) {
    try {
      Copy-Item -Path $origem -Destination $destino -ErrorAction Stop
      return $true
    } catch {
      $tentativa++
      Write-Host "Use o Ubuntu, pois um arquivo não copiou sem se corromper."
    }
  }
  return $false
}

# Função para exibir partições
function Exibir-Particoes {
  Get-WmiObject -Class Win32_DiskDrive | ForEach-Object {
    $disco = $_
    Write-Host "Disco: $($disco.Name)"
    Get-WmiObject -Class Win32_DiskPartition -Filter "DiskIndex = $($disco.Index)" | ForEach-Object {
      $particao = $_
      Write-Host "  Partição: $($particao.Name) - Tipo: $($particao.Type)"
      Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID = '$($particao.Name)'" | ForEach-Object {
        $volume = $_
        Write-Host "    Volume: $($volume.Name) - Tamanho: $($volume.Size / 1GB) GB"
      }
    }
  }
}

# Exibir partições
Exibir-Particoes
Write-Host "Pode excluir as partições lógicas contendo dados do usuário, se antes for realizado backup daqueles."

# Obter nome do computador e local
$nomeComputador = $env:COMPUTERNAME
$local = Read-Host "Digite o local do computador (Escola, CMEI, UBS, Receita, etc)"
$patrimonio = Read-Host "Digite o número do patrimônio do computador"

# Criar pasta de backup
$data = Get-Date -Format "dd-MM-yy"
$pastaBackup = "$hdExterno\$local-$patrimonio-$data"
Criar-PastaBackup $pastaBackup
$pastaC = "$pastaBackup\C"
Criar-PastaBackup $pastaC

# Fazer backup
$usuarios = Get-ChildItem -Path "C:\Users\" | Where-Object { $_.Name -notin $pastasIgnorar }
foreach ($usuario in $usuarios) {
  $pastaUsuario = "$pastaBackup\$($usuario.Name)"
  Criar-PastaBackup $pastaUsuario
  foreach ($pasta in $pastasCopiar) {
    $origem = "C:\Users\$($usuario.Name)\$pasta"
    $destino = "$pastaUsuario\$pasta"
    if (Test-Path $origem) {
      Criar-PastaBackup $destino
      Get-ChildItem -Path $origem -Recurse | ForEach-Object {
        $destinoArquivo = $_.FullName.Replace($origem, $destino)
        $destinoPasta = Split-Path $destinoArquivo
        Criar-PastaBackup $destinoPasta
        $copiado = Copiar-Arquivo -origem $_.FullName -destino $destinoArquivo
        if (!$copiado) {
          Add-Content -Path "$pastaBackup\erros.txt" -Value $_.FullName
        }
      }
    }
  }
  foreach ($pasta in $pastasEspeciais) {
    $origem = "C:\Users\$($usuario.Name)\$pasta"
    $destino = "$pastaC\$pasta"
    if (Test-Path $origem) {
      Criar-PastaBackup $destino
      Get-ChildItem -Path $origem -Recurse | ForEach-Object {
        $destinoArquivo = $_.FullName.Replace($origem, $destino)
        $destinoPasta = Split-Path $destinoArquivo
        Criar-PastaBackup $destinoPasta
        $copiado = Copiar-Arquivo -origem $_.FullName -destino $destinoArquivo
        if (!$copiado) {
          Add-Content -Path "$pastaBackup\erros.txt" -Value $_.FullName
        }
      }
    }
  }
  $pastasRestantes = Get-ChildItem -Path "C:\Users\$($usuario.Name)" | Where-Object { $_.Name -notin ($pastasCopiar + $pastasIgnorarUsuario + $pastasEspeciais) }
  foreach ($pasta in $pastasRestantes) {
    $resposta = Read-Host "Copiar pasta $($pasta.Name)? (s/n)"
    if ($resposta -eq 's') {
      $origem = $pasta.FullName
      $destino = "$pastaC\$($pasta.Name)"
      Criar-PastaBackup $destino
      Get-ChildItem -Path $origem -Recurse | ForEach-Object {
        $destinoArquivo = $_.FullName.Replace($origem, $destino)
        $destinoPasta = Split-Path $destinoArquivo
        Criar-PastaBackup $destinoPasta
        $copiado = Copiar-Arquivo -origem $_.FullName -destino $destinoArquivo
        if (!$copiado) {
          Add-Content -Path "$pastaBackup\erros.txt" -Value $_.FullName
        }
      }
    }
  }
}
White-Host "Os backups deverá ser armazenado em segurança por 2 meses após a formatação e devolução do computador, devendo ser excluído depois. O mesmo se aplica à imagem completa do HD do computador com o software Rescuezilla, que deverá ser salva dentro da pasta de backup completo do computador criada no HD externo."
