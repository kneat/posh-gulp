function Write-Gulp {
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
            "[$((date).ToString("HH:mm:ss"))] $entry"
        }
    }
}

Export-ModuleMember -Function Write-Gulp