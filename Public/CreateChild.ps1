<#
.SYNOPSIS
Give Delegate rights to create objects of selected type in target (usually an OU)

.EXAMPLE
Add-DSACLFullControl -TargetDN $UsersOU -DelegateDN $UserAdminGroup -ObjectTypeName User -AccessType Allow
Will give the group with DistinguishedName in UserAdminGroup access to create user objects in
the OU with DistinguishedName in $UsersOU and all sub-OUs.

#>
function Add-DSACLCreateChild {
    [CmdletBinding(DefaultParameterSetName='ByTypeName')]
    param (
        # DistinguishedName of object to modify ACL on. Usually an OU.
        [Parameter(Mandatory,ParameterSetName='ByTypeName',ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory,ParameterSetName='ByGuid',ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [String]
        $TargetDN,

        # DistinguishedName of group or user to give permissions to.
        [Parameter(Mandatory,ParameterSetName='ByTypeName',ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory,ParameterSetName='ByGuid',ValueFromPipelineByPropertyName)]
        [String]
        $DelegateDN,

        # Object type to give full control over
        [Parameter(Mandatory,ParameterSetName='ByTypeName')]
        [ValidateSet('Computer', 'Contact', 'Group', 'ManagedServiceAccount', 'User')]
        [String]
        $ObjectTypeName,

        # ObjectType guid, used for custom object types
        [Parameter(Mandatory,ParameterSetName='ByGuid')]
        [Guid]
        $ObjectTypeGuid,

        # Allow or Deny
        [Parameter(Mandatory,ParameterSetName='ByTypeName')]
        [Parameter(Mandatory,ParameterSetName='ByGuid')]
        [System.Security.AccessControl.AccessControlType]
        $AccessType,

        # Sets access right to "This object only"
        [Parameter(ParameterSetName='ByTypeName')]
        [Parameter(ParameterSetName='ByGuid')]
        [Switch]
        $NoInheritance
    )

    process {
        try {
            if ($NoInheritance.IsPresent) {
                $InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]'None'
            }
            else {
                $InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]'All'
            }
            switch ($PSCmdlet.ParameterSetName) {
                'ByTypeName' { $ObjectType = $Script:TypeTable[$ObjectTypeName]}
                'ByGuid'     { $ObjectType = $ObjectTypeGuid }
            }

            $Params = @{
                TargetDN              = $TargetDN
                DelegateDN            = $DelegateDN
                ActiveDirectoryRights = 'CreateChild'
                AccessControlType     = $AccessType
                ObjectType            = $ObjectType
                InheritanceType       = $InheritanceType
            }
            Add-DSACLCustom @Params

        }
        catch {
            throw
        }
    }
}
