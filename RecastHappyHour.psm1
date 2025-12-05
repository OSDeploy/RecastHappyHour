# RecastHappyHour PowerShell Module

#region Private Functions

function Get-HappyHourData {
    <#
    .SYNOPSIS
    Retrieves default happy hour configuration data.
    
    .DESCRIPTION
    Internal function that returns the default configuration settings for happy hour events,
    including location, time, and duration. This function is used by other module functions
    to provide consistent default values.
    
    .OUTPUTS
    System.Collections.Hashtable
    Returns a hashtable containing DefaultLocation, DefaultTime, and DefaultDuration.
    
    .NOTES
    This is a private function not exported from the module.
    #>
    [CmdletBinding()]
    param()
    
    return @{
        DefaultLocation = "The Local Pub"
        DefaultTime = "17:00"
        DefaultDuration = 120
    }
}

#endregion

#region Public Functions

function Get-HappyHourInfo {
    <#
    .SYNOPSIS
    Retrieves information about happy hour events.
    
    .DESCRIPTION
    The Get-HappyHourInfo function retrieves detailed information about happy hour events,
    including the location, time, duration, and day of the week. If no location is specified,
    the default location from module configuration is used. The function supports custom dates
    and provides formatted output for easy consumption.
    
    .PARAMETER Location
    Specifies the location of the happy hour event. If not provided, the default location
    "The Local Pub" is used.
    
    .PARAMETER Date
    Specifies the date of the happy hour event. Accepts any valid DateTime value.
    If not provided, the current date is used.
    
    .EXAMPLE
    Get-HappyHourInfo
    
    Gets default happy hour information for today at the default location.
    
    .EXAMPLE
    Get-HappyHourInfo -Location "Downtown Bar" -Date "2025-12-06"
    
    Gets happy hour information for Downtown Bar on December 6, 2025.
    
    .EXAMPLE
    Get-HappyHourInfo -Date (Get-Date).AddDays(7) -Verbose
    
    Gets happy hour information for one week from today with verbose output.
    
    .INPUTS
    None. You cannot pipe input to this function.
    
    .OUTPUTS
    System.Management.Automation.PSCustomObject
    Returns a custom object with Location, Date, Time, Duration, and DayOfWeek properties.
    
    .NOTES
    Name: Get-HappyHourInfo
    Author: Recast Software
    Version: 1.0.0
    DateCreated: 2025-12-05
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Location,
        
        [Parameter()]
        [datetime]$Date = (Get-Date)
    )
    
    begin {
        Write-Verbose "Getting happy hour information..."
    }
    
    process {
        $data = Get-HappyHourData
        
        if (-not $Location) {
            $Location = $data.DefaultLocation
        }
        
        $result = [PSCustomObject]@{
            Location = $Location
            Date = $Date.ToString("yyyy-MM-dd")
            Time = $data.DefaultTime
            Duration = "$($data.DefaultDuration) minutes"
            DayOfWeek = $Date.DayOfWeek
        }
        
        return $result
    }
    
    end {
        Write-Verbose "Happy hour information retrieved successfully."
    }
}

function New-HappyHourEvent {
    <#
    .SYNOPSIS
    Creates a new happy hour event with specified details.
    
    .DESCRIPTION
    The New-HappyHourEvent function creates a new happy hour event with a unique event ID,
    location, date/time, attendees list, and optional theme. The function supports WhatIf
    and Confirm parameters for safe execution. Event details are displayed with color-coded
    output and a PSCustomObject is returned containing all event information.
    
    .PARAMETER Location
    Specifies the location for the happy hour event. This parameter is mandatory.
    
    .PARAMETER Date
    Specifies the date and time for the event. Accepts any valid DateTime value.
    This parameter is mandatory.
    
    .PARAMETER Attendees
    Specifies an array of attendee names for the event. This parameter is optional.
    If not provided, an empty array is used.
    
    .PARAMETER Theme
    Specifies an optional theme for the happy hour event (e.g., "Tropical", "Sports", "Karaoke").
    
    .EXAMPLE
    New-HappyHourEvent -Location "Rooftop Bar" -Date "2025-12-10 17:00" -Attendees @("Alice", "Bob", "Charlie")
    
    Creates a new happy hour event at Rooftop Bar on December 10, 2025 at 5:00 PM with three attendees.
    
    .EXAMPLE
    New-HappyHourEvent -Location "Beach Club" -Date "2025-12-15 18:00" -Attendees @("Team") -Theme "Tropical"
    
    Creates a themed happy hour event with a Tropical theme.
    
    .EXAMPLE
    New-HappyHourEvent -Location "Downtown Pub" -Date (Get-Date).AddDays(3) -WhatIf
    
    Shows what would happen if the event was created without actually creating it.
    
    .INPUTS
    None. You cannot pipe input to this function.
    
    .OUTPUTS
    System.Management.Automation.PSCustomObject
    Returns a custom object with EventId, Location, DateTime, Attendees, Theme, Created, and Status properties.
    
    .NOTES
    Name: New-HappyHourEvent
    Author: Recast Software
    Version: 1.0.0
    DateCreated: 2025-12-05
    
    This function supports ShouldProcess for -WhatIf and -Confirm parameters.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$Location,
        
        [Parameter(Mandatory)]
        [datetime]$Date,
        
        [Parameter()]
        [string[]]$Attendees = @(),
        
        [Parameter()]
        [string]$Theme
    )
    
    if ($PSCmdlet.ShouldProcess($Location, "Create happy hour event")) {
        $event = [PSCustomObject]@{
            EventId = [guid]::NewGuid().ToString()
            Location = $Location
            DateTime = $Date
            Attendees = $Attendees
            Theme = $Theme
            Created = Get-Date
            Status = "Scheduled"
        }
        
        Write-Host "Happy Hour Event Created!" -ForegroundColor Green
        Write-Host "Event ID: $($event.EventId)" -ForegroundColor Cyan
        Write-Host "Location: $($event.Location)" -ForegroundColor Yellow
        Write-Host "Date/Time: $($event.DateTime)" -ForegroundColor Yellow
        
        if ($Attendees.Count -gt 0) {
            Write-Host "Attendees: $($Attendees -join ', ')" -ForegroundColor Yellow
        }
        
        if ($Theme) {
            Write-Host "Theme: $Theme" -ForegroundColor Magenta
        }
        
        return $event
    }
}

function Show-HappyHourMenu {
    <#
    .SYNOPSIS
    Displays a formatted happy hour menu with drinks and food items.
    
    .DESCRIPTION
    The Show-HappyHourMenu function displays a visually formatted menu of drinks and food items
    available during happy hour. The menu can be filtered by category and optionally include
    pricing information. Output is color-coded for easy reading and includes various beverages
    and appetizers.
    
    .PARAMETER Category
    Specifies which category of items to display. Valid values are 'All', 'Drinks', or 'Food'.
    Default value is 'All', which displays both drinks and food items.
    
    .PARAMETER IncludePrices
    When specified, includes pricing information for each menu item.
    If not specified, only item names are displayed.
    
    .EXAMPLE
    Show-HappyHourMenu
    
    Displays the complete happy hour menu with both drinks and food items without prices.
    
    .EXAMPLE
    Show-HappyHourMenu -Category Drinks -IncludePrices
    
    Displays only the drinks section of the menu with pricing information.
    
    .EXAMPLE
    Show-HappyHourMenu -Category Food
    
    Displays only the food section of the menu without prices.
    
    .EXAMPLE
    Show-HappyHourMenu -IncludePrices
    
    Displays the complete menu with pricing for all items.
    
    .INPUTS
    None. You cannot pipe input to this function.
    
    .OUTPUTS
    None. This function displays formatted text output to the console.
    
    .NOTES
    Name: Show-HappyHourMenu
    Author: Recast Software
    Version: 1.0.0
    DateCreated: 2025-12-05
    
    Menu items and prices are predefined within the function and represent sample data.
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateSet('All', 'Drinks', 'Food')]
        [string]$Category = 'All',
        
        [Parameter()]
        [switch]$IncludePrices
    )
    
    $menu = @{
        Drinks = @(
            @{Name = "House Beer"; Price = 5.00}
            @{Name = "House Wine"; Price = 6.00}
            @{Name = "Well Cocktails"; Price = 7.00}
            @{Name = "Craft Beer"; Price = 6.50}
        )
        Food = @(
            @{Name = "Nachos"; Price = 8.00}
            @{Name = "Wings"; Price = 10.00}
            @{Name = "Sliders"; Price = 9.00}
            @{Name = "Fries"; Price = 5.00}
        )
    }
    
    Write-Host "`n=== HAPPY HOUR MENU ===" -ForegroundColor Cyan
    Write-Host ""
    
    if ($Category -eq 'All' -or $Category -eq 'Drinks') {
        Write-Host "DRINKS:" -ForegroundColor Yellow
        foreach ($item in $menu.Drinks) {
            if ($IncludePrices) {
                Write-Host "  - $($item.Name) `$$($item.Price)" -ForegroundColor White
            } else {
                Write-Host "  - $($item.Name)" -ForegroundColor White
            }
        }
        Write-Host ""
    }
    
    if ($Category -eq 'All' -or $Category -eq 'Food') {
        Write-Host "FOOD:" -ForegroundColor Yellow
        foreach ($item in $menu.Food) {
            if ($IncludePrices) {
                Write-Host "  - $($item.Name) `$$($item.Price)" -ForegroundColor White
            } else {
                Write-Host "  - $($item.Name)" -ForegroundColor White
            }
        }
        Write-Host ""
    }
    
    Write-Host "======================" -ForegroundColor Cyan
    Write-Host ""
}

# new function to get the serial number of the computer
function Get-ComputerSerialNumber {
    <#
    .SYNOPSIS
    Retrieves the serial number of the local computer.
    
    .DESCRIPTION
    The Get-ComputerSerialNumber function uses Windows Management Instrumentation (WMI)
    to query the Win32_BIOS class and retrieve the serial number of the local computer.
    This is useful for asset management, inventory tracking, and system identification.
    The function includes error handling for WMI query failures.
    
    .EXAMPLE
    Get-ComputerSerialNumber
    
    Returns the serial number of the local machine.
    
    .EXAMPLE
    $serial = Get-ComputerSerialNumber
    Write-Host "Computer Serial Number: $serial"
    
    Retrieves the serial number and stores it in a variable for later use.
    
    .INPUTS
    None. You cannot pipe input to this function.
    
    .OUTPUTS
    System.String
    Returns the BIOS serial number as a string.
    
    .NOTES
    Name: Get-ComputerSerialNumber
    Author: Recast Software
    Version: 1.0.0
    DateCreated: 2025-12-05
    
    Requires local administrator privileges for WMI access on some systems.
    This function only works on Windows systems with WMI support.
    #>
    [CmdletBinding()]
    param()
    
    try {
        $serialNumber = (Get-WmiObject -Class Win32_BIOS).SerialNumber
        return $serialNumber
    } catch {
        Write-Error "Failed to retrieve serial number: $_"
    }
}


#endregion

#region Module Initialization

Write-Verbose "RecastHappyHour module loaded successfully."

#endregion

# Export module members
Export-ModuleMember -Function *
