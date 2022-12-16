---
external help file: DSACL-help.xml
Module Name: DSACL
online version:
schema: 2.0.0
---

# Add-DSACLCreateChild

## SYNOPSIS
Give Delegate rights to create objects of selected type in target (usually an OU)

## SYNTAX

### ByTypeName (Default)
```
Add-DSACLCreateChild -TargetDN <String> -DelegateDN <String> -ObjectTypeName <String>
 [-AccessType <AccessControlType>] [-NoInheritance] [<CommonParameters>]
```

### ByGuid
```
Add-DSACLCreateChild -TargetDN <String> -DelegateDN <String> -ObjectTypeGuid <Guid>
 [-AccessType <AccessControlType>] [-NoInheritance] [<CommonParameters>]
```

## DESCRIPTION
Give Delegate rights to create objects of selected type in target (usually an Organizational Unit)

## EXAMPLES

### Example 1
```powershell
PS C:\> Add-DSACLCreateChild -TargetDN $UsersOU -DelegateDN $UserAdminGroup -ObjectTypeName User
```

Will give the group with DistinguishedName in $UserAdminGroup access to create user objects in
the OU with DistinguishedName in $UsersOU and all sub-OUs. Add -NoInheritance do disable inheritance.

## PARAMETERS

### -AccessType
Specifies if the Access Control Entry is Allow or Deny

```yaml
Type: AccessControlType
Parameter Sets: (All)
Aliases:
Accepted values: Allow, Deny

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DelegateDN
DistinguishedName to delegate to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -NoInheritance
Switch parameter that disables Inheritance when delegating

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ObjectTypeGuid
ObjectType guid is used for custom object types

```yaml
Type: Guid
Parameter Sets: ByGuid
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ObjectTypeName
Object type to give full control over

```yaml
Type: String
Parameter Sets: ByTypeName
Aliases:
Accepted values: Computer, Contact, Group, ManagedServiceAccount, GroupManagedServiceAccount, User, All

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetDN
DistinguishedName of object to modify ACL on, usually an OU

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
