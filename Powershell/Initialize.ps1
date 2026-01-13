<#
    Module: Initialize.ps1
    Purpose:
        This script
#>

# ===================== Initialize Starship =====================
Invoke-Expression (&starship init powershell)

# ================= Initialize zoxide  =================
Invoke-Expression (& { (zoxide init powershell | Out-String) })
