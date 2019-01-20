function Set-DSACLMachineAccountQuota  {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int]
        $Quota
    )
    try {
        $DefaultNamingContextDN = Get-LdapObject -DistinguishedName RootDse | Select-Object -ExpandProperty defaultNamingContext
        $DefaultNamingContext = Get-LdapObject -DistinguishedName $DefaultNamingContextDN
        $DefaultNamingContext.'ms-DS-MachineAccountQuota' = $Quota
        Set-DSACLObject -DirectoryEntry $DefaultNamingContext
    } catch {
        throw
    }
}
