Add-Type -AssemblyName PresentationFramework

# Get repo info
$folderPath = Get-Location
$folderName = Split-Path $folderPath -Leaf
$branch = git rev-parse --abbrev-ref HEAD
$branches = git branch -a | Out-String

# Format message
$message = @"
Repository : $folderName
Path       : $folderPath
Current    : $branch

[ BRANCHES ]

$branches
"@

[System.Windows.MessageBox]::Show($message.Trim(), "Git Branches")
