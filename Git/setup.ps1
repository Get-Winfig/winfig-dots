# ====================================================================== #
# UTF-8 with BOM Encoding for output
# ====================================================================== #

if ($PSVersionTable.PSVersion.Major -eq 5) {
    $OutputEncoding = [System.Text.Encoding]::UTF8
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    [Console]::InputEncoding = [System.Text.Encoding]::UTF8
} else {
    $utf8WithBom = New-Object System.Text.UTF8Encoding $true
    $OutputEncoding = $utf8WithBom
    [Console]::OutputEncoding = $utf8WithBom
}

# ====================================================================== #
#  Script Metadata
# ====================================================================== #

$Script:WinfigMeta = @{
    Author       = "Armoghan-ul-Mohmin"
    CompanyName  = "Get-Winfig"
    Description  = "Windows configuration and automation framework"
    Version     = "1.0.0"
    License     = "MIT"
    Platform    = "Windows"
    PowerShell  = $PSVersionTable.PSVersion.ToString()
}

# ====================================================================== #
#  Color Palette
# ====================================================================== #

$Script:WinfigColors = @{
    Primary   = "Blue"
    Success   = "Green"
    Info      = "Cyan"
    Warning   = "Yellow"
    Error     = "Red"
    Accent    = "Magenta"
    Light     = "White"
    Dark      = "DarkGray"
}

# ====================================================================== #
# User Prompts
# ====================================================================== #

$Script:WinfigPrompts = @{
    Confirm    = "[?] Do you want to proceed? (Y/N): "
    Retry      = "[?] Do you want to retry? (Y/N): "
    Abort      = "[!] Operation aborted by user."
    Continue   = "[*] Press any key to continue..."
}

# ====================================================================== #
#  Paths
# ====================================================================== #

$Global:WinfigPaths = @{
    Desktop         = [Environment]::GetFolderPath("Desktop")
    Documents       = [Environment]::GetFolderPath("MyDocuments")
    UserProfile     = [Environment]::GetFolderPath("UserProfile")
    Temp            = [Environment]::GetEnvironmentVariable("TEMP")
    AppDataRoaming  = [Environment]::GetFolderPath("ApplicationData")
    AppDataLocal    = [Environment]::GetFolderPath("LocalApplicationData")
    Downloads       = [System.IO.Path]::Combine([Environment]::GetFolderPath("UserProfile"), "Downloads")
    Logs            = [System.IO.Path]::Combine([Environment]::GetEnvironmentVariable("TEMP"), "Winfig-Logs")
}
$Global:WinfigPaths.DotFiles = [System.IO.Path]::Combine($Global:WinfigPaths.UserProfile, ".Dotfiles")
$Global:WinfigPaths.Templates = [System.IO.Path]::Combine($Global:WinfigPaths.DotFiles, "winfig-dots")

# ====================================================================== #
# Start Time, Resets, Counters
# ====================================================================== #
$Global:WinfigLogStart = Get-Date
$Global:WinfigLogFilePath = $null
Remove-Variable -Name WinfigLogFilePath -Scope Global -ErrorAction SilentlyContinue
Remove-Variable -Name LogCount -Scope Global -ErrorAction SilentlyContinue
Remove-Variable -Name ErrorCount -Scope Global -ErrorAction SilentlyContinue
Remove-Variable -Name WarnCount -Scope Global -ErrorAction SilentlyContinue

# ====================================================================== #
# Utility Functions
# ====================================================================== #

# ---------------------------------------------------------------------------- #
# Function to display a Success message
function Show-SuccessMessage {
    param (
        [string]$Message
    )
    Write-Host "[OK] $Message" -ForegroundColor $Script:WinfigColors.Success
}

# ---------------------------------------------------------------------------- #
# Function to display an Error message
function Show-ErrorMessage {
    param (
        [string]$Message
    )
    Write-Host "[ERROR] $Message" -ForegroundColor $Script:WinfigColors.Error
}

# ---------------------------------------------------------------------------- #
# Function to display an Info message
function Show-InfoMessage {
    param (
        [string]$Message
    )
    Write-Host "[INFO] $Message" -ForegroundColor $Script:WinfigColors.Info
}

# ---------------------------------------------------------------------------- #
# Function to display a Warning message
function Show-WarningMessage {
    param (
        [string]$Message
    )
    Write-Host "[WARN] $Message" -ForegroundColor $Script:WinfigColors.Warning
}

# ---------------------------------------------------------------------------- #
# Function to prompt user for input with a specific color
function Prompt-UserInput {
    param (
        [string]$PromptMessage = $Script:WinfigPrompts.Confirm,
        [string]$PromptColor   = $Script:WinfigColors.Primary
    )
    # Write prompt in the requested color, keep cursor on same line, then read input
    Write-Host -NoNewline $PromptMessage -ForegroundColor $PromptColor
    $response = Read-Host

    return $response
}

# ---------------------------------------------------------------------------- #
# Function to Prompt user for confirmation (Y/N)
function Prompt-UserConfirmation {
    while ($true) {
        $response = Prompt-UserInput -PromptMessage $Script:WinfigPrompts.Confirm -PromptColor $Script:WinfigColors.Primary
        switch ($response.ToUpper()) {
            "Y" { return $true }
            "N" { return $false }
            default {
                Show-WarningMessage "Invalid input. Please enter Y or N."
            }
        }
    }
}

# ---------------------------------------------------------------------------- #
# Function to Prompt user to Retry (Y/N)
function Prompt-UserRetry {
    while ($true) {
        $response = Prompt-UserInput -PromptMessage $Script:WinfigPrompts.Retry -PromptColor $Script:WinfigColors.Primary
        switch ($response.ToUpper()) {
            "Y" { return $true }
            "N" { return $false }
            default {
                Show-WarningMessage "Invalid input. Please enter Y or N."
            }
        }
    }
}

# ---------------------------------------------------------------------------- #
# Function to Prompt user to continue
function Prompt-UserContinue {
    Write-Host $Script:WinfigPrompts.Continue -ForegroundColor $Script:WinfigColors.Primary
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# ---------------------------------------------------------------------------- #
# Function to Abort operation
function Abort-Operation {
    Show-ErrorMessage $Script:WinfigPrompts.Abort
    # Write log footer before exiting
    if ($Global:WinfigLogFilePath) {
        Log-Message -Message "Script terminated." -EndRun
    }
    exit 1
}

# ---------------------------------------------------------------------------- #
# Function to Write a Section Header
function Write-SectionHeader {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Title,

        [Parameter(Mandatory=$false)]
        [string]$Description = ""
    )
    $separator = "=" * 70
    Write-Host $separator -ForegroundColor $Script:WinfigColors.Accent
    Write-Host "$Title" -ForegroundColor $Script:WinfigColors.Primary
    if ($Description) {
        Write-Host "$Description" -ForegroundColor $Script:WinfigColors.Accent
    }
    Write-Host $separator -ForegroundColor $Script:WinfigColors.Accent
}

# ---------------------------------------------------------------------------- #
# Function to Write a Subsection Header
function Write-SubsectionHeader {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Title
    )
    $separator = "-" * 50
    Write-Host $separator -ForegroundColor $Script:WinfigColors.Accent
    Write-Host "$Title" -ForegroundColor $Script:WinfigColors.Primary
    Write-Host $separator -ForegroundColor $Script:WinfigColors.Accent
}

# ---------------------------------------------------------------------------- #
#  Function to Write a Log Message
function Log-Message {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,

        [Parameter(Mandatory=$false)]
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "SUCCESS")]
        [string]$Level = "INFO",

        [Parameter(Mandatory=$false)]
        [switch]$EndRun
    )

    if (-not $Global:LogCount) { $Global:LogCount = 0 }
    if (-not $Global:ErrorCount) { $Global:ErrorCount = 0 }
    if (-not $Global:WarnCount) { $Global:WarnCount = 0 }


    if (-not (Test-Path -Path $Global:WinfigPaths.Logs)) {
        New-Item -ItemType Directory -Path $Global:WinfigPaths.Logs -Force | Out-Null
    }

    $enc = New-Object System.Text.UTF8Encoding $true

    $identity = try { [System.Security.Principal.WindowsIdentity]::GetCurrent().Name } catch { $env:USERNAME }
    $isElevated = try {
        (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    } catch {
        $false
    }
    $scriptPath = if ($PSCommandPath) { $PSCommandPath } elseif ($MyInvocation.MyCommand.Path) { $MyInvocation.MyCommand.Path } else { $null }
    $psVersion = $PSVersionTable.PSVersion.ToString()
    $dotNetVersion = [System.Environment]::Version.ToString()
    $workingDir = (Get-Location).Path
    $osInfo = try {
        (Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop).Caption
    } catch {
        [Environment]::OSVersion.VersionString
    }
    # ---------------------------------------------------------------------------------------

    if (-not $Global:WinfigLogFilePath) {
        # $Global:WinfigLogStart is set in the main script execution block for each run
        $fileStamp = $Global:WinfigLogStart.ToString('yyyy-MM-dd_HH-mm-ss')
        $Global:WinfigLogFilePath = [System.IO.Path]::Combine($Global:WinfigPaths.Logs, "winfig-Dotfiles-$fileStamp.log")

        $header = @()
        $header += "==================== Winfig Dotfiles Log ===================="
        $header += "Start Time  : $($Global:WinfigLogStart.ToString('yyyy-MM-dd HH:mm:ss'))"
        $header += "Host Name   : $env:COMPUTERNAME"
        $header += "User        : $identity"
        $header += "IsElevated  : $isElevated"
        if ($scriptPath) { $header += "Script Path : $scriptPath" }
        $header += "Working Dir : $workingDir"
        $header += "PowerShell  : $psVersion"
        $header += "NET Version : $dotNetVersion"
        $header += "OS          : $osInfo"
        $header += "=============================================================="
        $header += ""

        try {
            [System.IO.File]::WriteAllLines($Global:WinfigLogFilePath, $header, $enc)
        } catch {
            $header | Out-File -FilePath $Global:WinfigLogFilePath -Encoding UTF8 -Force
        }
    } else {
        if (-not $Global:WinfigLogStart) {
            $Global:WinfigLogStart = Get-Date
        }

        try {
            if (Test-Path -Path $Global:WinfigLogFilePath) {
                $firstLine = Get-Content -Path $Global:WinfigLogFilePath -TotalCount 1 -ErrorAction SilentlyContinue
                if ($firstLine -and ($firstLine -notmatch 'Winfig Dotfiles Log')) {

                    $header = @()
                    $header += "==================== Winfig Dotfiles Log  ===================="
                    $header += "Start Time  : $($Global:WinfigLogStart.ToString('yyyy-MM-dd HH:mm:ss'))"
                    $header += "Host Name   : $env:COMPUTERNAME"
                    $header += "User        : $identity"
                    $header += "IsElevated  : $isElevated"
                    if ($scriptPath) { $header += "Script Path : $scriptPath" }
                    $header += "Working Dir : $workingDir"
                    $header += "PowerShell  : $psVersion"
                    $header += "NET Version : $dotNetVersion"
                    $header += "OS          : $osInfo"
                    $header += "======================================================================="
                    $header += ""

                    # Prepend header safely: write header to temp file then append original content
                    $temp = [System.IO.Path]::GetTempFileName()
                    try {
                        [System.IO.File]::WriteAllLines($temp, $header, $enc)
                        [System.IO.File]::AppendAllLines($temp, (Get-Content -Path $Global:WinfigLogFilePath -Raw).Split([Environment]::NewLine), $enc)
                        Move-Item -Force -Path $temp -Destination $Global:WinfigLogFilePath
                    } finally {
                        if (Test-Path $temp) { Remove-Item $temp -ErrorAction SilentlyContinue }
                    }
                }
            }
        } catch {
            # ignore header-fix failures; continue logging
        }
    }

    if ($EndRun) {
        $endTime = Get-Date
        # $Global:WinfigLogStart is guaranteed to be set now
        $duration = $endTime - $Global:WinfigLogStart
        $footer = @()
        $footer += ""
        $footer += "--------------------------------------------------------------"
        $footer += "End Time    : $($endTime.ToString('yyyy-MM-dd HH:mm:ss'))"
        $footer += "Duration    : $($duration.ToString('dd\.hh\:mm\:ss') -replace '^00\.', '')"
        $footer += "Log Count   : $Global:LogCount"
        $footer += "Errors/Warn : $Global:ErrorCount / $Global:WarnCount"
        $footer += "===================== End of Winfig Log ======================"
        try {
            [System.IO.File]::AppendAllLines($Global:WinfigLogFilePath, $footer, $enc)
        } catch {
            $footer | Out-File -FilePath $Global:WinfigLogFilePath -Append -Encoding UTF8
        }
        return
    }

    $now = Get-Date
    $timestamp = $now.ToString("yyyy-MM-dd HH:mm:ss.fff")
    $logEntry = "[$timestamp] [$Level] $Message"

    $Global:LogCount++
    if ($Level -eq 'ERROR') { $Global:ErrorCount++ }
    if ($Level -eq 'WARN') { $Global:WarnCount++ }

    try {
        [System.IO.File]::AppendAllText($Global:WinfigLogFilePath, $logEntry + [Environment]::NewLine, $enc)
    } catch {
        Write-Host "Failed to write log to file: $($_.Exception.Message)" -ForegroundColor Yellow
        Write-Host $logEntry
    }
}

# ====================================================================== #
#  Main Functions
# ====================================================================== #

# ---------------------------------------------------------------------------- #
# Function to check if running as Administrator
function IsAdmin{
    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal($currentUser)
    if ($principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Log-Message -Message "Script is running with Administrator privileges." -Level "SUCCESS"
    } else {
        Show-ErrorMessage "Script is NOT running with Administrator privileges."
        Log-Message -Message "Script is NOT running with Administrator privileges." -Level "ERROR"
        Log-Message "Forced exit." -EndRun
        $LogPathMessage = "Check the Log file for details: $($Global:WinfigLogFilePath)"
        Show-InfoMessage -Message $LogPathMessage
        exit 1
    }
}

# ---------------------------------------------------------------------------- #
# Function to check Working Internet Connection
function Test-InternetConnection {
    try {
        $request = [System.Net.WebRequest]::Create("http://www.google.com")
        $request.Timeout = 5000
        $response = $request.GetResponse()
        $response.Close()
        Log-Message -Message "Internet connection is available." -Level "SUCCESS"
        return $true
    } catch {
        Show-ErrorMessage "No internet connection available: $($_.Exception.Message)"
        Log-Message -Message "No internet connection available: $($_.Exception.Message)" -Level "ERROR"
        Log-Message "Forced exit." -EndRun
        $LogPathMessage = "Check the Log file for details: $($Global:WinfigLogFilePath)"
        Show-InfoMessage -Message $LogPathMessage
        exit 1

    }
}

# ---------------------------------------------------------------------------- #
# Function to Display Banner
function Winfig-Banner {
    Clear-Host
    Write-Host ""
    Write-Host ("  ██╗    ██╗██╗███╗   ██╗███████╗██╗ ██████╗  ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Light
    Write-Host ("  ██║    ██║██║████╗  ██║██╔════╝██║██╔════╝  ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Light
    Write-Host ("  ██║ █╗ ██║██║██╔██╗ ██║█████╗  ██║██║  ███╗ ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Accent
    Write-Host ("  ██║███╗██║██║██║╚██╗██║██╔══╝  ██║██║   ██║ ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Accent
    Write-Host ("  ╚███╔███╔╝██║██║ ╚████║██║     ██║╚██████╔╝ ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Success
    Write-Host ("   ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝  ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Success
    Write-Host ((" " * 70)) -ForegroundColor $Script:WinfigColors.Primary
    Write-Host ("" + $Script:WinfigMeta.CompanyName).PadLeft(40).PadRight(70) -ForegroundColor $Script:WinfigColors.Primary
    Write-Host ((" " * 70)) -ForegroundColor $Script:WinfigColors.Primary
    Write-Host ("  " + $Script:WinfigMeta.Description).PadRight(70) -ForegroundColor $Script:WinfigColors.Accent
    Write-Host ((" " * 70)) -ForegroundColor $Script:WinfigColors.Primary
    Write-Host (("  Version: " + $Script:WinfigMeta.Version + "    PowerShell: " + $Script:WinfigMeta.PowerShell).PadRight(70)) -ForegroundColor $Script:WinfigColors.Warning
    Write-Host (("  Author:  " + $Script:WinfigMeta.Author + "    Platform: " + $Script:WinfigMeta.Platform).PadRight(70)) -ForegroundColor $Script:WinfigColors.Warning
    Write-Host ""
}

# ---------------------------------------------------------------------------- #
# CTRL+C Signal Handler
trap {
    # Check if the error is due to a user interrupt (CTRL+C)
    if ($_.Exception.GetType().Name -eq "HostException" -and $_.Exception.Message -match "stopped by user") {

        # 1. Print the desired message
        Write-Host ""
        Write-Host ">>> [!] User interruption (CTRL+C) detected. Exiting gracefully..." -ForegroundColor $Script:WinfigColors.Accent

        # 2. Log the event before exit
        Log-Message -Message "Script interrupted by user (CTRL+C)." -Level "WARN"

        # 3. Write log footer before exiting
        if ($Global:WinfigLogFilePath) {
            Log-Message -Message "Script terminated by user (CTRL+C)." -EndRun
        }

        # 4. Terminate the script cleanly (exit code 1 is standard for non-zero exit)
        exit 1
    }
    # If it's a different kind of error, let the default behavior (or next trap) handle it
    continue
}

# ---------------------------------------------------------------------------- #
#  Create Dotfiles Directory if not exists
function Create-DotfilesDirectory {
    if (-not (Test-Path -Path $Global:WinfigPaths.DotFiles)) {
        try {
            New-Item -ItemType Directory -Path $Global:WinfigPaths.DotFiles -Force | Out-Null
            Show-SuccessMessage "Created Dotfiles directory at $($Global:WinfigPaths.DotFiles)."
            Log-Message -Message "Created Dotfiles directory at $($Global:WinfigPaths.DotFiles)." -Level "SUCCESS"
        } catch {
            Show-ErrorMessage "Failed to create Dotfiles directory: $($_.Exception.Message)"
            Log-Message -Message "Failed to create Dotfiles directory: $($_.Exception.Message)" -Level "ERROR"
            Abort-Operation
        }
    } else {
        Log-Message -Message "Dotfiles directory already exists at $($Global:WinfigPaths.DotFiles)." -Level "INFO"
    }
}

# ---------------------------------------------------------------------------- #
#  Check if git is installed
function Test-GitInstalled {
    try {
        git --version *> $null
        Log-Message -Message "Git is installed." -Level "SUCCESS"
        return $true
    } catch {
        Show-ErrorMessage "Git is not installed or not found in PATH."
        Log-Message -Message "Git is not installed or not found in PATH." -Level "ERROR"
        exit 1
    }
}

# ---------------------------------------------------------------------------- #
# Check if GPG is installed
function Test-GPGInstalled {
    try {
        gpg --version *> $null
        Log-Message -Message "GPG is installed." -Level "SUCCESS"
        return $true
    } catch {
        Show-ErrorMessage "GPG is not installed or not found in PATH."
        Log-Message -Message "GPG is not installed or not found in PATH." -Level "ERROR"
        exit 1
    }
}

# ---------------------------------------------------------------------------- #
# Create SSH Key for Git Setup (Interactive)
function Ensure-GitSSH {
    Write-SubsectionHeader -Title "SSH Key Setup"
    if (-not (Get-WindowsCapability -Online | Where-Object { $_.Name -like 'OpenSSH.Client*' -and $_.State -eq 'Installed' })) {
        Show-InfoMessage "OpenSSH Client is not installed. Installing..."
        Log-Message -Message "OpenSSH Client is not installed. Installing..." -Level "INFO"
        Add-WindowsCapability -Online -Name OpenSSH.Client
    }
    $sshDir = [System.IO.Path]::Combine($Global:WinfigPaths.UserProfile, ".ssh")
    if (-not (Test-Path -Path $sshDir)) {
        New-Item -ItemType Directory -Path $sshDir -Force | Out-Null
        Show-SuccessMessage "Created .ssh directory at $sshDir."
        Log-Message -Message "Created .ssh directory at $sshDir." -Level "SUCCESS"
    }

    $keyTypes = @("rsa", "ed25519", "ecdsa")
    Write-SubsectionHeader -Title "Choose SSH Key Type"
    for ($i = 0; $i -lt $keyTypes.Count; $i++) {
        Write-Host "  [$($i+1)] $($keyTypes[$i])" -ForegroundColor $Script:WinfigColors.Info
    }
    $typeChoice = Prompt-UserInput -PromptMessage "Enter number for key type (default: 1): " -PromptColor $Script:WinfigColors.Primary
    $keyType = if ($typeChoice -and $typeChoice -match '^[123]$') { $keyTypes[$typeChoice-1] } else { "rsa" }

    $keyBits = 4096
    if ($keyType -eq "rsa") {
        $bitsInput = Prompt-UserInput -PromptMessage "Enter bit length for RSA key (default: 4096): " -PromptColor $Script:WinfigColors.Primary
        if ($bitsInput -and $bitsInput -match '^[0-9]+$') { $keyBits = [int]$bitsInput }
    }

    $defaultComment = "$env:USERNAME@$env:COMPUTERNAME"
    $comment = Prompt-UserInput -PromptMessage "Enter email/comment for SSH key (default: $defaultComment): " -PromptColor $Script:WinfigColors.Primary
    if (-not $comment) { $comment = $defaultComment }

    $defaultFile = "id_${keyType}"
    $fileName = Prompt-UserInput -PromptMessage "Enter file name for SSH key (default: $defaultFile): " -PromptColor $Script:WinfigColors.Primary
    if (-not $fileName) { $fileName = $defaultFile }
    $keyPath = [System.IO.Path]::Combine($sshDir, $fileName)

    if (-not (Test-Path -Path $keyPath)) {
        try {
            $sshArgs = @()
            $sshArgs += "-t $keyType"
            if ($keyType -eq "rsa") { $sshArgs += "-b $keyBits" }
            $sshArgs += "-f `"$keyPath`""
            $sshArgs += "-N ''"
            $sshArgs += "-C `"$comment`""
            $cmd = "ssh-keygen $($sshArgs -join ' ')"
            Invoke-Expression $cmd *> $null
            Show-SuccessMessage "Generated new SSH key for Git at $keyPath."
            Log-Message -Message "Generated new SSH key for Git at $keyPath." -Level "SUCCESS"
        } catch {
            Show-ErrorMessage "Failed to generate SSH key: $($_.Exception.Message)"
            Log-Message -Message "Failed to generate SSH key: $($_.Exception.Message)" -Level "ERROR"
            Abort-Operation
        }
    } else {
        Show-InfoMessage "SSH key already exists at $keyPath."
        Log-Message -Message "SSH key already exists at $keyPath." -Level "INFO"
    }
    # Export public key for instructions
    $script:SSHPubKeyPath = "$keyPath.pub"
}

# ---------------------------------------------------------------------------- #
# Create GPG Key for Git Setup (Interactive) and save it in a variable to add it in gitconfig later in script
function Ensure-GitGPG {
    $script:GPGKeyID = $null
    Write-SubsectionHeader -Title "GPG Key Setup"
    try {
        gpg --version *> $null
    } catch {
        Show-ErrorMessage "GPG is not installed or not found in PATH. Please install GPG and rerun the script."
        Log-Message -Message "GPG is not installed or not found in PATH." -Level "ERROR"
        return
    }

    $existingKeys = gpg --list-secret-keys --keyid-format LONG 2>$null
    $keyLines = $existingKeys | Select-String '^sec\s'
    $keyIDs = @()
    foreach ($line in $keyLines) {
        if ($line -match '\/([A-F0-9]{16,})\s') {
            $keyIDs += $matches[1]
        }
    }

    if ($keyIDs.Count -gt 1) {
        Write-SubsectionHeader -Title "Multiple GPG Keys Detected"
        for ($i = 0; $i -lt $keyIDs.Count; $i++) {
            Write-Host "[$($i+1)] $($keyIDs[$i])" -ForegroundColor $Script:WinfigColors.Info
        }
        $choice = Prompt-UserInput -PromptMessage "Enter the number of the key you want to use for Git signing (default: 1): " -PromptColor $Script:WinfigColors.Primary
        if ($choice -match '^\d+$' -and $choice -ge 1 -and $choice -le $keyIDs.Count) {
            $script:GPGKeyID = $keyIDs[$choice-1]
        } else {
            $script:GPGKeyID = $keyIDs[0]
        }
    } elseif ($keyIDs.Count -eq 1) {
        $script:GPGKeyID = $keyIDs[0]
        Show-InfoMessage "Found GPG key: $script:GPGKeyID"
    }

    if (-not $script:GPGKeyID) {
        Show-WarningMessage "No GPG secret keys found. Let's create one for Git commit signing."
        Write-Host "You will now be prompted by GPG to generate a new key. Please follow the instructions in the terminal window." -ForegroundColor $Script:WinfigColors.Info
        try {
            gpg --full-generate-key
            $existingKeys = gpg --list-secret-keys --keyid-format LONG 2>$null
            $keyLines = $existingKeys | Select-String '^sec\s'
            $keyIDs = @()
            foreach ($line in $keyLines) {
                if ($line -match '\/([A-F0-9]{16,})\s') {
                    $keyIDs += $matches[1]
                }
            }
            if ($keyIDs.Count -gt 0) {
                $script:GPGKeyID = $keyIDs[-1]
                Show-SuccessMessage "Generated new GPG key for Git commit signing: $script:GPGKeyID"
                Log-Message -Message "Generated and found GPG key: $script:GPGKeyID" -Level "SUCCESS"
            } else {
                Show-ErrorMessage "Failed to detect new GPG key after creation."
                Log-Message -Message "Failed to detect new GPG key after creation." -Level "ERROR"
            }
        } catch {
            Show-ErrorMessage "Failed to generate GPG key: $($_.Exception.Message)"
            Log-Message -Message "Failed to generate GPG key: $($_.Exception.Message)" -Level "ERROR"
        }
    }

    if ($script:GPGKeyID) {
        Show-SuccessMessage "Using GPG key: $script:GPGKeyID"
    }
}

# ---------------------------------------------------------------------------- #
#  Git Setup Function
function SetupGitConfig {
    try {
        $Config    = [System.IO.Path]::Combine($Global:WinfigPaths.Templates, "Git", "gitconfig")
        $Ignore    = [System.IO.Path]::Combine($Global:WinfigPaths.Templates, "Git", "gitignore")
        $Tigrc    = [System.IO.Path]::Combine($Global:WinfigPaths.Templates, "Git", "tigrc")
        $Theme    = [System.IO.Path]::Combine($Global:WinfigPaths.Templates, "Git", "catppuchin.gitconfig")
        $Message   = [System.IO.Path]::Combine($Global:WinfigPaths.Templates, "Git", "gitmessage.txt")
        $target    = $Global:WinfigPaths.UserProfile

        $files = @{

            ".gitconfig" = $Config
            ".gitignore" = $Ignore
            ".tigrc" = $Tigrc
            ".catppuchin.gitconfig" = $Theme
            ".gitmessage.txt" = $Message
        }

        Write-SubsectionHeader -Title "Personalize Git Configuration"
        $userName = Prompt-UserInput -PromptMessage "Enter your name for Git commits: " -PromptColor $Script:WinfigColors.Primary
        $userEmail = Prompt-UserInput -PromptMessage "Enter your email for Git commits: " -PromptColor $Script:WinfigColors.Primary
        $gpgKey = $script:GPGKeyID

        $configContent = Get-Content -Path $Config -Raw
        $configContent = $configContent -replace '(?m)^([ \t]*name\s*=).*', "`$1 $userName"
        $configContent = $configContent -replace '(?m)^([ \t]*email\s*=).*', "`$1 $userEmail"
        if ($gpgKey) {
            $configContent = $configContent -replace '(?m)^([ \t]*signingkey\s*=).*', "`$1 $gpgKey"
        } else {
            $configContent = $configContent -replace '(?m)^([ \t]*signingkey\s*=).*', '#$1 <USER-GPG-KEY-ID> (not set)'
        }
        Set-Content -Path $Config -Value $configContent

        #  Setup GPG-Path in gitconfig
        $gpgPath = (Get-Command gpg).Source -replace '\\', '\\\\'
        $configContent = Get-Content -Path $Config -Raw
        $configContent = $configContent -replace '(?m)^([ \t]*program\s*=).*', "`$1 $gpgPath"
        Set-Content -Path $Config -Value $configContent

        # Write setup instructions for GitHub
        $instructionsPath = Join-Path $Global:WinfigPaths.UserProfile "setup-instructions.txt"
        $sshKeyText = ""
        if ($script:SSHPubKeyPath -and (Test-Path $script:SSHPubKeyPath)) {
            $sshKeyText = Get-Content $script:SSHPubKeyPath -Raw
        }
        $gpgKeyText = ""
        if ($gpgKey) {
            $gpgKeyText = gpg --armor --export $gpgKey 2>$null
        }

        $instructions = @()
        $instructions += "========================================"
        $instructions += "GitHub SSH & GPG Setup Instructions"
        $instructions += "========================================"
        $instructions += ""
        $instructions += "1. Add your SSH public key to GitHub:"
        $instructions += "   - Go to GitHub → Settings → SSH and GPG keys → New SSH key"
        $instructions += "   - Title: Give your key a descriptive name (e.g., 'Work Laptop')"
        $instructions += "   - Key type: Ensure it's 'Authentication Key'"
        $instructions += "   - Copy and paste the following key:"
        $instructions += ""
        $instructions += "===================================================================="
        $instructions += ""
        $instructions += $sshKeyText
        $instructions += ""
        $instructions += "===================================================================="
        $instructions += ""
        $instructions += "2. Add your GPG public key to GitHub:"
        $instructions += "   - Go to GitHub → Settings → SSH and GPG keys → New GPG key"
        $instructions += "   - Give it a meaningful name (e.g., 'Git Signing Key')"
        $instructions += "   - Copy and paste the following key:"
        $instructions += ""
        $instructions += "===================================================================="
        $instructions += ""
        $instructions += $gpgKeyText
        $instructions += ""
        $instructions += "===================================================================="
        $instructions += ""
        $instructions += "3. Test your setup:"
        $instructions += "   - SSH: ssh -T git@github.com"
        $instructions += "   - GPG: Create a test commit with: git commit -S -m 'Test signed commit'"
        $instructions += ""
        $instructions += "✅ Done! You can now use signed commits and SSH authentication with GitHub."
        $instructions += ""
        $instructions += "⚠️  IMPORTANT SECURITY NOTES:"
        $instructions += "   • This file contains SENSITIVE information"
        $instructions += "   • DO NOT share this file with anyone"
        $instructions += "   • Delete this file immediately after adding keys to GitHub"
        $instructions += "   • Store your SSH and GPG private keys securely"
        $instructions += ""
        Set-Content -Path $instructionsPath -Value $instructions -Encoding UTF8
        Show-InfoMessage "Instructions for adding your SSH and GPG keys to GitHub have been saved to: $instructionsPath"

        foreach ($name in $files.Keys) {
            $src = $files[$name]
            $dst = Join-Path $target $name

            # Remove existing file or directory or symlink if present
            if (Test-Path $dst) {
                try {
                    Remove-Item $dst -Force -Recurse
                    Log-Message -Message "Removed existing ${dst}" -Level "INFO"
                } catch {
                    Show-WarningMessage "Could not remove $dst. It may be in use. Skipping link."
                    Log-Message -Message "Could not remove ${dst}: $($_.Exception.Message)" -Level "WARN"
                    continue
                }
            }

            # Create symlink (directory or file)
            try {
                if (Test-Path $src -PathType Container) {
                    New-Item -ItemType SymbolicLink -Path $dst -Target $src -Force | Out-Null
                } else {
                    New-Item -ItemType SymbolicLink -Path $dst -Target $src -Force | Out-Null
                }
                Show-SuccessMessage "Symlinked $name to $dst"
                Log-Message -Message "Symlinked $src to $dst" -Level "SUCCESS"
            } catch {
                Show-WarningMessage "Could not create symlink for ${name}: $($_.Exception.Message)"
                Log-Message -Message "Could not create symlink for ${name}: $($_.Exception.Message)" -Level "WARN"
            }
        }
    } catch {
        Show-ErrorMessage "Failed to setup Git configuration: $($_.Exception.Message)"
        Log-Message -Message "Failed to setup Git configuration: $($_.Exception.Message)" -Level "ERROR"
    }
}

# ====================================================================== #
#  Main Script Execution
# ====================================================================== #

Winfig-Banner
Write-SectionHeader -Title "Checking Requirements"
Write-Host ""

IsAdmin | Out-Null
Show-SuccessMessage "Administrator privileges confirmed."

Test-InternetConnection | Out-Null
Show-SuccessMessage "Internet connection is available."

Test-GitInstalled | Out-Null
Show-SuccessMessage "Git installation check completed."

Create-DotfilesDirectory | Out-Null
Show-SuccessMessage "Dotfiles directory setup completed."

Test-GPGInstalled | Out-Null
Show-SuccessMessage "GPG installation check completed."

Write-Host ""
Prompt-UserContinue

Winfig-Banner
Write-SectionHeader -Title "Cloning Winfig Dotfiles Repository"
Write-Host ""
$repoPath = Join-Path $Global:WinfigPaths.DotFiles "winfig-dots"
if (-not (Test-Path -Path $repoPath)) {
    try {
        Show-InfoMessage "Cloning Winfig Dotfiles repository..."
        Log-Message -Message "Cloning Winfig Dotfiles repository..." -Level "INFO"
        git clone https://github.com/Get-Winfig/winfig-dots.git $repoPath *> $null
    } catch {
        Show-ErrorMessage "Failed to clone Winfig Dotfiles repository: $($_.Exception.Message)"
        Log-Message -Message "Failed to clone Winfig Dotfiles repository: $($_.Exception.Message)" -Level "ERROR"
        exit 1
    }
    if (Test-Path -Path $repoPath) {
        Show-SuccessMessage "Cloned Winfig Dotfiles repository to $repoPath."
        Log-Message -Message "Cloned Winfig Dotfiles repository to $repoPath." -Level "SUCCESS"
    } else {
        Show-ErrorMessage "Winfig Dotfiles repository was not cloned. Please check your internet connection or repository URL."
        Log-Message -Message "Winfig Dotfiles repository was not cloned. Please check your internet connection or repository URL." -Level "ERROR"
        exit 1
    }
} else {
    try {
        Show-InfoMessage "Updating Winfig Dotfiles repository..."
        Log-Message -Message "Updating Winfig Dotfiles repository..." -Level "INFO"
        Push-Location $repoPath
        git pull *> $null
        Pop-Location
        Show-SuccessMessage "Updated Winfig Dotfiles repository at $repoPath."
        Log-Message -Message "Updated Winfig Dotfiles repository at $repoPath." -Level "SUCCESS"
    } catch {
        Show-ErrorMessage "Failed to update Winfig Dotfiles repository: $($_.Exception.Message)"
        Log-Message -Message "Failed to update Winfig Dotfiles repository: $($_.Exception.Message)" -Level "ERROR"
        exit 1
    }
}

Write-Host ""
Prompt-UserContinue

Winfig-Banner
Write-SectionHeader -Title "Setup GPG and SSH Keys for Git"

Ensure-GitGPG

Ensure-GitSSH

Write-Host ""
Prompt-UserContinue

Winfig-Banner
Write-SectionHeader -Title "Setup Git Configuration"

SetupGitConfig

Write-Host ""
Write-SectionHeader -Title "Thank You For Using Winfig Dotfiles" -Description "https://github.com/Get-Winfig/"
Show-WarningMessage -Message "Restart Windows to apply changes"
Write-Host ""
Log-Message -Message "Logging Completed." -EndRun

# Open setup-instructions.txt in Notepad for user convenience
$instructionsPath = Join-Path $Global:WinfigPaths.UserProfile "setup-instructions.txt"
if (Test-Path $instructionsPath) {
    Start-Process notepad.exe $instructionsPath
}
