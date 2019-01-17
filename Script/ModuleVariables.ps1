$Script:GuidTable = @{
    'Account Restrictions'                      = [guid]'4c164200-20c0-11d0-a768-00aa006e0529'
    'All'                                       = [guid]'00000000-0000-0000-0000-000000000000'
    'CN'                                        = [guid]'bf96793f-0de6-11d0-a285-00aa003049e2'
    'Computer'                                  = [guid]'bf967a86-0de6-11d0-a285-00aa003049e2'
    'Contact'                                   = [guid]'5cb41ed0-0e4c-11d0-a286-00aa003049e2'
    'distinguishedName'                         = [guid]'bf9679e4-0de6-11d0-a285-00aa003049e2'
    'dNSHostName'                               = [guid]'72e39547-7b18-11d1-adef-00c04fd8d5cd'
    'DNS Host Name Attributes'                  = [guid]'72e39547-7b18-11d1-adef-00c04fd8d5cd'
    'gPLink'                                    = [guid]'f30e3bbe-9ff0-11d1-b603-0000f80367c1'
    'Group'                                     = [guid]'bf967a9c-0de6-11d0-a285-00aa003049e2'
    'GroupManagedServiceAccount'                = [guid]'7b8b558a-93a5-4af7-adca-c017e67f1057'
    'ManagedServiceAccount'                     = [guid]'ce206244-5827-4a86-ba1c-1c0c386c1b64'
    'member'                                    = [guid]'bf9679c0-0de6-11d0-a285-00aa003049e2'
    'name'                                      = [guid]'bf967a0e-0de6-11d0-a285-00aa003049e2'
    'OrganizationalUnit'                        = [guid]'bf967aa5-0de6-11d0-a285-00aa003049e2'
    'PwdLastSet'                                = [guid]'bf967a0a-0de6-11d0-a285-00aa003049e2'
    'ResetPassword'                             = [guid]'00299570-246d-11d0-a768-00aa006e0529'
    'sAMAccountName'                            = [guid]'3e0abfd0-126a-11d0-a060-00aa006c33ed'
    'self-membership'                           = [guid]'bf9679c0-0de6-11d0-a285-00aa003049e2'
    'servicePrincipalName'                      = [guid]'f3a64788-5306-11d1-a9c5-0000f80367c1'
    'User'                                      = [guid]'bf967aba-0de6-11d0-a285-00aa003049e2'
    'userParameters'                            = [guid]'bf967a6d-0de6-11d0-a285-00aa003049e2'
    'Validated write to DNS host name'          = [guid]'72e39547-7b18-11d1-adef-00c04fd8d5cd'
    'Validated write to service principal name' = [guid]'f3a64788-5306-11d1-a9c5-0000f80367c1'
}

$Script:DefaultContainersPatternTable = @{
    Computers = '^(?<prefix>B:32:AA312825768811D1ADED00C04FD8D5CD:)(?<DN>.+)$'
    Users     = '^(?<prefix>B:32:A9D1CA15768811D1ADED00C04FD8D5CD:)(?<DN>.+)$'
}

#$Script:RightsMapLoaded = $false
