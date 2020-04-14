$script:taskDeps = @{}
$script:taskBlocks = New-Object -TypeName PSObject

function Add-Task {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $name,
        [string[]]
        $deps = @(),
        [ScriptBlock]
        $action = {}
    )
    process {
        $script:taskDeps[$name] = $deps
        $script:taskBlocks |
            Add-Member `
                -MemberType ScriptMethod `
                -Name $name `
                -Value $action `
                -Force
    }
}

function Export-Tasks(){
    $script:taskDeps | ConvertTo-Json -Compress
}

function Invoke-Task($name){
    $originalVerbosePreference = $global:VerbosePreference
    $originalDebugPreference = $global:DebugPreference
    try {
        $global:VerbosePreference = "Continue"
        $global:DebugPreference = "Continue"
        $result = ((Invoke-Command -Verbose $script:taskBlocks.$name.Script) *>&1)
    } finally {
        $global:VerbosePreference = $originalVerbosePreference
        $global:DebugPreference = $originalDebugPreference
    }
         
    $result | ForEach-Object {
       $record = $_
       switch ($record.GetType().Name)
       {
          "InformationRecord" { @{level = "information"; message = "$record".Trim()}  }
          "String" { @{level = "unknown"; message = "$record".Trim()}  }
          "WarningRecord" { @{level = "warning"; message = "$record".Trim()} }
          "ErrorRecord" { @{level = "error"; message = "$record".Trim()}  }
          "VerboseRecord" { @{level = "verbose"; message = "$record".Trim()}  }
          "DebugRecord" { @{level = "debug"; message = "$record".Trim()}  }
          default {
             @{
                level = "unknown"
                message = ($record | Format-Table -HideTableHeaders -AutoSize -Wrap:$false | Out-String).Trim()
             }
          }
       }
    } | ForEach-Object {
       ConvertTo-Json $_ -Compress
    }
}

function Publish-Tasks{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [AllowEmptyCollection()]
        [string[]] $execute
    )
    process {
        if ($execute) {
            Invoke-Task $execute[0]
        } else {
            Export-Tasks
        }
    }
}

Export-ModuleMember -Function Add-Task, Publish-Tasks