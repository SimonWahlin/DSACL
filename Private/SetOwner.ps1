function Set-Owner {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [System.DirectoryServices.DirectoryEntry]
        $Target,

        [Parameter(Mandatory)]
        [String]
        $OwnerDN
    )
    process {
        try {
            $Owner = Get-SID -DistinguishedName $OwnerDN
            $Target.psbase.ObjectSecurity.SetOwner($Owner)
            $Target.psbase.CommitChanges()
        }
        catch {
            throw
        }
    }
}