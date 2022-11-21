---
external help file: DSACL-help.xml
Module Name: DSACL
online version:
schema: 2.0.0
---

# Add-DSACLCustom

## SYNOPSIS
Give Delegate custom rights in target (usually an OU)

## SYNTAX

### Delegate (Default)
```
Add-DSACLCustom -TargetDN <String> -DelegateDN <String> -ActiveDirectoryRights <ActiveDirectoryRights[]>
 -AccessControlType <AccessControlType> [-ObjectType <Guid>]
 [-InheritanceType <ActiveDirectorySecurityInheritance>] [-InheritedObjectType <Guid>] [<CommonParameters>]
```

### Sid
```
Add-DSACLCustom -TargetDN <String> -SID <String> -ActiveDirectoryRights <ActiveDirectoryRights[]>
 -AccessControlType <AccessControlType> [-ObjectType <Guid>]
 [-InheritanceType <ActiveDirectorySecurityInheritance>] [-InheritedObjectType <Guid>] [<CommonParameters>]
```

### Self
```
Add-DSACLCustom -TargetDN <String> [-Self] -ActiveDirectoryRights <ActiveDirectoryRights[]>
 -AccessControlType <AccessControlType> [-ObjectType <Guid>]
 [-InheritanceType <ActiveDirectorySecurityInheritance>] [-InheritedObjectType <Guid>] [<CommonParameters>]
```

## DESCRIPTION
Used to delegate any custom rights in Active Directory.
Requires knowledge of creating ActiveDirectoryAccessRules, please use with caution.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -AccessControlType
Specifies if the Access Control Entry is Allow or Deny

```yaml
Type: AccessControlType
Parameter Sets: (All)
Aliases:
Accepted values: Allow, Deny

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ActiveDirectoryRights
List of access rights that should be applied

```yaml
Type: ActiveDirectoryRights[]
Parameter Sets: (All)
Aliases:
Accepted values: CreateChild, DeleteChild, ListChildren, Self, ReadProperty, WriteProperty, DeleteTree, ListObject, ExtendedRight, Delete, ReadControl, GenericExecute, GenericWrite, GenericRead, WriteDacl, WriteOwner, GenericAll, Synchronize, AccessSystemSecurity

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DelegateDN
DistinguishedName of group or user to give permissions to.

```yaml
Type: String
Parameter Sets: Delegate
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InheritanceType
Sets if and how this rule should be inherited

```yaml
Type: ActiveDirectorySecurityInheritance
Parameter Sets: (All)
Aliases:
Accepted values: None, All, Descendents, SelfAndChildren, Children

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InheritedObjectType
Sets guid of object types that should inherit this rule

```yaml
Type: Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ObjectType
Sets guid where access right should apply

```yaml
Type: Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SID
Specify Secure Identifier (SID)

```yaml
Type: String
Parameter Sets: Sid
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Self
Give access to "Self" instead of a user or group

```yaml
Type: SwitchParameter
Parameter Sets: Self
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetDN
DistinguishedName of object to modify ACL on. Usually an OU.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
