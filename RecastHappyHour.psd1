@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'RecastHappyHour.psm1'

    # Version number of this module.
    ModuleVersion = '1.0.0'

    # ID used to uniquely identify this module
    GUID = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'

    # Author of this module
    Author = 'Your Name'

    # Company or vendor of this module
    CompanyName = 'Recast Software'

    # Copyright statement for this module
    Copyright = '(c) 2025. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'A sample PowerShell module for Recast Happy Hour demonstrations'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Functions to export from this module
    FunctionsToExport = @('Get-HappyHourInfo', 'New-HappyHourEvent', 'Show-HappyHourMenu', 'Get-ComputerSerialNumber')

    # Cmdlets to export from this module
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module
    AliasesToExport = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess
    PrivateData = @{
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('HappyHour', 'Events', 'Demo')

            # A URL to the license for this module.
            # LicenseUri = ''

            # A URL to the main website for this project.
            # ProjectUri = ''

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            # ReleaseNotes = ''
        }
    }
}
