$script:taskDeps = @{}
$script:taskBlocks = @{}

function Add-Task {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $name,
        [string[]]
        $deps = @(),
        [ScriptBlock]
        $action
    )
    process {
        $script:taskDeps[$name] = $deps        
        $script:taskBlocks[$name] = $action
    }
}

function Export-Tasks(){
    $script:taskDeps | ConvertTo-Json -Compress   
}

function Invoke-Task($name){
    $task = [ScriptBlock]::Create($script:taskBlocks[$name])
    Invoke-Command $task
}

function Publish-Tasks{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [AllowEmptyCollection()]
        [string[]]
        $execute
    )
    process {
        if ($execute) {
            Invoke-Task $execute
        } else {
            Export-Tasks        
        }
    }
} 

Export-ModuleMember -Function Add-Task, Publish-Tasks