function Set-CertPolicy {
    <#
    .SYNOPSIS
    Ignore SSL verification.
    
    .DESCRIPTION
    Using a custom .NET type, override SSL verification policies.

    #>

    param (
        [Switch] $SkipCertificateCheck,
        [Switch] $ResetToDefault
    )

    try {
        if ($SkipCertificateCheck) {
            try {
                [Net.ServicePointManager]::SecurityProtocol = "Tls12, Tls11, Tls"
                [Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
            } catch {
                $Err = $_
                if ($Err.Exception.Message.StartsWith("Cannot find type [TrustAllCertsPolicy]")) {
                    Add-Type -TypeDefinition  @"
                    using System.Net;
                    using System.Security.Cryptography.X509Certificates;
                    public class TrustAllCertsPolicy : ICertificatePolicy {
                        public bool CheckValidationResult(
                            ServicePoint srvPoint, X509Certificate certificate,
                            WebRequest request, int certificateProblem) {
                            return true;
                        }
                    }
"@
                    [Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
                } else {
                    throw $Err
                }
            }
        } else {
            [Net.ServicePointManager]::CertificatePolicy = $null
        }
    } catch {
        $Err = $_
        throw $Err
    }
    
}