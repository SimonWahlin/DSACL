---
external help file: DSACL-help.xml
Module Name: DSACL
online version:
schema: 2.0.0
---

# Add-DSACLFullControl

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### ByTypeName (Default)
```
Add-DSACLFullControl -TargetDN <String> -DelegateDN <String> -ObjectTypeName <String>
 [-AccessType <AccessControlType>] [-NoInheritance] [<CommonParameters>]
```

### ByGuid
```
Add-DSACLFullControl -TargetDN <String> -DelegateDN <String> -ObjectTypeGuid <Guid>
 [-AccessType <AccessControlType>] [-NoInheritance] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> Add-DSACLFullControl -
```

{{ Add example description here }}

## PARAMETERS

### -AccessType
{{ Fill AccessType Description }}

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
{{ Fill DelegateDN Description }}

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

### -ObjectTypeGuid
{{ Fill ObjectTypeGuid Description }}

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
{{ Fill ObjectTypeName Description }}

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
{{ Fill TargetDN Description }}

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
