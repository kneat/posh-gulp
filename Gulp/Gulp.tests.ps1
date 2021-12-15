Describe "Publish-Tasks @()" {

    BeforeEach {
        Import-Module "$PSScriptRoot\..\Gulp" -force
    }

    AfterEach {
        Remove-Module Gulp
    }

    Context "No Tasks added" {
        BeforeEach {
            $result = Publish-Tasks @()
        }
        It "should have output of {}" {
            $result | Should Be "{}"
        }
    }

    Context "One task with empty deps and no action" {
        BeforeEach {
            Add-Task 'empty' @()
            $result = Publish-Tasks @()
        }
        It "published should be {""empty"":[]]}" {
            $result | Should Be "{""empty"":[]}"
        }
    }

    Context "Three task with no deps or action" {
        BeforeEach {
            Add-Task "one"
            Add-Task "three" -action {}
            Add-Task "two" @() {}
            $result = Publish-Tasks @()
        }
        It 'result should be {"one":[],"three":[],"two":[]}' {
            $result | Should Be  '{"one":[],"three":[],"two":[]}'
        }
    }
}

Describe "Publish-Tasks 'name'" {

    BeforeEach {
        Import-Module "$PSScriptRoot\..\Gulp" -force
    }

    AfterEach {
        Remove-Module Gulp
    }

    Context "'name' outputs 'test output arg0'" {
        BeforeEach {
            Add-Task 'name' @() {param([string] $arg0) "test output" + $arg0} ' arg0'
            $result = Publish-Tasks 'name'
        }
        It "named on publish should output 'test output arg0'" {
            $result | Should Match """test output arg0"""
        }
    }

    Context "'name' outputs 'test output arg1'" {
        BeforeEach {
            Add-Task 'name' @() {param([string] $arg0, [string] $arg1) "test output" + $arg1} @(' arg0', ' arg1')
            $result = Publish-Tasks 'name'
        }
        It "named on publish should output 'test output arg1'" {
            $result | Should Match """test output arg1"""
        }
    }

    Context "'name' outputs 'test output'" {
        BeforeEach {
            Add-Task 'name' @() {"test output"}
            $result = Publish-Tasks 'name'
        }
        It "named on publish should output 'test output'" {
            $result | Should Match """test output"""
        }
    }
    Context "'name' is empty task" {
        BeforeEach {
            Add-Task 'name' @()
            $result = Publish-Tasks 'name'
        }
        It "should have no output" {
            $result | Should BeLike ""
        }
    }
    Context "'name' prints `$PSScriptRoot" {
        BeforeEach {
            Add-Task 'name' @() {
                $PSScriptRoot
            }
            $result = Publish-Tasks 'name'
        }
        It "result should be like ""*\Gulp""" {
            ($result | ConvertFrom-Json).Message | Should BeLike "*\Gulp"
        }
    }
    Context "'name' writes 'fail' error" {
        BeforeEach {
            Add-Task "name" @() {
                Write-Error 'fail'
            }
            $warnings = $((
                $errors = $((
                    $result = Publish-Tasks "name"
                ) > $null) 2>&1
            ) > $null) 3>&1
        }
        It "result should be 'fail'" {
            $result | Should Match """fail"""
        }
        It "error stream should be null" {
            $errors | Should Be $null
        }
        It "warning stream should be null" {
            $warnings | Should Be $null
        }
    }
    Context "'name' writes 'careful!' warning" {
        BeforeEach {
            Add-Task "name" @() {
                Write-Warning 'careful!'
            }
            $warnings = $((
                $errors = $((
                    $result = Publish-Tasks "name"
                ) > $null) 2>&1
            ) > $null) 3>&1
        }
        It 'result message should be "careful!"' {
           ($result | ConvertFrom-Json).Message | Should Be "careful!"
        }
        It 'result level should be "warning"' {
           ($result | ConvertFrom-Json).Level | Should Be "warning"
        }
        It "error stream should be null" {
            $errors | Should Be $null
        }
        It "warning stream should be null" {
            $warnings | Should Be $null
        }
    }
}