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

function Get-Task() {
    $currentTask
}

function Export-Tasks(){
    $script:taskDeps | ConvertTo-Json -Compress   
}

function Invoke-Task($name){
    $currentTask = $name
    Invoke-Command $script:taskBlocks.$name.Script
    $currentTask = $name
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

Export-ModuleMember -Function Add-Task, Get-Task, Publish-Tasks