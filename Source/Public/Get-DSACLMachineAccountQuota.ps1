function Get-DSACLMachineAccountQuota  {
    [CmdletBinding()]
    param ()
    try {
        $DefaultNamingContextDN = Get-LdapObject -DistinguishedName RootDse | Select-Object -ExpandProperty defaultNamingContext
        $DefaultNamingContext = Get-LdapObject -DistinguishedName $DefaultNamingContextDN
        $DefaultNamingContext.'ms-DS-MachineAccountQuota'.Value
    } catch {
        throw
    }
}
