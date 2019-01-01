function Get-LDAPObject {
    [CmdletBinding()]
    param (
        # DistinguishedName of LDAP object to bind to
        [Parameter(Mandatory)]
        [string]
        $DistinguishedName,

        # Set domain controller to use
        [Parameter()]
        [string]
        $Server,

        # Set Credentials to use when connecting
        [Parameter()]
        [pscredential]
        $Credential
    )
    try {
        $ArgumentList = $(
            if($PSBoundParameters.ContainsKey('Server')) {
                "LDAP://$Server/$DistinguishedName"
            }
            else {
                "LDAP://$DistinguishedName"
            }
            if($PSBoundParameters.ContainsKey('Credential')) {
                $Credential.UserName
                $Credential.GetNetworkCredential().Password
            }
        )
        $DirectoryEntry = New-Object -TypeName System.DirectoryServices.DirectoryEntry -ArgumentList $ArgumentList
        $null = try {
            # Try to read the object to force an exception if no object was found.
            $DirectoryEntry | Format-List
        }
        catch {
            throw 'Object not found!'
        }
        return $DirectoryEntry
    }
    catch {
        throw
    }
}
