---
external help file: DSACL-help.xml
Module Name: DSACL
online version:
schema: 2.0.0
---

# New-DSACLAuditRule

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### 6
```
New-DSACLAuditRule -Identity <SecurityIdentifier> -ActiveDirectoryRights <ActiveDirectoryRights[]>
 -AuditFlags <AuditFlags> -ObjectType <Guid> -InheritanceType <ActiveDirectorySecurityInheritance>
 -InheritedObjectType <Guid> [<CommonParameters>]
```

### 5
```
New-DSACLAuditRule -Identity <SecurityIdentifier> -ActiveDirectoryRights <ActiveDirectoryRights[]>
 -AuditFlags <AuditFlags> -ObjectType <Guid> -InheritanceType <ActiveDirectorySecurityInheritance>
 [<CommonParameters>]
```

### 4
```
New-DSACLAuditRule -Identity <SecurityIdentifier> -ActiveDirectoryRights <ActiveDirectoryRights[]>
 -AuditFlags <AuditFlags> -ObjectType <Guid> [<CommonParameters>]
```

### 3
```
New-DSACLAuditRule -Identity <SecurityIdentifier> -ActiveDirectoryRights <ActiveDirectoryRights[]>
 -AuditFlags <AuditFlags> -InheritanceType <ActiveDirectorySecurityInheritance> -InheritedObjectType <Guid>
 [<CommonParameters>]
```

### 2
```
New-DSACLAuditRule -Identity <SecurityIdentifier> -ActiveDirectoryRights <ActiveDirectoryRights[]>
 -AuditFlags <AuditFlags> -InheritanceType <ActiveDirectorySecurityInheritance> [<CommonParameters>]
```

### 1
```
New-DSACLAuditRule -Identity <SecurityIdentifier> -ActiveDirectoryRights <ActiveDirectoryRights[]>
 -AuditFlags <AuditFlags> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -ActiveDirectoryRights
{{ Fill ActiveDirectoryRights Description }}

```yaml
Type: ActiveDirectoryRights[]
Parameter Sets: (All)
Aliases:
Accepted values: CreateChild, DeleteChild, ListChildren, Self, ReadProperty, WriteProperty, DeleteTree, ListObject, ExtendedRight, Delete, ReadControl, GenericExecute, GenericWrite, GenericRead, WriteDacl, WriteOwner, GenericAll, Synchronize, AccessSystemSecurity

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AuditFlags
{{ Fill AuditFlags Description }}

```yaml
Type: AuditFlags
Parameter Sets: (All)
Aliases:
Accepted values: None, Success, Failure

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Identity
{{ Fill Identity Description }}

```yaml
Type: SecurityIdentifier
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -InheritanceType
{{ Fill InheritanceType Description }}

```yaml
Type: ActiveDirectorySecurityInheritance
Parameter Sets: 6, 5, 3, 2
Aliases:
Accepted values: None, All, Descendents, SelfAndChildren, Children

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -InheritedObjectType
{{ Fill InheritedObjectType Description }}

```yaml
Type: Guid
Parameter Sets: 6, 3
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ObjectType
{{ Fill ObjectType Description }}

```yaml
Type: Guid
Parameter Sets: 6, 5, 4
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Security.Principal.SecurityIdentifier

### System.DirectoryServices.ActiveDirectoryRights[]

### System.Security.AccessControl.AuditFlags

### System.Guid

### System.DirectoryServices.ActiveDirectorySecurityInheritance

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
