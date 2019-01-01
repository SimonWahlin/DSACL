function Get-DSACLDefaultContainer {
    [CmdletBinding()]
    param (
        $DomainDN,
        [ValidateSet('Users','Computers')]
        [string]
        $Container = 'Computers',
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


    $Domains.Properties.wellknownobjects | Where-Object -FilterScript {$_ -match $Script:DefaultContainersPatternTable[$Container]} | ForEach-Object -Process {
        if($Matches.ContainsKey('DN')) {
            [PSCustomObject]@{
                Name = 'ComputersContainer'
                DistinguishedName = $Matches['DN']
                Prefix = $Matches['prefix']
                Value = $_
            }
        }
    }
}
