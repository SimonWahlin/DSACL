<#
.Synopsis
   Create Access Control Entry for Active Directory ACL
.DESCRIPTION
   Create Access Control Entry for Active Directory ACL
.EXAMPLE
   New-ADAccessRule -Identity $SID -ActiveDirectoryRights 'CreateChild', 'DeleteChild' -AccessControlType Allow -ObjectType $TypeGuid -InheritanceType None
   Create access rule that gives the object with SID $SID access to create and delete objects of type $TypeGuid on "this object only"
#>
function New-DSACLAccessRule {
    [CmdletBinding()]
    param (
        # SID of principal that will rule will apply to
        [Parameter(Mandatory = $true, ParameterSetName = '1', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = '2', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = '3', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = '4', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = '5', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = '6', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [System.Security.Principal.SecurityIdentifier]
        $Identity,

        # List of access rights that should be applied
        [Parameter(Mandatory = $true, ParameterSetName = '1', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = '2', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = '3', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = '4', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = '5', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = '6', ValueFromPipelineByPropertyName = $true)]
        [System.DirectoryServices.ActiveDirectoryRights[]]
        $ActiveDirectoryRights,

        # Sets allow or deny
        [Parameter(Mandatory = $true, ParameterSetName = '1', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = '2', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = '3', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = '4', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = '5', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = '6', ValueFromPipelineByPropertyName = $true)]
        [System.Security.AccessControl.AccessControlType]
        $AccessControlType,

        # Sets guid where access right should apply
        [Parameter(Mandatory = $true, ParameterSetName = '4', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = '5', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = '6', ValueFromPipelineByPropertyName = $true)]
        [Guid]
        $ObjectType,

        # Sets if and how this rule should be inherited
        [Parameter(Mandatory = $true, ParameterSetName = '2', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = '3', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = '5', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = '6', ValueFromPipelineByPropertyName = $true)]
        [System.DirectoryServices.ActiveDirectorySecurityInheritance]
        $InheritanceType,

        # Sets guid of object types that should inherit this rule
        [Parameter(Mandatory = $true, ParameterSetName = '3', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = '6', ValueFromPipelineByPropertyName = $true)]
        [Guid]
        $InheritedObjectType
    )
    process {
        switch ($PSCmdlet.ParameterSetName) {
            '1' {$ArgumentList = $Identity, $ActiveDirectoryRights, $AccessControlType}
            '2' {$ArgumentList = $Identity, $ActiveDirectoryRights, $AccessControlType, $InheritanceType}
            '3' {$ArgumentList = $Identity, $ActiveDirectoryRights, $AccessControlType, $InheritanceType, $InheritedObjectType}
            '4' {$ArgumentList = $Identity, $ActiveDirectoryRights, $AccessControlType, $ObjectType}
            '5' {$ArgumentList = $Identity, $ActiveDirectoryRights, $AccessControlType, $ObjectType, $InheritanceType}
            '6' {$ArgumentList = $Identity, $ActiveDirectoryRights, $AccessControlType, $ObjectType, $InheritanceType, $InheritedObjectType}
        }
        New-Object -TypeName System.DirectoryServices.ActiveDirectoryAccessRule -ArgumentList $ArgumentList
    }
}