function Register-DSACLRightsMapVariable {
    [CmdletBinding()]
    param(
        [Parameter(DontShow)]
        [String]
        $Scope = 'Global'
    )
    $rootDSE = New-Object -TypeName System.DirectoryServices.DirectoryEntry -ArgumentList 'LDAP://RootDSE'
    $GuidMap = @{}
    $RightsMap = @{}
    $extendedGuidMap = @{}
    $extendedRightsMap = @{}

    $Params = @{
        SearchBase  = $rootDSE.SchemaNamingContext.Value
        LDAPFilter  = '(schemaIDGUID=*)'
        Property  = @('lDAPDisplayName', 'schemaIDGUID')
    }
    Find-LDAPObject @Params | ForEach-Object {
        $RightsMap[$_.lDAPDisplayName]=[System.GUID]$_.schemaIDGUID
        $GuidMap[[string][guid]$_.schemaIDGUID]=$_.lDAPDisplayName
    }

    $Params = @{
        SearchBase  = $rootDSE.ConfigurationNamingContext
        LDAPFilter  = '(&(objectclass=controlAccessRight)(rightsGUID=*))'
        Property  = @('displayName','rightsGUID')
    }
    Find-LDAPObject @Params | ForEach-Object {
        $extendedRightsMap[$_.displayName]=[System.GUID]$_.rightsGUID
        $extendedGuidMap[$_.rightsGUID]=$_.displayName
    }
    $(
        New-Variable -Scope $Scope -Name DSACLRightsMap -Value $RightsMap -Description 'Maps basic AD permissions to GUIDs' -Option ReadOnly -Force -PassThru
        New-Variable -Scope $Scope -Name DSACLExtendedRightsMap -Value $extendedRightsMap -Description 'Maps extended properties AD permissions to GUIDs' -Option ReadOnly -Force -PassThru
        New-Variable -Scope $Scope -Name DSACLGuidMap -Value $GuidMap -Description 'Maps GUIDs to AD permissions' -Option ReadOnly -Force -PassThru
        New-Variable -Scope $Scope -Name DSACLExtendedGuidMap -Value $extendedGuidMap -Description 'Maps GUIDs to extended properties AD permissions' -Option ReadOnly -Force -PassThru
    ) | Select-Object -Property Name, Description
}
