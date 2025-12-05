# RecastHappyHour PowerShell Module

A sample PowerShell module for managing and displaying happy hour events and information.

## Installation

### Manual Installation

1. Copy the module folder to one of your PowerShell module paths:

   ```powershell
   $env:PSModulePath -split ';'
   ```

2. Common locations:
   - Current User: `$HOME\Documents\PowerShell\Modules\` (PowerShell 7+)
   - Current User: `$HOME\Documents\WindowsPowerShell\Modules\` (Windows PowerShell)
   - All Users: `C:\Program Files\PowerShell\Modules\`

3. Import the module:

   ```powershell
   Import-Module RecastHappyHour
   ```

### Install from Current Location

```powershell
# Copy to user modules directory
$modulePath = "$HOME\Documents\WindowsPowerShell\Modules\RecastHappyHour"
Copy-Item -Path . -Destination $modulePath -Recurse -Force
Import-Module RecastHappyHour
```

## Available Commands

### Get-HappyHourInfo

Gets information about happy hour events including location, time, and duration.

**Syntax:**

```powershell
Get-HappyHourInfo [-Location <String>] [-Date <DateTime>]
```

**Examples:**

```powershell
# Get default happy hour information
Get-HappyHourInfo

# Get info for a specific location and date
Get-HappyHourInfo -Location "Downtown Bar" -Date "2025-12-06"
```

### New-HappyHourEvent

Creates a new happy hour event with specified details.

**Syntax:**

```powershell
New-HappyHourEvent -Location <String> -Date <DateTime> [-Attendees <String[]>] [-Theme <String>]
```

**Examples:**

```powershell
# Create a basic event
New-HappyHourEvent -Location "Rooftop Bar" -Date "2025-12-10 17:00"

# Create an event with attendees and theme
New-HappyHourEvent -Location "Beach Club" -Date "2025-12-15 18:00" -Attendees @("Alice", "Bob", "Charlie") -Theme "Tropical"
```

### Show-HappyHourMenu

Displays a formatted menu of drinks and appetizers available during happy hour.

**Syntax:**

```powershell
Show-HappyHourMenu [-Category <String>] [-IncludePrices]
```

**Examples:**

```powershell
# Show complete menu
Show-HappyHourMenu

# Show only drinks with prices
Show-HappyHourMenu -Category Drinks -IncludePrices

# Show only food items
Show-HappyHourMenu -Category Food
```

## Quick Start

```powershell
# Import the module
Import-Module RecastHappyHour

# Get help for any command
Get-Help Get-HappyHourInfo -Full

# List all available commands
Get-Command -Module RecastHappyHour

# View the menu
Show-HappyHourMenu -IncludePrices

# Create an event
New-HappyHourEvent -Location "Local Pub" -Date (Get-Date).AddDays(1) -Attendees @("Team Members")
```

## Testing the Module

```powershell
# Verify module is loaded
Get-Module RecastHappyHour

# Test all functions
Get-HappyHourInfo
Show-HappyHourMenu -IncludePrices
New-HappyHourEvent -Location "Test Venue" -Date (Get-Date) -Attendees @("Tester") -WhatIf
```

## Module Structure

```
RecastHappyHour/
├── RecastHappyHour.psd1    # Module manifest
├── RecastHappyHour.psm1    # Module script with functions
└── README.md               # This file
```

## Version History

- **1.0.0** (2025-12-05)
  - Initial release
  - Three core functions: Get-HappyHourInfo, New-HappyHourEvent, Show-HappyHourMenu
  - Support for custom locations, dates, themes, and attendees

## Requirements

- PowerShell 5.1 or higher

## License

Copyright (c) 2025. All rights reserved.

## Author

Your Name

## Contributing

Feel free to extend this module with additional functions for managing happy hour events!
