function Write-Gulp {
    [CmdletBinding()]
    param(  
        [Parameter(
            Position=0, 
            Mandatory=$true, 
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)
        ]
        [String[]]$Entries
    ) 
    process {
        foreach ($entry in $Entries) {
            Write-Host "[" -nonewline
            Write-Host (date).ToString("HH:mm:ss") -foregroundcolor "DarkGray" -nonewline
            Write-Host "] " -nonewline
            Write-Host $entry
        }
    }
}

Export-ModuleMember -Function Write-Gulp