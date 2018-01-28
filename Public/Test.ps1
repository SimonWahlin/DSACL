function Get-Public {
    [Alias('vbn')]
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
        function Get-Nested {
            [CmdletBinding()]
            param (

            )

            begin {
            }

            process {
            }

            end {
            }
        }
    }

    process {
        $Private = Get-Private
        if($Private -eq 'PrivateFunc') {
            return $true
        }
        else {
            return $false
        }
    }

    end {
    }
}