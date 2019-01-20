function Resolve-DSACLGuid {
    [CmdletBinding()]
    param (
        [guid]$Guid
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
        if($DSACLAttributeGuid.ContainsKey($Guid.ToString())) {
            $Result.Add('Attribute',$DSACLAttributeGuid[$Guid.ToString()])
        }
        if($DSACLClassGuid.ContainsKey($Guid.ToString())) {
            $Result.Add('Class',$DSACLClassGuid[$Guid.ToString()])
        }
        if($DSACLExtendedGuid.ContainsKey($Guid.ToString())) {
            $Result.Add('ExtendedRight',$DSACLExtendedGuid[$Guid.ToString()])
        }
        if($DSACLPropertySetGuid.ContainsKey($Guid.ToString())) {
            $Result.Add('PropertySet',$DSACLPropertySetGuid[$Guid.ToString()])
        }
        if($DSACLValidatedWriteName.ContainsKey($Guid.ToString())) {
            $Result.Add('ValidatedWrite',$DSACLValidatedWriteName[$Guid.ToString()])
        }
        [pscustomobject]$Result
    }

}