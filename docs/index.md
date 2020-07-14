# VIPerms Documentation

VIPerms is a PowerShell module which extends the core VMware PowerCLI modules to provide additional commands
for managing vSphere permissions.

## Main Features

### Global permissions

Currently it is not possible to add and remove global permissions using only the core VMware PowerCLI module. VIPerms
provides two commands [New-VIGlobalPermission](./platyPS/New-VIGlobalPermission.md) and [Remove-VIGlobalPermission](./platyPS/Remove-VIGlobalPermission.md)
to enable this functionality.

**DISCLAIMER - There is no API available for global permissions at this time. This module instead invokes
[MOB](https://code.vmware.com/docs/4205/vmware-vsphere-web-services-sdk-programming-guide/doc/PG_Appx_Using_MOB.21.3.html) methods
via HTML requests. Use at your own risk.**

### Distribute custom roles between multiple vCenter servers

When managing multiple vCenter Server instances, it can be quite a laborious task to manually create the same roles
on each server. The VIPerms command [Copy-VIRole](./platyPS/Copy-VIRole.md) speeds this process up considerably.

### Check for configuration drift of custom vSphere roles and permissions

The VIPerms commands [Export-VIRolePrivs](./platyPS/Export-VIRolePrivs) and [Test-VIRolePrivs](./platyPS/Test-VIRolePrivs)
provide an easy way to export the privileges for one or more roles, and then check for configuration drift
at a later point in time.
