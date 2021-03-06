<#
    .SYNOPSIS
    Give DelegateDN rights to join computers in target (usually an OU).

    .EXAMPLE
    Add-DSACLJoinDomain -TargetDN $ComputersOU -DelegateDN $JoinDomainAccounts -AccessType Allow
    Will give the group with DistinguishedName in $JoinDomainAccounts rights to join computers to
    the domain. Requires a computer account to be created already.

    Use switch -AllowCreate to allow to create computer objects in OU and join without a
    pre-existing computer object. Add -NoInheritance do disable the access to ineherit to sub-OUs.
#>
function Add-DSACLJoinDomain {
    [CmdletBinding()]
    param (
        # DistinguishedName of object to modify ACL on. Usually an OU.
        [Parameter(Mandatory)]
        [String]
        $TargetDN,

        # DistinguishedName of group or user to give permissions to.
        [Parameter(Mandatory)]
        [String]
        $DelegateDN,

        # Allow creating computer objects, this allows to join computers without a pre-staged computer account
        [Parameter()]
        [Switch]
        $AllowCreate,

        # Sets access right to "This object only"
        [Parameter()]
        [Switch]
        $NoInheritance
    )

    process {
        try {

            $WriteParams = @{
                TargetDN       = $TargetDN
                DelegateDN     = $DelegateDN
                ObjectTypeName = 'Computer'
                AccessType     = 'Allow'
                NoInheritance  = $NoInheritance
            }
            Add-DSACLResetPassword @WriteParams
            Add-DSACLWriteAccountRestrictions @WriteParams
            Add-DSACLWriteServicePrincipalName @WriteParams
            Add-DSACLWriteDNSHostName @WriteParams

            if($AllowCreate.IsPresent) {
                Add-DSACLCreateChild -TargetDN $TargetDN -DelegateDN $DelegateDN -ObjectTypeName Computer -NoInheritance:$NoInheritance
            }

        }
        catch {
            throw
        }
    }
}
