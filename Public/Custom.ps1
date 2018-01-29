<#
.SYNOPSIS
Give Delegate custom rights in target (usually an OU)

.DESCRIPTION
Used to delegate any custom rights in Active Directory.
Requires knowledge of creating ActiveDirectoryAccessRules, please use with caution.

#>
function Add-DSACLCustom {
    [CmdletBinding()]
    param (
        # DistinguishedName of object to modify ACL on. Usually an OU.
        [Parameter(Mandatory)]
        [String]
        $TargetDN,

        # DistinguishedName of group or user to give permissions to.
        [Parameter(Mandatory)]
        [String]
        $DelegateDN,

        # List of access rights that should be applied
        [Parameter(Mandatory)]
        [System.DirectoryServices.ActiveDirectoryRights[]]
        $ActiveDirectoryRights,

        # Sets allow or deny
        [Parameter(Mandatory)]
        [System.Security.AccessControl.AccessControlType]
        $AccessControlType,

        # Sets guid where access right should apply
        [Parameter()]
        [Guid]
        $ObjectType,

        # Sets if and how this rule should be inherited
        [Parameter()]
        [System.DirectoryServices.ActiveDirectorySecurityInheritance]
        $InheritanceType,

        # Sets guid of object types that should inherit this rule
        [Parameter()]
        [Guid]
        $InheritedObjectType

    )

    process {
        try {
            $Target = Get-LDAPObject -DistinguishedName $TargetDN
            $Delegate = Get-LDAPObject -DistinguishedName $DelegateDN
            $DelegateSID = New-Object -TypeName System.Security.Principal.SecurityIdentifier -ArgumentList $Delegate.ObjectSID.Value, 0

            $null = $PSBoundParameters.Remove('TargetDN')
            $null = $PSBoundParameters.Remove('DelegateDN')
            $PSBoundParameters.Add('Identity',$DelegateSID)

            $ACE = New-DSACLAccessRule @PSBoundParameters

            Add-DSACLAccessRule -Target $Target -ACE $ACE
        }
        catch {
            throw
        }
    }
}
