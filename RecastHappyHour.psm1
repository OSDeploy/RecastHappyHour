# RecastHappyHour PowerShell Module

#region Private Functions

function Get-HappyHourData {
    <#
    .SYNOPSIS
    Internal function to retrieve happy hour data.
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
    Gets information about happy hour events.
    
    .DESCRIPTION
    Retrieves details about happy hour including location, time, and duration.
    
    .PARAMETER Location
    The location of the happy hour event.
    
    .PARAMETER Date
    The date of the happy hour event.
    
    .EXAMPLE
    Get-HappyHourInfo
    Gets default happy hour information.
    
    .EXAMPLE
    Get-HappyHourInfo -Location "Downtown Bar" -Date "2025-12-06"
    Gets happy hour info for a specific location and date.
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
    Creates a new happy hour event.
    
    .DESCRIPTION
    Creates a new happy hour event with specified details.
    
    .PARAMETER Location
    The location for the happy hour event.
    
    .PARAMETER Date
    The date and time for the event.
    
    .PARAMETER Attendees
    List of attendees for the event.
    
    .PARAMETER Theme
    Optional theme for the happy hour.
    
    .EXAMPLE
    New-HappyHourEvent -Location "Rooftop Bar" -Date "2025-12-10 17:00" -Attendees @("Alice", "Bob", "Charlie")
    Creates a new happy hour event.
    
    .EXAMPLE
    New-HappyHourEvent -Location "Beach Club" -Date "2025-12-15 18:00" -Attendees @("Team") -Theme "Tropical"
    Creates a themed happy hour event.
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
    Displays a sample happy hour menu.
    
    .DESCRIPTION
    Shows a formatted menu of drinks and appetizers available during happy hour.
    
    .PARAMETER Category
    Filter menu by category (Drinks, Food, or All).
    
    .PARAMETER IncludePrices
    Include pricing information in the output.
    
    .EXAMPLE
    Show-HappyHourMenu
    Shows the complete happy hour menu.
    
    .EXAMPLE
    Show-HappyHourMenu -Category Drinks -IncludePrices
    Shows only drinks with prices.
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

#endregion

#region Module Initialization

Write-Verbose "RecastHappyHour module loaded successfully."

#endregion

# Export module members
Export-ModuleMember -Function 'Get-HappyHourInfo', 'New-HappyHourEvent', 'Show-HappyHourMenu'
