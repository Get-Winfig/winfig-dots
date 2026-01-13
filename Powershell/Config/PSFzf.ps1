<#
    Module: PSFzf.ps1
    Purpose:
        This script configures PSFzf (PowerShell Fzf) and PSReadLine settings to enhance command-line navigation and file searching capabilities.
#>

# ===================== PSReadLine Options =====================
$PSReadLineOptions = @{
    EditMode = 'Windows'
    HistoryNoDuplicates = $true
    HistorySearchCursorMovesToEnd = $false
    HistorySearchCaseSensitive = $false
    MaximumHistoryCount = 10000
    ShowToolTips = $true
    WordDelimiters = " ;:,=+-/|\()[]{}'`"?!@#%^&*<>"
    AddToHistoryHandler = {
        param($command)
        $command.Trim() -ne '' -and $command[0] -ne ' '
    }
    Colors = @{
        Command    = '#a6e3a1'
        Parameter  = '#89b4fa'
        Operator   = '#f5c2e7'
        Variable   = '#f9e2af'
        String     = '#fab387'
        Number     = '#94e2d5'
        Type       = '#b4befe'
        Comment    = '#6c7086'
        Keyword    = '#cba6f7'
        Error      = '#f38ba8'
    }
    BellStyle = 'None'
}

# Apply PSReadLine options
Set-PSReadLineOption @PSReadLineOptions

# ===================== PSFzf Keybindings =====================

# Fuzzy finding
Set-PsFzfOption -PSReadlineChordProvider 'Alt+f'
# Reverse history navigation
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'

# ===================== PSReadLine Key Handlers =====================

# Uparrow for backward history search
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
# DownArrow for forward history search
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
# Tab for menu completion
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
# Home for beginning of line
Set-PSReadLineKeyHandler -Key Home -Function BeginningOfLine
# End for end of line
Set-PSReadLineKeyHandler -Key End -Function EndOfLine

# ===================== Fuzzy Helpers & Integrations =====================

# Fuzzy directory jump with zoxide
Set-PSReadLineKeyHandler -Chord 'Alt+j' -ScriptBlock {
    $dir = zoxide query -l | fzf --height=40% --prompt="Jump to dir: "
    if ($dir) { Set-Location $dir }
}

# Fuzzy checkout a git branch
Set-PSReadLineKeyHandler -Chord 'Alt+b' -ScriptBlock {
    $branch = git branch --all | ForEach-Object { $_.Trim() } | fzf --prompt="Checkout Git branch: "
    if ($branch) { git checkout $branch }
}

# Enhanced fuzzy history search
Set-PSReadLineKeyHandler -Chord 'Ctrl+h' -ScriptBlock {
    $cmd = Get-History | Select-Object -ExpandProperty CommandLine | fzf --height=40% --prompt="History: "
    if ($cmd) { [Microsoft.PowerShell.PSConsoleReadLine]::Insert($cmd) }
}

# Open a recently modified file with fzf and VS Code
Set-PSReadLineKeyHandler -Chord 'Alt+o' -ScriptBlock {
    $file = Get-ChildItem -Recurse -File | Sort-Object LastWriteTime -Descending | Select-Object -First 100 | Select-Object -ExpandProperty FullName | fzf --preview 'bat --style=numbers --color=always {}' --preview-window=right:65% --prompt="Recent file: "
    if ($file) { code $file }
}
