## Campaign context and required reading

On the `experiment/shepherd-control` branch, the directory `1-math-control-remove-before-merge` contains the plan (`math-tool-ignorance-reduction-plan.md`) and supporting resources (diagrams, decision records). Spike subdirectories are research artifacts — read the plan's Resolution sections for findings, not the spike source code.

Read the entire plan before working. Then carefully re-read these exact sections:

- `## Ignorance reduction`
- `### Repository-owned validation`
- `### Output and ordering contracts`
- `## Implementation`
- `### 1. Implement Fibonacci with unit and isolated CLI coverage`

The resolved validation decision is that the only canonical acceptance command is:

```text
pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1
```

The repository-owned runner imports exactly Pester 5.7.1 and runs the root-level `math-tool.Tests.ps1`; the workflow `.github/workflows/shepherd-task-math-tool.yml` installs that exact Pester version and invokes the runner. Do not replace, bypass, or weaken this path.

The resolved behavior contract is:

- Direct CLI execution writes exactly one result line to stdout in the form `Fibonacci(N) = value`.
- `Get-Fibonacci` returns only the numeric result, with no incidental output.
- `N` is a non-negative integer.
- The production and test files are repository-root `math-tool.ps1` and `math-tool.Tests.ps1`.
- Work is serial; this first task must merge before task 2 starts.

Research found no spike source artifacts to reuse. Implement production behavior and production tests from the plan's resolved contracts rather than copying research code.

## Branch and execution order

Use `experiment/shepherd-control` from remote `origin` as the PR base branch. Do not target `main`.

This is task 1 of 2. Tasks are assigned, completed, and merged serially in plan order. Do not start work until this issue is assigned to you. Task 2 must not start until this task is merged into `experiment/shepherd-control`.

## Implement

Create repository-root `math-tool.ps1` and `math-tool.Tests.ps1` together.

In `math-tool.ps1`:

- Declare a script parameter named `N` that accepts non-negative integer input.
- Implement a pure `Get-Fibonacci` function.
- Return `0` for `N=0`, `1` for `N=1`, and the correct Fibonacci number for representative positive input.
- Ensure invoking the function emits only its numeric return value.
- When the script is directly executed, print exactly one stdout line: `Fibonacci(N) = value`, substituting the input and result.
- Keep direct-execution output separate from function behavior so dot-sourced unit tests do not receive CLI formatting output.

In `math-tool.Tests.ps1`:

- Dot-source `math-tool.ps1` and unit-test `Get-Fibonacci`.
- Cover `N=0`, `N=1`, and at least one small representative positive value.
- Launch isolated child `pwsh` processes to test direct CLI execution rather than treating an in-process function call as a CLI test.
- For each CLI case, assert successful exit and exact stdout with no additional lines or incidental output.

Follow existing repository PowerShell conventions: strict failures must remain visible, tests must be deterministic, and no external service or network access may be required.

## Completion gates

- `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1` exits zero locally using the repository-owned Pester 5.7.1 runner.
- The pinned pull-request workflow passes.
- Unit tests prove the numeric return values for `0`, `1`, and a representative positive input.
- Isolated child-process tests prove exact single-line CLI output for the same boundary and representative cases.
- A regression assertion distinguishes function output from CLI formatting, preventing incidental output from contaminating `Get-Fibonacci` results.
- `git diff` shows both root-level files introduced together and no unrelated production changes.

## Out of scope

- Factorial support and operation dispatch; those belong to task 2.
- Replacing or modifying the canonical test runner, the pinned Pester version, or the workflow.
- Additional operations, interactive prompts, alternate output formats, negative-number semantics, packaging, or unrelated refactoring.
- Reading, adapting, or copying any spike source code or spike test infrastructure.
