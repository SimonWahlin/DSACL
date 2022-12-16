---
external help file: DSACL-help.xml
Module Name: DSACL
online version:
schema: 2.0.0
---

# New-DSACLAccessRule

## SYNOPSIS
Create Access Control Entry for Active Directory ACL

## SYNTAX

### 6
```
New-DSACLAccessRule -Identity <SecurityIdentifier> -ActiveDirectoryRights <ActiveDirectoryRights[]>
 -AccessControlType <AccessControlType> -ObjectType <Guid>
 -InheritanceType <ActiveDirectorySecurityInheritance> -InheritedObjectType <Guid> [<CommonParameters>]
```

### 5
```
New-DSACLAccessRule -Identity <SecurityIdentifier> -ActiveDirectoryRights <ActiveDirectoryRights[]>
 -AccessControlType <AccessControlType> -ObjectType <Guid>
 -InheritanceType <ActiveDirectorySecurityInheritance> [<CommonParameters>]
```

### 4
```
New-DSACLAccessRule -Identity <SecurityIdentifier> -ActiveDirectoryRights <ActiveDirectoryRights[]>
 -AccessControlType <AccessControlType> -ObjectType <Guid> [<CommonParameters>]
```

### 3
```
New-DSACLAccessRule -Identity <SecurityIdentifier> -ActiveDirectoryRights <ActiveDirectoryRights[]>
 -AccessControlType <AccessControlType> -InheritanceType <ActiveDirectorySecurityInheritance>
 -InheritedObjectType <Guid> [<CommonParameters>]
```

### 2
```
New-DSACLAccessRule -Identity <SecurityIdentifier> -ActiveDirectoryRights <ActiveDirectoryRights[]>
 -AccessControlType <AccessControlType> -InheritanceType <ActiveDirectorySecurityInheritance>
 [<CommonParameters>]
```

### 1
```
New-DSACLAccessRule -Identity <SecurityIdentifier> -ActiveDirectoryRights <ActiveDirectoryRights[]>
 -AccessControlType <AccessControlType> [<CommonParameters>]
```

## DESCRIPTION
Create Access Control Entry for Active Directory ACL

## EXAMPLES

### Example 1
```powershell
PS C:\> New-ADAccessRule -Identity $SID -ActiveDirectoryRights 'CreateChild', 'DeleteChild' -AccessControlType Allow -ObjectType $TypeGuid -InheritanceType None
```

Create access rule that gives the object with SID $SID access to create and delete objects of type $TypeGuid on "this object only"

## PARAMETERS

### -AccessControlType
Sets allow or deny

```yaml
Type: AccessControlType
Parameter Sets: (All)
Aliases:
Accepted values: Allow, Deny

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Identity
SID of principal that will rule will apply to

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
Sets if and how this rule should be inherited

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
Sets guid of object types that should inherit this rule

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
Sets guid where access right should apply

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

### System.Security.AccessControl.AccessControlType

### System.Guid

### System.DirectoryServices.ActiveDirectorySecurityInheritance

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
