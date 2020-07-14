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

### Default (Default)
```
Connect-VIMobServer [-Server] <String[]> [-Port <Int32>] [-Protocol <String>] -Credential <PSCredential>
 [-Session <String>] [-NotDefault] [-SaveCredentials] [-AllLinked] [-Force] [-SkipCertificateCheck]
 [<CommonParameters>]
```

### SamlSecurityContext
```
Connect-VIMobServer [-Server] <String[]> [-Port <Int32>] [-Protocol <String>]
 -SamlSecurityContext <SamlSecurityContext> [-NotDefault] [-AllLinked] [-Force] [<CommonParameters>]
```

### Menu
```
Connect-VIMobServer [-Menu] [<CommonParameters>]
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

### -AllLinked
Indicates whether you want to connect to vCenter Server in linked mode. If you specify $true for the AllLinked parameter and the server to which you want to connect is a part of a federation vCenter Server, you'll be connected to all members of the linked vCenter Server.

To use this option, PowerCLI must be configured to work in multiple servers connection mode. To configure PowerCLI to support multiple servers connection, specify Multiple for the DefaultVIServerMode parameter of the Set-PowerCLIConfiguration cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: Default, SamlSecurityContext
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Specify the credentials to use to authenticate against the MOB.
This is usually administrator@vsphere.local

```yaml
Type: PSCredential
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Force
Suppresses all user interface prompts during the cmdlet execution. Currently, these include 'Multiple default servers' and 'Invalid certificate action'.

```yaml
Type: SwitchParameter
Parameter Sets: Default, SamlSecurityContext
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Menu
Indicates that you want to select a connection server from a list of recently connected servers. If Menu is set to $true, the cmdlet retrieves a list of the last visited servers and enters a nested command prompt, so that you can select a server from the list.

```yaml
Type: SwitchParameter
Parameter Sets: Menu
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -NotDefault
Indicates that you do not want to include the server to which you connect into the $defaultVIServers variable.

```yaml
Type: SwitchParameter
Parameter Sets: Default, SamlSecurityContext
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
Specifies the port on the server you want to use for the connection.

```yaml
Type: Int32
Parameter Sets: Default, SamlSecurityContext
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Protocol
Specifies the Internet protocol you want to use for the connection. It can be either http or https.

```yaml
Type: String
Parameter Sets: Default, SamlSecurityContext
Aliases:
Accepted values: http, https

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SamlSecurityContext
Specifies the SAML2 security context for the vCenter Server system. For more information about security contexts, see the about_security_context (about_security_context.html)article.

```yaml
Type: SamlSecurityContext
Parameter Sets: SamlSecurityContext
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -SaveCredentials
Indicates that you want to save the specified credentials in the local credential store.

Note: This parameter is not supported on the Core edition of PowerShell.

```yaml
Type: SwitchParameter
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server
Specify the name of a vCenter server.

```yaml
Type: String[]
Parameter Sets: Default, SamlSecurityContext
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
```

### -Session
Specifies the ID of an existing vCenter Server session you want to re-establish.

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipCertificateCheck
Skip certificate verification.

```yaml
Type: SwitchParameter
Parameter Sets: Default
Aliases:

Required: False
Position: Named
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
