---
external help file: DSACL-help.xml
Module Name: DSACL
online version:
schema: 2.0.0
---

# Add-DSACLWriteAccountRestrictions

## SYNOPSIS
Delegate rights to write to the property set "Account Restrictions" on objects of selected type in target (usually an OU)

## SYNTAX

### ByTypeName (Default)
```
Add-DSACLWriteAccountRestrictions -TargetDN <String> -DelegateDN <String> -ObjectTypeName <String>
 -AccessType <AccessControlType> [-NoInheritance] [<CommonParameters>]
```

### ByGuid
```
Add-DSACLWriteAccountRestrictions -TargetDN <String> -DelegateDN <String> -ObjectTypeGuid <Guid>
 -AccessType <AccessControlType> [-NoInheritance] [<CommonParameters>]
```

## DESCRIPTION
Delegate rights to write to the property set "Account Restrictions" on objects of selected type in target (usually an OU)

## EXAMPLES

### Example 1
```powershell
PS C:\> Add-DSACLWriteAccountRestrictions -TargetDN $UsersOU -DelegateDN $UserAdminGroup -ObjectTypeName User -AccessType Allow
```

Will give the group with DistinguishedName in $UserAdminGroup rights to SET SPN of user objects in the OU with DistinguishedName in $UsersOU and all sub-OUs. Add -NoInheritance to disable inheritance.

## PARAMETERS

### -AccessType
llow or Deny

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

### -DelegateDN
DistinguishedName of group or user to give permissions to.

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
Sets access right to "This object only"

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
ObjectType guid, used for custom object types

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
Accepted values: User, Computer, ManagedServiceAccount, GroupManagedServiceAccount

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
