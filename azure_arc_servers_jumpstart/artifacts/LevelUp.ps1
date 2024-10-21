# Note: This script is used to install additional tools and software on the ArcBox VMs for LevelUp workshops.

Write-Header "Installing VSCode extensions"
# Install VSCode extensions
$VSCodeExtensions = @(
    'ms-vscode.powershell',
    'esbenp.prettier-vscode',
    'ms-vscode-remote.remote-ssh',
    'hnw.vscode-auto-open-markdown-preview'
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

# Adding desktop shortcut for lab instructions
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Env:USERPROFILE\Desktop\Lab instructions.lnk")
$Shortcut.TargetPath = "https://aka.ms/arc-follow-along"
$Shortcut.IconLocation = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$shortcut.WindowStyle = 3
$shortcut.Save()

# Adding desktop shortcut for VS Code
Copy-Item -Path "$Env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Visual Studio Code\Visual Studio Code.lnk" -Destination "$Env:USERPROFILE\Desktop" -Force

# Removing desktop shortcut for MS Edge
Get-ChildItem "C:\Users\Public\Desktop\*Edge.lnk" | Remove-Item

# Cloning the Azure Arc Jumpstart levelup repository
git clone https://github.com/Azure/arc_jumpstart_levelup.git C:\NICConf

Set-Location C:\NICConf

git checkout nicconf

# Workaround for PowerShell modules installing into the wrong directory from Polyglot notebooks
Get-Item C:\Users\arcdemo\Documents\WindowsPowerShell* | Remove-Item -Force -Recurse

New-Item -Path C:\Users\student\Documents -ItemType SymbolicLink -Name WindowsPowerShell -Value C:\Users\student\Documents\PowerShell

# Disable welcome-pane in VS Code
@"
{
    "workbench.welcomePage.walkthroughs.openOnInstall": false,
    "workbench.startupEditor": "none"
}
"@ | Out-File -FilePath "C:\Users\student\AppData\Roaming\Code\User\settings.json" -Force
