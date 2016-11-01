$moduleLocation = "$PSScriptRoot\..\Logger"
Remove-Module Logger           

Describe "Write-Gulp" {
    Context "Write-Gulp hello world" {
        Import-Module $moduleLocation -force           
        $result = Write-Gulp "hello world"
        It "should have one output object" {
            $result.Count | Should Be 1
        }       
        It "should have output of '[...] hello world'" {
            $result | Should BeLike "``[??:??:??``] hello world"
        }
    }
    Context "hello world | Write-Gulp" {
        Import-Module $moduleLocation -force           
        $result = "hello world" | Write-Gulp
        It "should have one output object" {
            $result.Count | Should Be 1
        }       
        It "should have output of *hello world" {
            $result | Should BeLike "*hello world"
        }       
    }
    Context "hello, world | Write-Gulp" {
        Import-Module $moduleLocation -force           
        $result = "hello",  "world" | Write-Gulp
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