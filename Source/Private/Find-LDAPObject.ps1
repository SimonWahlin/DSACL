function Find-LDAPObject {
    [CmdletBinding()]
    param (
        [System.DirectoryServices.SearchScope]
        $SearchScope = [System.DirectoryServices.SearchScope]::Subtree,

        [string]
        $SearchBase,

        [string]
        $Server,

        [String[]]
        $Property,

        [Parameter(Mandatory)]
        [string]
        $LDAPFilter,

        [switch]
        $Raw
    )
    process {
        try {
            if($Property.Count -gt 0) {
                $Properties = $Property
            } else {
                $Properties = $null
            }
            if(-not $PSBoundParameters.ContainsKey('SearchBase')) {
                $SearchBase = Get-LdapObject -DistinguishedName RootDse | Select-Object -ExpandProperty defaultNamingContext
            }
            if ([string]::IsNullOrWhiteSpace($Server)) {
                $SearchRoot = "LDAP://$SearchBase"
            } else {
                $SearchRoot = "LDAP://$Server/$SearchBase"
            }

            $DirectoryEntry = New-Object -TypeName 'System.DirectoryServices.DirectoryEntry' -ArgumentList $SearchRoot
            $Searcher = New-Object -TypeName 'System.DirectoryServices.DirectorySearcher' -ArgumentList $DirectoryEntry, $LDAPFilter, $Properties, $SearchScope
            $Searcher.PageSize = 1000
            $Result = $Searcher.FindAll()
            if($Raw.IsPresent) {
                Write-Output $Result
            } else {
                foreach($Object in $Result) {
                    $ObjectData = @{}
                    foreach($prop in $Object.Properties.Keys) {
                        if($Object.Properties[$prop].Count -eq 1) {
                            $Data = $Object.Properties[$prop].Item(0)
                        } else {
                            $Data = for ($i = 0; $i -lt $Object.Properties[$prop].Count; $i++) {
                                $Object.Properties[$prop].Item($i)
                            }
                        }
                        $ObjectData.Add($prop,$Data)
                    }
                    [PSCustomObject]$ObjectData
                }
            }
        }
        catch {
            throw
        }
        finally {
            try {
                $Searcher.Dispose()
            }
            catch {
                # Don't care about errors
            }
        }
    }
}
