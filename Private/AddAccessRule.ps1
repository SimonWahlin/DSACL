function Add-DSACLAccessRule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.DirectoryServices.DirectoryEntry]
        $Target,

        [Parameter(Mandatory,ValueFromPipeline)]
        [System.DirectoryServices.ActiveDirectoryAccessRule]
        $ACE
    )
    process {
        try {
            $Target.psbase.ObjectSecurity.AddAccessRule($ACE)
        }
        catch {
            throw
        }
    }
    end {
        try {
            $Target.psbase.CommitChanges()
        }
        catch {
            throw
        }
    }
}