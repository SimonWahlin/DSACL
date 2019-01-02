function Set-DSACLDefaultContainer {
    [CmdletBinding()]
    param (
        [string]
        $DomainDN,

        [ValidateSet('Users','Computers')]
        [string]
        $Type = 'Computers',

        [string]
        $NewValue
    )

    $null = $PSBoundParameters.Remove('NewValue')
    $ContainerObject = Get-DSACLDefaultContainer @PSBoundParameters

    if($ContainerObject.Index -ge 0 ) {
        $FullNewValue = '{0}{1}' -f $ContainerObject.Prefix, $NewValue
        $DirectoryEntry = Get-LDAPObject -DistinguishedName $ContainerObject.DomainDN
        $DirectoryEntry.wellKnownObjects.RemoveAt($ContainerObject.Index)
        $null = $DirectoryEntry.wellKnownObjects.Add($FullNewValue)
        Set-DSACLObject -DirectoryEntry $DirectoryEntry
    } else {
        throw 'Failed to locate wellknown container.'
    }
}
