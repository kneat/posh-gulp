$script:taskDeps = [ordered]@{}
$script:taskBlocks = New-Object -TypeName PSObject
$script:taskArgs = [ordered]@{}
function Add-Task {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $name,
        [string[]]
        $deps = @(),
        [ScriptBlock]
        $action = {},
        [string[]]
        $arguments = @()
    )
    process {
        $script:taskDeps[$name] = $deps
        $script:taskArgs[$name] = $arguments
        $script:taskBlocks |
        Add-Member `
            -MemberType ScriptMethod `
            -Name $name `
            -Value $action `
            -Force
    }
}

function Export-Tasks() {
    $script:taskDeps | ConvertTo-Json -Compress
}

function Invoke-Task($name) {
    $originalVerbosePreference = $global:VerbosePreference
    $originalDebugPreference = $global:DebugPreference
    try {
        $global:VerbosePreference = "Continue"
        $global:DebugPreference = "Continue"
        $result = ((Invoke-Command -Verbose $script:taskBlocks.$name.Script -ArgumentList $script:taskArgs.$name) *>&1)
    }
    finally {
        $global:VerbosePreference = $originalVerbosePreference
        $global:DebugPreference = $originalDebugPreference
    }

    $result | ForEach-Object {
        $record = $_
        switch ($record.GetType().Name) {
            "InformationRecord" { @{level = "information"; message = "$record".Trim() } }
            "String" { @{level = "unknown"; message = "$record".Trim() } }
            "WarningRecord" { @{level = "warning"; message = "$record".Trim() } }
            "ErrorRecord" {
                $message = $record.Exception.Message.Trim()
                if ($message -eq "") { return }
                @{level = "error"; message = $message }
            }
            "VerboseRecord" { @{level = "verbose"; message = "$record".Trim() } }
            "DebugRecord" { @{level = "debug"; message = "$record".Trim() } }
            default {
                @{
                    level   = "unknown"
                    message = ($record | Format-Table -HideTableHeaders -AutoSize -Wrap:$false | Out-String).Trim()
                }
            }
        }
    } | ForEach-Object {
        ConvertTo-Json $_ -Compress
    }
}

function Publish-Tasks {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [string[]] $execute
    )
    process {
        if ($execute) {
            Invoke-Task $execute[0]
        }
        else {
            Export-Tasks
        }
    }
}

Export-ModuleMember -Function Add-Task, Publish-Tasks