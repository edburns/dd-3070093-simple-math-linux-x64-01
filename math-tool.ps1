[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateRange(0, [int]::MaxValue)]
    [int]$N,
    [ValidateSet('fibonacci', 'factorial')]
    [string]$Operation = 'fibonacci'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-Fibonacci {
    [CmdletBinding()]
    [OutputType([int])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, 46)]
        [int]$N
    )

    if ($N -eq 0) {
        return 0
    }
    if ($N -eq 1) {
        return 1
    }

    $previous = 0
    $current = 1
    for ($i = 2; $i -le $N; $i++) {
        $next = $previous + $current
        $previous = $current
        $current = $next
    }

    return $current
}

function Get-Factorial {
    [CmdletBinding()]
    [OutputType([System.Numerics.BigInteger])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$N
    )

    [System.Numerics.BigInteger]$result = 1
    for ($i = 2; $i -le $N; $i++) {
        $result *= $i
    }

    return $result
}

if ($MyInvocation.InvocationName -ne '.') {
    if ($Operation -eq 'fibonacci') {
        $result = Get-Fibonacci -N $N
        Write-Output "Fibonacci($N) = $result"
    }
    else {
        $result = Get-Factorial -N $N
        Write-Output "Factorial($N) = $result"
    }
}
