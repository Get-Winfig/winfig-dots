<#
    Module: timer.ps1
    Purpose:
        This script defines a function to time the execution duration of a given command in PowerShell.
#>

function timer {
    param(
        [Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)]
        [string[]]$Command
    )
    $start = Get-Date
    Write-Host "Starting timer for: $($Command -join ' ')" -ForegroundColor DarkCyan
    Invoke-Expression ($Command -join ' ')
    $end = Get-Date
    $duration = New-TimeSpan -Start $start -End $end
    Write-Host "Command completed in $($duration.TotalSeconds) seconds." -ForegroundColor Green
}
