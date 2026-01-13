<#
    Module: Microsoft.PowerShell_profile.ps1
    Purpose:
        This script configures the PowerShell profile by importing essential modules and setting up the environment for an enhanced command-line experience.
#>

$Path = "$PSScriptRoot"

# Import Configurations
."$Path/Config/Load.ps1"
."$Path/Config/PSFzf.ps1"
."$Path/Config/PsModules.ps1"

# Load Aliases
."$Path/Aliases.ps1"

# Load Initialization
."$Path/Initialize.ps1"

# Load Functions
Get-ChildItem -Path "$Path/Functions" -Filter *.ps1 | ForEach-Object {
    . $_.FullName
}

# Load secrets/env if present
if (Test-Path "$PSScriptRoot\Secrets.ps1") {
    . "$PSScriptRoot\Secrets.ps1"
}
