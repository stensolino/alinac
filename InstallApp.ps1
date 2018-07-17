$Logfile = "C:\logs\$(gc env:computername).log"

Function LogWrite
{
   Param ([string]$logstring)

   Add-content $Logfile -value $logstring
}

LogWrite('========== Start executing InstallApp script ==========')

sl C:\ExploringAspNetCore

#LogWrite('========== START: restore ==========')

# Restore the nuget references
#& "C:\Program Files\dotnet\dotnet.exe" restore

#LogWrite('========== START: publish ==========')


# Publish application with all of its dependencies and runtime for IIS to use
#& "C:\Program Files\dotnet\dotnet.exe" publish --configuration release -o c:\ExploringAspNetCore\alinac\publish #--runtime active

LogWrite('========== START: Copy and move files ==========')

#Remove-Item .\fppspec.yml -Force
#Remove-Item .\InstallApp.ps1 -Force
#Remove-Item .\RemoveApp.ps1 -Force

Copy-Item -Path .\release -Recurse -Destination .\ -Container

Remove-Item .\alinac -Force -Recurse

LogWrite('========== END: Copy and move files ==========')

LogWrite('========== START: IIS config ==========')

# Point IIS wwwroot of the published folder. CodeDeploy uses 32 bit version of PowerShell.
# To make use the IIS PowerShell CmdLets we need call the 64 bit version of PowerShell.
#C:\Windows\SysNative\WindowsPowerShell\v1.0\powershell.exe -Command {Import-Module WebAdministration; Set-ItemProperty 'IIS:\sites\Default Web Site' -Name physicalPath -Value c:\ExploringAspNetCore\publish}
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Command {Import-Module WebAdministration; Set-ItemProperty 'IIS:\sites\Default Web Site' -Name physicalPath -Value C:\ExploringAspNetCore\alinac}

LogWrite('========== END: IIS config ==========')