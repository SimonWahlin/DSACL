<#
.SYNOPSIS
Give Delegate rights to rename computers in target (usually an OU)

.EXAMPLE
Add-DSACLRenameComputer -TargetDN $ComputersOU -DelegateDN $ComputerAdminGroup -AccessType Allow
Will give the group with DistinguishedName in $ComputerAdminGroup rights to rename computers in
the OU with DistinguishedName in $ComputersOU and all sub-OUs. Add -NoInheritance do disable inheritance.
#>
function Add-DSACLRenameComputer {
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

        # Allow or Deny
        [Parameter(Mandatory,ParameterSetName='Delegate')]
        [Parameter(Mandatory,ParameterSetName='Self')]
        [System.Security.AccessControl.AccessControlType]
        $AccessType,

        # Sets access right to "This object only"
        [Parameter(ParameterSetName='Delegate')]
        [Parameter(ParameterSetName='Self')]
        [Switch]
        $NoInheritance
    )

    process {
        try {

            $Target = Get-LDAPObject -DistinguishedName $TargetDN
            switch ($PSCmdlet.ParameterSetName) {
                'Delegate' {
                    $Delegate = Get-LDAPObject -DistinguishedName $DelegateDN
                    $DelegateSID = New-Object -TypeName System.Security.Principal.SecurityIdentifier -ArgumentList $Delegate.ObjectSID.Value, 0
                }
                'Self' { $DelegateSID = New-Object -TypeName System.Security.Principal.SecurityIdentifier -ArgumentList 'S-1-5-10' }
            }

            if ($NoInheritance.IsPresent) {
                $InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]'Children'
            }
            else {
                $InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]'Descendents'
            }

            $AceParams = @{
                Identity = $DelegateSID
                ActiveDirectoryRights = 'WriteProperty'
                AccessControlType = $AccessType
                InheritedObjectType   = $Script:GuidTable['Computer']
                InheritanceType       = $InheritanceType
            }

            'distinguishedName', 'name', 'CN' | ForEach-Object -Process {
                New-DSACLAccessRule -ObjectType $Script:GuidTable[$_] @AceParams
            } | Add-DSACLAccessRule -Tartget $Target

        }
        catch {
            throw
        }
    }
}
