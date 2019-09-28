---
external help file: VIPerms-help.xml
Module Name: VIPerms
online version:
schema: 2.0.0
---

# Connect-VIMobServer

## SYNOPSIS
Connect to the vSphere Managed Object Browser (MOB).

## SYNTAX

```
Connect-VIMobServer [-Server] <String> [-Credential] <PSCredential> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
This function will first test the connection to the specified vCenter server MOB.
If successful
the Uri and PSCredentials object are stored in the global variable $Global:VIPerms for use
with other functions in this module.

## EXAMPLES

### EXAMPLE 1
```
Connect-VIMobServer -Server "vcenter.example.com"
```

## PARAMETERS

### -Server
Specify the name of a vCenter server.

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

### -Credential
Specify the credentials to use to authenticate against the MOB.
This is usually administrator@vsphere.local

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipCertificateCheck
Skip certificate verification.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
