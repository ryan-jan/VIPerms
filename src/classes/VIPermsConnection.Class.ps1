class VIPermsConnection {
    [string] $Server
    [int] $Port
    [pscredential] $Credential
    [bool] $SkipCertificateCheck

    VIPermsConnection () {}

    VIPermsConnection ($Server) {
        $this.Server = $Server
    }

    VIPermsConnection ($Server, $Port, $Credential, $SkipCertificateCheck) {
        $this.Server = $Server
        $this.Port = $Port
        $this.Credential = $Credential
        $this.SkipCertificateCheck = $SkipCertificateCheck
    }

    [void] AddToSession() {
        if (Test-Path "Variable:\VIPerms") {
            if ($global:VIPerms.Where({$_.Server -eq $this.Server}).Count -eq 0) {
                $global:VIPerms += $this
            } else {
                $global:VIPerms = $global:VIPerms.Where({$_.Server -ne $this.Server})
                $global:VIPerms += $this
            }
        } else {
            $global:VIPerms = @()
            $global:VIPerms += $this
        }
    }

    [void] RemoveFromSession() {
        if (Test-Path "Variable:\VIPerms") {
            if ($global:VIPerms.Where({$_.Server -eq $this.Server}).Count -gt 0) {
                $global:VIPerms = $global:VIPerms.Where({$_.Server -ne $this.Server})
            }
        }
    }

    [bool] TestConnection() {
        if (Invoke-MobRequest -Server $this.Server -TestConnection) {
            return $True
        } else {
            return $False
        }
    }
}