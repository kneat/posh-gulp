Import-Module ./Gulp -force

Start-Tasks $args

New-Task "task one"

New-Task "posh:simple" ("task one", "simple") {
    Write-Host 'simple from powershell'
}

Stop-Tasks

