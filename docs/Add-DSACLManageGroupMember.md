---
external help file: DSACL-help.xml
Module Name: DSACL
online version:
schema: 2.0.0
---

# Add-DSACLManageGroupMember

## SYNOPSIS
Give Delegate rights to manage members in group(s).

## SYNTAX

### OnContainer (Default)
```
Add-DSACLManageGroupMember -TargetDN <String> -DelegateDN <String> [-AccessType <AccessControlType>]
 [-NoInheritance] [<CommonParameters>]
```

### OnGroup
```
Add-DSACLManageGroupMember -TargetDN <String> -DelegateDN <String> [-AccessType <AccessControlType>]
 [-DirectOnGroup] [<CommonParameters>]
```

## DESCRIPTION
Give Delegate rights to manage members in group(s).

## EXAMPLES

### Example 1
```powershell
PS C:\> Add-DSACLManageGroupMember -TargetDN $GroupsOU -DelegateDN $AccessAdminGroup -AccessType Allow
```

Will give the group with DistinguishedName in $AccessAdminGroup access to manage members of any group in the OU with DistinguishedName in $GroupsOU and all sub-OUs. Add -NoInheritance do disable inheritance.

### Example 2
```powershell
PS C:\> Add-DSACLManageGroupMember -TargetDN $GroupsOU -DelegateDN $AccessAdminGroup -AccessType Allow -NoInheritance
```

Will give the group with DistinguishedName in $AccessAdminGroup access to manage members of any group in the OU with DistinguishedName in $GroupsOU. Will not effect groups in sub-OUs.

### Example 3
```powershell
PS C:\> Add-DSACLManageGroupMember -TargetDN $SpecialGroup -DelegateDN $AccessAdminGroup -AccessType Allow -DirectOnGroup
```

Will give the group with DistinguishedName in $AccessAdminGroup access to manage members of the group in with DistinguishedName in $SpecialGroup.

## PARAMETERS

### -AccessType
Allow or Deny

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

### -DirectOnGroup
Sets access right to "This object only", use this when TargetDN is a group.

```yaml
Type: SwitchParameter
Parameter Sets: OnGroup
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoInheritance
Sets access right to "Children". Use this to effect all groups in OU but not subOUs

```yaml
Type: SwitchParameter
Parameter Sets: OnContainer
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
