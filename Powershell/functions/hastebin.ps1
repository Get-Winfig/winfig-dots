<#
    Module: hastebin.ps1
    Purpose:
        This script defines a function to upload text or file content to Hastebin and return the shareable URL.
        - Special thanks to Chris Titus for the the server and function.
#>

function hastebin {
    param(
        [string]$FilePath
    )
    # If no file path provided, use fzf to select one interactively
    if (-not $FilePath) {
        $fzfCmd = 'fzf --prompt="   Select file to upload: " --border --reverse --header="Use ↑/↓ to select, <Enter> to confirm" --pointer="➤" --color="bg+:#1e1e2e,bg:#181825,spinner:#f5c2e7,hl:#f38ba8,fg:#cdd6f4,header:#89b4fa,info:#f9e2af,pointer:#a6e3a1,marker:#f5c2e7,fg+:#cdd6f4,prompt:#89b4fa,hl+:#f38ba8" --preview "bat --style=numbers --color=always {}"'
        $FilePath = (Get-ChildItem -File | Select-Object -ExpandProperty Name | Out-String).Trim() | cmd /c $fzfCmd
        if (-not $FilePath) {
            Write-Host "No file selected." -ForegroundColor Yellow
            return
        }
    }

    if (-not (Test-Path $FilePath -PathType Leaf)) {
        Write-Host "File path does not exist: $FilePath" -ForegroundColor Red
        return
    }

    $Content = Get-Content $FilePath -Raw
    $uri = "http://bin.christitus.com/documents"
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Post -Body $Content -ErrorAction Stop
        $hasteKey = $response.key
        $url = "http://bin.christitus.com/$hasteKey"
        Set-Clipboard $url
        Write-Host ([System.IO.Path]::GetFileName($FilePath)) -ForegroundColor Magenta
        Write-Host "  Hastebin URL:" -ForegroundColor Cyan -NoNewline
        Write-Host (" $url ") -ForegroundColor Green
        Write-Host "  (Copied to clipboard)" -ForegroundColor Yellow
    } catch {
        Write-Host "Failed to upload the document." -ForegroundColor Red
        Write-Host $_
    }
}

Set-Alias hb hastebin
