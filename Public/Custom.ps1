<#
.SYNOPSIS
Give Delegate custom rights in target (usually an OU)

.DESCRIPTION
Used to delegate any custom rights in Active Directory.
Requires knowledge of creating ActiveDirectoryAccessRules, please use with caution.

#>
function Add-DSACLCustom {
    [CmdletBinding(DefaultParameterSetName='Delegate')]
    param (
        # DistinguishedName of object to modify ACL on. Usually an OU.
        [Parameter(Mandatory,ParameterSetName='Delegate')]
        [Parameter(Mandatory,ParameterSetName='Self')]
        [String]
        $TargetDN,

        # Give access to "Self" instead of a user or group
        [Parameter(Mandatory,ParameterSetName='Self')]
        [Switch]
        $Self,

        # DistinguishedName of group or user to give permissions to.
        [Parameter(Mandatory,ParameterSetName='Delegate')]
        [String]
        $DelegateDN,

        # List of access rights that should be applied
        [Parameter(Mandatory,ParameterSetName='Delegate')]
        [Parameter(Mandatory,ParameterSetName='Self')]
        [System.DirectoryServices.ActiveDirectoryRights[]]
        $ActiveDirectoryRights,

        # Sets allow or deny
        [Parameter(Mandatory,ParameterSetName='Delegate')]
        [Parameter(Mandatory,ParameterSetName='Self')]
        [System.Security.AccessControl.AccessControlType]
        $AccessControlType,

        # Sets guid where access right should apply
        [Parameter(ParameterSetName='Delegate')]
        [Parameter(ParameterSetName='Self')]
        [Guid]
        $ObjectType,

        # Sets if and how this rule should be inherited
        [Parameter(ParameterSetName='Delegate')]
        [Parameter(ParameterSetName='Self')]
        [System.DirectoryServices.ActiveDirectorySecurityInheritance]
        $InheritanceType,

        # Sets guid of object types that should inherit this rule
        [Parameter(ParameterSetName='Delegate')]
        [Parameter(ParameterSetName='Self')]
        [Guid]
        $InheritedObjectType

    )

    process {
        try {
            $Target = Get-LDAPObject -DistinguishedName $TargetDN -ErrorAction Stop
            switch ($PSCmdlet.ParameterSetName) {
                'Delegate' {
                    $DelegateSID = Get-SID -DistinguishedName $DelegateDN
                }
                'Self' { $DelegateSID = New-Object -TypeName System.Security.Principal.SecurityIdentifier -ArgumentList 'S-1-5-10' }
            }

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
