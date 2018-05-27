<#
.SYNOPSIS
Set owner on any object in Active Directory

#>
function Set-DSACLOwner {
    [CmdletBinding(SupportsShouldProcess)]
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
