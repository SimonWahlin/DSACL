<#
.SYNOPSIS
Give Delegate rights to manage members in group(s).

.EXAMPLE
Add-DSACLManageGroupMember -TargetDN $GroupsOU -DelegateDN $AccessAdminGroup -AccessType Allow
Will give the group with DistinguishedName in $AccessAdminGroup access to manage members
of any group in the OU with DistinguishedName in $GroupsOU and all sub-OUs. Add -NoInheritance do disable inheritance.

.EXAMPLE
Add-DSACLManageGroupMember -TargetDN $GroupsOU -DelegateDN $AccessAdminGroup -AccessType Allow -NoInheritance
Will give the group with DistinguishedName in $AccessAdminGroup access to manage members
of any group in the OU with DistinguishedName in $GroupsOU. Will not effect groups in sub-OUs.

.EXAMPLE
Add-DSACLManageGroupMember -TargetDN $SpecialGroup -DelegateDN $AccessAdminGroup -AccessType Allow -DirectOnGroup
Will give the group with DistinguishedName in $AccessAdminGroup access to manage members
of the group in with DistinguishedName in $SpecialGroup.

#>
function Add-DSACLManagerCanUpdateGroupMember {
    [CmdletBinding(DefaultParameterSetName='OnContainer')]
    param (
        # DistinguishedName of object to modify ACL on. Usually an OU.
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [String]
        $TargetDN
    )

    process {
        try {
            $Params = @{
                TargetDN              = $TargetDN
                DelegateDN            = $DelegateDN
                ActiveDirectoryRights = 'WriteProperty','ExtendedRight'
                AccessControlType     = $Script:GuidTable['self-membership']
                InheritanceType       = 'None'
            }
            Add-DSACLCustom @Params
        }
        catch {
            throw
        }
    }
}
