---
external help file: VIPerms-help.xml
Module Name: VIPerms
online version:
schema: 2.0.0
---

# Remove-VIGlobalPermission

## SYNOPSIS
Delete a global permission for a specific user/group.

## SYNTAX

```
Remove-VIGlobalPermission [-Principal] <String> [-IsGroup] [<CommonParameters>]
```

## DESCRIPTION
Delete a global permission for a specific user/group.

## EXAMPLES

### EXAMPLE 1
```
Remove-VIGlobalPermission -Name "VSPHERE.LOCAL\Administrator"
```

### EXAMPLE 2
```
Remove-VIGlobalPermission -Name "VSPHERE.LOCAL\group-of-users" -IsGroup
```

## PARAMETERS

### -IsGroup
Specify whether the target is a group object or not.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Principal
{{ Fill Principal Description }}

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

## OUTPUTS

## NOTES

## RELATED LINKS
