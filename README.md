# VIPerms

VIPerms is a PowerShell module to help manage vSphere global permissions. There does not appear to be a public
API for managing global permissions currently. However, it is possible to manipulate them using the
Managed Object Browser (MOB). This module wraps web requests to the MOB into PowerShell commands.

## Getting Started

Installation is simple via the PowerShell Gallery.

```powershell
Install-Module -Name "VIPerms" -Scope "CurrentUser"
Import-Module -Name "VIPerms"
```

The first thing you need to do is use the `Connect-VIMobServer` function to make a connection to your vCenter
server. When prompted you must supply the `administrator@vsphere.local` credentials.

```powershell
Connect-VIMobServer -Server "vcenter.example.com"
```

Once you have successfully connected to your vCenter server you can use the `Get-VIGlobalPermission` function
to list all global permissions.

```powershell
Get-VIGlobalPermissions

Principal                                                            PrincipalType Role            Propagate
---------                                                            ------------- ----            ---------
VSPHERE.LOCAL\vpxd-extension-b2df90b0-1e03-11e6-b844-005056bf2aaa    User          Admin           true
VSPHERE.LOCAL\vpxd-b2df90b0-1e03-11e6-b844-005056bf2aaa              User          Admin           true
VSPHERE.LOCAL\vsphere-webclient-b2df90b0-1e03-11e6-b844-005056bf2aaa User          Admin           true
VSPHERE.LOCAL\Administrators                                         Group         Admin           true
VSPHERE.LOCAL\Administrator                                          User          Admin           true
...
```

## Add/Remove Global Permissions

### New-VIGlobalPermission

The `New-VIGlobalPermission` function will allow you to create a global permission. You must supply a user/group
name and the identifier of the required role to assign.

First use the `Get-VIMobRole` function to get the identifier for the specific role.

```powershell
Get-VIMobRole

Name     Description Id
----     ----------- --
Admin    Admin       -1
ReadOnly ReadOnly    -2
View     View        -3
...
```

Then use the `New-VIGlobalPermission` function to create the permission. For example to assign the `Admin` role
to the vSphere user `VSPHERE.LOCAL\test-user` you would use.

```powershell
New-VIGlobalPermission -Name "VSPHERE.LOCAL\test-user" -RoleId -2
```

If you are assigning a role to a group you will need to use the `-IsGroup` parameter.

```powershell
New-VIGlobalPermission -Name "VSPHERE.LOCAL\group-of-users" -IsGroup -RoleId -2
```

By default the global permission will propagate to all children objects. If you would like to override this
you can use the `-Propagate` parameter.

```powershell
New-VIGlobalPermission -Name "VSPHERE.LOCAL\group-of-users" -IsGroup -RoleId -2 -Propagate:$false
```

## Remove-VIGlobalPermission

The `Remove-VIGlobalPermission` function will allow you to delete a global permission.

```powershell
Remove-VIGlobalPermission -Name "VSPHERE.LOCAL\test-user"
```

Again, f you are removing a permission from a group you will need to use the `-IsGroup` parameter.

```powershell
Remove-VIGlobalPermission -Name "VSPHERE.LOCAL\group-of-users" -IsGroup
```

## Self-Signed Certificates

If your environment makes use of un-signed/self-signed certificates then you will need to use the
`-SkipCertificateCheck` parameter for each function. For example:

```powershell
Connect-VIMobServer -Server "vcenter.example.com" -SkipCertificateCheck
```

## Acknowledgements

The inspiration for this module came from William Lam's [GlobalPermissions.ps1](https://github.com/lamw/vghetto-scripts/blob/master/powershell/GlobalPermissions.ps1)
script. This gave me the information I needed to be able to interact with the MOB service via PowerShell.
