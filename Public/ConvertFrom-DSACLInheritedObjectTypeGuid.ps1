function ConvertFrom-DSACLInheritedObjectTypeGuid {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
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
        if($AccessRule.ObjectFlags.HasFlag([System.Security.AccessControl.ObjectAceFlags]::InheritedObjectAceTypePresent)) {

            if ($DSACLClassGuid.ContainsKey($AccessRule.InheritedObjectType.ToString())) {
                return $DSACLClassGuid[$AccessRule.InheritedObjectType.ToString()]
            }

            if ($DSACLAttributeGuid.ContainsKey($AccessRule.InheritedObjectType.ToString())) {
                return $DSACLAttributeGuid[$AccessRule.InheritedObjectType.ToString()]
            }

            return $AccessRule.InheritedObjectType.ToString()
        }
        else {
            return 'All'
        }
    }
}