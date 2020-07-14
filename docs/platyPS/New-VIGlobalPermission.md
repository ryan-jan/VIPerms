---
external help file: VIPerms-help.xml
Module Name: VIPerms
online version:
schema: 2.0.0
---

# New-VIGlobalPermission

## SYNOPSIS
Add a global permission for a user/group.

## SYNTAX

```
New-VIGlobalPermission [-Server] <String[]> [-Principal] <String> [-IsGroup] [-Role] <String> [-Propagate]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a global permission assigning either a user or group to a specific role.

## EXAMPLES

### EXAMPLE 1
```
New-VIGlobalPermission -Name "VSPHERE.LOCAL\joe-bloggs" -RoleId -1
```

### EXAMPLE 2
```
New-VIGlobalPermission -Name "VSPHERE.LOCAL\group-of-users" -IsGroup -RoleId -1
```

### EXAMPLE 3
```
New-VIGlobalPermission -Name "VSPHERE.LOCAL\joe-bloggs" -RoleId -1 -Propagate:$false
```

## PARAMETERS

### -IsGroup
Specify whether the target is a group object or not.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Propagate
Specify whether the permission should propagate to all children objects or not.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: [Switch]::Present
Accept pipeline input: False
Accept wildcard characters: False
```

### -Role
{{ Fill Role Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server
{{ Fill Server Description }}

```yaml
Type: String[]
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