---
external help file: DSACL-help.xml
Module Name: DSACL
online version:
schema: 2.0.0
---

# Add-DSACLMoveObjectFrom

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

```
Add-DSACLMoveObjectFrom [-ObjectTypeName] <String> [-TargetDN] <Object> [-DelegateDN] <Object> [-NoInheritance]
 [<CommonParameters>]
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

### -DelegateDN
{{ Fill DelegateDN Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -NoInheritance
{{ Fill NoInheritance Description }}

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
{{ Fill ObjectTypeName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Computer, Contact, Group, ManagedServiceAccount, GroupManagedServiceAccount, User, All

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetDN
{{ Fill TargetDN Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
