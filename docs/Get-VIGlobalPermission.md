---
external help file: VIPerms-help.xml
Module Name: VIPerms
online version:
schema: 2.0.0
---

# Get-VIGlobalPermission

## SYNOPSIS
Get one or more global permissions.

## SYNTAX

```
Get-VIGlobalPermission [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Return information relating to one or more global permissions.
This is not very performant as it literally
parses the html from the response of the vSphere MOB to get the information.
This appears to be the
only way to achieve this currently as there is no public API available for vSphere global permissions.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> Get-VIGlobalPermission

Principal                                                            PrincipalType Role            Propagate
---------                                                            ------------- ----            ---------
VSPHERE.LOCAL\vpxd-extension-b2df90b0-1e03-11e6-b844-005056bf2aaa    User          Admin           true
VSPHERE.LOCAL\vpxd-b2df90b0-1e03-11e6-b844-005056bf2aaa              User          Admin           true
VSPHERE.LOCAL\vsphere-webclient-b2df90b0-1e03-11e6-b844-005056bf2aaa User          Admin           true
VSPHERE.LOCAL\Administrators                                         Group         Admin           true
VSPHERE.LOCAL\Administrator                                          User          Admin           true
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
