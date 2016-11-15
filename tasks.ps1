Import-Module ./Gulp

Add-Task "posh:empty"

Add-Task "posh:simple" ("build", "posh:empty") {
    Write-Host 'simple powershell task'
}

Publish-Tasks $args