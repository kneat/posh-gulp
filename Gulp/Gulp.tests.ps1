$moduleLocation = "$PSScriptRoot\..\Gulp"

Describe "Publish-Tasks" {
    Context "No Tasks" {
        Import-Module $moduleLocation -force           
        $result = Publish-Tasks @()
        It "should be {}" {
            $result | Should Be "{}"
        }       
    }
    Context "One task with empty deps and no action" {
        Import-Module $moduleLocation -force           
        Add-Task 'empty' @()
        $result = Publish-Tasks @()
        It "should be {""empty"":[]]}" {
            $result | Should Be "{""empty"":[]}"
        }       
    }
    Context "Three task with no deps or action" {
        Import-Module $moduleLocation -force           
        Add-Task "one"
        Add-Task "two"
        Add-Task "three"
        $result = Publish-Tasks @()
        It "should contain ""one"":null" {
            $result | Should BeLike  "*""one"":null*"
        }       
        It "should contain ""two"":null" {
            $result | Should BeLike  "*""two"":null*"
        }       
        It "should contain ""three"":null" {
            $result | Should BeLike  "*""three"":null*"
        }       
    }
}