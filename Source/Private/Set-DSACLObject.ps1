function Set-DSACLObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.DirectoryServices.DirectoryEntry]
        $DirectoryEntry
    )
    try {
        $DirectoryEntry.psbase.CommitChanges()
    } catch {
        throw
    }
}
