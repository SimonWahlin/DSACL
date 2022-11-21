---
external help file: DSACL-help.xml
Module Name: DSACL
online version:
schema: 2.0.0
---

# Add-DSACLManagerCanUpdateGroupMember

## SYNOPSIS
Give Delegate rights to groups manager to manage members in group(s).
Note that this access stays with the user if the manager changes.

## SYNTAX

```
Add-DSACLManagerCanUpdateGroupMember [-TargetDN] <String> [<CommonParameters>]
```

## DESCRIPTION
Give Delegate rights to groups manager to manage members in group(s).
Note that this access stays with the user if the manager changes.

## EXAMPLES

### Example 1
```powershell
PS C:\> Add-DSACLManagerCanUpdateGroupMember -TargetDN $Group
```

Will give the current manager of the group in $Group access to manage members.
Note that this access stays with the user if the manager changes.

## PARAMETERS

### -TargetDN
DistinguishedName of object to modify ACL on. Has to be a group.

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
