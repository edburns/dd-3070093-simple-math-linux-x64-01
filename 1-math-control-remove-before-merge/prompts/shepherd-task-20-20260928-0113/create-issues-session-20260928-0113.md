# Copilot CLI Session

> [!NOTE]
> - **Session ID:** `89641437-c4ec-436a-add1-bee3b8e6749b`  
> - **Started:** 9/28/2026, 1:13:05 AM  
> - **Duration:** 1m 39s  
> - **Exported:** 9/28/2026, 1:14:45 AM  

---

<sub>2s</sub>

### User

Invoke skill `shepherd-task-20-create-issues-from-plan` with these inputs:

- CAMPAIGN_ID: adcb73ba-b4e3-443e-ba80-18493643ac26
- LESSON_PROPAGATION: off
- REPO: edburns/dd-3070093-simple-math-linux-x64-01
- BASE_BRANCH: experiment/shepherd-control
- PARENT_ISSUE: 1
- PLAN_DIRECTORY: 1-math-control-remove-before-merge
- PLAN_FILE_NAME: math-tool-ignorance-reduction-plan.md
- QUESTIONS_SECTION: ## Ignorance reduction
- IMPLEMENTATION_SECTION: ## Implementation
- EXPECTED_TASK_COUNT: 2
- BASE_REMOTE: origin
- LOG_DIRECTORY: /home/edburns/workareas/dd-3070093-simple-math-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260928-0113
- DRAFT_VALIDATOR: /home/edburns/.copilot/plugins/shepherd-task/scripts/validate-stage20-drafts.sh
- ISSUE_BODY_VERIFIER: /home/edburns/.copilot/plugins/shepherd-task/scripts/verify-github-issue-body.sh
- CHILD_LINK_VERIFIER: /home/edburns/.copilot/plugins/shepherd-task/scripts/verify-stage20-child-links.sh

Fixture pagination response contract (mandatory):

- `gh api ... --paginate --slurp` returns a JSON array of page payloads, so a
  one-page response has the shape `[[{...}]]`, not `[{...}]`.
- Before indexing child issue fields such as `.id`, normalize the response to
  one flat issue array exactly once.
- In Bash, use:
  `jq 'if length == 0 then [] elif all(.[]; type == "array") then add else . end'`.
- In PowerShell, capture the `gh` output and `$LASTEXITCODE` first, then pass
  the complete JSON through the same `jq` normalization before
  `ConvertFrom-Json`.
- Use the normalized flat array for the pre-creation baseline, final child
  count/order checks, and failure reconciliation. Do not apply `add` a second
  time to an already-flat array.

---

<sub>7s</sub>

### `skill`

**shepherd-task-20-create-issues-from-plan**

<details>
<summary>Arguments</summary>

```json
{
  "skill": "shepherd-task-20-create-issues-from-plan"
}
```

</details>

```
Skill "shepherd-task-20-create-issues-from-plan" loaded successfully. Follow the instructions in the skill context.
```


---

<sub>12s</sub>

### Copilot

I’m validating the campaign inputs, plan structure, repository state, and required drafting conventions before any GitHub mutation.

---

<sub>14s</sub>

### `bash`

**Validate repository and invocation paths**

$ set -euo pipefail
printf 'ROOT=%s\n' "$(git rev-parse --show-toplevel)"
printf '%s\n' '--- remotes ---'
git remote -v
printf '%s\n' '--- branches ---'
git branch -a --no-color
printf '%s\n' '--- default branch ---'
git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || true
printf '%s\n' '--- invocation paths ---'
for p in "/home/edburns/workareas/dd-3070093-simple-math-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260928-0113" "/home/edburns/.copilot/plugins/shepherd-task/scripts/validate-stage20-drafts.sh" "/home/edburns/.copilot/plugins/shepherd-task/scripts/verify-github-issue-body.sh" "/home/edburns/.copilot/plugins/shepherd-task/scripts/verify-stage20-child-links.sh"; do stat -c '%A %U:%G %n' "$p"; done

<details>
<summary>20 lines</summary>

```
ROOT=/home/edburns/workareas/dd-3070093-simple-math-linux-x64-01-shepherd-control
--- remotes ---
origin	git@github.com:edburns/dd-3070093-simple-math-linux-x64-01.git (fetch)
origin	git@github.com:edburns/dd-3070093-simple-math-linux-x64-01.git (push)
--- branches ---
* experiment/shepherd-control
+ experiment/shepherd-shared-baseline
  main
  remotes/origin/HEAD -> origin/main
  remotes/origin/experiment/shepherd-control
  remotes/origin/experiment/shepherd-shared-baseline
  remotes/origin/main
--- default branch ---
origin/main
--- invocation paths ---
drwxr-xr-x edburns:edburns /home/edburns/workareas/dd-3070093-simple-math-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260928-0113
-rwxr-xr-x edburns:edburns /home/edburns/.copilot/plugins/shepherd-task/scripts/validate-stage20-drafts.sh
-rwxr-xr-x edburns:edburns /home/edburns/.copilot/plugins/shepherd-task/scripts/verify-github-issue-body.sh
-rwxr-xr-x edburns:edburns /home/edburns/.copilot/plugins/shepherd-task/scripts/verify-stage20-child-links.sh
<shellId: 1 completed with exit code 0>
```

</details>


---

<sub>14s</sub>

### `bash`

**Read campaign plan and resources**

$ set -euo pipefail
git show 'experiment/shepherd-control:1-math-control-remove-before-merge/math-tool-ignorance-reduction-plan.md'
printf '\n--- CAMPAIGN MANIFEST ---\n'
git show 'experiment/shepherd-control:1-math-control-remove-before-merge/shepherd-campaign.json'
printf '\n--- CAMPAIGN LESSONS EXISTS ---\n'
git cat-file -e 'experiment/shepherd-control:1-math-control-remove-before-merge/campaign-lessons.md' && echo yes
printf '\n--- SUPPORTING TREE ---\n'
git ls-tree -r --name-only experiment/shepherd-control -- '1-math-control-remove-before-merge'

<details>
<summary>63 lines</summary>

```
# PowerShell math-tool control campaign

Build the fixture in two cheap, serial tasks. The repository already contains
deterministic CI pinned to Pester 5.7.1. The acceptance command for every task
is `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1`. Task 2 starts only after task 1 is merged.

## Ignorance reduction

### Repository-owned validation

**Question:** What command and environment define acceptance?

**Resolution:** The committed canonical command is
`pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1`. The baseline workflow
`.github/workflows/shepherd-task-math-tool.yml` installs exactly Pester
5.7.1 and invokes that repository-owned runner. Do not replace or bypass it.

### Output and ordering contracts

**Question:** What externally observable behavior and dependency order are required?

**Resolution:** Direct CLI execution writes exactly one result line to stdout:
`Fibonacci(N) = value` or `Factorial(N) = value`. Functions return the
numeric value without incidental output. Inputs are non-negative integers.
Implementation is serial: task 2 depends on merged task 1. The implementation
and test files are repository-root `math-tool.ps1` and
`math-tool.Tests.ps1`.

## Implementation

### 1. Implement Fibonacci with unit and isolated CLI coverage

Create `math-tool.ps1` with parameter `N` and a pure `Get-Fibonacci`
function. Direct execution must print exactly `Fibonacci(N) = value`.
Create `math-tool.Tests.ps1` containing dot-sourced unit tests for the
function and isolated child-`pwsh` process tests for direct CLI behavior.
Cover N=0, N=1, and a small representative value. Keep changes limited to the
math tool and its tests.

Acceptance: `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1` exits zero and the pinned pull-request CI
passes.

### 2. Add factorial and operation dispatch

After task 1 is merged, extend the same script with a pure `Get-Factorial`
function and an `Operation` parameter that dispatches between `fibonacci`
and `factorial` while retaining `N`. Preserve Fibonacci behavior. Cover
factorial edge cases 0 and 1 plus a small representative value. Keep the
interface and tests objective and small; the issue does not prescribe how to
extend the tests.

Acceptance: `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1` exits zero for the combined regression suite
and the pinned pull-request CI passes.

--- CAMPAIGN MANIFEST ---
{
  "schemaVersion": 1,
  "campaignId": "adcb73ba-b4e3-443e-ba80-18493643ac26",
  "campaignIssueNumber": 1,
  "campaignShortname": "math-control",
  "repository": "edburns/dd-3070093-simple-math-linux-x64-01",
  "baseBranch": "experiment/shepherd-control",
  "lessonPropagation": "off",
  "campaignMetadataDirectory": "1-math-control-remove-before-merge",
  "lessonsFile": "campaign-lessons.md",
  "createdBy": {
    "shepherdTaskVersion": "1.0.5",
    "stageOutcomeProtocolVersion": 1
  },
  "createdAt": "2026-09-28T01:13:02Z"
}

--- CAMPAIGN LESSONS EXISTS ---
yes

--- SUPPORTING TREE ---
1-math-control-remove-before-merge/campaign-lessons.md
1-math-control-remove-before-merge/math-tool-ignorance-reduction-plan.md
1-math-control-remove-before-merge/shepherd-campaign.json
1-math-control-remove-before-merge/shepherd-test-experiment.json
<shellId: 0 completed with exit code 0>
```

</details>


---

<sub>14s</sub>

### `view`

**view the file at /home/edburns/.copilot/skills/shepherd-task-20-create-issues-from-plan/examples/01-1682-java-tool-ergonomics.md.**

/home/edburns/.copilot/skills/shepherd-task-20-create-issues-from-plan/examples/01-1682-java-tool-ergonomics.md

<details>
<summary>15 lines</summary>

```
# Example 01: 1682-java-tool-ergonomics-prompts-remove-before-merge

Read `copilot-sdk/1682-java-tool-ergonomics-prompts-remove-before-merge/dd-3018003-ignorance-reduction-for-implementation-plan.md` (the plan) to get the context.

✅✅Pay very close attention to each **Resolution:** to the questions in `Phase 3 — Ignorance reduction: questions to answer before writing code`.

In this session, we are creating issues of type **Task** as children of Epic https://github.com/github/copilot-sdk/issues/1682 . These issues correspond to the sub-sections in `## Phase 4 — Implementation (the build order)`.

I want you to use `gh` to create issues as sub-issues of 1682.

- I will dispatch these issues by assigning them to an agent. Leave them unassigned for now.

- The description you put in the issues you create is the specification for the work the agent assigned to the issue must do. Therefore, you need to be very specific and targeted when writing the description.

- Set the type to **Task**.

- Each issue will be worked on and resolved in serial. You can assume:
  - All issues will operate in this topic branch of `upstream`: `edburns/1682-java-tool-ergonomics`.

  - The assignee agent has access to the topic branch and, most importantly, to the prompts in the directory `1682-java-tool-ergonomics-prompts-remove-before-merge`, which includes the plan. Therefore, you can instruct the agent to access the plan by reference, you don't need to reference it by value directly in the issue.

- The sub-sections of `## Phase 4 — Implementation (the build order)` have essential details for each corresponding **Task**.

- Instruct the agent to read the entire plan before working.

- Instruct the agent to carefully re-read the relevant sections of the plan. ❌❌You can't just say, "read the relevant sections of the plan". ✅✅In the description of the issue, list exactly what sections of the plan apply to this particular issue.
- Though the sub-sections of `## Phase 4 — Implementation (the build order)` have essential details for each corresponding **Task**, I want you to carefully consider if there are additional gating tests you can add so that as the agent proceeds from one task to the next, the likelihood of rework is reduced.
```

</details>


---

<sub>14s</sub>

### `view`

**view the file at /home/edburns/.copilot/skills/shepherd-task-20-create-issues-from-plan/examples/02-1810-java-tool-as-lambda.md.**

/home/edburns/.copilot/skills/shepherd-task-20-create-issues-from-plan/examples/02-1810-java-tool-as-lambda.md

<details>
<summary>12 lines</summary>

```
# Example 02: 1810-java-tool-ergonomics-tool-as-lambda-remove-before-merge

Carefully read the plan `copilot-sdk/1810-java-tool-ergonomics-tool-as-lambda-remove-before-merge/1810-ignorance-reduction-for-implementation-plan.md`.

We have completed Phases 1 - 3. We are now on Phase 4.

For each sub item in Phase 4, file a child issue of Feature #1810.

Use `gh` to look at Epic #1682 and its child issues for the standard of verbosity and concreteness for issue descriptions.

The issue should be assignable to a coding agent and there must be sufficient detail in the description for the agent to proceed to completion.

Pull out the specific relevant content from Phase 3 as it applies to this current issue in Phase 4.

Tell the agent to take `edburns/1810-java-tool-ergonomics-tool-as-lambda` as the base branch. When I assign the issue to the coding agent, I will set this as the base branch.

Tell the agent to read `1810-java-tool-ergonomics-tool-as-lambda-remove-before-merge/1810-ignorance-reduction-for-implementation-plan.md`, which is present on the branch, for context.

Tell the agent which sub-item within Phase 4 they are solving.

Tell the agent that each issue will be assigned, resolved and merged to the base branch in the order in which they appear in the plan.

No work is to start until I assign each issue to the coding agent, in turn.
```

</details>


---

<sub>14s</sub>

### `view`

**view the file at /home/edburns/.copilot/skills/shepherd-task-20-create-issues-from-plan/examples/03-dd-3017826-java-real-estate-demo.md.**

/home/edburns/.copilot/skills/shepherd-task-20-create-issues-from-plan/examples/03-dd-3017826-java-real-estate-demo.md

<details>
<summary>14 lines</summary>

```
# Example 03: dd-3017826-java-real-estate-demo-remove-before-merge

Read `dd-3017826-java-real-estate-demo-remove-before-merge\dd-3017826-java-real-estate-demo-ignorance-reduction-plan.md` (the plan) to get the context.

✅✅Pay very close attention to each **Resolution:** to the questions in `Phase 2 — Ignorance reduction: questions to answer before writing code`.

In this session, we are creating sub-issues as children of https://github.com/edburns/Build26-BRK206-your-agent-anywhere-multiclient-multidevice-with-github-copilot-sdk/issues/2 . These issues correspond to the sub-sections in `## Phase 3 — Implementation (build order)`.

I want you to use `gh` to create issues as sub-issues of #2.

- I will dispatch these issues by assigning them to an agent. Leave them unassigned for now.

- The description you put in the issues you create is the specification for the work the agent assigned to the issue must do. Therefore, you need to be very specific and targeted when writing the description.

- Each issue will be worked on and resolved in serial. You can assume:
  - All issues will operate in this topic branch of `origin`: `edburns/2-build-out-demo`.

  - The assignee agent has access to the topic branch and, most importantly, to the prompts in the directory `dd-3017826-java-real-estate-demo-remove-before-merge`, which includes the plan. Therefore, you can instruct the agent to access the plan by reference, you don't need to reference it by value directly in the issue.

- The sub-sections of `## Phase 3 — Implementation (build order)` have essential details for each corresponding sub-issue.

- Instruct the agent to read the entire plan before working.

- Instruct the agent to carefully re-read the relevant sections of the plan. ❌❌You can't just say, "read the relevant sections of the plan". ✅✅In the description of the issue, list exactly what sections of the plan apply to this particular issue.
- Though the sub-sections of `## Phase 3 — Implementation (build order)` have essential details for each corresponding sub-issue, I want you to carefully consider if there are additional gating tests you can add so that as the agent proceeds from one task to the next, the likelihood of rework is reduced.
```

</details>


---

<sub>14s</sub>

### `view`

**view the file at /home/edburns/.copilot/skills/shepherd-task-20-create-issues-from-plan/examples/04-28-python-agent-demo.md.**

/home/edburns/.copilot/skills/shepherd-task-20-create-issues-from-plan/examples/04-28-python-agent-demo.md

<details>
<summary>16 lines</summary>

```
# Example 04: 28-python-agent-demo-remove-before-merge

Read `28-python-agent-demo-remove-before-merge/28-python-agent-demo-ignorance-reduction-plan.md` (the plan) to get the context.

✅✅Pay very close attention to each **Resolution:** to the questions in `Phase 2 — Ignorance reduction: questions to answer before writing code`. These pertain to the implementation tasks in Phase 3. ✅✅✅ Include relevant spike findings as self-contained prose in the issue description; do not direct the agent to spike directories or source files.

In this session, we are creating sub-issues as children of https://github.com/edburns/Build26-BRK206-your-agent-anywhere-multiclient-multidevice-with-github-copilot-sdk/issues/28 . These issues correspond to the sub-sections in `## Phase 3 — Implementation (build order)`.

I want you to use `gh` to create issues as sub-issues of #28

- I will dispatch these issues by assigning them to an agent. Leave them unassigned for now.

- The description you put in the issues you create is the specification for the work the agent assigned to the issue must do. Therefore, you need to be very specific and targeted when writing the description.

- Again, ✅✅For each **Resolution:** to the questions in `Phase 2 — Ignorance reduction: questions to answer before writing code`, include the relevant Resolution values in the issue description. These pertain to the implementation tasks in Phase 3. ✅✅✅ State relevant spike findings directly in the issue body with enough detail to implement them without reading spike code.

- For tasks dealing with the UI, make sure to refer to the relevant screengrabs, but only ones within `28-python-agent-demo-remove-before-merge/`.

- Each issue will be worked on and resolved in serial. You can assume:
  - All issues will operate in this topic branch of `origin`: `edburns/28-python-agent-demo`.

  - The assignee agent has access to the topic branch and, most importantly, to the prompts in the directory `28-python-agent-demo-remove-before-merge/`, which includes the plan. Therefore, you can instruct the agent to access the plan by reference, you don't need to reference it by value directly in the issue.

- The sub-sections of `## Phase 3 — Implementation (build order)` have essential details for each corresponding sub-issue.

- Instruct the agent to read the entire plan before working.

- Instruct the agent to carefully re-read the relevant sections of the plan. ❌❌You can't just say, "read the relevant sections of the plan". ✅✅In the description of the issue, list exactly what sections of the plan apply to this particular issue.
- Though the sub-sections of `## Phase 3 — Implementation (build order)` have essential details for each corresponding sub-issue, I want you to carefully consider if there are additional gating tests you can add so that as the agent proceeds from one task to the next, the likelihood of rework is reduced.
```

</details>


---

<sub>14s</sub>

### `view`

**view the file at /home/edburns/.copilot/plugins/shepherd-task/scripts/validate-stage20-drafts.sh.**

/home/edburns/.copilot/plugins/shepherd-task/scripts/validate-stage20-drafts.sh

<details>
<summary>65 lines</summary>

```
#!/usr/bin/env bash
# shepherd-task-version: 1.0.5

set -euo pipefail

[[ $# -eq 3 ]] || {
    echo "Usage: $0 <body-directory> <expected-count> <off|campaign>" >&2
    exit 1
}

body_directory="$1"
expected_count="$2"
lesson_propagation="$3"

[[ -d "$body_directory" ]] || {
    echo "Stage-20 body directory does not exist: $body_directory" >&2
    exit 1
}
[[ "$expected_count" =~ ^[1-9][0-9]*$ ]] || {
    echo "Expected count must be a positive integer." >&2
    exit 1
}
[[ "$lesson_propagation" == "off" || "$lesson_propagation" == "campaign" ]] || {
    echo "Lesson propagation must be off or campaign." >&2
    exit 1
}

body_files=()
for body_file in "$body_directory"/*-body.md; do
    [[ -f "$body_file" ]] || continue
    [[ "$body_file" != *-observed-body.md ]] || continue
    body_files+=("$body_file")
done
[[ ${#body_files[@]} -eq $expected_count ]] || {
    echo "Expected $expected_count persisted stage-20 body files; found ${#body_files[@]}." >&2
    exit 1
}

required_headings=(
    '## Campaign context and required reading'
    '## Branch and execution order'
    '## Implement'
    '## Completion gates'
    '## Out of scope'
)

for body_file in "${body_files[@]}"; do
    [[ -s "$body_file" && "$(awk 'END { print NR }' "$body_file")" -gt 1 ]] || {
        echo "Persisted issue body must contain physical Markdown lines: $body_file" >&2
        exit 1
    }
    first_nonblank="$(awk 'NF { print; exit }' "$body_file")"
    [[ "$first_nonblank" =~ ^##[[:space:]]+[^[:space:]] ]] || {
        echo "Persisted issue body must begin with a level-two heading: $body_file" >&2
        exit 1
    }
    for heading in "${required_headings[@]}"; do
        grep -Fqx -- "$heading" "$body_file" || {
            echo "Persisted issue body is missing the physical heading '$heading': $body_file" >&2
            exit 1
        }
    done
    if [[ "$lesson_propagation" == "campaign" ]]; then
        grep -Fqx -- '## Campaign lessons (REQUIRED)' "$body_file" || {
            echo "Treatment issue body is missing its campaign-lessons heading: $body_file" >&2
            exit 1
        }
    elif grep -Fqx -- '## Campaign lessons (REQUIRED)' "$body_file"; then
        echo "Control issue body unexpectedly contains a campaign-lessons heading: $body_file" >&2
        exit 1
    fi
done
```

</details>


---

<sub>14s</sub>

### `view`

**view the file at /home/edburns/.copilot/plugins/shepherd-task/scripts/verify-github-issue-body.sh.**

/home/edburns/.copilot/plugins/shepherd-task/scripts/verify-github-issue-body.sh

<details>
<summary>131 lines</summary>

```
#!/usr/bin/env bash
# shepherd-task-version: 1.0.5
set -euo pipefail

fail() {
    printf 'verify-github-issue-body: %s\n' "$*" >&2
    exit 1
}

[[ $# -ge 3 && $# -le 6 ]] ||
    fail "usage: $0 OWNER/REPO ISSUE_NUMBER EXPECTED_BODY_PATH [MAX_ATTEMPTS] [DELAY_SECONDS] [DIAGNOSTIC_PATH]"

repository="$1"
issue_number="$2"
expected_body_path="$3"
max_attempts="${4:-6}"
delay_seconds="${5:-5}"
diagnostic_path="${6:-}"
gh_command="${GH_COMMAND:-gh}"

[[ "$repository" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]] ||
    fail "invalid repository: $repository"
[[ "$issue_number" =~ ^[1-9][0-9]*$ ]] ||
    fail "invalid issue number: $issue_number"
[[ "$max_attempts" =~ ^[1-9][0-9]*$ ]] ||
    fail "MAX_ATTEMPTS must be a positive integer"
[[ "$delay_seconds" =~ ^[0-9]+$ ]] ||
    fail "DELAY_SECONDS must be a non-negative integer"
[[ -f "$expected_body_path" ]] ||
    fail "expected issue body file not found: $expected_body_path"

temp_directory="$(mktemp -d)"
trap 'rm -rf "$temp_directory"' EXIT
response_path="$temp_directory/response.json"
actual_path="$temp_directory/actual.txt"
actual_normalized="$temp_directory/actual-normalized.txt"
expected_normalized="$temp_directory/expected-normalized.txt"

normalize_file() {
    jq -b -Rsj 'gsub("\r\n|\r"; "\n")' "$1" >"$2"
}

equivalent_files() {
    local actual="$1"
    local expected="$2"
    local candidate="$temp_directory/candidate.txt"

    cmp -s -- "$actual" "$expected" && return 0
    cp "$actual" "$candidate"
    printf '\n' >>"$candidate"
    cmp -s -- "$candidate" "$expected" && return 0
    cp "$expected" "$candidate"
    printf '\n' >>"$candidate"
    cmp -s -- "$actual" "$candidate"
}

sha256_file() {
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$1" | awk '{print $1}'
    else
        shasum -a 256 "$1" | awk '{print $1}'
    fi
}

write_diagnostic() {
    local reason="$1"
    local attempts="$2"
    [[ -n "$diagnostic_path" ]] || return 0

    mkdir -p "$(dirname "$diagnostic_path")"
    local expected_length actual_length expected_hash actual_hash first_offset
    expected_length="$(wc -c <"$expected_normalized" | tr -d ' ')"
    actual_length="$(wc -c <"$actual_normalized" | tr -d ' ')"
    expected_hash="$(sha256_file "$expected_normalized")"
    actual_hash="$(sha256_file "$actual_normalized")"
    first_offset="$( (cmp -l -- "$actual_normalized" "$expected_normalized" 2>/dev/null || true) | awk 'NR == 1 { print $1 - 1 }')"
    [[ -n "$first_offset" ]] || first_offset="null"

    jq -n \
        --arg repository "$repository" \
        --argjson issueNumber "$issue_number" \
        --arg endpoint "repos/$repository/issues/$issue_number" \
        --argjson attempts "$attempts" \
        --arg observedAt "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
        --arg reason "$reason" \
        --argjson expectedLength "$expected_length" \
        --argjson actualLength "$actual_length" \
        --arg expectedSha256 "$expected_hash" \
        --arg actualSha256 "$actual_hash" \
        --argjson firstDifferenceOffset "$first_offset" \
        '{
            schemaVersion: 1,
            repository: $repository,
            issueNumber: $issueNumber,
            endpoint: $endpoint,
            attempts: $attempts,
            observedAt: $observedAt,
            reason: $reason,
            expectedLength: $expectedLength,
            actualLength: $actualLength,
            expectedSha256: $expectedSha256,
            actualSha256: $actualSha256,
            firstDifferenceOffset: $firstDifferenceOffset
        }' >"$diagnostic_path"
}

normalize_file "$expected_body_path" "$expected_normalized"
last_reason=""

for ((attempt = 1; attempt <= max_attempts; attempt++)); do
    set +e
    "$gh_command" api "repos/$repository/issues/$issue_number" >"$response_path" 2>"$temp_directory/error.txt"
    exit_code=$?
    set -e

    if [[ $exit_code -ne 0 ]]; then
        last_reason="GitHub REST request failed with exit code $exit_code."
        error_message="$(cat "$temp_directory/error.txt")"
        authentication_error_pattern='HTTP[[:space:]]+(401|403)|[Aa]uthentication|[Nn][Oo][Tt][[:space:]]authorized|[Rr]esource[[:space:]]not[[:space:]]accessible'
        if [[ "$error_message" =~ $authentication_error_pattern ]]; then
            : >"$actual_normalized"
            write_diagnostic "$last_reason" "$attempt"
            fail "unable to fetch issue #$issue_number from $repository: $error_message"
        fi
    elif ! jq -e 'type == "object" and has("body")' "$response_path" >/dev/null 2>&1; then
        last_reason="GitHub REST response was invalid JSON."
    else
        jq -b -j '.body // ""' "$response_path" >"$actual_path"
        normalize_file "$actual_path" "$actual_normalized"
        if equivalent_files "$actual_normalized" "$expected_normalized"; then
            cat "$response_path"
            exit 0
        fi
        last_reason="GitHub issue body differs from the persisted draft."
    fi

    if [[ $attempt -lt $max_attempts ]]; then
        printf 'verify-github-issue-body: %s Retrying issue #%s body verification (%s/%s).\n' \
            "$last_reason" "$issue_number" "$attempt" "$max_attempts" >&2
        ((delay_seconds > 0)) && sleep "$delay_seconds"
    fi
done

[[ -f "$actual_normalized" ]] || : >"$actual_normalized"
write_diagnostic "$last_reason" "$max_attempts"
diagnostic_suffix=""
[[ -z "$diagnostic_path" ]] || diagnostic_suffix=" Diagnostic: $diagnostic_path"
fail "issue #$issue_number body verification failed after $max_attempts attempts. $last_reason$diagnostic_suffix"
```

</details>


---

<sub>14s</sub>

### `view`

**view the file at /home/edburns/.copilot/plugins/shepherd-task/scripts/verify-stage20-child-links.sh.**

/home/edburns/.copilot/plugins/shepherd-task/scripts/verify-stage20-child-links.sh

<details>
<summary>30 lines</summary>

```
#!/usr/bin/env bash
# shepherd-task-version: 1.0.5

set -euo pipefail

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <PRE_CREATION_CHILDREN_JSON> <FINAL_CHILDREN_JSON> <CREATION_LEDGER_JSON>" >&2
    exit 2
fi

for command_name in jq; do
    command -v "$command_name" >/dev/null 2>&1 || {
        echo "Error: Required command '$command_name' was not found." >&2
        exit 1
    }
done

script_dir="$(cd "$(dirname "$0")" && pwd)"
filter_path="$script_dir/verify-stage20-child-links.jq"
[[ -f "$filter_path" ]] || {
    echo "Error: Stage-20 child-link verification filter was not found: $filter_path" >&2
    exit 1
}

for input_path in "$@"; do
    [[ -f "$input_path" ]] || {
        echo "Error: Stage-20 child-link verification input was not found: $input_path" >&2
        exit 1
    }
done

jq -n \
    --slurpfile baseline "$1" \
    --slurpfile final "$2" \
    --slurpfile ledger "$3" \
    -f "$filter_path"
```

</details>


---

<sub>20s</sub>

### Copilot

The plan has exactly two serial tasks and both gating questions have substantive resolutions: the canonical Pester runner/CI contract, and the exact stdout, return-value, input, file, and ordering contract. I’m now establishing the pre-creation GitHub baseline and repository-specific test details.

---

<sub>25s</sub>

### `bash`

**Validate GitHub and save child baseline**

$ set -euo pipefail
REPO='edburns/dd-3070093-simple-math-linux-x64-01'
PARENT=1
LOG='/home/edburns/workareas/dd-3070093-simple-math-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260928-0113'
mkdir -p "$LOG/issue-bodies"
test -w "$LOG" && test -w "$LOG/issue-bodies"
repo_json="$(gh api "repos/$REPO")"
printf '%s\n' "$repo_json" | jq '{full_name,default_branch,owner:{login,type}}'
parent_json="$(gh api "repos/$REPO/issues/$PARENT")"
printf '%s\n' "$parent_json" | jq '{number,state,html_url,title,pull_request:has("pull_request")}'
owner_type="$(printf '%s\n' "$repo_json" | jq -r '.owner.type')"
owner_login="$(printf '%s\n' "$repo_json" | jq -r '.owner.login')"
if [[ "$owner_type" == Organization ]]; then
  gh api "orgs/$owner_login/issue-types" | jq '{selected: ([.[] | select(.name == "Task" and .is_enabled == true)] | first // null), all: [.[] | {name,is_enabled}]}'
elif [[ "$owner_type" == User ]]; then
  printf '%s\n' '{"selected":null,"reason":"user-owned repository"}'
else
  printf 'Unrecognized owner type: %s\n' "$owner_type" >&2
  exit 1
fi
raw="$(gh api "repos/$REPO/issues/$PARENT/sub_issues" --paginate --slurp)"
normalized="$(printf '%s\n' "$raw" | jq 'if length == 0 then [] elif all(.[]; type == "array") then add else . end')"
printf '%s\n' "$normalized" | jq -e 'type == "array" and all(.[]; type == "object" and has("id") and has("number"))' >/dev/null
tmp="$LOG/pre-creation-children.json.tmp"
printf '%s\n' "$normalized" > "$tmp"
mv "$tmp" "$LOG/pre-creation-children.json"
printf '%s\n' "$normalized" | jq '[.[] | {id,number,title}]'

<details>
<summary>18 lines</summary>

```
{
  "full_name": "edburns/dd-3070093-simple-math-linux-x64-01",
  "default_branch": "main",
  "owner": {
    "login": null,
    "type": null
  }
}
{
  "number": 1,
  "state": "open",
  "html_url": "https://github.com/edburns/dd-3070093-simple-math-linux-x64-01/issues/1",
  "title": "[Campaign][off] shepherd-task simple-math control",
  "pull_request": false
}
{"selected":null,"reason":"user-owned repository"}
[]
<shellId: 2 completed with exit code 0>
```

</details>


---

<sub>25s</sub>

### `bash`

**Inspect acceptance runner and workflow**

$ set -euo pipefail
printf '%s\n' '--- tracked root ---'
git ls-tree --name-only experiment/shepherd-control
for path in '.github/workflows/shepherd-task-math-tool.yml' 'eng/test-math-tool.ps1' 'README.md'; do
  if git cat-file -e "experiment/shepherd-control:$path" 2>/dev/null; then
    printf '\n--- %s ---\n' "$path"
    git show "experiment/shepherd-control:$path"
  fi
done

<details>
<summary>62 lines</summary>

```
--- tracked root ---
.github
1-math-control-remove-before-merge
LICENSE
README.md
eng

--- .github/workflows/shepherd-task-math-tool.yml ---
name: Shepherd task math tool

on:
  pull_request:
  push:
  workflow_dispatch:

permissions:
  contents: read

jobs:
  test:
    name: Shepherd task math tool
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install Pester 5.7.1
        shell: pwsh
        run: Install-Module Pester -RequiredVersion 5.7.1 -Scope CurrentUser -Force
      - name: Test math tool
        shell: pwsh
        run: ./eng/test-math-tool.ps1

--- eng/test-math-tool.ps1 ---
[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$requiredVersion = '5.7.1'
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$implementationPath = Join-Path $repositoryRoot 'math-tool.ps1'
$testPath = Join-Path $repositoryRoot 'math-tool.Tests.ps1'

$implementationExists = Test-Path -LiteralPath $implementationPath -PathType Leaf
$testsExist = Test-Path -LiteralPath $testPath -PathType Leaf
if (-not $implementationExists -and -not $testsExist) {
    Write-Host 'Math-tool implementation has not been introduced yet; baseline validation passed.'
    exit 0
}
if (-not $implementationExists -or -not $testsExist) {
    throw 'math-tool.ps1 and math-tool.Tests.ps1 must be introduced together.'
}

$available = Get-Module -ListAvailable Pester |
    Where-Object { $_.Version.ToString() -eq $requiredVersion } |
    Select-Object -First 1
if (-not $available) {
    Write-Host "Installing Pester $requiredVersion in CurrentUser scope..."
    Install-Module Pester -RequiredVersion $requiredVersion -Scope CurrentUser -Force
}

Import-Module Pester -RequiredVersion $requiredVersion -Force
$result = Invoke-Pester -Path $testPath -PassThru
if ($result.FailedCount -gt 0) {
    Write-Error "Pester reported $($result.FailedCount) failed test(s)."
    exit 1
}
exit 0

--- README.md ---
# dd-3070093-simple-math-linux-x64-01
https://devdiv.visualstudio.com/DevDiv/_workitems/edit/3070093
<shellId: 3 completed with exit code 0>
```

</details>


---

<sub>25s</sub>

### `bash`

**Verify base remote and branch**

$ set -euo pipefail
remote_url="$(git remote get-url origin)"
case "$remote_url" in
  git@github.com:edburns/dd-3070093-simple-math-linux-x64-01.git|https://github.com/edburns/dd-3070093-simple-math-linux-x64-01.git|https://github.com/edburns/dd-3070093-simple-math-linux-x64-01) ;;
  *) printf 'Remote mismatch: %s\n' "$remote_url" >&2; exit 1 ;;
esac
git show-ref --verify --quiet refs/heads/experiment/shepherd-control || git show-ref --verify --quiet refs/remotes/origin/experiment/shepherd-control
printf 'remote=%s branch=present\n' "$remote_url"

```
remote=git@github.com:edburns/dd-3070093-simple-math-linux-x64-01.git branch=present
<shellId: 4 completed with exit code 0>
```


---

<sub>33s</sub>

### Copilot

The repository is user-owned, so children will be created **without an issue type**. No existing child issues were found; the normalized baseline is persisted. I’m drafting both complete specifications now, with the canonical runner, pinned Pester version, exact CLI/function contracts, serial dependency, and regression gates embedded directly.

---

<sub>49s</sub>

### `apply_patch`

<details>
<summary>Arguments</summary>

````json
"*** Begin Patch\n*** Add File: /home/edburns/workareas/dd-3070093-simple-math-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260928-0113/issue-bodies/01-1-implement-fibonacci-body.md\n+## Campaign context and required reading\n+\n+On the `experiment/shepherd-control` branch, the directory `1-math-control-remove-before-merge` contains the plan (`math-tool-ignorance-reduction-plan.md`) and supporting resources (diagrams, decision records). Spike subdirectories are research artifacts — read the plan's Resolution sections for findings, not the spike source code.\n+\n+Read the entire plan before working. Then carefully re-read these exact sections:\n+\n+- `## Ignorance reduction`\n+- `### Repository-owned validation`\n+- `### Output and ordering contracts`\n+- `## Implementation`\n+- `### 1. Implement Fibonacci with unit and isolated CLI coverage`\n+\n+The resolved validation decision is that the only canonical acceptance command is:\n+\n+```text\n+pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1\n+```\n+\n+The repository-owned runner imports exactly Pester 5.7.1 and runs the root-level `math-tool.Tests.ps1`; the workflow `.github/workflows/shepherd-task-math-tool.yml` installs that exact Pester version and invokes the runner. Do not replace, bypass, or weaken this path.\n+\n+The resolved behavior contract is:\n+\n+- Direct CLI execution writes exactly one result line to stdout in the form `Fibonacci(N) = value`.\n+- `Get-Fibonacci` returns only the numeric result, with no incidental output.\n+- `N` is a non-negative integer.\n+- The production and test files are repository-root `math-tool.ps1` and `math-tool.Tests.ps1`.\n+- Work is serial; this first task must merge before task 2 starts.\n+\n+Research found no spike source artifacts to reuse. Implement production behavior and production tests from the plan's resolved contracts rather than copying research code.\n+\n+## Branch and execution order\n+\n+Use `experiment/shepherd-control` from remote `origin` as the PR base branch. Do not target `main`.\n+\n+This is task 1 of 2. Tasks are assigned, completed, and merged serially in plan order. Do not start work until this issue is assigned to you. Task 2 must not start until this task is merged into `experiment/shepherd-control`.\n+\n+## Implement\n+\n+Create repository-root `math-tool.ps1` and `math-tool.Tests.ps1` together.\n+\n+In `math-tool.ps1`:\n+\n+- Declare a script parameter named `N` that accepts non-negative integer input.\n+- Implement a pure `Get-Fibonacci` function.\n+- Return `0` for `N=0`, `1` for `N=1`, and the correct Fibonacci number for representative positive input.\n+- Ensure invoking the function emits only its numeric return value.\n+- When the script is directly executed, print exactly one stdout line: `Fibonacci(N) = value`, substituting the input and result.\n+- Keep direct-execution output separate from function behavior so dot-sourced unit tests do not receive CLI formatting output.\n+\n+In `math-tool.Tests.ps1`:\n+\n+- Dot-source `math-tool.ps1` and unit-test `Get-Fibonacci`.\n+- Cover `N=0`, `N=1`, and at least one small representative positive value.\n+- Launch isolated child `pwsh` processes to test direct CLI execution rather than treating an in-process function call as a CLI test.\n+- For each CLI case, assert successful exit and exact stdout with no additional lines or incidental output.\n+\n+Follow existing repository PowerShell conventions: strict failures must remain visible, tests must be deterministic, and no external service or network access may be required.\n+\n+## Completion gates\n+\n+- `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1` exits zero locally using the repository-owned Pester 5.7.1 runner.\n+- The pinned pull-request workflow passes.\n+- Unit tests prove the numeric return values for `0`, `1`, and a representative positive input.\n+- Isolated child-process tests prove exact single-line CLI output for the same boundary and representative cases.\n+- A regression assertion distinguishes function output from CLI formatting, preventing incidental output from contaminating `Get-Fibonacci` results.\n+- `git diff` shows both root-level files introduced together and no unrelated production changes.\n+\n+## Out of scope\n+\n+- Factorial support and operation dispatch; those belong to task 2.\n+- Replacing or modifying the canonical test runner, the pinned Pester version, or the workflow.\n+- Additional operations, interactive prompts, alternate output formats, negative-number semantics, packaging, or unrelated refactoring.\n+- Reading, adapting, or copying any spike source code or spike test infrastructure.\n*** Add File: /home/edburns/workareas/dd-3070093-simple-math-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260928-0113/issue-bodies/02-2-add-factorial-dispatch-body.md\n+## Campaign context and required reading\n+\n+On the `experiment/shepherd-control` branch, the directory `1-math-control-remove-before-merge` contains the plan (`math-tool-ignorance-reduction-plan.md`) and supporting resources (diagrams, decision records). Spike subdirectories are research artifacts — read the plan's Resolution sections for findings, not the spike source code.\n+\n+Read the entire plan before working. Then carefully re-read these exact sections:\n+\n+- `## Ignorance reduction`\n+- `### Repository-owned validation`\n+- `### Output and ordering contracts`\n+- `## Implementation`\n+- `### 1. Implement Fibonacci with unit and isolated CLI coverage`\n+- `### 2. Add factorial and operation dispatch`\n+\n+The resolved validation decision is that the only canonical acceptance command is:\n+\n+```text\n+pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1\n+```\n+\n+The repository-owned runner imports exactly Pester 5.7.1 and runs the root-level `math-tool.Tests.ps1`; the workflow `.github/workflows/shepherd-task-math-tool.yml` installs that exact Pester version and invokes the runner. Do not replace, bypass, or weaken this path.\n+\n+The resolved behavior and ordering contract is:\n+\n+- Direct CLI execution writes exactly one result line to stdout: `Fibonacci(N) = value` or `Factorial(N) = value`.\n+- Both functions return only their numeric value, with no incidental output.\n+- Inputs are non-negative integers.\n+- The production and test files remain repository-root `math-tool.ps1` and `math-tool.Tests.ps1`.\n+- This task depends on task 1 having been merged and must preserve all Fibonacci behavior.\n+\n+Research found no spike source artifacts to reuse. Implement production behavior and production tests from the plan's resolved contracts rather than copying research code.\n+\n+## Branch and execution order\n+\n+Use `experiment/shepherd-control` from remote `origin` as the PR base branch. Do not target `main`.\n+\n+This is task 2 of 2. Tasks are assigned, completed, and merged serially in plan order. Do not start work until this issue is assigned to you and task 1 has been merged into `experiment/shepherd-control`. Build on the merged task-1 implementation rather than recreating it.\n+\n+## Implement\n+\n+Extend the existing root-level `math-tool.ps1`:\n+\n+- Add a pure `Get-Factorial` function.\n+- Return `1` for both `N=0` and `N=1`, and the correct factorial for representative positive input.\n+- Add an `Operation` parameter that dispatches between `fibonacci` and `factorial` while retaining `N`.\n+- Preserve direct invocation without an explicit operation as Fibonacci behavior, so task-1 CLI usage and output remain compatible.\n+- For Fibonacci dispatch, print exactly `Fibonacci(N) = value`.\n+- For factorial dispatch, print exactly `Factorial(N) = value`.\n+- Ensure each direct invocation emits exactly one result line and each function emits only its numeric return value.\n+- Constrain operation selection to the two specified operations and keep non-negative-integer validation for `N`.\n+\n+Extend the existing root-level `math-tool.Tests.ps1`:\n+\n+- Add dot-sourced unit coverage for `Get-Factorial` at `N=0`, `N=1`, and at least one small representative positive value.\n+- Add isolated child-`pwsh` process coverage for factorial dispatch and exact output.\n+- Retain and run all task-1 Fibonacci unit and isolated CLI tests.\n+- Add dispatch-focused coverage proving both explicit operations route to the correct function and format.\n+- Add compatibility coverage proving omitted `Operation` still follows the original Fibonacci CLI behavior.\n+\n+Keep the implementation and test suite objective, deterministic, and small.\n+\n+## Completion gates\n+\n+- `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1` exits zero for the combined regression suite using the repository-owned Pester 5.7.1 runner.\n+- The pinned pull-request workflow passes.\n+- Factorial unit tests prove numeric-only results for `0`, `1`, and a representative positive input.\n+- Isolated child-process tests prove exact single-line factorial output with no extra stdout.\n+- The complete task-1 Fibonacci suite remains green and verifies unchanged output and numeric return behavior.\n+- Dispatch tests discriminate `fibonacci` from `factorial`, and a compatibility test proves the default invocation remains Fibonacci.\n+- Invalid operation or invalid negative input cannot be silently treated as a successful valid calculation.\n+- `git diff` is limited to the math tool and its tests unless a directly necessary repository-owned test adjustment is justified.\n+\n+## Out of scope\n+\n+- New mathematical operations beyond Fibonacci and factorial.\n+- Changing the exact output strings, adding interactive prompts, or introducing alternate output formats.\n+- Replacing or modifying the canonical test runner, the pinned Pester version, or the workflow.\n+- Packaging, performance optimization for large inputs, unrelated refactoring, or broad error-handling redesign.\n+- Reading, adapting, or copying any spike source code or spike test infrastructure.\n*** End Patch\n"
````

</details>

```
Added 2 file(s): /home/edburns/workareas/dd-3070093-simple-math-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260928-0113/issue-bodies/01-1-implement-fibonacci-body.md, /home/edburns/workareas/dd-3070093-simple-math-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260928-0113/issue-bodies/02-2-add-factorial-dispatch-body.md
```


---

<sub>55s</sub>

### `bash`

**Validate persisted issue drafts**

$ set -euo pipefail
LOG='/home/edburns/workareas/dd-3070093-simple-math-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260928-0113'
VALIDATOR='/home/edburns/.copilot/plugins/shepherd-task/scripts/validate-stage20-drafts.sh'
"$VALIDATOR" "$LOG/issue-bodies" 2 off
for file in "$LOG"/issue-bodies/*-body.md; do
  printf '%s: lines=%s bytes=%s first=%s\n' "$(basename "$file")" "$(wc -l < "$file")" "$(wc -c < "$file")" "$(awk 'NF {print; exit}' "$file")"
done

```
01-1-implement-fibonacci-body.md: lines=73 bytes=4318 first=## Campaign context and required reading
02-2-add-factorial-dispatch-body.md: lines=78 bytes=4964 first=## Campaign context and required reading
<shellId: 5 completed with exit code 0>
```


---

<sub>55s</sub>

### `view`

**view the file at /home/edburns/workareas/dd-3070093-simple-math-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260928-0113/issue-bodies/01-1-implement-fibonacci-body.md.**

/home/edburns/workareas/dd-3070093-simple-math-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260928-0113/issue-bodies/01-1-implement-fibonacci-body.md

<details>
<summary>50 lines</summary>

````
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
````

</details>


---

<sub>55s</sub>

### `view`

**view the file at /home/edburns/workareas/dd-3070093-simple-math-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260928-0113/issue-bodies/02-2-add-factorial-dispatch-body.md.**

/home/edburns/workareas/dd-3070093-simple-math-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260928-0113/issue-bodies/02-2-add-factorial-dispatch-body.md

<details>
<summary>56 lines</summary>

````
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
````

</details>


---

<sub>55s</sub>

### `bash`

**Confirm repository owner metadata**

$ set -euo pipefail
gh api 'repos/edburns/dd-3070093-simple-math-linux-x64-01' | jq '{owner, owner_value_type:(.owner|type), owner_login:(.owner.login // null), owner_type:(.owner.type // null), top_level_owner_type:(.owner_type // null), top_level_owner_login:(.owner_login // null)}'

<details>
<summary>29 lines</summary>

```
{
  "owner": {
    "login": "edburns",
    "id": 75821,
    "node_id": "MDQ6VXNlcjc1ODIx",
    "avatar_url": "https://avatars.githubusercontent.com/u/75821?v=4",
    "gravatar_id": "",
    "url": "https://api.github.com/users/edburns",
    "html_url": "https://github.com/edburns",
    "followers_url": "https://api.github.com/users/edburns/followers",
    "following_url": "https://api.github.com/users/edburns/following{/other_user}",
    "gists_url": "https://api.github.com/users/edburns/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/edburns/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/edburns/subscriptions",
    "organizations_url": "https://api.github.com/users/edburns/orgs",
    "repos_url": "https://api.github.com/users/edburns/repos",
    "events_url": "https://api.github.com/users/edburns/events{/privacy}",
    "received_events_url": "https://api.github.com/users/edburns/received_events",
    "type": "User",
    "user_view_type": "public",
    "site_admin": true
  },
  "owner_value_type": "object",
  "owner_login": "edburns",
  "owner_type": "User",
  "top_level_owner_type": null,
  "top_level_owner_login": null
}
<shellId: 6 completed with exit code 0>
```

</details>


---

<sub>1m 4s</sub>

### Copilot

Both persisted drafts passed the required validator and were re-read from disk. I’m beginning the one-shot mutation: create each issue unassigned, verify its REST body byte-for-byte, link it to #1, and persist the ledger after every state transition.

---

<sub>1m 19s</sub>

### `bash`

**Create verify and link child issues**

$ set -Eeuo pipefail
REPO='edburns/dd-3070093-simple-math-linux-x64-01'
PARENT=1
LOG='/home/edburns/workareas/dd-3070093-simple-math-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260928-0113'
LEDGER="$LOG/creation-ledger.json"
RESULT="$LOG/stage-20-result.json"
BODY_VERIFIER='/home/edburns/.copilot/plugins/shepherd-task/scripts/verify-github-issue-body.sh'
DRAFT_VALIDATOR='/home/edburns/.copilot/plugins/shepherd-task/scripts/validate-stage20-drafts.sh'

atomic_write() {
  local destination="$1" content="$2" temporary
  temporary="$(mktemp "${destination}.tmp.XXXXXX")"
  printf '%s\n' "$content" > "$temporary"
  mv "$temporary" "$destination"
}

update_ledger_flag() {
  local number="$1" field="$2" value="$3" updated
  updated="$(
    jq \
      --argjson number "$number" \
      --arg field "$field" \
      --argjson value "$value" \
      'map(if .number == $number then .[$field] = $value else . end)' \
      "$LEDGER"
  )" || return 1
  atomic_write "$LEDGER" "$updated"
}

reconcile_and_fail() {
  local operation="$1" error="$2" raw normalized reconciled failed_result
  set +e
  raw="$(gh api "repos/$REPO/issues/$PARENT/sub_issues" --paginate --slurp 2>&1)"
  local query_exit=$?
  if [[ $query_exit -eq 0 ]]; then
    normalized="$(printf '%s\n' "$raw" | jq 'if length == 0 then [] elif all(.[]; type == "array") then add else . end')"
    if [[ $? -eq 0 ]]; then
      atomic_write "$LOG/final-children.json" "$normalized"
      reconciled="$(jq --argjson children "$normalized" 'map(.linked = ([ $children[].id ] | index(.id) != null))' "$LEDGER")"
      if [[ $? -eq 0 ]]; then atomic_write "$LEDGER" "$reconciled"; fi
    else
      error="$error; reconciliation normalization failed"
    fi
  else
    error="$error; reconciliation query failed: $raw"
  fi
  failed_result="$(jq -n --arg operation "$operation" --arg error "$error" '{schemaVersion:1,status:"failed",ledgerFile:"creation-ledger.json",operationError:{operation:$operation,error:$error}}')"
  atomic_write "$RESULT" "$failed_result"
  printf 'Stage 20 failed during %s: %s\n' "$operation" "$error" >&2
  if jq -e 'length == 0' "$LEDGER" >/dev/null 2>&1; then
    printf 'No issues were created; no cleanup is required.\n' >&2
  else
    jq -r '.[] | "#\(.number) | \(.title) | \(.url) | \(.bodyFile) | body_verified=\(.body_verified) | linked=\(.linked)"' "$LEDGER" >&2
    jq -r --arg repo "$REPO" '.[] | "gh issue delete \(.number) --repo \"\($repo)\" --yes"' "$LEDGER" >&2
  fi
  printf 'The operation did not complete. No automatic rollback was performed; delete every issue in the ledger before invoking this skill again.\n' >&2
  exit 1
}

create_and_link() {
  local subsection="$1" title="$2" body_file="$3" body_relative="$4"
  local created create_exit issue_id issue_number issue_url new_ledger observed verify_exit link_output link_exit linked_ok

  set +e
  created="$(gh api "repos/$REPO/issues" -X POST -f title="$title" -F "body=@$body_file" --jq '{id,number,node_id,html_url,title}' 2>&1)"
  create_exit=$?
  set -e
  [[ $create_exit -eq 0 ]] || reconcile_and_fail "create issue for $subsection" "$created"
  if ! printf '%s\n' "$created" | jq -e 'type == "object" and (.id|type == "number") and (.number|type == "number") and (.html_url|type == "string")' >/dev/null; then
    reconcile_and_fail "parse created issue for $subsection" "GitHub returned an invalid issue creation payload"
  fi
  issue_id="$(printf '%s\n' "$created" | jq -r '.id')"
  issue_number="$(printf '%s\n' "$created" | jq -r '.number')"
  issue_url="$(printf '%s\n' "$created" | jq -r '.html_url')"
  new_ledger="$(jq \
    --arg subsection "$subsection" \
    --arg bodyFile "$body_relative" \
    --argjson id "$issue_id" \
    --argjson number "$issue_number" \
    --arg title "$title" \
    --arg url "$issue_url" \
    '. + [{implementationSubsection:$subsection,bodyFile:$bodyFile,id:$id,number:$number,title:$title,url:$url,body_verified:false,linked:false}]' \
    "$LEDGER")" || reconcile_and_fail "persist ledger for issue #$issue_number" "Unable to append the created issue"
  atomic_write "$LEDGER" "$new_ledger"

  set +e
  observed="$("$BODY_VERIFIER" "$REPO" "$issue_number" "$body_file" 6 5 "$LOG/issue-$issue_number-body-verification-failure.json" 2>&1)"
  verify_exit=$?
  set -e
  [[ $verify_exit -eq 0 ]] || reconcile_and_fail "verify body for issue #$issue_number" "$observed"
  update_ledger_flag "$issue_number" body_verified true || reconcile_and_fail "persist body verification for issue #$issue_number" "Unable to update creation ledger"

  linked_ok=false
  for attempt in 1 2 3; do
    set +e
    link_output="$(printf '{\"sub_issue_id\": %s}' "$issue_id" | gh api "repos/$REPO/issues/$PARENT/sub_issues" -X POST --input - 2>&1)"
    link_exit=$?
    set -e
    if [[ $link_exit -eq 0 ]]; then
      linked_ok=true
      break
    fi
    sleep 1
  done
  [[ "$linked_ok" == true ]] || reconcile_and_fail "link issue #$issue_number to parent #$PARENT" "$link_output"
  update_ledger_flag "$issue_number" linked true || reconcile_and_fail "persist link state for issue #$issue_number" "Unable to update creation ledger"
  printf 'Created and linked #%s: %s\n' "$issue_number" "$title"
}

"$DRAFT_VALIDATOR" "$LOG/issue-bodies" 2 off
atomic_write "$LEDGER" '[]'
atomic_write "$RESULT" '{"schemaVersion":1,"status":"in_progress","ledgerFile":"creation-ledger.json","operationError":null}'

create_and_link \
  '1. Implement Fibonacci with unit and isolated CLI coverage' \
  '1. Implement Fibonacci with unit and isolated CLI coverage' \
  "$LOG/issue-bodies/01-1-implement-fibonacci-body.md" \
  'issue-bodies/01-1-implement-fibonacci-body.md'

create_and_link \
  '2. Add factorial and operation dispatch' \
  '2. Add factorial and operation dispatch' \
  "$LOG/issue-bodies/02-2-add-factorial-dispatch-body.md" \
  'issue-bodies/02-2-add-factorial-dispatch-body.md'


```
Created and linked #2: 1. Implement Fibonacci with unit and isolated CLI coverage
Created and linked #3: 2. Add factorial and operation dispatch
<shellId: 7 completed with exit code 0>
```


---

<sub>1m 27s</sub>

### Copilot

Both issues were created, body-verified, and linked in plan order as #2 and #3. I’m running the authoritative child-link comparison plus final open/unassigned/body checks before marking the stage complete.

---

<sub>1m 33s</sub>

### `bash`

**Verify final issue postconditions**

$ set -Eeuo pipefail
REPO='edburns/dd-3070093-simple-math-linux-x64-01'
PARENT=1
LOG='/home/edburns/workareas/dd-3070093-simple-math-linux-x64-01-shepherd-control/1-math-control-remove-before-merge/prompts/shepherd-task-20-20260928-0113'
LEDGER="$LOG/creation-ledger.json"
RESULT="$LOG/stage-20-result.json"
BODY_VERIFIER='/home/edburns/.copilot/plugins/shepherd-task/scripts/verify-github-issue-body.sh'
CHILD_VERIFIER='/home/edburns/.copilot/plugins/shepherd-task/scripts/verify-stage20-child-links.sh'

atomic_write() {
  local destination="$1" content="$2" temporary
  temporary="$(mktemp "${destination}.tmp.XXXXXX")"
  printf '%s\n' "$content" > "$temporary"
  mv "$temporary" "$destination"
}

fail_postcondition() {
  local operation="$1" error="$2" raw normalized reconciled failed_result
  set +e
  raw="$(gh api "repos/$REPO/issues/$PARENT/sub_issues" --paginate --slurp 2>&1)"
  local query_exit=$?
  if [[ $query_exit -eq 0 ]]; then
    normalized="$(printf '%s\n' "$raw" | jq 'if length == 0 then [] elif all(.[]; type == "array") then add else . end')"
    if [[ $? -eq 0 ]]; then
      atomic_write "$LOG/final-children.json" "$normalized"
      reconciled="$(jq --argjson children "$normalized" 'map(.linked = ([ $children[].id ] | index(.id) != null))' "$LEDGER")"
      [[ $? -ne 0 ]] || atomic_write "$LEDGER" "$reconciled"
    else
      error="$error; reconciliation normalization failed"
    fi
  else
    error="$error; reconciliation query failed: $raw"
  fi
  failed_result="$(jq -n --arg operation "$operation" --arg error "$error" '{schemaVersion:1,status:"failed",ledgerFile:"creation-ledger.json",operationError:{operation:$operation,error:$error}}')"
  atomic_write "$RESULT" "$failed_result"
  printf 'Stage 20 failed during %s: %s\n' "$operation" "$error" >&2
  jq -r '.[] | "#\(.number) | \(.title) | \(.url) | \(.bodyFile) | body_verified=\(.body_verified) | linked=\(.linked)"' "$LEDGER" >&2
  jq -r --arg repo "$REPO" '.[] | "gh issue delete \(.number) --repo \"\($repo)\" --yes"' "$LEDGER" >&2
  printf 'The operation did not complete. No automatic rollback was performed; delete every issue in the ledger before invoking this skill again.\n' >&2
  exit 1
}

set +e
raw="$(gh api "repos/$REPO/issues/$PARENT/sub_issues" --paginate --slurp 2>&1)"
fetch_exit=$?
set -e
[[ $fetch_exit -eq 0 ]] || fail_postcondition 'fetch final child snapshot' "$raw"
set +e
normalized="$(printf '%s\n' "$raw" | jq 'if length == 0 then [] elif all(.[]; type == "array") then add else . end' 2>&1)"
normalize_exit=$?
set -e
[[ $normalize_exit -eq 0 ]] || fail_postcondition 'normalize final child snapshot' "$normalized"
atomic_write "$LOG/final-children.json" "$normalized"

set +e
child_check="$("$CHILD_VERIFIER" "$LOG/pre-creation-children.json" "$LOG/final-children.json" "$LEDGER" 2>&1)"
child_exit=$?
set -e
[[ $child_exit -eq 0 ]] || fail_postcondition 'verify child links and order' "$child_check"
printf '%s\n' "$child_check"

while IFS=$'\t' read -r number body_relative; do
  body_path="$LOG/$body_relative"
  set +e
  issue_json="$("$BODY_VERIFIER" "$REPO" "$number" "$body_path" 6 5 "$LOG/issue-$number-final-body-verification-failure.json" 2>&1)"
  verify_exit=$?
  set -e
  [[ $verify_exit -eq 0 ]] || fail_postcondition "final body verification for issue #$number" "$issue_json"
  if ! printf '%s\n' "$issue_json" | jq -e '.state == "open" and (.assignees | type == "array" and length == 0)' >/dev/null; then
    fail_postcondition "verify open and unassigned issue #$number" 'Issue is not open or has one or more assignees'
  fi
  printf 'Final verification passed for #%s (open, unassigned, exact body).\n' "$number"
done < <(jq -r '.[] | [.number,.bodyFile] | @tsv' "$LEDGER")

atomic_write "$RESULT" '{"schemaVersion":1,"status":"complete","ledgerFile":"creation-ledger.json","operationError":null}'
printf '%s\n' 'Stage 20 postconditions passed.'
jq '{status,ledgerFile,operationError}' "$RESULT"
jq '[.[] | {implementationSubsection,number,title,url,body_verified,linked}]' "$LEDGER"

<details>
<summary>36 lines</summary>

```
{
  "baselineCount": 0,
  "ledgerCount": 2,
  "finalCount": 2,
  "newIssueIds": [
    5607912133,
    5607912343
  ]
}
Final verification passed for #2 (open, unassigned, exact body).
Final verification passed for #3 (open, unassigned, exact body).
Stage 20 postconditions passed.
{
  "status": "complete",
  "ledgerFile": "creation-ledger.json",
  "operationError": null
}
[
  {
    "implementationSubsection": "1. Implement Fibonacci with unit and isolated CLI coverage",
    "number": 2,
    "title": "1. Implement Fibonacci with unit and isolated CLI coverage",
    "url": "https://github.com/edburns/dd-3070093-simple-math-linux-x64-01/issues/2",
    "body_verified": true,
    "linked": true
  },
  {
    "implementationSubsection": "2. Add factorial and operation dispatch",
    "number": 3,
    "title": "2. Add factorial and operation dispatch",
    "url": "https://github.com/edburns/dd-3070093-simple-math-linux-x64-01/issues/3",
    "body_verified": true,
    "linked": true
  }
]
<shellId: 8 completed with exit code 0>
```

</details>


---

<sub>1m 38s</sub>

### Copilot

Created and verified two ordered, open, unassigned child issues under #1. Stage result is `complete`; issues were created **without an issue type**.

| Implementation subsection | Issue | Title | URL |
|---|---:|---|---|
| 1. Implement Fibonacci with unit and isolated CLI coverage | #2 | 1. Implement Fibonacci with unit and isolated CLI coverage | https://github.com/edburns/dd-3070093-simple-math-linux-x64-01/issues/2 |
| 2. Add factorial and operation dispatch | #3 | 2. Add factorial and operation dispatch | https://github.com/edburns/dd-3070093-simple-math-linux-x64-01/issues/3 |

**Ordered child issue numbers:** `2,3`

**Suggested stage 25 invocation:**
```text
/shepherd-task-25-given-list REPO=edburns/dd-3070093-simple-math-linux-x64-01 BASE_BRANCH=experiment/shepherd-control ISSUE_NUMBERS=2,3 PLAN_DIRECTORY=1-math-control-remove-before-merge
```

---

<sub>Generated by [GitHub Copilot CLI](https://github.com/features/copilot/cli)</sub>
