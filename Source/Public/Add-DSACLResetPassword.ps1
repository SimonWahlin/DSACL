<#
.SYNOPSIS
Delegate ResetPassword rights on objects of selected type in target (usually an OU)

.EXAMPLE
Add-DSACLResetPassword -TargetDN $UsersOU -DelegateDN $UserAdminGroup -ObjectTypeName User -AccessType Allow
Will give the group with DistinguishedName in $UserAdminGroup ResetPassword rights of user objects in
the OU with DistinguishedName in $UsersOU and all sub-OUs. Add -NoInheritance to disable inheritance.
#>
function Add-DSACLResetPassword {
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
        [ValidateSet('User', 'Computer', 'ManagedServiceAccount', 'GroupManagedServiceAccount')]
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
                $InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]'Children'
            }
            else {
                $InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]'Descendents'
            }
            switch ($PSCmdlet.ParameterSetName) {
                'ByTypeName' { $ObjectType = $Script:GuidTable[$ObjectTypeName]}
                'ByGuid'     { $ObjectType = $ObjectTypeGuid }
            }

            $Params = @{
                TargetDN              = $TargetDN
                DelegateDN            = $DelegateDN
                ActiveDirectoryRights = 'ExtendedRight'
                AccessControlType     = $AccessType
                ObjectType            = $Script:GuidTable['ResetPassword']
                InheritanceType       = $InheritanceType
                InheritedObjectType   = $ObjectType
            }
            Add-DSACLCustom @Params

        }
        catch {
            throw
        }
    }
}
