[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateRange(0, [int]::MaxValue)]
    [int]$N
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-Fibonacci {
    [CmdletBinding()]
    [OutputType([int])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, [int]::MaxValue)]
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

if ($MyInvocation.InvocationName -ne '.') {
    $result = Get-Fibonacci -N $N
    Write-Host "Fibonacci($N) = $result"
}
