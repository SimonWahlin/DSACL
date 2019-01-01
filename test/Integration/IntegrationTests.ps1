param (
    $ModulePath = "$PSScriptRoot\..\..",
    $DomainDN = 'DC=lab,DC=simonw,DC=se',
    $DomainFlatName = 'LAB'
)
$ErrorActionPreference = 'Stop'
# Remove trailing slash or backslash
$ModulePath = $ModulePath -replace '[\\/]*$'
$ModuleName = Split-Path -Path $ModulePath -Leaf

# Validate we are in designated test environment
try {
    Import-Module -Name ActiveDirectory -ErrorAction Stop
    Import-Module -Name Pester -MinimumVersion '4.1.1' -ErrorAction Stop
    Import-Module -Name $ModulePath
    $Domain = Get-ADDomain -ErrorAction Stop
    if ($Domain.DistinguishedName -ne $DomainDN) {
        throw
    }
} catch {
    Write-Verbose -Message 'Not in test environment or invalid environment' -Verbose
    return
}

# Cleanup
try {
    $TestOUName = "DSACL_Module_Test"
    Get-ADOrganizationalUnit -Identity "OU=$TestOUName,$DomainDN" |
        Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false -PassThru |
        Remove-ADOrganizationalUnit -Recursive -Confirm:$false
}
catch {
    # Ignore errors
}

# Initialize with new OU structure
try {
    $TestOU = New-ADOrganizationalUnit -Name $TestOUName -Path $DomainDN -PassThru
    $SubOU = New-ADOrganizationalUnit -Name 'Sub' -Path $TestOU -PassThru

    $TestUserName = 'DSACLModuleTest'
    $TestUser = New-ADUser -Name "$TestUserName" -Path "$TestOU" -PassThru
    $CleanACL = Get-Acl -Path "AD:\$($TestOU.DistinguishedName)"
}
catch {
    throw
}

function Assert-DSACL {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        $ACL,
        $ActiveDirectoryRight,
        $InheritanceType,
        $InheritedObjectType,
        $ObjectType,
        $AccessControlType = 'Allow',
        $IdentityReference,
        [bool]$IsInherited
    )

    $ACL |
        Select-Object -ExpandProperty Access |
        Where-Object -FilterScript {
            $_.ActiveDirectoryRights -eq $ActiveDirectoryRight -and
            $_.InheritanceType -eq $InheritanceType -and
            $_.ObjectType -eq $ObjectType -and
            $_.InheritedObjectType -eq $InheritedObjectType -and
            $_.AccessControlType -eq $AccessControlType -and
            $_.IdentityReference -like $IdentityReference -and
            $_.IsInherited -eq $IsInherited
        }
}

Describe "Integration testing in domain: $DomainDN" -Tag Integration {
    Context 'Testing Public Functions wrapping Add-DSACLCustom' {
        BeforeAll {
            Import-Module -Name $ModulePath
        }
        AfterEach {
            Set-ACL -Path "AD:\$($TestOU.DistinguishedName)" -AclObject $CleanACL
        }
        AfterAll {
            Get-Module -Name $ModuleName | Remove-Module -Force
        }

        $ObjectTypeCases = @(
            @{
                ObjectType = 'Computer'
                ObjectGuid = 'bf967a86-0de6-11d0-a285-00aa003049e2'
            },
            @{
                ObjectType = 'Contact'
                ObjectGuid = '5cb41ed0-0e4c-11d0-a286-00aa003049e2'
            },
            @{
                ObjectType = 'Group'
                ObjectGuid = 'bf967a9c-0de6-11d0-a285-00aa003049e2'
            },
            @{
                ObjectType = 'ManagedServiceAccount'
                ObjectGuid = 'ce206244-5827-4a86-ba1c-1c0c386c1b64'
            },
            @{
                ObjectType = 'User'
                ObjectGuid = 'bf967aba-0de6-11d0-a285-00aa003049e2'
            },
            @{
                ObjectType = 'All'
                ObjectGuid = '00000000-0000-0000-0000-000000000000'
            }
        )

        $Commands = @(
            @{
                Command = 'Add-DSACLCreateChild'
                ActiveDirectoryRights = 'CreateChild'
                InheritanceType = 'None','All'
                ObjectType = 'ObjectGuid'
                InheritedObjectType = '00000000-0000-0000-0000-000000000000'
                Types = 'Computer', 'Contact', 'Group', 'ManagedServiceAccount', 'User', 'All'
            },
            @{
                Command = 'Add-DSACLDeleteChild'
                ActiveDirectoryRights = 'DeleteChild'
                InheritanceType = 'None','All'
                ObjectType = 'ObjectGuid'
                InheritedObjectType = '00000000-0000-0000-0000-000000000000'
                Types = 'Computer', 'Contact', 'Group', 'ManagedServiceAccount', 'User', 'All'
            },
            @{
                Command = 'Add-DSACLFullControl'
                ActiveDirectoryRights = 'GenericAll'
                InheritanceType = 'Children','Descendents'
                ObjectType = '00000000-0000-0000-0000-000000000000'
                InheritedObjectType = 'ObjectGuid'
                Types = 'Computer', 'Contact', 'Group', 'ManagedServiceAccount', 'User', 'All'
            },
            @{
                Command = 'Add-DSACLResetPassword'
                ActiveDirectoryRights = 'ExtendedRight'
                ObjectType = '00299570-246d-11d0-a768-00aa006e0529'
                InheritanceType = 'Children','Descendents'
                InheritedObjectType = 'ObjectGuid'
                Types = 'Computer','User','ManagedServiceAccount'
            }
        )
        foreach($Command in $Commands) {
            Context $Command.Command {
                <#
                    $Command = $Commands[0]
                #>
                $TypeCases = $ObjectTypeCases | Where-Object -FilterScript {$_.ObjectType -in $Command.Types}
                <#
                    1 | % {$ObjectType, $ObjectGuid = $TypeCases[$_].ObjectType, $TypeCases[$_].ObjectGuid}
                #>

                It "Delegates access to allow $($Command.ActiveDirectoryRights) on <ObjectType> without inheritance" -TestCases $TypeCases {
                    param($ObjectType,$ObjectGuid)

                    $DSACLParam = @{
                        TargetDN = $TestOU.DistinguishedName
                        DelegateDN = $TestUser.DistinguishedName
                        ObjectTypeName = $ObjectType
                        AccessType = 'Allow'
                        NoInheritance = $True
                    }
                    & $Command.Command @DSACLParam

                    # Short pause to allow for Get-ACL to catch up (?)
                    Start-Sleep -Seconds 1

                    $ExpectedResult = @{
                        ActiveDirectoryRight = $Command.ActiveDirectoryRights
                        ObjectType = if($Command.ObjectType -eq 'ObjectGuid'){$ObjectGuid}else{$Command.ObjectType}
                        InheritedObjectType = if($Command.InheritedObjectType -eq 'ObjectGuid'){$ObjectGuid}else{$Command.InheritedObjectType}
                        InheritanceType = $Command.InheritanceType[0]
                        AccessControlType = 'Allow'
                        IdentityReference = "$DomainFlatName\$TestUserName"
                        IsInherited = $false
                    }

                    $ACL = Get-Acl -Path "AD:\$($TestOU.DistinguishedName)"
                    $ACL | Assert-DSACL @ExpectedResult | Measure-Object | Select-Object -ExpandProperty Count | Should -BeExactly 1

                    # FullControl on ALL objects without inheritance will still give full control to subOU with "ThisObjectOnly"
                    if (-not ($Command.Command -eq 'Add-DSACLFullControl' -and $ObjectType -eq 'All')) {
                        Get-Acl -Path "AD:\$($SubOU.DistinguishedName)" |
                            Select-Object -ExpandProperty Access |
                            Where-Object -FilterScript {
                                $_.IdentityReference -like "$DomainFlatName\$TestUserName" -and
                                $_.IsInherited -eq $true
                            } | Measure-Object | Select-Object -ExpandProperty Count | Should -BeExactly 0
                    }
                }

                It "Delegates access to allow $($Command.ActiveDirectoryRights) on <ObjectType> with inheritance" -TestCases $TypeCases {
                    param($ObjectType,$ObjectGuid)
                    $DSACLParam = @{
                        TargetDN = $TestOU.DistinguishedName
                        DelegateDN = $TestUser.DistinguishedName
                        ObjectTypeName = $ObjectType
                        AccessType = 'Allow'
                    }
                    & $Command.Command @DSACLParam

                    # Short pause to allow for Get-ACL to catch up (?)
                    Start-Sleep -Seconds 1

                    $ExpectedResult = @{
                        ActiveDirectoryRight = $Command.ActiveDirectoryRights
                        ObjectType = if($Command.ObjectType -eq 'ObjectGuid'){$ObjectGuid}else{$Command.ObjectType}
                        InheritedObjectType = if($Command.InheritedObjectType -eq 'ObjectGuid'){$ObjectGuid}else{$Command.InheritedObjectType}
                        InheritanceType = $Command.InheritanceType[1]
                        AccessControlType = 'Allow'
                        IdentityReference = "$DomainFlatName\$TestUserName"
                        IsInherited = $false
                    }

                    Get-Acl -Path "AD:\$($TestOU.DistinguishedName)" |
                        Assert-DSACL @ExpectedResult |
                        Measure-Object | Select-Object -ExpandProperty Count | Should -BeExactly 1

                    Get-Acl -Path "AD:\$($SubOU.DistinguishedName)" |
                        Select-Object -ExpandProperty Access |
                        Where-Object -FilterScript {
                            $_.IdentityReference -like "$DomainFlatName\$TestUserName" -and
                            $_.IsInherited -eq $true
                        } | Measure-Object | Select-Object -ExpandProperty Count | Should -BeExactly 1
                }
            }
        }
    }
}
