$senha = ConvertTo-SecureString -String "Patagon1@" -AsPlainText -Force
Enable-LocalUser -Name "Administrador"
Set-LocalUser -Name "Administrador" -Password $senha -PasswordNeverExpires $true
