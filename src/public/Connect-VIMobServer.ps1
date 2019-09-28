function Connect-VIMobServer {
    <#
    .SYNOPSIS
    Connect to the vSphere Managed Object Browser (MOB).
    
    .DESCRIPTION
    This function will first test the connection to the specified vCenter server MOB. If successful
    the Uri and PSCredentials object are stored in the global variable $Global:VIPerms for use
    with other functions in this module. 
    
    .PARAMETER Server
    Specify the name of a vCenter server.
    
    .PARAMETER Credential
    Specify the credentials to use to authenticate against the MOB.
    This is usually administrator@vsphere.local
    
    .PARAMETER SkipCertificateCheck
    Skip certificate verification.
    
    .EXAMPLE
    Connect-VIMobServer -Server "vcenter.example.com"
    #>


    param (
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string] $Server,

        [Parameter(
            Position = 1,
            Mandatory = $true
        )]
        [PSCredential] $Credential,

        [Parameter(
            Position = 2,
            Mandatory = $false
        )]
        [Switch] $SkipCertificateCheck
    )

    try {
        $ProPref = $ProgressPreference
        $ProgressPreference = "SilentlyContinue"
        if ($SkipCertificateCheck) {
            Set-CertPolicy -SkipCertificateCheck
        }
        $Global:VIPerms = @{
            Server = $Server
            Credential = $Credential
            SkipCertificateCheck = $true
        }
        Invoke-Login -Server $Server -Credential $Credential
        [PSCustomObject] @{
            Server = $Server
            User = $Credential.GetNetworkCredential().UserName
        }
        Invoke-Logoff
        if ($SkipCertificateCheck) {
            Set-CertPolicy -ResetToDefault
        }
        $ProgressPreference = $ProPref
    } catch {
        $Err = $_
        throw $Err
    }
}