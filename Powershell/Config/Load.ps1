<#
    Module: Load.ps1
    Purpose:
        This script detects the running PowerShell version and logs profile load events to a temporary file.
        - For PowerShell Core (v7+), logs to 'pwsh-load.log'.
        - For Windows PowerShell (v5.x and below), logs to 'powershell-load.log'.
        The log includes a timestamp and profile type for troubleshooting and auditing profile loads.
#>

function Write-ProfileLoadLog {
    param (
        [string]$LogPath,
        [string]$Message
    )
    try {
        $Message | Out-File -FilePath $LogPath -Append -Encoding UTF8
    } catch {
        Write-Warning "Failed to write to log file: $LogPath"
    }
}

if ($PSVersionTable.PSVersion -ge [Version]"7.0") {
    $LogPath = [System.IO.Path]::Combine($env:TEMP, "pwsh-load.log")
    $LogMessage = "PowerShell Core profile loaded at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
} else {
    $LogPath = [System.IO.Path]::Combine($env:TEMP, "powershell-load.log")
    $LogMessage = "Windows PowerShell profile loaded at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
}

Write-ProfileLoadLog -LogPath $LogPath -Message $LogMessage
