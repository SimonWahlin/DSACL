function Get-Private {
    [CmdletBinding()]
    param (
        # Specifies a path to one or more locations. Wildcards are permitted.
        [Parameter(Mandatory=$false,
                   Position=0,
                   ParameterSetName="ParameterSetName",
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations.")]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [Alias('PSPath')]
        [string[]]
        $Path
    )

    begin {
    }

    process {
        return 'PrivateFunc'
    }

    end {
    }
}