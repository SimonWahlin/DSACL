<#
.SYNOPSIS
Delegate rights to link GPO on target (usually an OU)

.EXAMPLE
Add-DSACLLinkGPO -TargetDN $UsersOU -DelegateDN $GPAdmin -AccessType Allow
Will give the group with DistinguishedName in $GPAdmin rights to link GPOs on
the OU with DistinguishedName in $UsersOU and all sub-OUs. Add -NoInheritance to disable inheritance.
#>
function Add-DSACLLinkGPO {
    [CmdletBinding()]
    param (
        # DistinguishedName of object to modify ACL on. Usually an OU.
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [String]
        $TargetDN,

        # DistinguishedName of group or user to give permissions to.
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [String]
        $DelegateDN,

        # Allow or Deny
        [Parameter()]
        [System.Security.AccessControl.AccessControlType]
        $AccessType = 'Allow',

        # Sets access right to "This object only"
        [Parameter()]
        [Switch]
        $NoInheritance
    )

    process {
        try {
            $Params = @{
                TargetDN              = $TargetDN
                DelegateDN            = $DelegateDN
                ActiveDirectoryRights = 'WriteProperty'
                AccessControlType     = $AccessType
                ObjectType            = $Script:GuidTable['gPLink']
            }

            if ($NoInheritance.IsPresent) {
                $Params['InheritanceType'] = [System.DirectoryServices.ActiveDirectorySecurityInheritance]::None
            }
            else {
                $Params['InheritanceType'] = [System.DirectoryServices.ActiveDirectorySecurityInheritance]::All
                $Params['InheritedObjectType'] = $Script:GuidTable['OrganizationalUnit']
            }

            Add-DSACLCustom @Params

        }
        catch {
            throw
        }
    }
}
