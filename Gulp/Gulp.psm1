$script:taskDeps = @{}
$script:taskBlocks = New-Object -TypeName PSObject

function Add-Task {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $name,
        [string[]]
        $deps = @(),
        [ScriptBlock]
        $action = {}
    )
    process {
        $script:taskDeps[$name] = $deps        
        $script:taskBlocks |
            Add-Member `
                -MemberType ScriptMethod `
                -Name $name `
                -Value $action
    }
}

function Export-Tasks(){
    $script:taskDeps | ConvertTo-Json -Compress   
}

function Invoke-Task($name){
    $script:taskBlocks.$name()
}

function Publish-Tasks{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [AllowEmptyCollection()]
        [string[]] $execute
    )
    process {
        if ($execute) {
            Invoke-Task $execute[0]
        } else {
            Export-Tasks        
        }
    }
} 

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

Export-ModuleMember -Function Add-Task, Publish-Tasks, Write-Gulp