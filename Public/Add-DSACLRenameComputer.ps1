<#
.SYNOPSIS
Give Delegate rights to rename objects in target (usually an OU)

.EXAMPLE
Add-DSACLRenameObject -ObjectTypeName Computer -TargetDN $ComputersOU -DelegateDN $ComputerAdminGroup -AccessType Allow
Will give the group with DistinguishedName in $ComputerAdminGroup rights to rename computers in
the OU with DistinguishedName in $ComputersOU and all sub-OUs. Add -NoInheritance do disable inheritance.
#>
function Add-DSACLRenameObject {
    [CmdletBinding(DefaultParameterSetName='Delegate')]
    param (
        # Object type to allow being renamed
        [Parameter(Mandatory,ParameterSetName='Delegate')]
        [Parameter(Mandatory,ParameterSetName='Self')]
        [ValidateSet('Computer', 'Contact', 'Group', 'ManagedServiceAccount', 'GroupManagedServiceAccount', 'User','All')]
        [String]
        $ObjectTypeName,

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
                    $DelegateSID = Get-SID -DistinguishedName $DelegateDN
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
                AccessControlType = 'Allow'
                InheritedObjectType   = $Script:GuidTable[$ObjectTypeName]
                InheritanceType       = $InheritanceType
            }

            'distinguishedName', 'name', 'CN' | ForEach-Object -Process {
                New-DSACLAccessRule -ObjectType $Script:GuidTable[$_] @AceParams
            } | Set-DSACLAccessRule -Target $Target

        }
        catch {
            throw
        }
    }
}
