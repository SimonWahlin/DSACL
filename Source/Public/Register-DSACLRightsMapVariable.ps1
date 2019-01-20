function Register-DSACLRightsMapVariable {
    [CmdletBinding()]
    param(
        [Parameter(DontShow)]
        [String]
        $Scope = 'Global'
    )
    $rootDSE = New-Object -TypeName System.DirectoryServices.DirectoryEntry -ArgumentList 'LDAP://RootDSE'

    # Create empty hash-tables
    $ClassName = @{}
    $ClassGuid = @{}
    $AttributeName = @{}
    $AttributeGuid = @{}
    $ExtendedName = @{}
    $ExtendedGuid = @{}
    $ValidatedWriteName = @{}
    $ValidatedWriteGuid = @{}
    $PropertySetName = @{}
    $PropertySetGuid = @{}

    # Locate Classes
    $Params = @{
        SearchBase  = $rootDSE.SchemaNamingContext.Value
        LDAPFilter  = '(&(objectClass=classSchema)(schemaIDGUID=*))'
        Property  = @('lDAPDisplayName', 'schemaIDGUID')
    }
    Find-LDAPObject @Params | ForEach-Object {
        $ClassName[$_.lDAPDisplayName]=[System.GUID]$_.schemaIDGUID
        $ClassGuid[[string][guid]$_.schemaIDGUID]=$_.lDAPDisplayName
    }

    # Locate Attributes
    $Params = @{
        SearchBase  = $rootDSE.SchemaNamingContext.Value
        LDAPFilter  = '(&(objectClass=attributeSchema)(schemaIDGUID=*))'
        Property  = @('lDAPDisplayName', 'schemaIDGUID')
    }
    Find-LDAPObject @Params | ForEach-Object {
        $AttributeName[$_.lDAPDisplayName]=[System.GUID]$_.schemaIDGUID
        $AttributeGuid[[string][guid]$_.schemaIDGUID]=$_.lDAPDisplayName
    }

    # Info on AccessRights found here: https://docs.microsoft.com/en-us/windows/desktop/ad/creating-a-control-access-right
    # Locate Extended Rights
    $Params = @{
        SearchBase  = $rootDSE.ConfigurationNamingContext
        LDAPFilter  = '(&(objectclass=controlAccessRight)(rightsGUID=*)(validAccesses=256))'
        Property  = @('displayName','rightsGUID')
    }
    Find-LDAPObject @Params | ForEach-Object {
        $ExtendedName[$_.displayName]=[System.GUID]$_.rightsGUID
        $ExtendedGuid[$_.rightsGUID]=$_.displayName
    }

    # Locate Validated Writes
    $Params = @{
        SearchBase  = $rootDSE.ConfigurationNamingContext
        LDAPFilter  = '(&(objectclass=controlAccessRight)(rightsGUID=*)(validAccesses=8))'
        Property  = @('displayName','rightsGUID')
    }
    Find-LDAPObject @Params | ForEach-Object {
        $ValidatedWriteName[$_.displayName]=[System.GUID]$_.rightsGUID
        $ValidatedWriteGuid[$_.rightsGUID]=$_.displayName
    }

    # Locate Property Sets
    $Params = @{
        SearchBase  = $rootDSE.ConfigurationNamingContext
        LDAPFilter  = '(&(objectclass=controlAccessRight)(rightsGUID=*)(validAccesses=48))'
        Property  = @('displayName','rightsGUID')
    }
    Find-LDAPObject @Params | ForEach-Object {
        $PropertySetName[$_.displayName]=[System.GUID]$_.rightsGUID
        $PropertySetGuid[$_.rightsGUID]=$_.displayName
    }

    $(
        New-Variable -Scope $Scope -Name DSACLClassName -Value $ClassName -Description 'Maps Active Directory Class names to GUIDs' -Option ReadOnly -Force -PassThru
        New-Variable -Scope $Scope -Name DSACLClassGuid -Value $ClassGuid -Description 'Maps Active Directory Class GUIDs to names' -Option ReadOnly -Force -PassThru
        New-Variable -Scope $Scope -Name DSACLAttributeName -Value $AttributeName -Description 'Maps Active Directory Attribute names to GUIDs' -Option ReadOnly -Force -PassThru
        New-Variable -Scope $Scope -Name DSACLAttributeGuid -Value $AttributeGuid -Description 'Maps Active Directory Attribute GUIDs to names' -Option ReadOnly -Force -PassThru
        New-Variable -Scope $Scope -Name DSACLExtendedName -Value $ExtendedName -Description 'Maps Active Directory Extended Right names to GUIDs' -Option ReadOnly -Force -PassThru
        New-Variable -Scope $Scope -Name DSACLExtendedGuid -Value $ExtendedGuid -Description 'Maps Active Directory Extended Right GUIDs to names' -Option ReadOnly -Force -PassThru
        New-Variable -Scope $Scope -Name DSACLValidatedWriteName -Value $ValidatedWriteName -Description 'Maps Active Directory ValidatedWrite names to GUIDs' -Option ReadOnly -Force -PassThru
        New-Variable -Scope $Scope -Name DSACLValidatedWriteGuid -Value $ValidatedWriteGuid -Description 'Maps Active Directory ValidatedWrite GUIDs to names' -Option ReadOnly -Force -PassThru
        New-Variable -Scope $Scope -Name DSACLPropertySetName -Value $PropertySetName -Description 'Maps Active Directory Property Set names to GUIDs' -Option ReadOnly -Force -PassThru
        New-Variable -Scope $Scope -Name DSACLPropertySetGuid -Value $PropertySetGuid -Description 'Maps Active Directory Property Set GUIDs to names' -Option ReadOnly -Force -PassThru
    ) | Select-Object -Property Name, Description
}
