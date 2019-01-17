<#
.SYNOPSIS
Give Delegate rights to groups manager to manage members in group(s).
Note that this access stays with the user if the manager changes.

.EXAMPLE
Add-DSACLManagerCanUpdateGroupMember -TargetDN $Group
Will give the current manager of the group in $Group access to manage members.
Note that this access stays with the user if the manager changes.

#>
function Add-DSACLManagerCanUpdateGroupMember {
    [CmdletBinding(DefaultParameterSetName='OnContainer')]
    param (
        # DistinguishedName of object to modify ACL on. Has to be a group.
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [String]
        $TargetDN
    )

    process {
        try {
            $Group = Get-LDAPObject -DistinguishedName $TargetDN
            if($Group.objectClass -notcontains 'group') {
                throw 'Target has to be a group.'
            }
            $DelegateDN = $Group.managedBy

            Add-DSACLManageGroupMember -TargetDN $TargetDN -DelegateDN $DelegateDN -DirectOnGroup
        }
        catch {
            throw
        }
    }
}
