Import-Module ./Gulp -force

Add-Task "task one"

Add-Task "posh:simple" ("task one", "simple") {
    Write-Host 'simple from powershell'
}

Stop-Tasks $args

