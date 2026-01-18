<#
    Module: Aliases.ps1
    Purpose:
        This script defines categorized PowerShell aliases and functions to streamline workflows and enhance productivity.
#>

# ===================== Git Shortcuts =====================

# Git Status
function gst { git status }
# Git Branch
function gbr { git branch }
# Git Commit
function gcomit { git commit }
# Git Commit with message
function gcmmit { git commit -m }
# Git Amend Commit
function gammend { git commit --amend }
# Git Ammend no message change
function gamendnm { git commit --amend --no-edit }
# Git Log
function glog { git log }
# Git Diff
function gdf { git diff }
# Git Pull
function gpull { git pull }
# Git Fetch
function gfetch { git fetch }
# Git Push
function gpush { git push }
# Git Add all changes
function gad { git add . }
# Git Clone
function gcl { git clone }
# Git Reset last commit but keep changes
function guncommit { git reset --soft HEAD~1 }
# Git Checkout branch
function gcheckout { param($name) git checkout -b $name }

# ===================== Tig Shortcuts =====================

# Git Interface using Tig
function t { tig }
# Git Blame using Tig
function tb { tig blame }
# Git Status using Tig
function tst { tig status }
# Git Logs using Tig
function tlog { tig log }
# Git diff using Tig
function tdf { tig diff }

# ===================== System & Info =====================

# Display system information
function sysinfo { Get-ComputerInfo }
# Get your public IP address
function myip { curl ipinfo.io/ip }
# Get your Local IP address
function localip { Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv4' -and $_.PrefixOrigin -eq 'Dhcp'} | Select-Object -ExpandProperty IPAddress }
# Flush DNS cache
function flushdns { Clear-DnsClientCache ; Write-Host "DNS has been flushed" }
# Display PATH entries with indices
function path { $i = 0 ; $env:PATH -split ';' | Where-Object { $_ -and $_.Trim() } | ForEach-Object { [PSCustomObject]@{ 'Index' = ++$i; 'Path Entry' = $_.Trim() } } | Format-Table -AutoSize }

# ===================== File & Directory Navigation =====================

# Go up one directory
function .. { Set-Location .. }
# Go up two directories
function ... { Set-Location ../.. }
# Go up three directories
function .... { Set-Location ../../.. }
# Create a directory and navigate into it
function mkcd { param($dir) mkdir $dir -Force; Set-Location $dir }
# Open current directory in VS Code
function edit-here { code (Get-Location) }
# Open current directory in default file explorer
function here { Invoke-Item (Get-Location) }

# ===================== File Operations =====================

# Create an empty file like 'touch' in Unix
function touch { New-Item -ItemType File -Path $args[0] -Force }
# List files with PowerColorLS
Set-Alias la PowercolorLs
# Long list with PowerColorLS showing directory sizes
function ll { PowerColorLS -a -l --show-directory-size }
# List only files using PowerColorLS
function lf { PowerColorLS -a -l -f --show-directory-size }
# List only directories using PowerColorLS
function ld { PowerColorLS -a -l -d --show-directory-size }
# List only hidden files
function lh { Get-ChildItem -Force | Where-Object { $_.Attributes -match "Hidden" } | Format-Table -AutoSize }
# Go back to previous directory
function back { Set-Location - }
# 5 most recently modified files
function lastmod { Get-ChildItem -Recurse | Sort-Object LastWriteTime -Descending | Select-Object -First 5 }
# 5 oldest files
function oldest { Get-ChildItem -Recurse | Sort-Object LastWriteTime | Select-Object -First 5 }
# 5 most recently accessed files
function recent { Get-ChildItem -Recurse | Sort-Object LastAccessTime -Descending | Select-Object -First 5 }

# ===================== Process & System Control =====================

# Kill a process by name
function pkill($name) { Get-Process $name -ErrorAction SilentlyContinue | Stop-Process }
# Clear the console
function cls { Clear-Host }
# Reload PowerShell profile
function reload { . $PROFILE }
# Edit PowerShell profile
function edit-profile { code $PROFILE }

# ===================== File Content Helpers =====================

# Display the first n lines of a file
function head { param($Path, $n = 10) ; Get-Content $Path -Head $n }
# Last n lines, with optional follow
function tail { param($Path, $n = 10, [switch]$f = $false) ; Get-Content $Path -Tail $n -Wait:$f }

# ===================== Hashing =====================

# MD5 hash
function md5 { Get-FileHash -Algorithm MD5 $args }
# SHA1 hash
function sha1 { Get-FileHash -Algorithm SHA1 $args }
# SHA256 hash
function sha256 { Get-FileHash -Algorithm SHA256 $args }

# ===================== Utility & Misc =====================

# Find the path of a command
function which($name) { Get-Command $name | Select-Object -ExpandProperty Definition }
# Open files or directories
function open { Invoke-Item $args }
# Edit files with VsCode
function edit { code $args }

# ===================== Aliases for External Tools =====================

if ($PSVersionTable.PSVersion -ge [Version]"7.0") {
    # Use 'cat' for bat (a better cat command)
    Set-Alias cat bat.exe
    # Use 'h' to get command history
    Set-Alias h Get-History
}
# Use 'grep' to search strings
Set-Alias grep Select-String
# Launch LazyGit
Set-Alias lg lazygit.exe
# Launch NTop
Set-Alias htop ntop.exe
# Launch FastFetch
Set-Alias neofetch fastfetch.exe
# Preview Markdown files
Set-Alias view glow.exe
# Zoxide alias
Set-Alias j z
Set-Alias ji zi
# sudo alias for Windows
Set-Alias sudo gsudo.exe
# onefetch alias for gitfetch
Set-Alias gitfetch onefetch.exe


# ==================== Custom Locations =====================

# Navigate to Dotfiles directory
function Dotfiles { Set-Location ([System.IO.Path]::Combine([System.Environment]::GetFolderPath('UserProfile'), ".Dotfiles")) }
# Navigate to TEMP Directory
function TEMP  { Set-Location ([System.Environment]::GetEnvironmentVariable("TEMP")) }
# Navigate to Desktop
function Desktop  { Set-Location ([System.Environment]::GetFolderPath('Desktop')) }
# Navigate to Documents
function Documents  { Set-Location ([System.Environment]::GetFolderPath('MyDocuments')) }
# Navigate to UserProfile
function UserProfile  { Set-Location ([System.Environment]::GetFolderPath('UserProfile')) }
# Navigate to Downloads
function Downloads  { Set-Location ([System.Environment]::GetFolderPath('Downloads')) }
# Navigate to Pictures
function Pictures { Set-Location ([System.Environment]::GetFolderPath('MyPictures')) }
# Navigate to Videos
function Videos { Set-Location ([System.Environment]::GetFolderPath('MyVideos')) }
# Navigate to ShareX Screenshots
function ShareXScreenshots { Set-Location ([System.IO.Path]::Combine(([System.Environment]::GetFolderPath('MyDocuments')), "ShareX", "Screenshots")) }

# =================== Miscellaneous Utilities =====================

# Display full help for a command
function man { Get-Help $args[0] -Full }
# Display basic file information
function file { Get-Item $args[0] | Select-Object Name, Extension, Length, CreationTime, LastWriteTime, LastAccessTime }
# Open WinUtil full-release
function winutil { Invoke-WebRequest -UseBasicParsing https://christitus.com/win | Invoke-Expression }
# Open WinUtil dev-release
function winutildev { Invoke-WebRequest -UseBasicParsing https://christitus.com/windev | Invoke-Expression }
