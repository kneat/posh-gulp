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
        Add-Task "two" @()
        Add-Task "three"
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
}