<#
.SYNOPSIS
Give Delegate rights to create objects of selected type in target (usually an OU)

.EXAMPLE
Add-DSACLCreateChild -TargetDN $UsersOU -DelegateDN $UserAdminGroup -ObjectTypeName User
Will give the group with DistinguishedName in $UserAdminGroup access to create user objects in
the OU with DistinguishedName in $UsersOU and all sub-OUs. Add -NoInheritance do disable inheritance.

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
        [ValidateSet('Computer', 'Contact', 'Group', 'ManagedServiceAccount', 'GroupManagedServiceAccount', 'User','All')]
        [String]
        $ObjectTypeName,

        # ObjectType guid, used for custom object types
        [Parameter(Mandatory,ParameterSetName='ByGuid')]
        [Guid]
        $ObjectTypeGuid,

        # Allow or Deny
        [Parameter(ParameterSetName='ByTypeName')]
        [Parameter(ParameterSetName='ByGuid')]
        [System.Security.AccessControl.AccessControlType]
        $AccessType = 'Allow',

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
                'ByTypeName' { $ObjectType = $Script:GuidTable[$ObjectTypeName]}
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
