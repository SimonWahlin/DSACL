function Set-DSACLOwner {
    [CmdletBinding(SupportsShouldProcess)]
    [Alias('chown')]
    [Alias('setowner')]
    param (
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [String]
        $TargetDN,

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
