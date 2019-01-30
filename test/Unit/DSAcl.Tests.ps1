param(
    $ModulePath = "$PSScriptRoot\..\..\Source\",
    $ModuleName = 'DSACL'
)
$ErrorActionPreference = 'Stop'
# Remove trailing slash or backslash
$ModulePath = $ModulePath -replace '[\\/]*$'

# Clean up
try {
    Get-Module -Name $ModuleName | Remove-Module -Force
}
catch {
    # Ignore errors
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
    It 'Loads from module path without errors' {
        {Import-Module "$ModulePath\$ModuleName.psd1" -ErrorAction Stop} | Should -Not -Throw
    }
    AfterAll {
        Get-Module -Name $ModuleName | Remove-Module -Force
    }
}

Describe 'DSACL Unit tests' -Tag 'Unit' {
    BeforeAll {
        Import-Module "$ModulePath\$ModuleName.psd1"
    }

    AfterAll {
        Get-Module -Name $ModuleName | Remove-Module -Force
    }

    Context 'Testing Private functions' {
        InModuleScope -ModuleName DSACL {
            # TODO...
        }
    }

    #region Mocks
    Mock Get-LDAPObject -ModuleName DSACL {
        [pscustomobject]@{
            DistinguishedName = $DistinguishedName
            defaultNamingContext = 'N/A'
        }
    }
    Mock Get-SID -ModuleName DSACL {
        if ($DistinguishedName -match 'S(-\d+){2,4}') {
            $SIDString = $DistinguishedName
        } else {
            $SIDString = 'S-1-0-0'
        }
        New-Object -TypeName System.Security.Principal.SecurityIdentifier -ArgumentList $SIDString
    }
    function global:Set-MOCKDSACLAccessRule {
        param(
            $Target,
            [Parameter(ValueFromPipeline=$true)]
            $Ace
        )
        Process {
            $Ace
        }
    }
    Set-Alias -Name Set-DSACLAccessRule -Value Set-MOCKDSACLAccessRule -Scope Global
    function global:Set-MOCKOwner {
        param(
            $Target,
            [Parameter(ValueFromPipeline=$true)]
            $Owner
        )
        [pscustomobject]@{Target=$Target;Owner=$Owner}
    }
    Set-Alias -Name Set-Owner -Value Set-MOCKOwner -Scope Global
    #endregion Mocks

    Context 'Testing Public Functions wrapping Add-DSACLCustom' {
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
                ObjectType = 'GroupManagedServiceAccount'
                ObjectGuid = '7b8b558a-93a5-4af7-adca-c017e67f1057'
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
                Name = 'CreateChild'
                Command = 'Add-DSACLCreateChild'
                ActiveDirectoryRights = 'CreateChild'
                InheritanceType = 'All'
                ObjectType = 'ObjectGuid'
                InheritedObjectType = '00000000-0000-0000-0000-000000000000'
                Types = 'Computer', 'Contact', 'Group', 'ManagedServiceAccount', 'GroupManagedServiceAccount', 'User', 'All'
            },
            @{
                Name = 'CreateChild with NoInheritance'
                Command = 'Add-DSACLCreateChild'
                Params = @{'NoInheritance'=$True}
                ActiveDirectoryRights = 'CreateChild'
                InheritanceType = 'None'
                ObjectType = 'ObjectGuid'
                InheritedObjectType = '00000000-0000-0000-0000-000000000000'
                Types = 'Computer', 'Contact', 'Group', 'ManagedServiceAccount', 'GroupManagedServiceAccount', 'User', 'All'
            },
            @{
                Name = 'DeleteChild'
                Command = 'Add-DSACLDeleteChild'
                ActiveDirectoryRights = 'Delete'
                InheritanceType = 'Descendents'
                ObjectType = '00000000-0000-0000-0000-000000000000'
                InheritedObjectType = 'ObjectGuid'
                Types = 'Computer', 'Contact', 'Group', 'ManagedServiceAccount', 'GroupManagedServiceAccount', 'User', 'All'
            },
            @{
                Name = 'DeleteChild with IncludeChildren'
                Command = 'Add-DSACLDeleteChild'
                Params = @{'IncludeChildren'=$True}
                ActiveDirectoryRights = 'Delete', 'DeleteTree'
                InheritanceType = 'Descendents'
                ObjectType = '00000000-0000-0000-0000-000000000000'
                InheritedObjectType = 'ObjectGuid'
                Types = 'Computer', 'Contact', 'Group', 'ManagedServiceAccount', 'GroupManagedServiceAccount', 'User', 'All'
            },
            @{
                Name = 'DeleteChild with NoInheritance'
                Command = 'Add-DSACLDeleteChild'
                Params = @{'NoInheritance'=$True}
                ActiveDirectoryRights = 'Delete'
                InheritanceType = 'Children'
                ObjectType = '00000000-0000-0000-0000-000000000000'
                InheritedObjectType = 'ObjectGuid'
                Types = 'Computer', 'Contact', 'Group', 'ManagedServiceAccount', 'GroupManagedServiceAccount', 'User', 'All'
            },
            @{
                Name = 'DeleteChild with IncludeChildren and NoInheritance'
                Command = 'Add-DSACLDeleteChild'
                Params = @{'IncludeChildren'=$True;'NoInheritance'=$True}
                ActiveDirectoryRights = 'Delete', 'DeleteTree'
                InheritanceType = 'Children'
                ObjectType = '00000000-0000-0000-0000-000000000000'
                InheritedObjectType = 'ObjectGuid'
                Types = 'Computer', 'Contact', 'Group', 'ManagedServiceAccount', 'GroupManagedServiceAccount', 'User', 'All'
            },
            @{
                Name = 'FullControl'
                Command = 'Add-DSACLFullControl'
                ActiveDirectoryRights = 'GenericAll'
                InheritanceType = 'Descendents'
                ObjectType = '00000000-0000-0000-0000-000000000000'
                InheritedObjectType = 'ObjectGuid'
                Types = 'Computer', 'Contact', 'Group', 'ManagedServiceAccount', 'GroupManagedServiceAccount', 'User', 'All'
            },
            @{
                Name = 'FullControl with NoInheritance'
                Command = 'Add-DSACLFullControl'
                Params = @{'NoInheritance'=$True}
                ActiveDirectoryRights = 'GenericAll'
                InheritanceType = 'Children'
                ObjectType = '00000000-0000-0000-0000-000000000000'
                InheritedObjectType = 'ObjectGuid'
                Types = 'Computer', 'Contact', 'Group', 'ManagedServiceAccount', 'GroupManagedServiceAccount', 'User', 'All'
            },
            @{
                Name = 'ResetPassword'
                Command = 'Add-DSACLResetPassword'
                ActiveDirectoryRights = 'ExtendedRight'
                ObjectType = '00299570-246d-11d0-a768-00aa006e0529'
                InheritanceType = 'Descendents'
                InheritedObjectType = 'ObjectGuid'
                Types = 'Computer','User','ManagedServiceAccount', 'GroupManagedServiceAccount'
            },
            @{
                Name = 'ResetPassword with NoInheritance'
                Command = 'Add-DSACLResetPassword'
                Params = @{'NoInheritance'=$True}
                ActiveDirectoryRights = 'ExtendedRight'
                ObjectType = '00299570-246d-11d0-a768-00aa006e0529'
                InheritanceType = 'Children'
                InheritedObjectType = 'ObjectGuid'
                Types = 'Computer','User','ManagedServiceAccount', 'GroupManagedServiceAccount'
            }
        )
        foreach($Command in $Commands) {
            Context $Command.Name {
                $TestCases = $ObjectTypeCases.Where({$_.ObjectType -in $Command.Types})
                foreach($AccessType in @('Allow','Deny')) {

                    It "$AccessType $($Command.Name) on <ObjectType>" -TestCases $TestCases {
                        param(
                            $ObjectType,
                            $ObjectGuid
                        )

                        $DSACLParam = @{
                            TargetDN = 'TESTDN'
                            DelegateDN = 'TESTDN'
                            ObjectTypeName = $ObjectType
                            AccessType = $AccessType
                        }

                        foreach($Key in $Command.Params.Keys) {
                            $DSACLParam.Add($Key,$Command.Params[$Key])
                        }

                        # Generate ACE
                        $ACE = & $Command.Command @DSACLParam

                        # Create expected ACE
                        $ExpectedAce = @{
                            IdentityReference = 'S-1-0-0'
                            ActiveDirectoryRights = $Command.ActiveDirectoryRights
                            AccessControlType = $AccessType
                            ObjectType = $(if($Command.ObjectType -eq 'ObjectGuid'){$ObjectGuid}else{$Command.ObjectType})
                            InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]$Command.InheritanceType
                            InheritedObjectType = $(if($Command.InheritedObjectType -eq 'ObjectGuid'){$ObjectGuid}else{$Command.InheritedObjectType})
                        }
                        Test-ACE -Ace $ACE -TemplateHash $ExpectedAce | Should -Be $true
                    }
                }
            }
        }
    }

    Context 'Testing other public functions' {
        Context 'Add-DSACLRenameComputer' {

            It 'Delegates RenameComputer access to DelegateDN with inheritance' {
                $DSACLParam = @{
                    TargetDN = 'TESTDN'
                    DelegateDN = 'TESTDN'
                    NoInheritance = $False
                    ObjectTypeName = 'Computer'
                }
                $ACEs = Add-DSACLRenameObject @DSACLParam
                $ExpectedAces = @(
                    @{
                        IdentityReference     = 'S-1-0-0'
                        ActiveDirectoryRights = 'WriteProperty'
                        AccessControlType     = 'Allow'
                        ObjectType            = 'bf9679e4-0de6-11d0-a285-00aa003049e2'
                        InheritedObjectType   = 'bf967a86-0de6-11d0-a285-00aa003049e2'
                        InheritanceType       = 'Descendents'
                    },
                    @{
                        IdentityReference     = 'S-1-0-0'
                        ActiveDirectoryRights = 'WriteProperty'
                        AccessControlType     = 'Allow'
                        ObjectType            = 'bf967a0e-0de6-11d0-a285-00aa003049e2'
                        InheritedObjectType   = 'bf967a86-0de6-11d0-a285-00aa003049e2'
                        InheritanceType       = 'Descendents'
                    },
                    @{
                        IdentityReference     = 'S-1-0-0'
                        ActiveDirectoryRights = 'WriteProperty'
                        AccessControlType     = 'Allow'
                        ObjectType            = 'bf96793f-0de6-11d0-a285-00aa003049e2'
                        InheritedObjectType   = 'bf967a86-0de6-11d0-a285-00aa003049e2'
                        InheritanceType       = 'Descendents'
                    },
                    @{
                        IdentityReference     = 'S-1-0-0'
                        ActiveDirectoryRights = 'WriteProperty'
                        AccessControlType     = 'Allow'
                        ObjectType            = '4c164200-20c0-11d0-a768-00aa006e0529'
                        InheritedObjectType   = 'bf967a86-0de6-11d0-a285-00aa003049e2'
                        InheritanceType       = 'Descendents'
                    },
                    @{
                        IdentityReference     = 'S-1-0-0'
                        ActiveDirectoryRights = 'WriteProperty'
                        AccessControlType     = 'Allow'
                        ObjectType            = '3e0abfd0-126a-11d0-a060-00aa006c33ed'
                        InheritedObjectType   = 'bf967a86-0de6-11d0-a285-00aa003049e2'
                        InheritanceType       = 'Descendents'
                    },
                    @{
                        IdentityReference     = 'S-1-0-0'
                        ActiveDirectoryRights = 'WriteProperty'
                        AccessControlType     = 'Allow'
                        ObjectType            = '72e39547-7b18-11d1-adef-00c04fd8d5cd'
                        InheritedObjectType   = 'bf967a86-0de6-11d0-a285-00aa003049e2'
                        InheritanceType       = 'Descendents'
                    },
                    @{
                        IdentityReference     = 'S-1-0-0'
                        ActiveDirectoryRights = 'WriteProperty'
                        AccessControlType     = 'Allow'
                        ObjectType            = 'f3a64788-5306-11d1-a9c5-0000f80367c1'
                        InheritedObjectType   = 'bf967a86-0de6-11d0-a285-00aa003049e2'
                        InheritanceType       = 'Descendents'
                    }
                )
                for ($i = 0; $i -lt $ACEs.Count; $i++) {
                    Test-ACE -Ace $ACEs[$i] -TemplateHash $ExpectedAces[$i] | Should -Be $true
                }
            }

            It 'Delegates Rename Computer access to DelegateDN without inheritance' {
                $DSACLParam = @{
                    TargetDN = 'TESTDN'
                    DelegateDN = 'TESTDN'
                    NoInheritance = $True
                    ObjectTypeName = 'Computer'
                }
                $ACEs = Add-DSACLRenameObject @DSACLParam

                $ExpectedAces = @(
                    @{
                        IdentityReference     = 'S-1-0-0'
                        ActiveDirectoryRights = 'WriteProperty'
                        AccessControlType     = 'Allow'
                        ObjectType            = 'bf9679e4-0de6-11d0-a285-00aa003049e2'
                        InheritedObjectType   = 'bf967a86-0de6-11d0-a285-00aa003049e2'
                        InheritanceType       = 'Children'
                    },
                    @{
                        IdentityReference     = 'S-1-0-0'
                        ActiveDirectoryRights = 'WriteProperty'
                        AccessControlType     = 'Allow'
                        ObjectType            = 'bf967a0e-0de6-11d0-a285-00aa003049e2'
                        InheritedObjectType   = 'bf967a86-0de6-11d0-a285-00aa003049e2'
                        InheritanceType       = 'Children'
                    },
                    @{
                        IdentityReference     = 'S-1-0-0'
                        ActiveDirectoryRights = 'WriteProperty'
                        AccessControlType     = 'Allow'
                        ObjectType            = 'bf96793f-0de6-11d0-a285-00aa003049e2'
                        InheritedObjectType   = 'bf967a86-0de6-11d0-a285-00aa003049e2'
                        InheritanceType       = 'Children'
                    },
                    @{
                        IdentityReference     = 'S-1-0-0'
                        ActiveDirectoryRights = 'WriteProperty'
                        AccessControlType     = 'Allow'
                        ObjectType            = '4c164200-20c0-11d0-a768-00aa006e0529'
                        InheritedObjectType   = 'bf967a86-0de6-11d0-a285-00aa003049e2'
                        InheritanceType       = 'Children'
                    },
                    @{
                        IdentityReference     = 'S-1-0-0'
                        ActiveDirectoryRights = 'WriteProperty'
                        AccessControlType     = 'Allow'
                        ObjectType            = '3e0abfd0-126a-11d0-a060-00aa006c33ed'
                        InheritedObjectType   = 'bf967a86-0de6-11d0-a285-00aa003049e2'
                        InheritanceType       = 'Children'
                    },
                    @{
                        IdentityReference     = 'S-1-0-0'
                        ActiveDirectoryRights = 'WriteProperty'
                        AccessControlType     = 'Allow'
                        ObjectType            = '72e39547-7b18-11d1-adef-00c04fd8d5cd'
                        InheritedObjectType   = 'bf967a86-0de6-11d0-a285-00aa003049e2'
                        InheritanceType       = 'Children'
                    },
                    @{
                        IdentityReference     = 'S-1-0-0'
                        ActiveDirectoryRights = 'WriteProperty'
                        AccessControlType     = 'Allow'
                        ObjectType            = 'f3a64788-5306-11d1-a9c5-0000f80367c1'
                        InheritedObjectType   = 'bf967a86-0de6-11d0-a285-00aa003049e2'
                        InheritanceType       = 'Children'
                    }
                )
                for ($i = 0; $i -lt $ACEs.Count; $i++) {
                    Test-ACE -Ace $ACEs[$i] -TemplateHash $ExpectedAces[$i] | Should -Be $true
                }
            }
        }

        Context 'Add-DSACLJoinDomain' {
            It 'Delegates JoinDomain access (existing-computer-accounts) to DelegateDN with inheritance' {

            }
        }

        Context 'Add-DSACLReplicatingDirectoryChanges' {
            It 'Delegates ReplicatingDirectoryChanges access to DelegateDN' {
                $DSACLParam = @{
                    DelegateDN = 'TESTDN'
                }
                $ACE = Add-DSACLReplicatingDirectoryChanges @DSACLParam

                $ExpectedAce = @{
                    IdentityReference = 'S-1-0-0'
                    ActiveDirectoryRights = 'ExtendedRight'
                    AccessControlType = 'Allow'
                    ObjectType = '1131f6aa-9c07-11d1-f79f-00c04fc2dcd2'
                    InheritanceType = 'None'
                }
                Test-ACE -Ace $ACE -TemplateHash $ExpectedAce | Should -Be $true
            }

            It 'Delegates ReplicatingDirectoryChanges-All access to DelegateDN' {
                $DSACLParam = @{
                    DelegateDN = 'TESTDN'
                    AllowReplicateSecrets = $true
                }
                $ACE = Add-DSACLReplicatingDirectoryChanges @DSACLParam

                $ExpectedAce = @{
                    IdentityReference = 'S-1-0-0'
                    ActiveDirectoryRights = 'ExtendedRight'
                    AccessControlType = 'Allow'
                    ObjectType = '1131f6ad-9c07-11d1-f79f-00c04fc2dcd2'
                    InheritanceType = 'None'
                }
                Test-ACE -Ace $ACE -TemplateHash $ExpectedAce | Should -Be $true
            }
        }

        Context 'Add-DSACLManageGroupMember' {
            It 'Delegates access to manage groups in OU with inheritacnce' {
                $DSACLParam = @{
                    DelegateDN = 'TESTDN'
                    TargetDN = 'TESTDN'
                }
                $ACE = Add-DSACLManageGroupMember @DSACLParam

                $ExpectedAce = @{
                    IdentityReference = 'S-1-0-0'
                    ActiveDirectoryRights = 'WriteProperty'
                    AccessControlType = 'Allow'
                    ObjectType = 'bf9679c0-0de6-11d0-a285-00aa003049e2'
                    InheritanceType = 'Descendents'
                    InheritedObjectType = 'bf967a9c-0de6-11d0-a285-00aa003049e2'
                }
                Test-ACE -Ace $ACE -TemplateHash $ExpectedAce | Should -Be $true
            }

            It 'Delegates access to manage groups in OU without inheritacnce' {
              $DSACLParam = @{
                    DelegateDN = 'TESTDN'
                    TargetDN = 'TESTDN'
                    NoInheritance = $True
                }
                $ACE = Add-DSACLManageGroupMember @DSACLParam

                $ExpectedAce = @{
                    IdentityReference = 'S-1-0-0'
                    ActiveDirectoryRights = 'WriteProperty'
                    AccessControlType = 'Allow'
                    ObjectType = 'bf9679c0-0de6-11d0-a285-00aa003049e2'
                    InheritanceType = 'Children'
                    InheritedObjectType = 'bf967a9c-0de6-11d0-a285-00aa003049e2'
                }
                Test-ACE -Ace $ACE -TemplateHash $ExpectedAce | Should -Be $true
            }

            It 'Delegates access to manage a specific group' {
               $DSACLParam = @{
                    DelegateDN = 'TESTDN'
                    TargetDN = 'TESTDN'
                    DirectOnGroup = $True
                }
                $ACE = Add-DSACLManageGroupMember @DSACLParam

                $ExpectedAce = @{
                    IdentityReference = 'S-1-0-0'
                    ActiveDirectoryRights = 'WriteProperty'
                    AccessControlType = 'Allow'
                    ObjectType = 'bf9679c0-0de6-11d0-a285-00aa003049e2'
                    InheritanceType = 'None'
                    InheritedObjectType = '00000000-0000-0000-0000-000000000000'
                }
                Test-ACE -Ace $ACE -TemplateHash $ExpectedAce | Should -Be $true
            }

        }

        Context 'Creating AccessRules' {

        }

        Context 'Register-DSACLRightsMapVariable' {
            Mock Find-LDAPObject -ModuleName DSACL -ParameterFilter {$LDAPFilter -eq '(&(objectclass=controlAccessRight)(rightsGUID=*)(validAccesses=256))'} {
                [pscustomobject]@{
                    'displayName' = 'extended'
                    'rightsGUID' = [guid]::Empty
                }
                [pscustomobject]@{
                    'displayName' = 'extended1'
                    'rightsGUID' = [guid]'00000000-0000-0000-0000-000000000001'
                }
            }

            Mock Find-LDAPObject -ModuleName DSACL -ParameterFilter {$LDAPFilter -eq '(&(objectclass=controlAccessRight)(rightsGUID=*)(validAccesses=8))'} {
                [pscustomobject]@{
                    'displayName' = 'validated'
                    'rightsGUID' = [guid]::Empty
                }
                [pscustomobject]@{
                    'displayName' = 'validated1'
                    'rightsGUID' = [guid]'00000000-0000-0000-0000-000000000001'
                }
            }

            Mock Find-LDAPObject -ModuleName DSACL -ParameterFilter {$LDAPFilter -eq '(&(objectclass=controlAccessRight)(rightsGUID=*)(validAccesses=48))'} {
                [pscustomobject]@{
                    'displayName' = 'propertyset'
                    'rightsGUID' = [guid]::Empty
                }
                [pscustomobject]@{
                    'displayName' = 'propertyset1'
                    'rightsGUID' = [guid]'00000000-0000-0000-0000-000000000001'
                }
            }

            Mock Find-LDAPObject -ModuleName DSACL -ParameterFilter {$LDAPFilter -eq '(&(objectClass=classSchema)(schemaIDGUID=*))'} {
                [pscustomobject]@{
                    'lDAPDisplayName' = 'class'
                    'schemaIDGUID' = [guid]::Empty
                }
                [pscustomobject]@{
                    'lDAPDisplayName' = 'class1'
                    'schemaIDGUID' = [guid]'00000000-0000-0000-0000-000000000001'
                }
            }

            Mock Find-LDAPObject -ModuleName DSACL -ParameterFilter {$LDAPFilter -eq '(&(objectClass=attributeSchema)(schemaIDGUID=*))'} {
                [pscustomobject]@{
                    'lDAPDisplayName' = 'attribute'
                    'schemaIDGUID' = [guid]::Empty
                }
                [pscustomobject]@{
                    'lDAPDisplayName' = 'attribute1'
                    'schemaIDGUID' = [guid]'00000000-0000-0000-0000-000000000001'
                }
            }

            BeforeAll {
                # Make sure no DSACL variables are present
                Get-Variable -Name DSACL* -Scope Global | Remove-Variable -Scope Global -Force
            }

            It 'Registers 10 variables' {
                Register-DSACLRightsMapVariable -Scope Global
                $Variables = Get-Variable -Name DSACL* -Scope Global
                $Variables.Count | Should -Be 10
            }
        }
    }

}

