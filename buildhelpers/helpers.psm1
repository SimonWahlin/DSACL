function Merge-ModuleFiles {
    [CmdletBinding()]
    param (
        # Specifies a path to one or more locations.
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations.")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string[]]
        $Path,

        # Specifies a path to outputfile.
        [ValidateNotNullOrEmpty()]
        [string]
        $OutputPath,

        # Encoding of input-files
        [Parameter()]
        [Microsoft.PowerShell.Commands.FileSystemCmdletProviderEncoding]
        $Encoding = 'UTF8'
    )
    process {
        $Path | Foreach-Object -Process {
            Get-Content -Path $_ -Encoding $Encoding
        } | Out-File -FilePath $OutputPath -Encoding $Encoding -Force
    }
}

function Get-ScriptblockFromFile {
    [CmdletBinding()]
    param (
        # Specifies a path to one or more locations. Wildcards are permitted.
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations.")]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string[]]
        $Path,

        # Encoding of input-files
        [Parameter()]
        [Microsoft.PowerShell.Commands.FileSystemCmdletProviderEncoding]
        $Encoding = 'UTF8'
    )
    process {
        $Content = $Path | Foreach-Object -Process {
            Get-Content -Path $_ -Encoding $Encoding
        } | Out-String
        [ScriptBlock]::Create($Content)
    }
}

function Get-FunctionFromScriptblock {
    [CmdletBinding()]
    param (
        # Scriptblock
        [Parameter(Mandatory)]
        [scriptblock]
        $ScriptBlock
    )
    process {
        $ScriptBlock.Ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst]},$false).Name
    }
}

function Get-AliasFromScriptblock {
    [CmdletBinding()]
    param (
        # Scriptblock
        [Parameter(Mandatory)]
        [scriptblock]
        $ScriptBlock
    )
    process {
        (
            $ScriptBlock.Ast.FindAll({ $args[0] -is [System.Management.Automation.Language.AttributeAst] },$true) |
            Where-Object -FilterScript {
                $_.TypeName.FullName -eq 'Alias' -and $_.Parent -is [System.Management.Automation.Language.ParamBlockAst]
            }
        ).PositionalArguments.Value
    }
}