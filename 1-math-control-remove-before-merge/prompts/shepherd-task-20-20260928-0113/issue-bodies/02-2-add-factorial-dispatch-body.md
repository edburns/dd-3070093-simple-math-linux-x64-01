## Campaign context and required reading

On the `experiment/shepherd-control` branch, the directory `1-math-control-remove-before-merge` contains the plan (`math-tool-ignorance-reduction-plan.md`) and supporting resources (diagrams, decision records). Spike subdirectories are research artifacts — read the plan's Resolution sections for findings, not the spike source code.

Read the entire plan before working. Then carefully re-read these exact sections:

- `## Ignorance reduction`
- `### Repository-owned validation`
- `### Output and ordering contracts`
- `## Implementation`
- `### 1. Implement Fibonacci with unit and isolated CLI coverage`
- `### 2. Add factorial and operation dispatch`

The resolved validation decision is that the only canonical acceptance command is:

```text
pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1
```

The repository-owned runner imports exactly Pester 5.7.1 and runs the root-level `math-tool.Tests.ps1`; the workflow `.github/workflows/shepherd-task-math-tool.yml` installs that exact Pester version and invokes the runner. Do not replace, bypass, or weaken this path.

The resolved behavior and ordering contract is:

- Direct CLI execution writes exactly one result line to stdout: `Fibonacci(N) = value` or `Factorial(N) = value`.
- Both functions return only their numeric value, with no incidental output.
- Inputs are non-negative integers.
- The production and test files remain repository-root `math-tool.ps1` and `math-tool.Tests.ps1`.
- This task depends on task 1 having been merged and must preserve all Fibonacci behavior.

Research found no spike source artifacts to reuse. Implement production behavior and production tests from the plan's resolved contracts rather than copying research code.

## Branch and execution order

Use `experiment/shepherd-control` from remote `origin` as the PR base branch. Do not target `main`.

This is task 2 of 2. Tasks are assigned, completed, and merged serially in plan order. Do not start work until this issue is assigned to you and task 1 has been merged into `experiment/shepherd-control`. Build on the merged task-1 implementation rather than recreating it.

## Implement

Extend the existing root-level `math-tool.ps1`:

- Add a pure `Get-Factorial` function.
- Return `1` for both `N=0` and `N=1`, and the correct factorial for representative positive input.
- Add an `Operation` parameter that dispatches between `fibonacci` and `factorial` while retaining `N`.
- Preserve direct invocation without an explicit operation as Fibonacci behavior, so task-1 CLI usage and output remain compatible.
- For Fibonacci dispatch, print exactly `Fibonacci(N) = value`.
- For factorial dispatch, print exactly `Factorial(N) = value`.
- Ensure each direct invocation emits exactly one result line and each function emits only its numeric return value.
- Constrain operation selection to the two specified operations and keep non-negative-integer validation for `N`.

Extend the existing root-level `math-tool.Tests.ps1`:

- Add dot-sourced unit coverage for `Get-Factorial` at `N=0`, `N=1`, and at least one small representative positive value.
- Add isolated child-`pwsh` process coverage for factorial dispatch and exact output.
- Retain and run all task-1 Fibonacci unit and isolated CLI tests.
- Add dispatch-focused coverage proving both explicit operations route to the correct function and format.
- Add compatibility coverage proving omitted `Operation` still follows the original Fibonacci CLI behavior.

Keep the implementation and test suite objective, deterministic, and small.

## Completion gates

- `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1` exits zero for the combined regression suite using the repository-owned Pester 5.7.1 runner.
- The pinned pull-request workflow passes.
- Factorial unit tests prove numeric-only results for `0`, `1`, and a representative positive input.
- Isolated child-process tests prove exact single-line factorial output with no extra stdout.
- The complete task-1 Fibonacci suite remains green and verifies unchanged output and numeric return behavior.
- Dispatch tests discriminate `fibonacci` from `factorial`, and a compatibility test proves the default invocation remains Fibonacci.
- Invalid operation or invalid negative input cannot be silently treated as a successful valid calculation.
- `git diff` is limited to the math tool and its tests unless a directly necessary repository-owned test adjustment is justified.

## Out of scope

- New mathematical operations beyond Fibonacci and factorial.
- Changing the exact output strings, adding interactive prompts, or introducing alternate output formats.
- Replacing or modifying the canonical test runner, the pinned Pester version, or the workflow.
- Packaging, performance optimization for large inputs, unrelated refactoring, or broad error-handling redesign.
- Reading, adapting, or copying any spike source code or spike test infrastructure.
