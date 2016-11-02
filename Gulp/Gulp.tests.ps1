$moduleLocation = "$PSScriptRoot\..\Gulp"
Remove-Module Gulp           

Describe "Publish-Tasks" {
    Context "No Tasks" {
        Import-Module $moduleLocation -force           
        $result = Publish-Tasks @()
        It "should have output of {}" {
            $result | Should Be "{}"
        }       
    }
    Context "Simple task outputs 'test output'" {
        Import-Module $moduleLocation -force           
        Add-Task 'simple' @() {"test output"}
        It "named on publish should output 'test output'" {
            Publish-Tasks 'simple' | Should Be "test output"
        }       
    }
    Context "One task with empty deps and no action" {
        Import-Module $moduleLocation -force           
        Add-Task 'empty' @()
        It "published should be {""empty"":[]]}" {
            Publish-Tasks @() | Should Be "{""empty"":[]}"
        }       
        It "Publish-Tasks 'empty' have no output" {
            Publish-Tasks @('empty') | Should BeLike ""
        }       
    }
    Context "Three task with no deps or action" {
        Import-Module $moduleLocation -force           
        Add-Task "one"
        Add-Task "two" @() {}
        Add-Task "three" -action {}
        $result = Publish-Tasks @()
        It "should contain ""one"":[]" {
            $result | Should BeLike  "*""one"":``[``]*"
        }       
        It "should contain ""two"":[]" {
            $result | Should BeLike  "*""two"":``[``]*"
        }       
        It "should contain ""three"":[]" {
            $result | Should BeLike  "*""three"":``[``]*"
        }       
    }
    Context "`$PSScriptRoot should not be empty" {
        Import-Module $moduleLocation -force           
        Add-Task 'root' @() {
            $PSScriptRoot
        }
        It "task run" {
            Publish-Tasks @('root') | Should BeLike "*\Gulp"
        }       
    }
}

Describe "Get-Task" {
   Context "Get-Task not during task execution" {
        Import-Module $moduleLocation -force           
        It "should return null" {
            Get-Task | Should Be $null
        }       
    } 
    Context "inside running task 'my:task'" {
        Import-Module $moduleLocation -force           
        Add-Task 'my:task' @() {
            It "should return" {
                Get-Task | Should Be "my:task"
            }       
        }
        Publish-Tasks @('my:task')
    }
    Context "after running task 'my:task'" {
        Import-Module $moduleLocation -force           
        Add-Task 'my:task' @() {
        }
        Publish-Tasks @('my:task')
        It "should return null" {
            Get-Task | Should Be $null
        }       
    } 
}
