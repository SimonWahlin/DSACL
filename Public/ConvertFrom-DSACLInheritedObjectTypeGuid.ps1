function ConvertFrom-DSACLInheritedObjectTypeGuid {
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
                $InheritedObjectType = $AccessRule.InheritedObjectType
            }

            'Audit' {
                $ObjectFlags = $AuditRule.ObjectFlags
                $InheritedObjectType = $AuditRule.InheritedObjectType
            }
        }
        if ($ObjectFlags.HasFlag([System.Security.AccessControl.ObjectAceFlags]::InheritedObjectAceTypePresent)) {

            if ($Script:DSACLClassGuid.ContainsKey($InheritedObjectType.ToString())) {
                return $Script:DSACLClassGuid[$InheritedObjectType.ToString()]
            }

            if ($Script:DSACLAttributeGuid.ContainsKey($InheritedObjectType.ToString())) {
                return $Script:DSACLAttributeGuid[$InheritedObjectType.ToString()]
            }

            return $InheritedObjectType.ToString()
        }
        else {
            return 'All'
        }

    }
}