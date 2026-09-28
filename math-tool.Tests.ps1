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

Describe 'Get-Factorial' {
    It 'returns 1 for N=0' {
        Get-Factorial -N 0 | Should -Be 1
    }

    It 'returns 1 for N=1' {
        Get-Factorial -N 1 | Should -Be 1
    }

    It 'returns the correct factorial for a representative positive value' {
        Get-Factorial -N 5 | Should -Be 120
    }

    It 'emits only its numeric return value, with no incidental output' {
        $output = @(Get-Factorial -N 5)
        $output.Count | Should -Be 1
        $output[0] | Should -Be 120
        ($output[0] -is [System.Numerics.BigInteger]) | Should -BeTrue
    }
}

Describe 'math-tool.ps1 direct CLI execution' {
    BeforeAll {
        function Invoke-MathTool {
            param(
                [int]$N,
                [string]$Operation
            )

            $stderrPath = [System.IO.Path]::GetTempFileName()
            try {
                $arguments = @('-NoLogo', '-NoProfile', '-File', $script:ImplementationPath, '-N', $N)
                if ($PSBoundParameters.ContainsKey('Operation')) {
                    $arguments += @('-Operation', $Operation)
                }
                $stdout = & pwsh @arguments 2> $stderrPath
                $exitCode = $LASTEXITCODE
                $stderr = @(Get-Content -LiteralPath $stderrPath)
            }
            finally {
                Remove-Item -LiteralPath $stderrPath -Force
            }

            [pscustomobject]@{
                ExitCode = $exitCode
                Stdout   = @($stdout)
                Stderr   = $stderr
            }
        }
    }

    It 'prints exactly one line "Fibonacci(0) = 0" for N=0 when operation is omitted' {
        $result = Invoke-MathTool -N 0
        $result.ExitCode | Should -Be 0
        $result.Stdout.Count | Should -Be 1
        $result.Stdout[0] | Should -Be 'Fibonacci(0) = 0'
    }

    It 'dispatches explicitly to Fibonacci and prints exactly one formatted line' {
        $result = Invoke-MathTool -N 1 -Operation fibonacci
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

    It 'dispatches to factorial and prints exactly one formatted line' {
        $result = Invoke-MathTool -N 5 -Operation factorial
        $result.ExitCode | Should -Be 0
        $result.Stdout.Count | Should -Be 1
        $result.Stdout[0] | Should -Be 'Factorial(5) = 120'
    }

    It 'rejects values whose Fibonacci number exceeds Int32' {
        $result = Invoke-MathTool -N 47
        $result.ExitCode | Should -Not -Be 0
        $result.Stdout.Count | Should -Be 0
        $result.Stderr -join "`n" | Should -Match 'maximum allowed range of 46'
    }

    It 'does not contaminate Get-Fibonacci results with CLI formatting output' {
        $result = Invoke-MathTool -N 10
        $result.Stdout[0] | Should -Not -Be (Get-Fibonacci -N 10)
        $result.Stdout[0] | Should -Match '^Fibonacci\(10\) = 55$'
    }

    It 'rejects operations outside the supported set' {
        $result = Invoke-MathTool -N 5 -Operation unsupported
        $result.ExitCode | Should -Not -Be 0
        $result.Stdout.Count | Should -Be 0
    }

    It 'rejects negative inputs' {
        $result = Invoke-MathTool -N -1 -Operation factorial
        $result.ExitCode | Should -Not -Be 0
        $result.Stdout.Count | Should -Be 0
    }
}
