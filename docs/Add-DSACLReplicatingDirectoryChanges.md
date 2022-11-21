---
external help file: DSACL-help.xml
Module Name: DSACL
online version:
schema: 2.0.0
---

# Add-DSACLReplicatingDirectoryChanges

## SYNOPSIS
Give Delegate "Replicating Directory Changes" rights on domain with DistinguishedName in target

## SYNTAX

```
Add-DSACLReplicatingDirectoryChanges [-DelegateDN] <String> [-AllowReplicateSecrets] [<CommonParameters>]
```

## DESCRIPTION
Give Delegate "Replicating Directory Changes" rights on domain with DistinguishedName in target

## EXAMPLES

### Example 1
```powershell
PS C:\> Add-DSACLReplicatingDirectoryChanges -DelegateDN $AADCServiceAccount
```

Will give the service account with DistinguishedName in $AADCServiceAccount the right "Replicating Directory Changes".
Add -AllowReplicateSecrets to grant "Replicating Directory Changes All" instead..

## PARAMETERS

### -AllowReplicateSecrets
Allow replicating secrets, like passwords (Corresponds to "Replicating Directory Changes All")

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

### -DelegateDN
DistinguishedName of group or user to give permissions to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
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
