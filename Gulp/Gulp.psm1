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
    $(Invoke-Command $script:taskBlocks.$name.Script) *>&1 | %{
        $record = $_
        switch ($record.GetType().Name)
        {
            "InformationRecord" { "$record" }
            "String" { "$record" }
            "WarningRecord" { "$record" }
            "ErrorRecord" { "$record"  }
            default {"unknown: $_"}
        }
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