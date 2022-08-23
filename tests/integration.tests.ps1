BeforeAll {
   function Merge-Streams {
      param (
         $script
      )

   (& $script 2>&1) |
      ForEach-Object -Begin { $line = '' } -Process {
         # There are some inconsistencies in errors, some "lines" are split into multiple
         # error objects and some are not. This following hack attempts to clean things
         # by "joining" the split errors.
         if ($_ -is [System.Management.Automation.ErrorRecord]) {
            if ($null -eq $_.TargetObject) {
               $line += $_.Exception.Message
               if ($_.Exception.Message[$_.Exception.Message.Length - 1] -ne 10) {
                  return
               }
               $line = $line.Trim()
            }
            else {
               $line = $_.Exception.Message
            }
         }
         else {
            $line = $_
         }

         Write-Output $line

         $line = ''
      }
   }
}

Describe "Running tasks from gulp" {

   Context "Run 'posh:write:all'" {
      BeforeAll {
         Push-Location $PSScriptRoot
         $script:result = Merge-Streams { npx gulp posh:write:all }
      }
      AfterAll {
         Pop-Location
      }

      It "Line <line> is like <expected>" -TestCases @(
         @{ Line = 0; Expected = "* Importing Tasks *" }
         @{ Line = 1; Expected = "*" }
         @{ Line = 2; Expected = "*" }
         @{ Line = 3; Expected = "*" }
         @{ Line = 4; Expected = "* simple write-host" }
         @{ Line = 5; Expected = "* simple write-output" }
         @{ Line = 6; Expected = "* simple write-error" }
         @{ Line = 7; Expected = "* simple write-warning" }
         @{ Line = 8; Expected = "* simple write-information" }
      ) {
         $script:result[$line] | Should -BeLike $expected
      }

   }

   Context "Run 'posh:write:all' with verbose" {
      BeforeAll {
         Push-Location $PSScriptRoot
         $script:result = Merge-Streams { npx gulp posh:write:all --verbose }
      }
      AfterAll {
         Pop-Location
      }

      It "Line <line> is like <expected>" -TestCases @(
         @{ Line = 0; Expected = "* Importing Tasks *" }
         @{ Line = 1; Expected = "*" }
         @{ Line = 2; Expected = "*" }
         @{ Line = 3; Expected = "*" }
         @{ Line = 4; Expected = "* simple write-host" }
         @{ Line = 5; Expected = "* simple write-output" }
         @{ Line = 6; Expected = "* simple write-error" }
         @{ Line = 7; Expected = "* simple write-warning" }
         @{ Line = 8; Expected = "* simple write-information" }
         @{ Line = 9; Expected = "* simple write-verbose" }
         @{ Line = 10; Expected = "* simple write-debug" }
      ) {
         $script:result[$line] | Should -BeLike $expected
      }

   }

}
