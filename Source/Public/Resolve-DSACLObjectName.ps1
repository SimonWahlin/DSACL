function Resolve-DSACLObjectName {
    [CmdletBinding()]
    param (
        [string]$Name
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
        $Result = [ordered]@{}
        if($DSACLAttributeName.ContainsKey($Name)) {
            $Result.Add('Attribute',$DSACLAttributeName[$Name])
        }
        if($DSACLClassName.ContainsKey($Name)) {
            $Result.Add('Class',$DSACLClassName[$Name])
        }
        if($DSACLExtendedName.ContainsKey($Name)) {
            $Result.Add('ExtendedRight',$DSACLExtendedName[$Name])
        }
        if($DSACLPropertySetName.ContainsKey($Name)) {
            $Result.Add('PropertySet',$DSACLPropertySetName[$Name])
        }
        if($DSACLValidatedWriteName.ContainsKey($Name)) {
            $Result.Add('ValidatedWrite',$DSACLValidatedWriteName[$Name])
        }
        [pscustomobject]$Result
    }

}