<#
    Module: Weather.ps1
    Purpose:
        This script defines a function to fetch and display the current weather information based on the user's IP-detected location.
#>

function weather {
    # Get location from IP
    $location = Invoke-RestMethod "https://ipinfo.io/json"
    $city = $location.city
    $country = $location.country

    # Get weather for detected location
    Invoke-RestMethod "https://wttr.in/$city"
}
