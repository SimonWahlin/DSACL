function Get-SID {
    [CmdletBinding()]
    param (
        # DistinguishedName of LDAP object to get SID from
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

    process {
        $Object = Get-LDAPObject @PSBoundParameters
        New-Object -TypeName System.Security.Principal.SecurityIdentifier -ArgumentList $Object.ObjectSID.Value, 0
    }

}
