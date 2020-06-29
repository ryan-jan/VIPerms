function Connect-VIMobServer {
    [CmdletBinding()]
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
        [pscredential] $Credential,

        [Parameter(
            Position = 2,
            Mandatory = $false
        )]
        [switch] $SkipCertificateCheck
    )

    try {
        $global:VIPerms = @{
            Server = $Server
            Credential = $Credential
            SkipCertificateCheck = $false
        }
        if ($SkipCertificateCheck) {
            #Set-CertPolicy -SkipCertificateCheck
            $global:VIPerms.SkipCertificateCheck = $true
        }
        if (Invoke-MobRequest -TestConnection) {
            [PSCustomObject] @{
                Server = $global:VIPerms.Server
                User = $global:VIPerms.Credential.GetNetworkCredential().UserName
            }
        } else {
            Write-Warning "Authentication failed."
        }
        #if ($SkipCertificateCheck) {
        #    Set-CertPolicy -ResetToDefault
        #}
    } catch {
        $Err = $_
        throw $Err
    }
}