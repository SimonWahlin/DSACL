---
external help file: DSACL-help.xml
Module Name: DSACL
online version:
schema: 2.0.0
---

# Add-DSACLJoinDomain

## SYNOPSIS
Give DelegateDN rights to join computers in target (usually an OU).

## SYNTAX

```
Add-DSACLJoinDomain [-TargetDN] <String> [-DelegateDN] <String> [-AllowCreate] [-NoInheritance]
 [<CommonParameters>]
```

## DESCRIPTION
Give DelegateDN rights to join computers in target (usually an OU).

## EXAMPLES

### Example 1
```powershell
PS C:\> Add-DSACLJoinDomain -TargetDN $ComputersOU -DelegateDN $JoinDomainAccounts -AccessType Allow
```

Will give the group with DistinguishedName in $JoinDomainAccounts rights to join computers to the domain. Requires a computer account to be created already.

## PARAMETERS

### -AllowCreate
Allow creating computer objects, this allows to join computers without a pre-staged computer account

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
Position: 1
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

### -TargetDN
DistinguishedName of object to modify ACL on. Usually an OU.

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
