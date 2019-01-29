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
        [ValidateSet('Computer', 'Contact', 'Group', 'ManagedServiceAccount', 'GroupManagedServiceAccount', 'User','All')]
        [String]
        $ObjectTypeName,

        # DistinguishedName of object to modify ACL on. Usually an OU.
        [Parameter(Mandatory,ParameterSetName='Delegate')]
        [String]
        $TargetDN,

        # DistinguishedName of group or user to give permissions to.
        [Parameter(Mandatory,ParameterSetName='Delegate')]
        [String]
        $DelegateDN,

        # Sets access right to "This object only"
        [Parameter(ParameterSetName='Delegate')]
        [Switch]
        $NoInheritance
    )

    process {
        try {

            $null = $PSBoundParameters.Remove('ObjectTypeName')
            $null = $PSBoundParameters.Remove('NoInheritance')

            if ($NoInheritance.IsPresent) {
                $InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]::Children
            }
            else {
                $InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]::Descendents
            }

            $AceParams = @{
                ActiveDirectoryRights = 'WriteProperty'
                AccessControlType     = 'Allow'
                InheritanceType       = $InheritanceType
                InheritedObjectType   = $Script:GuidTable[$ObjectTypeName]
            }

            'distinguishedName', 'name', 'CN' | ForEach-Object -Process {
                Add-DSACLCustom -ObjectType $Script:GuidTable[$_] @AceParams @PSBoundParameters
            }

            if($ObjectTypeName -eq 'Computer') {

                'Account Restrictions' ,'sAMAccountName' | ForEach-Object -Process {
                    Add-DSACLCustom -ObjectType $Script:GuidTable[$_] @AceParams @PSBoundParameters
                }

                $WriteParams = @{
                    TargetDN       = $TargetDN
                    DelegateDN     = $DelegateDN
                    ObjectTypeName = 'Computer'
                    AccessType     = 'Allow'
                    NoInheritance  = $NoInheritance.IsPresent
                }
                Add-DSACLWriteDNSHostName @WriteParams
                Add-DSACLWriteServicePrincipalName @WriteParams

            }

        }
        catch {
            throw
        }
    }
}
