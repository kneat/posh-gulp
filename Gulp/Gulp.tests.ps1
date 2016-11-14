Describe "Publish-Tasks" {

    BeforeEach {
        Import-Module "$PSScriptRoot\..\Gulp" -force
    }

    AfterEach {
        Remove-Module Gulp
    }

    Context "No Tasks" {
        BeforeEach {
            $result = Publish-Tasks @()
        }
        It "should have output of {}" {
            $result | Should Be "{}"
        }       
    }
    Context "Simple task outputs 'test output'" {
        BeforeEach {
            Add-Task 'simple' @() {"test output"}
        }
        It "named on publish should output 'test output'" {
            Publish-Tasks 'simple' | Should Be "test output"
        }       
    }
    Context "One task with empty deps and no action" {
        BeforeEach {
            Add-Task 'empty' @()
        }
        It "published should be {""empty"":[]]}" {
            Publish-Tasks @() | Should Be "{""empty"":[]}"
        }       
        It "Publish-Tasks 'empty' have no output" {
            Publish-Tasks @('empty') | Should BeLike ""
        }       
    }
    Context "Three task with no deps or action" {
        BeforeEach {
            Add-Task "one"
            Add-Task "two" @() {}
            Add-Task "three" -action {}
        }
        It "should contain ""one"":[]" {
            Publish-Tasks @() | Should BeLike  "*""one"":``[``]*"
        }       
        It "should contain ""two"":[]" {
            Publish-Tasks @() | Should BeLike  "*""two"":``[``]*"
        }       
        It "should contain ""three"":[]" {
            Publish-Tasks @() | Should BeLike  "*""three"":``[``]*"
        }       
    }
    Context "`$PSScriptRoot should not be empty" {
        BeforeEach {
            Add-Task 'root' @() {
                $PSScriptRoot
            }
        }
        It "task run" {
            Publish-Tasks @('root') | Should BeLike "*\Gulp"
        }       
    }
}

Describe "Publish-Tasks errors" {
    BeforeEach {
        Import-Module "$PSScriptRoot\..\Gulp"

        Add-Task "errors" @() {
            Write-Error "fail"
        }
    }

    AfterEach {
        Remove-Module Gulp
    }

    Context "Get-Task not during task execution" {
        It "error stream should contain fail" {
            $(Publish-Tasks "errors" > $null) 2>&1 |
                Should BeLike "*fail*"
        }       
    } 
}

Describe "Get-Task" {
    BeforeEach {
        Import-Module "$PSScriptRoot\..\Gulp"
    }

    AfterEach {
        Remove-Module Gulp
    }
 
    Context "Get-Task not during task execution" {
        It "should return null" {
            Get-Task | Should Be $null
        }       
    } 
    Context "inside running task 'my:task'" {
        BeforeEach {
            Add-Task 'my:task' @() {
                Get-Task
            }
        }
        It "should return" {
            Publish-Tasks @('my:task') | Should Be "my:task"
        }       
    }
    Context "after running task 'my:task'" {
        BeforeEach {
            Add-Task 'my:task' @() {}
        }
        It "should return null" {
            Publish-Tasks @('my:task')
            Get-Task | Should Be $null
        }  
    } 
}