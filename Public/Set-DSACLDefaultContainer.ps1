function Set-DSACLDefaultContainer {
    [CmdletBinding()]
    param (
        [string]
        $DomainDN,
        [ValidateSet('Users','Computers')]
        [string]
        $Container = 'Computers',
        [string]
        $NewValue
    )
    if(-not $PSBoundParameters.ContainsKey('DomainDN')) {
        $LDAPFilter = '(objectclass=domain)'
    } else {
        $LDAPFilter = "(distinguishedname=$DomainDN)"
    }

    $Domains = Find-LDAPObject -LDAPFilter $LDAPFilter -Raw
    if($null -eq $Domains) {
        throw 'Domain not found, please specify correct DomainDN'
    }
    if($Domains.Count -gt 1) {
        throw 'More than one domain found, please specify DomainDN'
    }

    $ContainerObject = $Domains.Properties.wellknownobjects | Where-Object -FilterScript {$_ -match $Script:DefaultContainersPatternTable[$Container]} | ForEach-Object -Process {
        if($Matches.ContainsKey('DN')) {
            [PSCustomObject]@{
                Name = 'ComputersContainer'
                DistinguishedName = $Matches['DN']
                Prefix = $Matches['prefix']
                Value = $_
            }
        }
    }

    $Index = $Domains.Properties.wellknownobjects.IndexOf($ContainerObject.Value)
    if($Index -ge 0 ) {
        $FullNewValue = $ContainerObject.Value.Replace($ContainerObject.DistinguishedName,$NewValue)
        $DirectoryEntry = $Domains.GetDirectoryEntry()
        $DirectoryEntry.wellKnownObjects.RemoveAt($Index)
        $null = $DirectoryEntry.wellKnownObjects.Add($FullNewValue)
        Set-DSACLObject -DirectoryEntry $DirectoryEntry
    } else {
        throw 'Failed to locate wellknown container.'
    }
}
