$execute = $args
$tasks = @{}

function Task($name, $deps, $action){
    if ($execute -eq $name) {
        Invoke-Command $action
    } else {
        $tasks[$name] = $deps        
    }
}

Task "task one"

Task "posh:simple" ("task one", "simple") {
    Write-Host 'simple from powershell'
}

if (!$execute) {
    $tasks | ConvertTo-Json -Compress   
}