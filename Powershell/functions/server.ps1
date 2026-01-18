<#
    Module: Server.ps1
    Purpose:
        This script defines a function that use fzf to select a service (node, npm, hugo, python, uv, php, etc) to start a local development server.
#>

function server {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string]$Service,
        # Default port to use
        [int]$Port = 8000,
        # General path to serve from, defaults to current directory
        [Parameter(Mandatory=$false)]
        [string]$Path = "."
    )

    begin {
        # Define available services and their commands
        $services = @{
            "node"   = { param($path, $port) npx http-server $path -p $port }
            "npm"    = { param($path, $port) npx serve $path -l $port }
            "hugo"   = { param($path, $port) hugo server --source $path --port $port --bind localhost --disableLiveReload }
            "python" = { param($path, $port) python -m http.server $port --directory $path }
            "uv"     = { param($path, $port) uv run python -m http.server $port --directory $path }
            "php"    = { param($path, $port) php -S localhost:$port -t $path }
            "mkdocs" = { param() uv run mkdocs serve --dirtyreload --livereload }
        }
    }

    process {
        # If Service is not provided, prompt with fzf
        if ([string]::IsNullOrWhiteSpace($Service)) {
            $Service = $services.Keys | fzf --height=30% --prompt="Select service to start: " --header="Use ↑/↓ to select, <Enter> to confirm" --reverse --border
            if ([string]::IsNullOrWhiteSpace($Service)) {
                Write-Host "No service selected. Exiting."
                return
            }
        }

        # Validate service after selection
        $validServices = $services.Keys
        if ($Service -notin $validServices) {
            Write-Host "Unknown service: $Service. Available services: $($validServices -join ', ')" -ForegroundColor Red
            return
        }

        # Resolve path to absolute
        $resolvedPath = Resolve-Path $Path -ErrorAction SilentlyContinue
        if (-not $resolvedPath) {
            Write-Host "Path not found: $Path" -ForegroundColor Red
            return
        }

        Write-Host "Starting $Service server..." -ForegroundColor Cyan
        Write-Host "Path: $resolvedPath" -ForegroundColor Gray
        Write-Host "Port: $Port" -ForegroundColor Gray
        Write-Host "URL: http://localhost:$Port" -ForegroundColor Green
        Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow

        # Execute the service command
        try {
            & $services[$Service] $resolvedPath $Port
        }
        catch {
            Write-Host "Error starting $Service server: $_" -ForegroundColor Red
        }
    }
}
