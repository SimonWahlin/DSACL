function ConvertFrom-DSACLObjectTypeGuid {
    [CmdletBinding(DefaultParameterSetName='Access')]
    param (
        [Parameter(Mandatory, ParameterSetName='Access', ValueFromPipeline)]
        [Alias('ACE')]
        [Alias('Access')]
        [System.DirectoryServices.ActiveDirectoryAccessRule]
        $AccessRule,

        [Parameter(Mandatory, ParameterSetName='Audit', ValueFromPipeline)]
        [Alias('Audit')]
        [System.DirectoryServices.ActiveDirectoryAuditRule]
        $AuditRule
    )

    begin {
        try {
            $null = Get-Variable -Name DSACLAttributeGuid -Scope Script -ErrorAction Stop
        }
        catch {
            $null = Register-DSACLRightsMapVariable -Scope Script
        }
    }

    process {
        switch($PSCmdlet.ParameterSetName) {
            'Access' {
                $ObjectFlags = $AccessRule.ObjectFlags
                $ActiveDirectoryRights = $AccessRule.ActiveDirectoryRights
                $ObjectType = $AccessRule.ObjectType
            }

            'Audit' {
                $ObjectFlags = $AuditRule.ObjectFlags
                $ActiveDirectoryRights = $AuditRule.ActiveDirectoryRights
                $ObjectType = $AuditRule.ObjectType
            }
        }
        if ($ObjectFlags.HasFlag([System.Security.AccessControl.ObjectAceFlags]::ObjectAceTypePresent)) {

            # Check for Extended Access Rights
            if ( $ActiveDirectoryRights.HasFlag([System.DirectoryServices.ActiveDirectoryRights]::ExtendedRight) ) {
                if($Script:DSACLExtendedGuid.ContainsKey($ObjectType.ToString())) {
                    return $Script:DSACLExtendedGuid[$ObjectType.ToString()]
                }
            }

            # Validated (Self) and not WriteProperty, check in extended map
            if (
                -not $ActiveDirectoryRights.HasFlag([System.DirectoryServices.ActiveDirectoryRights]::WriteProperty) -and
                $ActiveDirectoryRights.HasFlag([System.DirectoryServices.ActiveDirectoryRights]::Self)
            ) {
                if ($Script:DSACLValidatedWriteGuid.ContainsKey($ObjectType.ToString())) {
                    return $Script:DSACLValidatedWriteGuid[$ObjectType.ToString()]
                }
            }

            # Search for Classes if AccessRight is CreateChild or DeleteChild
            if(
                $ActiveDirectoryRights.HasFlag([System.DirectoryServices.ActiveDirectoryRights]::CreateChild) -or
                $ActiveDirectoryRights.HasFlag([System.DirectoryServices.ActiveDirectoryRights]::DeleteChild)
            ) {
                if ($Script:DSACLClassGuid.ContainsKey($ObjectType.ToString())) {
                    return $Script:DSACLClassGuid[$ObjectType.ToString()]
                }
            }

            if(
                $ActiveDirectoryRights.HasFlag([System.DirectoryServices.ActiveDirectoryRights]::ReadProperty) -or
                $ActiveDirectoryRights.HasFlag([System.DirectoryServices.ActiveDirectoryRights]::WriteProperty)
            ) {
                # Search for Attribute-Sets
                if ($Script:DSACLPropertySetGuid.ContainsKey($ObjectType.ToString())) {
                    return $Script:DSACLPropertySetGuid[$ObjectType.ToString()]
                }

                # Search for Attributes
                if ($Script:DSACLAttributeGuid.ContainsKey($ObjectType.ToString())) {
                    return $Script:DSACLAttributeGuid[$ObjectType.ToString()]
                }
            }

            # TODO: Add more scenarios

            # Fallback to return guid
            return $ObjectType.ToString()
        }
        else {
            return 'All'
        }
    }
}