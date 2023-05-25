Import-Module servermanager
Add-WindowsFeature web-server -IncludeAllSubFeature
Add-WindowsFeature Web-Asp-Net45
Add-WindowsFeature NET-Framework-Features
Set-Content -Path "C:\inetpub\wwwroot\Default.html" -Value "This is the server $($env:COMPUTERNAME)"