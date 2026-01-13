<#
    Module: update.ps1
    Purpose:
        This script defines update and upgrade functions for system packages (winget, chocolatey) and PowerShell modules.
#>

function update {
    Write-Host ""
    Write-Host "==================== UPDATE CHECK ====================" -ForegroundColor Cyan
    Write-Host ""

    # Winget
    Write-Host ""
    Write-Host "--- Winget Packages ---" -ForegroundColor Yellow
    Write-Host ""
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        $wingetUpdates = winget list --upgrade-available
        if ($wingetUpdates) {
            $wingetUpdates | Write-Host
        } else {
            Write-Host "No winget package updates available." -ForegroundColor Green
        }
    } else {
        Write-Host "winget not found. Skipping winget update check." -ForegroundColor DarkGray
    }

    # Chocolatey
    Write-Host ""
    Write-Host "--- Chocolatey Packages ---" -ForegroundColor Yellow
    Write-Host ""
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        $chocoUpdates = choco outdated
        if ($chocoUpdates) {
            $chocoUpdates | Write-Host
        } else {
            Write-Host "No chocolatey package updates available." -ForegroundColor Green
        }
    } else {
        Write-Host "chocolatey not found. Skipping chocolatey update check." -ForegroundColor DarkGray
    }

    # PowerShell Modules
    Write-Host ""
    Write-Host "--- PowerShell Modules ---" -ForegroundColor Yellow
    Write-Host ""
    try {
        $outdatedModules = Get-InstalledModule | Where-Object {
            $_.Version -lt (Find-Module -Name $_.Name).Version
        }
        if ($outdatedModules) {
            $outdatedModules | Format-Table Name, Version, @{Name="Latest";Expression={ (Find-Module -Name $_.Name).Version }} | Out-String | Write-Host
        } else {
            Write-Host "All PowerShell modules are up to date." -ForegroundColor Green
        }
    } catch {
        Write-Host "Failed to check PowerShell modules." -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "=====================================================" -ForegroundColor Cyan
    Write-Host ""
}

function upgrade {
    Write-Host ""
    Write-Host "==================== UPGRADE ====================" -ForegroundColor Cyan
    Write-Host ""

    # Winget
    Write-Host ""
    Write-Host "--- Upgrading Winget Packages ---" -ForegroundColor Yellow
    Write-Host ""
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget upgrade --all --silent
    } else {
        Write-Host "winget not found. Skipping winget upgrade." -ForegroundColor DarkGray
    }

    # Chocolatey
    Write-Host ""
    Write-Host "--- Upgrading Chocolatey Packages ---" -ForegroundColor Yellow
    Write-Host ""
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        choco upgrade all -y
    } else {
        Write-Host "chocolatey not found. Skipping chocolatey upgrade." -ForegroundColor DarkGray
    }

    # PowerShell Modules
    Write-Host ""
    Write-Host "--- Upgrading PowerShell Modules ---" -ForegroundColor Yellow
    Write-Host ""
    try {
        Get-InstalledModule | ForEach-Object {
            Write-Host "Upgrading module: $($_.Name)" -ForegroundColor Green
            Update-Module -Name $_.Name -Force
        }
    } catch {
        Write-Host "Failed to upgrade PowerShell modules." -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host ""
}
