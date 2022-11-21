---
external help file: DSACL-help.xml
Module Name: DSACL
online version:
schema: 2.0.0
---

# ConvertFrom-DSACLInheritedObjectTypeGuid

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Access (Default)
```
ConvertFrom-DSACLInheritedObjectTypeGuid -AccessRule <ActiveDirectoryAccessRule> [<CommonParameters>]
```

### Audit
```
ConvertFrom-DSACLInheritedObjectTypeGuid -AuditRule <ActiveDirectoryAuditRule> [<CommonParameters>]
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

### -AccessRule
{{ Fill AccessRule Description }}

```yaml
Type: ActiveDirectoryAccessRule
Parameter Sets: Access
Aliases: Access, ACE

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -AuditRule
{{ Fill AuditRule Description }}

```yaml
Type: ActiveDirectoryAuditRule
Parameter Sets: Audit
Aliases: Audit

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.DirectoryServices.ActiveDirectoryAccessRule

### System.DirectoryServices.ActiveDirectoryAuditRule

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
