Import-Module ../Gulp

Add-Task "posh:write:all" @() {
    Write-Host 'simple write-host'
    Write-Output 'simple write-output'
    Write-Error 'simple write-error'
    Write-Warning 'simple write-warning'
}

Publish-Tasks $args