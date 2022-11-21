---
external help file: DSACL-help.xml
Module Name: DSACL
online version:
schema: 2.0.0
---

# Set-DSACLOwner

## SYNOPSIS
Sets an Active Directory object as the Owner of an Access Control List (ACL).

## SYNTAX

```
Set-DSACLOwner [-TargetDN] <String> [-OwnerDN] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The **Set-DSACLOwner** cmdlet will set the given OwnerDN (Objects Distinguished Name) as Owner of the specified TargetDN (Target Distinguished Name).

The TargetDN parameter specifies what object the modification will execute on.

The OwnerDN parameter specifies what object in Active Directory that will take ownership of the target.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-DSACLOwner -TargetDN "OU=Accounting,DC=FABRIKAM,DC=COM" -OwnerDN "CN=Chew David,OU=Accounting,DC=FABRIKAM,DC=COM"
```

The following example will set Chew David as owner of the Accounting Organizational Units Access Control List.

## PARAMETERS

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OwnerDN
The OwnerDN parameter specifies what object in Active Directory that will take ownership of the target.

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

### -TargetDN
The TargetDN parameter specifies what object the modification will execute on.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
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
