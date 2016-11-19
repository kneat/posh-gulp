Describe "Publish-Tasks @()" {

    Context "gulp posh:write:all" {
        BeforeAll {
            pushd $PSScriptRoot
            $result = gulp posh:write:all
        }
        AfterAll {
            popd
        }
        It "third line is 'simple write-host'" {
            $result[2] | Should Be "simple write-host"
        }
        It "fourth line is 'simple write-output'" {
            $result[3] | Should Be "simple write-output"
        }
        It "fifth line is 'simple write-error'" {
            $result[4] | Should Be "simple write-error"
        }
        It "sixth line is 'simple write-warning'" {
            $result[5] | Should Be "simple write-warning"
        }
        It "seventh line is 'simple write-information'" {
            $result[6] | Should Be "simple write-information"
        }
        It "eight line is 'simple write-verbose'" {
            $result[7] | Should Be "simple write-verbose"
        }
        It "ninth line is 'simple write-debug'" {
            $result[8] | Should Be "simple write-debug"
        }
    }

}
