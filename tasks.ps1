Import-Module ./Gulp
Import-Module ./Logger

Add-Task "posh:empty"

Add-Task "posh:simple" ("build", "posh:empty") {
    Write-Gulp -name 'posh:simple' 'simple powershell task'
}

Publish-Tasks $args