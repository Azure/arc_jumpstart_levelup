# Note: This script is used to install additional tools and software on the ArcBox VMs for LevelUp workshops.

Write-Header "Installing VSCode extensions"
# Install VSCode extensions
$VSCodeExtensions = @(
    'ms-vscode.powershell',
    'esbenp.prettier-vscode',
    'ms-vscode-remote.remote-ssh'
)

foreach ($extension in $VSCodeExtensions) {
    code --install-extension $extension
}

$PS7url = "https://github.com/PowerShell/PowerShell/releases/latest"
$PS7latestVersion = (Invoke-WebRequest -Uri $PS7url).Content | Select-String -Pattern "[0-9]+\.[0-9]+\.[0-9]+" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value
$PS7windowsInstallerFilePath = "$Env:ArcBoxDir\PowerShell-$($PS7latestVersion)-win-x64.msi"
Invoke-WebRequest "https://github.com/PowerShell/PowerShell/releases/download/v$($PS7latestVersion)/PowerShell-$($PS7latestVersion)-win-x64.msi" -OutFile $PS7windowsInstallerFilePath


Write-Header "Installing PowerShell 7 on the ArcBox-Win2K22 machine"
Copy-VMFile $Win2k22vmName -SourcePath $PS7windowsInstallerFilePath -DestinationPath "$Env:ArcBoxDir\PowerShell-7-win-x64.msi" -CreateFullPath -FileSource Host -Force
Invoke-Command -VMName $Win2k22vmName -ScriptBlock { Start-Process msiexec.exe -ArgumentList "/I C:\ArcBox\PowerShell-7-win-x64.msi /quiet" } -Credential $winCreds

#Write-Header "Installing PowerShell 7 on the ArcBox-Win2K19 machine"
#Copy-VMFile $Win2k19vmName -SourcePath $PS7windowsInstallerFilePath -DestinationPath "$Env:ArcBoxDir\PowerShell-7-win-x64.msi" -CreateFullPath -FileSource Host -Force
#Invoke-Command -VMName $Win2k19vmName -ScriptBlock { Start-Process msiexec.exe -ArgumentList "/I C:\ArcBox\PowerShell-7-win-x64.msi /quiet" } -Credential $winCreds

Write-Header "Installing PowerShell 7 on the nested ArcBox-Ubuntu-01 VM"
$ubuntuSession = New-SSHSession -ComputerName $Ubuntu01VmIp -Credential $linCreds -Force -WarningAction SilentlyContinue
$Command = "wget https://github.com/PowerShell/PowerShell/releases/download/v$($PS7latestVersion)/powershell_$($PS7latestVersion)-1.deb_amd64.deb;sudo dpkg -i /home/arcdemo/powershell_$($PS7latestVersion)-1.deb_amd64.deb"
$(Invoke-SSHCommand -SSHSession $ubuntuSession -Command $Command -Timeout 600 -WarningAction SilentlyContinue).Output

Write-Host "Installing PSWSMan on the Linux VM"
$ubuntuSession = New-SSHSession -ComputerName $Ubuntu01VmIp -Credential $linCreds -Force -WarningAction SilentlyContinue
$Command = "sudo pwsh -command 'Install-Module -Force -PassThru -Name PSWSMan'"
$(Invoke-SSHCommand -SSHSession $ubuntuSession -Command $Command -Timeout 600 -WarningAction SilentlyContinue).Output

Write-Host "Configuring PSWSMan on the Linux VM"
$ubuntuSession = New-SSHSession -ComputerName $Ubuntu01VmIp -Credential $linCreds -Force -WarningAction SilentlyContinue
$Command = "sudo pwsh -command 'Install-WSMan'"
$(Invoke-SSHCommand -SSHSession $ubuntuSession -Command $Command -Timeout 600 -WarningAction SilentlyContinue).Output
