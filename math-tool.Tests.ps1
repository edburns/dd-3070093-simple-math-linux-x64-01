Set-StrictMode -Version Latest

BeforeAll {
    $script:ImplementationPath = Join-Path $PSScriptRoot 'math-tool.ps1'
    . $script:ImplementationPath -N 0
}

Describe 'Get-Fibonacci' {
    It 'returns 0 for N=0' {
        Get-Fibonacci -N 0 | Should -Be 0
    }

    It 'returns 1 for N=1' {
        Get-Fibonacci -N 1 | Should -Be 1
    }

    It 'returns the correct Fibonacci number for a representative positive value' {
        Get-Fibonacci -N 10 | Should -Be 55
    }

    It 'returns the largest Fibonacci number representable by Int32' {
        Get-Fibonacci -N 46 | Should -Be 1836311903
    }

    It 'rejects values whose Fibonacci number exceeds Int32' {
        { Get-Fibonacci -N 47 } | Should -Throw
    }

    It 'emits only its numeric return value, with no incidental output' {
        $output = @(Get-Fibonacci -N 10)
        $output.Count | Should -Be 1
        $output[0] | Should -Be 55
    }
}

Describe 'math-tool.ps1 direct CLI execution' {
    BeforeAll {
        function Invoke-MathTool {
            param(
                [int]$N
            )

            $stdout = & pwsh -NoLogo -NoProfile -File $script:ImplementationPath -N $N
            [pscustomobject]@{
                ExitCode = $LASTEXITCODE
                Stdout   = @($stdout)
            }
        }
    }

    It 'prints exactly one line "Fibonacci(0) = 0" for N=0' {
        $result = Invoke-MathTool -N 0
        $result.ExitCode | Should -Be 0
        $result.Stdout.Count | Should -Be 1
        $result.Stdout[0] | Should -Be 'Fibonacci(0) = 0'
    }

    It 'prints exactly one line "Fibonacci(1) = 1" for N=1' {
        $result = Invoke-MathTool -N 1
        $result.ExitCode | Should -Be 0
        $result.Stdout.Count | Should -Be 1
        $result.Stdout[0] | Should -Be 'Fibonacci(1) = 1'
    }

    It 'prints exactly one line "Fibonacci(10) = 55" for a representative positive value' {
        $result = Invoke-MathTool -N 10
        $result.ExitCode | Should -Be 0
        $result.Stdout.Count | Should -Be 1
        $result.Stdout[0] | Should -Be 'Fibonacci(10) = 55'
    }

    It 'rejects values whose Fibonacci number exceeds Int32' {
        $result = Invoke-MathTool -N 47
        $result.ExitCode | Should -Not -Be 0
        $result.Stdout.Count | Should -Be 0
    }

    It 'does not contaminate Get-Fibonacci results with CLI formatting output' {
        $result = Invoke-MathTool -N 10
        $result.Stdout[0] | Should -Not -Be (Get-Fibonacci -N 10)
        $result.Stdout[0] | Should -Match '^Fibonacci\(10\) = 55$'
    }
}
