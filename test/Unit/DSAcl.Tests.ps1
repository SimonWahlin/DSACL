param(
    $ModulePath = "$PSScriptRoot\..\.."
)
# Remove trailing slash or backslash
$ModulePath = $ModulePath -replace '[\\/]*$'
$ModuleName = Split-Path -Path $ModulePath -Leaf
$ModuleManifestName = 'DSAcl.psd1'
$ModuleManifestPath = Join-Path -Path $ModulePath -ChildPath $ModuleManifestName

# Clean up
try {
    Get-Module -Name $ModuleName | Remove-Module -Force
}
catch {

}
function Test-ACE ($Ace, $TemplateHash) {
    foreach($key in $TemplateHash.Keys) {
        if($Ace.$key -ne $TemplateHash.$key) {
            return $false
        }
    }
    return $true
}
Describe 'Core Module Tests' -Tags 'CoreModule', 'Unit' {
    It 'Passes Test-ModuleManifest' {
        {Test-ModuleManifest -Path $ModuleManifestPath -ErrorAction Stop} | Should -Not -Throw
    }

    It 'Loads from module path without errors' {
        {Import-Module "$ModulePath" -ErrorAction Stop} | Should -Not -Throw
    }
    AfterAll {
        Get-Module -Name $ModuleName | Remove-Module -Force
    }
}

Describe 'DSACL Unit tests' -Tag 'Unit' {
    BeforeAll {
        Import-Module $ModulePath
    }

    AfterAll {
        Get-Module -Name $ModuleName | Remove-Module -Force
    }

    Context 'Testing Private functions' {
        InModuleScope -ModuleName DSACL {

        }
    }
    #region Mocks
    Mock Get-LDAPObject -ModuleName DSACL {
        #New-MockObject -Type System.DirectoryServices.DirectoryEntry
        [pscustomobject]@{
            DistinguishedName = $DistinguishedName
            defaultNamingContext = 'N/A'
        }
    }
    Mock Get-SID -ModuleName DSACL {
        New-Object -TypeName System.Security.Principal.SecurityIdentifier -ArgumentList 'S-1-5-10'
    }
    function global:Mock-Add-DSACLAccessRule {
        param(
            $Target,
            [Parameter(ValueFromPipeline=$true)]
            $Ace
        )
        Process {
            $Ace
        }
    }
    Set-Alias -Name Add-DSACLAccessRule -Value Mock-Add-DSACLAccessRule -Scope Global
    # Mock Add-DSACLAccessRule -ModuleName DSACL {
    #     $ACE
    # }
    #endregion Mocks

    Context 'Testing Public Functions' {
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
                Types = 'Computer','Contact','Group','ManagedServiceAccount','User','All'
            },
            @{
                Command = 'Add-DSACLDeleteChild'
                ActiveDirectoryRights = 'DeleteChild'
                InheritanceType = 'None','All'
                ObjectType = 'ObjectGuid'
                InheritedObjectType = '00000000-0000-0000-0000-000000000000'
                Types = 'Computer','Contact','Group','ManagedServiceAccount','User','All'
            },
            @{
                Command = 'Add-DSACLFullControl'
                ActiveDirectoryRights = 'GenericAll'
                InheritanceType = 'Children','Descendents'
                ObjectType = '00000000-0000-0000-0000-000000000000'
                InheritedObjectType = 'ObjectGuid'
                Types = 'Computer','Contact','Group','ManagedServiceAccount','User','All'
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
                $TestCases = $ObjectTypeCases.Where({$_.ObjectType -in $Command.Types})
                foreach($AccessType in @('Allow','Deny')) {
                    It "Delegates access to $AccessType $($Command.ActiveDirectoryRights) on <ObjectType> without inheritance" -TestCases $TestCases {
                        param($ObjectType,$ObjectGuid)
                        $DSACLParam = @{
                            TargetDN = 'TESTDN'
                            DelegateDN = 'TESTDN'
                            ObjectTypeName = $ObjectType
                            AccessType = $AccessType
                            NoInheritance = $True
                        }
                        # Generate ACE
                        $ACE = & $Command.Command @DSACLParam

                        # Create expected ACE
                        $ExpectedAce = @{
                            IdentityReference = 'S-1-5-10'
                            ActiveDirectoryRights = $Command.ActiveDirectoryRights
                            AccessControlType = $AccessType
                            ObjectType = $(if($Command.ObjectType -eq 'ObjectGuid'){$ObjectGuid}else{$Command.ObjectType})
                            InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]$Command.InheritanceType[0]
                            InheritedObjectType = $(if($Command.InheritedObjectType -eq 'ObjectGuid'){$ObjectGuid}else{$Command.InheritedObjectType})
                        }
                        Test-ACE -Ace $ACE -TemplateHash $ExpectedAce | Should -Be $true
                    }

                    It "Delegates access to $AccessType $($Command.ActiveDirectoryRights) on <ObjectType> with inheritance" -TestCases $TestCases {
                        param($ObjectType,$ObjectGuid)
                        $DSACLParam = @{
                            TargetDN = 'TESTDN'
                            DelegateDN = 'TESTDN'
                            ObjectTypeName = $ObjectType
                            AccessType = $AccessType
                        }
                        # Generate ACE
                        $ACE = & $Command.Command @DSACLParam

                        # Create expected ACE:
                        $ExpectedAce = @{
                            IdentityReference = 'S-1-5-10'
                            ActiveDirectoryRights = $Command.ActiveDirectoryRights
                            AccessControlType = $AccessType
                            ObjectType = $(if($Command.ObjectType -eq 'ObjectGuid'){$ObjectGuid}else{$Command.ObjectType})
                            InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]$Command.InheritanceType[1]
                            InheritedObjectType = $(if($Command.InheritedObjectType -eq 'ObjectGuid'){$ObjectGuid}else{$Command.InheritedObjectType})
                        }
                        Test-ACE -Ace $Ace -TemplateHash $ExpectedAce | Should -Be $true
                    }
                }
            }
        }

        Context 'Add-DSACLRenameComputer' {
            It 'Delegates RenameComputer access to DelegateDN without inheritance' {
                $DSACLParam = @{
                    TargetDN = 'TESTDN'
                    DelegateDN = 'TESTDN'
                    NoInheritance = $True
                }
                $ACEs = Add-DSACLRenameComputer @DSACLParam

                $ExpectedAces = @(
                    @{
                        IdentityReference = 'S-1-5-10'
                        ActiveDirectoryRights = 'WriteProperty'
                        AccessControlType = 'Allow'
                        ObjectType = 'bf9679e4-0de6-11d0-a285-00aa003049e2'
                        InheritanceType = 'Children'
                        InheritedObjectType = 'bf967a86-0de6-11d0-a285-00aa003049e2'
                    },
                    @{
                        IdentityReference = 'S-1-5-10'
                        ActiveDirectoryRights = 'WriteProperty'
                        AccessControlType = 'Allow'
                        ObjectType = 'bf967a0e-0de6-11d0-a285-00aa003049e2'
                        InheritanceType = 'Children'
                        InheritedObjectType = 'bf967a86-0de6-11d0-a285-00aa003049e2'
                    },
                    @{
                        IdentityReference = 'S-1-5-10'
                        ActiveDirectoryRights = 'WriteProperty'
                        AccessControlType = 'Allow'
                        ObjectType = 'bf96793f-0de6-11d0-a285-00aa003049e2'
                        InheritanceType = 'Children'
                        InheritedObjectType = 'bf967a86-0de6-11d0-a285-00aa003049e2'
                    }
                )
                0..2 | Foreach-Object -Process {
                    Test-ACE -Ace $ACEs[$_] -TemplateHash $ExpectedAces[$_] | Should -Be $true
                }
            }
        }

        Context 'Add-DSACLReplicatingDirectoryChanges' {
            It 'Delegates ReplicatingDirectoryChanges access to DelegateDN' {
                $DSACLParam = @{
                    DelegateDN = 'TESTDN'
                }
                $ACE = Add-DSACLReplicatingDirectoryChanges @DSACLParam

                $ExpectedAce = @{
                    IdentityReference = 'S-1-5-10'
                    ActiveDirectoryRights = 'ExtendedRight'
                    AccessControlType = 'Allow'
                    ObjectType = '1131f6aa-9c07-11d1-f79f-00c04fc2dcd2'
                    InheritanceType = 'None'
                }
                Test-ACE -Ace $ACE -TemplateHash $ExpectedAce | Should -Be $true
            }
        }

        Context 'Testing creating AccessRukes' {

        }
    }
    # TargetDN              = $TargetDN
    # DelegateDN            = $DelegateDN
    # ActiveDirectoryRights = 'ExtendedRight'
    # AccessControlType     = $AccessType
    # ObjectType            = $Script:GuidTable['ResetPassword']
    # InheritanceType       = $InheritanceType
    # InheritedObjectType   = $ObjectType

}

