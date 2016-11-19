Import-Module ../Gulp

Add-Task "posh:write:all" @() {
    Write-Host 'simple write-host'
    Write-Output 'simple write-output'
    Write-Error 'simple write-error'
    Write-Warning 'simple write-warning'
    Write-Information 'simple write-information'
    Write-Verbose 'simple write-verbose'
    Write-Debug 'simple write-debug'
}

Publish-Tasks $args