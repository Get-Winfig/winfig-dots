<#
    Module: PsModules.ps1
    Purpose:
        This script imports a set of PowerShell modules to enhance the functionality and user experience of the PowerShell environment.
        - Load modules compatible with powershell version
        - Enhance terminal capabilities with icons, git integration, and improved command line editing.
#>

function Import-ModuleSafe {
    param (
        [Parameter(Mandatory)]
        [string]$Name,
        [string]$ErrorMessage = "Module '$Name' is not installed. Please install it using 'Install-Module $Name' and restart your session."
    )
    try {
        Import-Module -Name $Name -ErrorAction Stop -Force
    } catch {
        Write-Host "$ErrorMessage" -ForegroundColor Red
    }
}

Import-ModuleSafe -Name "posh-git" `
    -ErrorMessage "posh-git is missing! Install it with: Install-Module posh-git -Scope CurrentUser"
Import-ModuleSafe -Name "Terminal-Icons" `
    -ErrorMessage "Terminal-Icons is missing! Install it with: Install-Module Terminal-Icons -Scope CurrentUser"
Import-ModuleSafe -Name "PowercolorLs" `
    -ErrorMessage "PowercolorLs is missing! Install it with: Install-Module PowercolorLs -Scope CurrentUser"
Import-ModuleSafe -Name "Microsoft.PowerShell.Archive" `
    -ErrorMessage "Microsoft.PowerShell.Archive is missing! Install it with: Install-Module Microsoft.PowerShell.Archive -Scope CurrentUser"
Import-ModuleSafe -Name "PSWeb" `
    -ErrorMessage "PSWeb is missing! Install it with: Install-Module PSWeb -Scope CurrentUser"
Import-ModuleSafe -Name "PSFzf" `
    -ErrorMessage "PSFzf is missing! Install it with: Install-Module PSFzf -Scope CurrentUser"
Import-ModuleSafe -Name "PSReadLine" `
    -ErrorMessage "PSReadLine is missing! Install it with: Install-Module PSReadLine -Scope CurrentUser"
Import-ModuleSafe -Name "syntax-highlighting" `
    -ErrorMessage "syntax-highlighting is missing! Install it with: Install-Module syntax-highlighting -Scope CurrentUser"
# Import-ModuleSafe -Name "PSCompletions" `
#     -ErrorMessage "PSCompletions is missing! Install it with: Install-Module PSCompletions -Scope CurrentUser"

# Only import if PowerShell version is 7 or higher
if ($PSVersionTable.PSVersion.Major -ge 7) {
    try {
        Import-ModuleSafe -Name "Microsoft.WinGet.CommandNotFound" `
        -ErrorMessage "Microsoft.WinGet.CommandNotFound is missing or requires PowerShell 7.4+. Install it with: Install-Module Microsoft.WinGet.CommandNotFound -Scope CurrentUser"
    } catch {
        Write-Host ""
    }
}
