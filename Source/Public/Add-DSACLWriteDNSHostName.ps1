<#
.SYNOPSIS
Delegate rights to SET DNSHostName on objects of selected type in target (usually an OU)

.EXAMPLE
Add-DSACLWriteDNSHostName -TargetDN $ComputersOU -DelegateDN $ComputerAdminGroup -ObjectTypeName Computer -AccessType Allow
Will give the group with DistinguishedName in $ComputerAdminGroup rights to SET DNSHostName of computer objects in
the OU with DistinguishedName in $ComputersOU and all sub-OUs. Add -NoInheritance to disable inheritance.
#>
function Add-DSACLWriteDNSHostName {
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
        [ValidateSet('Computer', 'ManagedServiceAccount','GroupManagedServiceAccount')]
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
                $ObjectType = $Script:GuidTable['Validated write to DNS host name']
                $ActiveDirectoryRights = [System.DirectoryServices.ActiveDirectoryRights]::Self
            } else {
                $ObjectType = $Script:GuidTable['DNS Host Name Attributes']
                $ActiveDirectoryRights = [System.DirectoryServices.ActiveDirectoryRights]::WriteProperty
            }

            $AceParams = @{
                TargetDN              = $TargetDN
                DelegateDN            = $DelegateDN
                ActiveDirectoryRights = $ActiveDirectoryRights
                AccessControlType     = 'Allow'
                ObjectType            = $ObjectType
                InheritanceType       = $InheritanceType
                InheritedObjectType   = $InheritanceObjectType
            }
            Add-DSACLCustom @AceParams

        } catch {
            throw
        }
    }
}
