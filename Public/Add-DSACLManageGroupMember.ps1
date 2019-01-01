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
function Add-DSACLManageGroupMember {
    [CmdletBinding(DefaultParameterSetName='OnContainer')]
    param (
        # DistinguishedName of object to modify ACL on. Usually an OU.
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [String]
        $TargetDN,

        # DistinguishedName of group or user to give permissions to.
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [String]
        $DelegateDN,

        # Allow or Deny
        [Parameter()]
        [System.Security.AccessControl.AccessControlType]
        $AccessType = 'Allow',

        # Sets access right to "Children". Use this to effect all groups in OU but not subOUs
        [Parameter(ParameterSetName='OnContainer')]
        [Switch]
        $NoInheritance,

        # Sets access right to "This object only", use this when TargetDN is a group.
        [Parameter(ParameterSetName='OnGroup')]
        [Switch]
        $DirectOnGroup
    )

    process {
        try {
            if ($NoInheritance.IsPresent) {
                $InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]'Children'
            } elseif ($DirectOnGroup.IsPresent) {
                $InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]'None'
            } else {
                $InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]'Descendents'
            }

            $Params = @{
                TargetDN              = $TargetDN
                DelegateDN            = $DelegateDN
                ActiveDirectoryRights = 'WriteProperty'
                AccessControlType     = $AccessType
                ObjectType            = $Script:GuidTable['member']
                InheritanceType       = $InheritanceType
                InheritedObjectType   = $Script:GuidTable['group']
            }
            Add-DSACLCustom @Params

        }
        catch {
            throw
        }
    }
}
