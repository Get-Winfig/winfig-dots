<#
    Module: networkinfo.ps1
    Purpose:
        This script defines a function to retrieve and display detailed network adapter information, including IP addresses, DNS servers, MAC addresses, link speed, and DHCP status.
        It supports filtering by adapter name and formats the output for readability.
#>

function networkinfo {
    [CmdletBinding()] # Makes it an advanced function, enabling common parameters
    param(
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string[]]$Name # Allows filtering by adapter name, supports pipeline input
    )

    process {
        try {
            # Get network adapters, filtering by Name if provided.
            # -ErrorAction Stop will stop the function if no adapter is found for the given name.
            $adapters = if ($PSBoundParameters.ContainsKey('Name')) {
                Get-NetAdapter -Name $Name -ErrorAction Stop
            } else {
                Get-NetAdapter -ErrorAction Stop # Get all adapters if no name is specified
            }

            foreach ($adapter in $adapters) {
                Write-Host "----- Network Adapter: $($adapter.Name) ($($adapter.Status)) -----" -ForegroundColor Cyan

                # Initialize variables to N/A or empty for disconnected/not present adapters
                $ipv4Address = "N/A"
                $subnetMask = "N/A"
                $defaultGateway = "N/A"
                $dnsServers = "N/A"
                $dhcpEnabled = "N/A"
                $linkSpeed = "$($adapter.LinkSpeed) Mbps" # Default link speed

                # Only attempt to get IP configuration and DNS if the adapter is 'Up'
                if ($adapter.Status -eq 'Up') {
                    $ipConfig = Get-NetIPConfiguration -InterfaceIndex $adapter.IfIndex -ErrorAction SilentlyContinue

                    if ($ipConfig) {
                        # IPv4 Address
                        if ($ipConfig.IPv4Address -and $ipConfig.IPv4Address.IPAddress) {
                            $ipv4Address = $ipConfig.IPv4Address.IPAddress
                            $subnetMask = $ipConfig.IPv4Address.PrefixLength
                        }

                        # Default Gateway
                        if ($ipConfig.IPv4DefaultGateway -and $ipConfig.IPv4DefaultGateway.NextHop) {
                            $defaultGateway = $ipConfig.IPv4DefaultGateway.NextHop
                        }

                        # DHCP Enabled status
                        if ($ipConfig.DhcpEnabled -ne $null) {
                            $dhcpEnabled = $ipConfig.DhcpEnabled
                        }

                        # DNS Servers
                        if ($ipConfig.DNSServer -and $ipConfig.DNSServer.ServerAddresses) {
                            $activeDnsServers = $ipConfig.DNSServer.ServerAddresses | Where-Object { $_ }
                            if ($activeDnsServers.Count -gt 0) {
                                $dnsServers = $activeDnsServers -join ', '
                            }
                        }
                    }
                }

                # Create a custom object for display
                [PSCustomObject]@{
                    'Name'              = $adapter.Name
                    'Description'       = $adapter.InterfaceDescription
                    'Status'            = $adapter.Status
                    'MAC Address'       = $adapter.MacAddress
                    'Link Speed'        = $linkSpeed
                    'IPv4 Address'      = $ipv4Address
                    'Subnet Mask'       = $subnetMask
                    'Default Gateway'   = $defaultGateway
                    'DNS Servers'       = $dnsServers
                    'Interface Index'   = $adapter.IfIndex # Useful for other cmdlets
                    'DHCP Enabled'      = $dhcpEnabled
                    'Connection Type'   = $adapter.ConnectionType # e.g., Ethernet, Wireless80211
                } | Format-List # Format as a list for detailed, readable output
            }
        }
        catch {
            Write-Host "Error retrieving network information: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "Ensure you have the 'NetAdapter' and 'NetTCPIP' modules available and sufficient permissions." -ForegroundColor Yellow
        }
    }
}
