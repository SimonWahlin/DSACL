<#
.SYNOPSIS
Delegate rights to write to the property set "Account Restrictions" on objects of selected type in target (usually an OU)

.DESCRIPTION
Delegate rights to write to the property set "Account Restrictions" on objects of selected type in target (usually an OU)

A property set is a set of attributes that can be used to minimize the amount of ACE's to create. The property set
"Account Restrictions". More information about this set can be found here: https://docs.microsoft.com/en-us/windows/desktop/adschema/r-user-account-restrictions

.EXAMPLE
Add-DSACLWriteAccountRestrictions -TargetDN $UsersOU -DelegateDN $UserAdminGroup -ObjectTypeName User -AccessType Allow
Will give the group with DistinguishedName in $UserAdminGroup rights to SET SPN of user objects in
the OU with DistinguishedName in $UsersOU and all sub-OUs. Add -NoInheritance to disable inheritance.
#>

function Add-DSACLWriteAccountRestrictions {
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
        [ValidateSet('User', 'Computer', 'ManagedServiceAccount','GroupManagedServiceAccount')]
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
                $InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]'Children'
            } else {
                $InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]'Descendents'
            }

            switch ($PSCmdlet.ParameterSetName) {
                'ByTypeName' { $InheritanceObjectType = $Script:GuidTable[$ObjectTypeName]}
                'ByGuid'     { $InheritanceObjectType = $ObjectTypeGuid }
            }

            $AceParams = @{
                TargetDN              = $TargetDN
                DelegateDN            = $DelegateDN
                ActiveDirectoryRights = 'WriteProperty'
                AccessControlType     = 'Allow'
                ObjectType            = $Script:GuidTable['Account Restrictions']
                InheritanceType       = $InheritanceType
                InheritedObjectType   = $InheritanceObjectType
            }
            Add-DSACLCustom @AceParams

        } catch {
            throw
        }
    }
}
