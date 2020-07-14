function Connect-VIMobServer {
    [CmdletBinding(DefaultParameterSetName='Default')]
    param (
        [Parameter(ParameterSetName = 'Default', Mandatory = $true, Position = 0)]
        [Parameter(ParameterSetName = 'SamlSecurityContext', Mandatory = $true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string[]] $Server,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'SamlSecurityContext')]
        [ValidateNotNull()]
        [ValidateRange(0, 65535)]
        [int] $Port = "443",

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'SamlSecurityContext')]
        [ValidateSet('http', 'https')]
        [string] $Protocol,

        [Parameter(ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [pscredential] $Credential,

        [Parameter(ParameterSetName='Default')]
        [string] $Session,

        [Parameter(ParameterSetName = 'SamlSecurityContext', Mandatory = $true, ValueFromPipeline = $true)]
        [VMware.VimAutomation.Common.Types.V1.Authentication.SamlSecurityContext] $SamlSecurityContext,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'SamlSecurityContext')]
        [switch] $NotDefault,

        [Parameter(ParameterSetName = 'Default')]
        [switch] $SaveCredentials,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'SamlSecurityContext')]
        [switch] $AllLinked,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'SamlSecurityContext')]
        [switch] $Force,

        [Parameter(ParameterSetName = 'Menu', Mandatory = $true)]
        [switch] $Menu,

        [Parameter(ParameterSetName = 'Default')]
        [switch] $SkipCertificateCheck
    )

    begin {
        try {
            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer)) {
                $PSBoundParameters['OutBuffer'] = 1
            }
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand(
                'VMware.VimAutomation.Core\Connect-VIServer',
                [System.Management.Automation.CommandTypes]::Cmdlet)
            $OriginalParams = $PSBoundParameters
            $OriginalParams.Remove("SkipCertificateCheck") | Out-Null
            $scriptCmd = {& $wrappedCmd @OriginalParams }
            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($PSCmdlet)
        } catch {
            throw
        }
    }

    process {
        try {
            foreach ($Srv in $Server) {
                $Conn = [VIPermsConnection]::new($Srv, $Port, $Credential, $SkipCertificateCheck)
                $Conn.AddToSession()
                if ($Conn.TestConnection()) {
                    Write-Host "Connected to MOB uri https://$($Conn.Server):$($Conn.Port)/invsvc/mob3 sucessfully."
                } else {
                    $Conn.RemoveFromSession()
                    throw "Authentication failed."
                }
            }
            
            $steppablePipeline.Process($_)
        } catch {
            throw
        }
    }

    end {
        try {
            $steppablePipeline.End()
        } catch {
            throw
        }
    }
    <#
    .ForwardHelpTargetName VMware.VimAutomation.Core\Connect-VIServer
    .ForwardHelpCategory Cmdlet
    #>
}