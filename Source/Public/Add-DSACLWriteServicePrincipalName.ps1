<#
.SYNOPSIS
Delegate rights to SET ServicePrincipalName (SPN) on objects of selected type in target (usually an OU)

.EXAMPLE
Add-DSACLWriteServicePrincipalName -TargetDN $UsersOU -DelegateDN $UserAdminGroup -ObjectTypeName User -AccessType Allow
Will give the group with DistinguishedName in $UserAdminGroup rights to SET SPN of user objects in
the OU with DistinguishedName in $UsersOU and all sub-OUs. Add -NoInheritance to disable inheritance.
#>
function Add-DSACLWriteServicePrincipalName {
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
        $NoInheritance,

        # Only effects validated writes
        [Parameter(ParameterSetName='ByTypeName')]
        [Parameter(ParameterSetName='ByGuid')]
        [Switch]
        $ValidatedOnly
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

            if($ValidatedOnly.IsPresent) {
                $ActiveDirectoryRights = 'Self'
            } else {
                $ActiveDirectoryRights = 'WriteProperty'
            }

            $AceParams = @{
                TargetDN              = $TargetDN
                DelegateDN            = $DelegateDN
                ActiveDirectoryRights = $ActiveDirectoryRights
                AccessControlType     = 'Allow'
                ObjectType            = $Script:GuidTable['servicePrincipalName']
                InheritanceType       = $InheritanceType
                InheritedObjectType   = $InheritanceObjectType
            }
            Add-DSACLCustom @AceParams

        } catch {
            throw
        }
    }
}
