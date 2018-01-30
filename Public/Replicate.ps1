<#
.SYNOPSIS
Give Delegate "Replicating Directory Changes" rights on domain with DistinguishedName in target

.EXAMPLE
Add-DSACLReplicatingDirectoryChanges -DelegateDN $AADCServiceAccount
Will give the service account with DistinguishedName in $AADCServiceAccount the right "Replicating Directory Changes".
Add -AllowReplicateSecrets to grant "Replicating Directory Changes All" instead..

#>
function Add-DSACLReplicatingDirectoryChanges {
    [CmdletBinding(DefaultParameterSetName='ByTypeName')]
    param (
        # DistinguishedName of group or user to give permissions to.
        [Parameter(Mandatory)]
        [String]
        $DelegateDN,

        # Allow replicating secrets, like passwords (Corresponds to "Replicating Directory Changes All")
        [Parameter()]
        [Switch]
        $AllowReplicateSecrets
    )

    process {
        try {

            $TargetDN = Get-LdapObject -DistinguishedName RootDse | Select-Object -ExpandProperty defaultNamingContext

            if ($AllowReplicateSecrets.IsPresent) {
                $ObjectType = '1131f6ad-9c07-11d1-f79f-00c04fc2dcd2'
            }
            else {
                $ObjectType = '1131f6aa-9c07-11d1-f79f-00c04fc2dcd2'
            }
            $Params = @{
                TargetDN              = $TargetDN
                DelegateDN            = $DelegateDN
                ActiveDirectoryRights = 'ExtendedRight'
                AccessControlType     = 'Allow'
                ObjectType            = $ObjectType
                InheritanceType       = 'None'
            }
            Add-DSACLCustom @Params

        }
        catch {
            throw
        }
    }
}
