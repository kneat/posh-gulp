function Start-Tasks($execute)
{
    $script:execute = $execute
    $script:tasks = @{}
} 

function New-Task($name, $deps, $action){
    if ($script:execute -eq $name) {
        Invoke-Command $action
    } else {
        $script:tasks[$name] = $deps        
    }
}

function Stop-Tasks()
{
    if (!$script:execute) {
        $script:tasks | ConvertTo-Json -Compress   
    }
} 

Export-ModuleMember -Function Start-Tasks
Export-ModuleMember -Function New-Task
Export-ModuleMember -Function Stop-Tasks
