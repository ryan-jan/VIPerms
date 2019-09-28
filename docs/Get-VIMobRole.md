---
external help file: VIPerms-help.xml
Module Name: VIPerms
online version:
schema: 2.0.0
---

# Get-VIMobRole

## SYNOPSIS
Get roles via the Managed Object Browser (MOB)

## SYNTAX

```
Get-VIMobRole [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Retrieve all available roles from the vCenter MOB.
This is not the most effective way of retrieving this
information.
If you are using PowerCLI you should use the built in Get-VIRole CmdLet instead.

## EXAMPLES

### EXAMPLE 1
```
Get-VIMobRole
```

## PARAMETERS

### -SkipCertificateCheck
Skip certificate verification.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
