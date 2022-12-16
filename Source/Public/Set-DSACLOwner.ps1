<#
.SYNOPSIS
    Sets an Active Directory object as the Owner of an Access Control List (ACL).

.DESCRIPTION
    The **Set-DSACLOwner** cmdlet will set the given OwnerDN (Objects Distinguished Name) as Owner of the specified TargetDN (Target Distinguished Name).
    The TargetDN parameter specifies what object the modification will execute on.
    The OwnerDN parameter specifies what object in Active Directory that will take ownership of the target.

.EXAMPLE
    Set-DSACLOwner -TargetDN "OU=Accounting,DC=FABRIKAM,DC=COM" -OwnerDN "CN=Chew David,OU=Accounting,DC=FABRIKAM,DC=COM"
#>
function Set-DSACLOwner {
    [CmdletBinding(SupportsShouldProcess)]
    [Alias('chown')]
    [Alias('setowner')]
    param (
        # DistinguishedName of object to modify ACL on.
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [String]
        $TargetDN,

        # DistinguishedName of group or user to give permissions to.
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [String]
        $OwnerDN
    )

    process {
        try {
            $Target = Get-LDAPObject -DistinguishedName $TargetDN -ErrorAction Stop
            $Owner = Get-LDAPObject -DistinguishedName $OwnerDN -ErrorAction Stop
            if($PSCmdlet.ShouldProcess($TargetDN,'Setting owner')) {
                Set-Owner -Target $Target -Owner $Owner.DistinguishedName
            }
        }
        catch {
            throw
        }
    }
}
