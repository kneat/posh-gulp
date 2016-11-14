$loggerLocation = "$PSScriptRoot\..\Logger"
$gulpLocation = "$PSScriptRoot\..\Gulp"
Import-Module $loggerLocation -force           

function catchHost($expression){
    $line = {@()}.invoke()
    $($expression.invoke() > $null) 6>&1 | %{
        $line.Add($_.ToString())
        if (!$_.MessageData.NoNewLine){
            Write-Output ($line -join '')
            $line.Clear()
        }    
    }
}

Describe "Write-Gulp" {
    Context "Write-Gulp hello world" {
        $result = catchHost{
            Write-Gulp "hello world"
        }
        It "should have one output object" {
            $result.Count | Should Be 1
        }       
        It "should have output of '[??:??:??] hello world'" {
            $result | Should BeLike "``[??:??:??``] hello world"
        }
    }
    Context "hello world | Write-Gulp" {
        $result = catchHost{
            "hello world" | Write-Gulp
        }
        It "should have one output object" {
            $result.Count | Should Be 1
        }       
        It "should have output of *hello world" {
            $result | Should BeLike "*hello world"
        }       
    }
    Context "hello, world | Write-Gulp" {
        $result = catchHost{
            "hello", "world" | Write-Gulp
        }
        It "should have 2 output objects" {
            $result.Count | Should Be 2
        }       
        It "first line like *hello" {
            $result[0] | Should BeLike "*hello"
        }       
        It "second line like *world" {
            $result[1] | Should BeLike "*world"
        }       
    }   
}

Remove-Module Logger
