function ConvertFrom-DSACLObjectTypeGuid {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('ACE')]
        [Alias('Access')]
        [System.DirectoryServices.ActiveDirectoryAccessRule]
        $AccessRule
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
        if ($AccessRule.ObjectFlags.HasFlag([System.Security.AccessControl.ObjectAceFlags]::ObjectAceTypePresent)) {

            # Check for Extended Access Rights
            if ( $AccessRule.ActiveDirectoryRights.HasFlag([System.DirectoryServices.ActiveDirectoryRights]::ExtendedRight) ) {
                if($DSACLExtendedGuid.ContainsKey($AccessRule.ObjectType.ToString())) {
                    return $DSACLExtendedGuid[$AccessRule.ObjectType.ToString()]
                }
            }

            # Validated (Self) and not WriteProperty, check in extended map
            if (
                -not $AccessRule.ActiveDirectoryRights.HasFlag([System.DirectoryServices.ActiveDirectoryRights]::WriteProperty) -and
                $AccessRule.ActiveDirectoryRights.HasFlag([System.DirectoryServices.ActiveDirectoryRights]::Self)
            ) {
                if ($DSACLValidatedWriteGuid.ContainsKey($AccessRule.ObjectType.ToString())) {
                    return $DSACLValidatedWriteGuid[$AccessRule.ObjectType.ToString()]
                }
            }

            # Search for Classes if AccessRight is CreateChild or DeleteChild
            if(
                $AccessRule.ActiveDirectoryRights.HasFlag([System.DirectoryServices.ActiveDirectoryRights]::CreateChild) -or
                $AccessRule.ActiveDirectoryRights.HasFlag([System.DirectoryServices.ActiveDirectoryRights]::DeleteChild)
            ) {
                if ($DSACLClassGuid.ContainsKey($AccessRule.ObjectType.ToString())) {
                    return $DSACLClassGuid[$AccessRule.ObjectType.ToString()]
                }
            }

            if(
                $AccessRule.ActiveDirectoryRights.HasFlag([System.DirectoryServices.ActiveDirectoryRights]::ReadProperty) -or
                $AccessRule.ActiveDirectoryRights.HasFlag([System.DirectoryServices.ActiveDirectoryRights]::WriteProperty)
            ) {
                # Search for Attribute-Sets
                if ($DSACLPropertySetGuid.ContainsKey($AccessRule.ObjectType.ToString())) {
                    return $DSACLPropertySetGuid[$AccessRule.ObjectType.ToString()]
                }

                # Search for Attributes
                if ($DSACLAttributeGuid.ContainsKey($AccessRule.ObjectType.ToString())) {
                    return $DSACLAttributeGuid[$AccessRule.ObjectType.ToString()]
                }
            }

            # TODO: Add more scenarios

            # Fallback to return guid
            return $AccessRule.ObjectType.ToString()
        }
        else {
            return 'All'
        }
    }
}