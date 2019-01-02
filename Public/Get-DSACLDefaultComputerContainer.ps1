function Get-DSACLDefaultContainer {
    [CmdletBinding()]
    param (
        $DomainDN,
        [ValidateSet('Users','Computers')]
        [string]
        $Type = 'Computers'
    )
    if(-not $PSBoundParameters.ContainsKey('DomainDN')) {
        $LDAPFilter = '(objectclass=domain)'
    } else {
        $LDAPFilter = "(distinguishedname=$DomainDN)"
    }

    $Domains = Find-LDAPObject -LDAPFilter $LDAPFilter
    if($null -eq $Domains) {
        throw 'Domain not found, please specify correct DomainDN'
    }
    if($Domains.Count -gt 1) {
        throw 'More than one domain found, please specify DomainDN'
    }

    $Domains.wellknownobjects | Where-Object -FilterScript {$_ -match $Script:DefaultContainersPatternTable[$Type]} | ForEach-Object -Process {
        if($Matches.ContainsKey('DN')) {
            [DSACLDefaultContainerConfig]::new(
                'Default{0}Container' -f $Type,
                $Matches['DN'],
                $Matches['prefix'],
                $Domains.wellknownobjects.IndexOf($_),
                $Domains.distinguishedname
            )
        }
    }
}
