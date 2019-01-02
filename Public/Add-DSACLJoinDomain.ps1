<#
    .SYNOPSIS
    Give $DelegateDN rights to join computers in target (usually an OU).

    .EXAMPLE
    Add-DSACLJoinDomain -TargetDN $ComputersOU -DelegateDN $JoinDomainAccounts -AccessType Allow
    Will give the group with DistinguishedName in $JoinDomainAccounts rights to join computers to
    the domain. Requires a computer account to be created already.

    Use switch -AllowCreate to allow to create computer objects in OU and thereby join without a
    pre-existing computer object. -AllowDelete will give rights to move account away from this
    location (requires allow create on destination). Add -NoInheritance do disable inheritance.
#>
function Add-DSACLJoinDomain {
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

        # Sets access right to "This object only"
        [Parameter()]
        [Switch]
        $AllowCreate,

        # Sets access right to "This object only"
        [Parameter()]
        [Switch]
        $AllowDelete,

        # Sets access right to "This object only"
        [Parameter()]
        [Switch]
        $NoInheritance
    )

    process {
        try {

            $Target = Get-LDAPObject -DistinguishedName $TargetDN
            $DelegateSID = Get-SID -DistinguishedName $DelegateDN

            $InheritanceParam = @{}
            if ($NoInheritance.IsPresent) {
                $InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]'Children'
                $InheritanceParam['NoInheritance'] = $true
            }
            else {
                $InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]'Descendents'
            }

            Add-DSACLResetPassword -TargetDN $TargetDN -DelegateDN $DelegateDN -ObjectTypeName Computer -AccessType Allow @InheritanceParam

            $AceParams = @{
                Identity              = $DelegateSID
                ActiveDirectoryRights = 'ExtendedRight'
                AccessControlType     = 'Allow'
                InheritanceType       = $InheritanceType
                InheritedObjectType   = $Script:GuidTable['Computer']
            }

            'Account Restrictions', 'Validated write to DNS host name', 'Validated write to service principal name' | ForEach-Object -Process {
                New-DSACLAccessRule -ObjectType $Script:GuidTable[$_] @AceParams
            } | Set-DSACLAccessRule -Target $Target

            if($AllowCreate.IsPresent) {
                Add-DSACLCreateChild -TargetDN $TargetDN -DelegateDN $DelegateDN -ObjectTypeName Computer -NoInheritance:$NoInheritance
            }

            if($AllowDelete.IsPresent) {
                Add-DSACLDeleteChild -TargetDN $TargetDN -DelegateDN $DelegateDN -ObjectTypeName Computer -NoInheritance:$NoInheritance.IsPresent
            }

        }
        catch {
            throw
        }
    }
}
