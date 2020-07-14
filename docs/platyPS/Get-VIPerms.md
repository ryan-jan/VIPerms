---
external help file: VIPerms-help.xml
Module Name: VIPerms
online version:
schema: 2.0.0
---

# Get-VIPerms

## SYNOPSIS
Retrieve all vCenter permissions, including global permissions.

## SYNTAX

```
Get-VIPerms [[-Server] <String[]>] [-ExcludeGlobal] [<CommonParameters>]
```

## DESCRIPTION
This function will retrieve all permissions from a vCenter server including global permissions.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> Get-VIPerms

Principal                                                                      Role                                   Entity                IsGroup Propagate
---------                                                                      ----                                   ------                ------- ---------
VSPHERE.LOCAL\vpxd-extension-b2df90b0-1e03-11e6-b844-005056bf2aaa              Admin                                  Global                False   True
VSPHERE.LOCAL\vpxd-b2df90b0-1e03-11e6-b844-005056bf2aaa                        Admin                                  Global                False   True
VSPHERE.LOCAL\vsphere-webclient-b2df90b0-1e03-11e6-b844-005056bf2aaa           vSphere Client Solution User           Datacenters           False   True
```

## PARAMETERS

### -ExcludeGlobal
Exclude global permissions from the results.

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

### -Server
{{ Fill Server Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
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
