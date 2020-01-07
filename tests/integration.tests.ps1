Describe "Running tasks from gulp" {

   Context "Run 'posh:write:all'" {
      BeforeAll {
         Push-Location $PSScriptRoot
         $result = gulp posh:write:all
      }
      AfterAll {
         Pop-Location
      }

      @(
         "* Importing Tasks *"
         "*"
         "*"
         "simple write-host"
         "simple write-output"
         "simple write-error"
         "simple write-warning"
         "simple write-information"
         "simple write-verbose"
         "simple write-debug"
      ) | ForEach-Object { $i = 0 } {
         It "line $i is like '$_'" {
            $result[$i] | Should BeLike $_
         }
         $i++
      }
   }

}
