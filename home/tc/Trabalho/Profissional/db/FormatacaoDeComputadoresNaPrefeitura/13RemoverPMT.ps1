Remove-LocalUser -Name "PMT" -Confirm:$false
Add-WindowsCapability -Online -Name "Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0"
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "TOLEDO.PR.GOV.BR\tiago.costa", (ConvertTo-SecureString -String "1ssdl2601@" -AsPlainText -Force)
Add-Computer -DomainName "toledo.pr.gov.br" -Credential $cred


