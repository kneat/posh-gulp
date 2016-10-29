$script:taskDeps = @{}
$script:taskBlocks = @{}

function Add-Task($name, $deps, $action){
    $script:taskDeps[$name] = $deps        
    $script:taskBlocks[$name] = $action.ToString()
}

function Export-Tasks()
{
    $script:taskDeps | ConvertTo-Json -Compress   
}

function Invoke-Task($name)
{
    $task = [ScriptBlock]::Create($script:taskBlocks[$name])
    Invoke-Command $task
}

function Stop-Tasks($execute)
{
    if ($execute) {
        Invoke-Task $execute
    } else {
        Export-Tasks        
    }
} 

Export-ModuleMember -Function Add-Task, Stop-Tasks