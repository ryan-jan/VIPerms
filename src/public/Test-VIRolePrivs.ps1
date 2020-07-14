function Test-VIRolePrivs {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({$_ -like "*.json"})]
        [System.IO.FileInfo] $Path,

        [Parameter(Mandatory = $false)]
        [string[]] $Server = $global:DefaultVIServer.Name
    )

    try {
        $VIRolePrivs = Get-Content -Path $Path -Raw | ConvertFrom-Json
        foreach ($Srv in $Server) {
            foreach ($Role in $VIRolePrivs.Roles) {
                $VIRole = Get-VIRole -Server $Srv -Name $Role.Name
                $Comp = Compare-Object -ReferenceObject $Role.PrivilegeList -DifferenceObject $VIRole.PrivilegeList
                if ($null -ne $Comp) {
                    Write-Warning "$Srv - The '$($Role.Name)' role privileges do not match the reference file."
                    if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
                        foreach ($Diff in $Comp) {
                            if ($Diff.SideIndicator -eq "<=") {
                                Write-Verbose ("$($Diff.InputObject) is present in the reference file but is not " +
                                              "assigned to the '$($Role.Name)' role.")
                            } elseif ($Diff.SideIndicator -eq "=>") {
                                Write-Verbose ("$Srv - The '$($Diff.InputObject)' permission is assigned to the " +
                                               "'$($Role.Name)' role but is not present in the reference file.")
                            }
                            
                        }
                    }
                }
            }
        }
    } catch {
        $Err = $_
        throw $Err
    }
}