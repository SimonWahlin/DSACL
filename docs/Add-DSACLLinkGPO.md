---
external help file: DSACL-help.xml
Module Name: DSACL
online version:
schema: 2.0.0
---

# Add-DSACLLinkGPO

## SYNOPSIS
Delegate rights to link GPO on target (usually an OU)

## SYNTAX

```
Add-DSACLLinkGPO [-TargetDN] <String> [-DelegateDN] <String> [[-AccessType] <AccessControlType>]
 [-NoInheritance] [<CommonParameters>]
```

## DESCRIPTION
Delegate rights to link GPO on target (usually an OU)

## EXAMPLES

### Example 1
```powershell
PS C:\> Add-DSACLLinkGPO -TargetDN $UsersOU -DelegateDN $GPAdmin -AccessType Allow
```

Will give the group with DistinguishedName in $GPAdmin rights to link GPOs on
the OU with DistinguishedName in $UsersOU and all sub-OUs. Add -NoInheritance to disable inheritance.

## PARAMETERS

### -AccessType
Allow or Deny

```yaml
Type: AccessControlType
Parameter Sets: (All)
Aliases:
Accepted values: Allow, Deny

Required: False
Position: 2
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
Position: 1
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

### -TargetDN
DistinguishedName of object to modify ACL on. Usually an OU.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
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
