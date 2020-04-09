Function Merge-Streams ($script){
   (& $script 2>&1) |
      ForEach-Object {$line = ''} {
         # There are some inconsistencies in errors, some "lines" are split into multiple
         # error objects and some are not. This following hack attempts to clean things
         # by "joining" the split errors.
         if ($_ -is [System.Management.Automation.ErrorRecord]) {
            if ($_.TargetObject -eq $null) {
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

Describe "Running tasks from gulp" {

   Context "Run 'posh:write:all'" {
      BeforeAll {
         Push-Location $PSScriptRoot
         $result = Merge-Streams {npx gulp posh:write:all}
      }
      AfterAll {
         Pop-Location
      }

      @(
         "* Importing Tasks *"
         "*"
         "*"
         "* simple write-host"
         "* simple write-output"
         "* simple write-error"
         "* simple write-warning"
         "* simple write-information"
      ) | ForEach-Object { $i = 0; $line = '' } {

         It "line $i is like '$_'" {
            $result[$i] | Should BeLike $_
         }

         $i++
      }
   }

   Context "Run 'posh:write:all' with verbose" {
      BeforeAll {
         Push-Location $PSScriptRoot
         $result = Merge-Streams {npx gulp posh:write:all --verbose}
      }
      AfterAll {
         Pop-Location
      }

      @(
         "* Importing Tasks *"
         "*"
         "*"
         "* simple write-host"
         "* simple write-output"
         "* simple write-error"
         "* simple write-warning"
         "* simple write-information"
         "* simple write-verbose"
         "* simple write-debug"
      ) | ForEach-Object { $i = 0 } {
         It "line $i is like '$_'" {
            $result[$i] | Should BeLike $_
         }
         $i++
      }
   }

}
