---
external help file: DSACL-help.xml
Module Name: DSACL
online version:
schema: 2.0.0
---

# Add-DSACLRenameObject

## SYNOPSIS
Give Delegate rights to rename objects in target (usually an OU)

## SYNTAX

```
Add-DSACLRenameObject -ObjectTypeName <String> -TargetDN <String> -DelegateDN <String> [-NoInheritance]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> Add-DSACLRenameObject -ObjectTypeName Computer -TargetDN $ComputersOU -DelegateDN $ComputerAdminGroup -AccessType Allow
```

Will give the group with DistinguishedName in $ComputerAdminGroup rights to rename computers in the OU with DistinguishedName in $ComputersOU and all sub-OUs. Add -NoInheritance do disable inheritance.

## PARAMETERS

### -DelegateDN
DistinguishedName of group or user to give permissions to.

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

### -ObjectTypeName
Object type to allow being renamed

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Computer, Contact, Group, ManagedServiceAccount, GroupManagedServiceAccount, User, All

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
