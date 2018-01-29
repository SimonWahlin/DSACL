function Add-DSACLAccessRule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.DirectoryServices.DirectoryEntry]
        $Target,

        [Parameter(Mandatory)]
        [System.DirectoryServices.ActiveDirectoryAccessRule]
        $ACE
    )
    try {
        $Target.psbase.ObjectSecurity.AddAccessRule($ACE)
        $Target.psbase.CommitChanges()
    }
    catch {
        throw
    }
}