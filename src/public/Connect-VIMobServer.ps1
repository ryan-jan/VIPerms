function Connect-VIMobServer {
    [CmdLetBinding()]
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
        $Global:VIPerms = @{
            Server = $Server
            Credential = $Credential
            SkipCertificateCheck = $false
        }
        if ($SkipCertificateCheck) {
            Set-CertPolicy -SkipCertificateCheck
            $Global:VIPerms.SkipCertificateCheck = $true
        }
        Invoke-Login -Server $global:VIPerms.Server -Credential $global:VIPerms.Credential
        [PSCustomObject] @{
            Server = $global:VIPerms.Server
            User = $global:VIPerms.Credential.GetNetworkCredential().UserName
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