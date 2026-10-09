# Build Plan Format

These formats match claude-build as documented in its README and script (https://github.com/ToddE/claude-build, checked against v1.3.0, commit 27d7058, 2026-10-09). Its reference examples are `examples/BUILD_STATE.md`, `examples/PLAN.md`, and `examples/claude-build.conf`. The script reads `BUILD_STATE.md` and `claude-build.conf` without a model, so those two are a contract. The other three files are read by Claude Code sessions and can be adapted.

## BUILD_STATE.md

The first lines are machine-read. Keep them in this exact form.

```
# Build state

STATUS: ready
NEXT: 0.1
BLOCKED_REASON:

| Id | Milestone | Task | Model | Effort | Status | Commit | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
```

Rules the script and the sessions rely on:

- **STATUS** is `ready`, `blocked`, `gate`, or `done`. A new plan starts at `ready`.
- **NEXT** is the Id of the first `todo` row.
- **Id** is unique. Tasks run in table order from NEXT. Use `<milestone>.<n>` (`0.1`, `3.12`).
- **Milestone** is a short label (`M0`, `M3 MVP`).
- **Task** is the instruction. It names where the detail lives and how to check it. A row whose Task starts with `GATE` is a review point, and one that starts with `GATE!` always stops the build (see Gate rows).
- **Model** is `sonnet`, `opus`, or `haiku`. Empty on a gate row, or to use `MODEL` from the config.
- **Effort** is empty (use the model's default), or `low`, `medium`, `high`, `xhigh`, `max`.
- **Status** is `todo`, `doing`, or `done`. A new plan has only `todo`.
- **Commit** and **Notes** start empty. Runs fill them. A task that fails twice gets a diagnosis in Notes, Model set to `opus`, Effort set to `high`, and stays `todo`.
- Never delete a row. A redone task keeps its row with a note.
- **A literal `|` inside a cell is written `\|`.** claude-build splits rows on `|` and warns when a row has a different number of cells than the header. This applies to commands in the Task cell, for example ``grep -c "a\|b" file``. Every row has the same number of cells as the header.

Optional extra header lines (`MILESTONE:`, `LAST_RUN:`, `LAST_COMMIT:`) are allowed after the first three. Add them only if the project's CLAUDE.md says who updates them.

### Writing the Task cell

A good Task cell has three parts: the work, the pointer, the check.

| Weak | Strong |
| --- | --- |
| Build the login | Implement sign-in, sign-out, and lockout per REQ-Auth-01 to REQ-Auth-04 in planning/functional-requirements.md. Tests TC-SignIn-01 to TC-SignIn-05 pass |
| Set up the database | Apply migrations in db/migrations/ and load db/seed.sql. `pnpm db:check` exits 0 |
| Add tests | Write one automated test per test case in planning/test-cases.md section "Reset password", named with the test case id. `pnpm test auth` passes |

### Open questions

If the plan cannot be finished without an answer that would change scope, order, or model choice, write your best draft with the assumption you made, and list each point after the table:

```
## Open questions

1. <question>. Assumed: <the assumption the tasks use>.
```

Then set `STATUS: blocked` and `BLOCKED_REASON: Answer the open questions in this file, then set STATUS to ready`. This is the same convention claude-build's own `--init` uses. If there are no open questions, leave `STATUS: ready`.

### Test rows

The last task of each milestone after M0 writes or extends the automated tests for that milestone, from its test cases, and cites the TC ids. It sits directly before the milestone's gate row. M0 sets up the test runner and ends with a task that makes every `GATE_CHECKS` command exit 0 on the empty project.

```
| 1.4 | M1 Thin path | Write the M1 tests from TC-ClientUpdate-01 to TC-ClientUpdate-04 in planning/test-cases.md, each named with its TC id. `pnpm test` passes | sonnet | | todo | | |
```

### Gate rows

Two kinds, both with no Model, both directly after the milestone's test row.

```
| 1.5 | M1 Thin path | GATE! Decision for M2: the bundle response shape ... | | | todo | | |
| 2.5 | M2 Variations | GATE. Review point ... | | | todo | | |
```

- **`GATE`** is a review point. With `GATE_MODE="stop"` (the default) the run sets the row `done`, sets `STATUS: gate`, and stops. The person sets `STATUS: ready` to continue (`claude-build --ready` makes the edit). With `GATE_MODE="continue"` the build records the point, keeps going, and lists it in the report at the end. If `GATE_CHECKS` is set, claude-build runs those commands itself at each `GATE` row and at the end, with no model deciding whether they passed. A failure goes to a fix session that gets the failing command and its output, and the checks run again. If they still fail after `GATE_FIX_TRIES` tries, the build stops as blocked.
- **`GATE!`** always stops, in both modes. Use it for a decision that later work depends on: a risk spike result, a design choice, credentials, or a protected area where a person should look first.

Write the Task cell for a person who has not read the plan. Say what was built, the path of each file to open (from the project root), what a correct result looks like, and what to do if it is wrong. The run turns this into the row's Notes and its final message.

## CLAUDE.md

Short. It loads in every session. Sections, in order:

1. **First step.** Read `BUILD_STATE.md`, do the NEXT task, update it, commit. Set `STATUS: blocked` with a reason at a stop condition, `STATUS: gate` at a gate.
2. **Where the plan is.** One line pointing to the engineering prompt and the build plan.
3. **Rules.** Numbered, one line each: the architecture and security rules that every task must follow, plus "requirements are edited only in `<file>`" and "each test case becomes one automated test with the same id."
4. **Stop only for.** The credentials or external steps, text assigned to a person, a test still failing after three fix attempts, a change that would weaken a security rule, and each milestone gate. Each item says what to do in place of waiting (continue with a mock, write a marker, and so on).
5. **Which model does what.** A short summary of the routing rule, and that the Model and Effort columns decide.
6. **Token discipline.** Read only what the task needs; narrowest check first; edit lines, not whole files; after two failed attempts write a three-line diagnosis in Notes, set Model to `opus` and Effort to `high`, leave the task `todo`, and stop.

## claude-build.conf

Shell syntax, run by claude-build, so it must be owned by the user and not writable by everyone (`chmod o-w`); claude-build refuses to use it otherwise. Every key claude-build reads is below except `PROMPT` and `PROMPT_FILE`. Keys left at the default are still written, so the file documents itself. Add a comment above any value that differs from the default.

```bash
# <project> build config. Version YYYY-MM-DD HH:MM.

# Identity and paths. PROJECT_DIR must be absolute. Other paths are relative to it.
PROJECT_NAME="<name>"
PROJECT_DIR="<absolute path to the project>"
STATE_FILE="BUILD_STATE.md"
LOG_DIR=".build"

# What each run is told. PROMPT and PROMPT_FILE are left out on purpose: claude-build's built-in
# prompt applies, and it adds rules about gates, stop requests, and leftover files. A copied
# prompt goes stale.
# Files a run starts reading from (relative to PROJECT_DIR). Nothing is loaded in advance.
CONTEXT_FILES=("planning/engineering-prompt-<timestamp>.md")

# Model and effort. The Model and Effort columns of the state file decide each run.
# MODEL is the fallback for a task with no Model cell.
MODEL="sonnet"
MODEL_FROM_STATE=1
EFFORT=""
EFFORT_FROM_STATE=1
EFFORT_DEFAULTS=("opus=high" "sonnet=medium" "haiku=low")

# What an unattended run may do. Anything not listed is refused.
# One Bash(...) entry per check command and local dev tool from the plan.
# No push, deploy, publish, or delete commands.
PERMISSION_MODE="acceptEdits"
ALLOWED_TOOLS=(
  "Read" "Edit" "Write" "Glob" "Grep"
  "Bash(ls:*)" "Bash(cat:*)" "Bash(mkdir:*)"
  "Bash(<package manager>:*)"
  "Bash(git status:*)" "Bash(git diff:*)" "Bash(git add:*)" "Bash(git commit:*)" "Bash(git log:*)"
)
EXTRA_CLAUDE_ARGS=()
CLAUDE_BIN="claude"

# Pacing and failure handling.
# Tasks per run is an instruction in the prompt. Use 2 or 3 for large tasks or protected areas
# so work is committed often.
TASKS_PER_RUN=5
# Longest one run may take (90s, 45m, 3h). A run stopped this way counts as failed and backs off.
TIMEOUT="3h"
# Seconds to wait when there is nothing to do or after a failed run. Waiting uses no tokens.
INTERVAL=1200
# Seconds to wait after a good run.
AFTER_RUN=30
# Seconds to wait after the 1st, 2nd, 3rd, and later failed runs in a row (for example a usage limit).
BACKOFF_STEPS=(3600 7200 14400 21600)
# Seconds between redraws of --watch.
WATCH_EVERY=5

# Automated checks. claude-build runs these commands itself at each GATE row and at the end of the
# build. Each exits 0 on a healthy project and needs a Bash(...) entry in ALLOWED_TOOLS. Empty = off.
GATE_CHECKS=("<check command>" "<check command>")
# When a check fails: fix sessions to try before the build stops as blocked.
GATE_FIX_TRIES=2
# Model for each fix attempt, in order. The last one repeats.
FIX_MODELS=("sonnet" "opus")
# Longest one check command may run.
CHECK_TIMEOUT="30m"
# Paths counted as tests when the report lists test files a fix session changed.
TEST_GLOBS=("test/*" "tests/*" "*/test/*" "*/tests/*" "*__tests__*" "*.test.*" "*.spec.*" "*_test.*" "test_*")

# Review points. stop = a GATE row pauses the build until STATUS is set back to ready.
# continue = a GATE row is recorded and the build keeps going; the report lists it at the end.
# A GATE! row always stops. Use continue only when GATE_CHECKS is not empty.
GATE_MODE="stop"

# Handoff report, written whenever the build stops (gate, blocked, or done) to
# LOG_DIR/report-latest.md. REPORT=1 makes one short call to REPORT_MODEL to write the plain-words
# summary. REPORT=0 skips the call and uses the task notes.
REPORT=1
REPORT_MODEL="sonnet"
REPORT_EFFORT="low"

# Safety copies of unfinished work, saved as commits under refs/claude-build/rescue/ that are on no
# branch. SNAPSHOT_EVERY is seconds between copies (0 turns them off). SNAPSHOT_KEEP is how many to keep.
# New files that are not ignored are saved too, so keep build output in .gitignore.
SNAPSHOT_EVERY=60
SNAPSHOT_KEEP=60

# 1 = write one readable line per step to the log (needs jq). 0 = off.
STREAM=1

# How long Claude Code waits for a background helper after the model ends its turn, in milliseconds.
# 0 = unlimited, and TIMEOUT ends a run that never finishes.
BG_WAIT_CEILING_MS=0

# Safety.
REQUIRE_GIT=1
REDACT_FILES=(".env.local")
```

How to set the values that vary by project is in SKILL.md, "Build claude-build.conf from the plan". Other recipes (documentation project, overnight, two builds in one project) are in claude-build's `examples/claude-build.conf`. The built-in prompt does not tell the run to read CLAUDE.md, because Claude Code loads it at the start of every session.

## build-plan-YYYY-MM-DD-HHMM.md

```
*<project> build plan. Draft N. Version YYYY-MM-DD HH:MM. Turns the planning files into ordered work.*

# <project> Build Plan

## 1. Tools and structure
Table: area, choice. Language, package manager, framework, hosting, test tools, where code lives.

## 2. Rules for the builder
Numbered. Same rules as CLAUDE.md, with a fuller reason where useful.
### Stop only for
Table: reason, what to do.

## 3. Milestones
### M0. <name>
- What to build, as bullets.
- Use cases covered.
Done when: checks a command can run.
(Repeat per milestone. Mark gates and say what the person reviews.)

## 4. Checks run at every milestone
Table: check, command.

## 5. Test approach
How test cases become automated tests, fixtures, and security tests.

## 6. Traceability
How requirement ids appear in code and which script lists uncovered ones. Include the coverage list from the plan: requirement or use case, task ids.

## 7. Model routing
The four-question rule, the protected paths list, and the effort overrides, with one line of reason each. The task-level assignments live in BUILD_STATE.md only.
```

## engineering-prompt-YYYY-MM-DD-HHMM.md

```
*<project> engineering prompt. Draft N. Version YYYY-MM-DD HH:MM.*

Act as an expert staff engineer for <stack and domain>.

Build <product> from the planning files in this folder. They are complete enough to build without further questions. Read [README.md](README.md) first, then work through the build plan.

## Order
1. build plan: tools, structure, milestones, checks, when to stop.
2. decisions log, if any: decisions already made.
3. architecture guidelines or review.
4. data model and API spec, if any.
5. use cases, functional requirements, test cases: the behavior to build and the tests to pass.
6. design, copy, brand, and email files, if any.
7. credentials checklist: what is needed from the owner and when.

## Rules and stops
The rules, stop conditions, and model split are in ../CLAUDE.md, loaded at the start of every session.

## First action
Read ../BUILD_STATE.md and do the task it names as NEXT. Report at <the gates>. Between gates, keep going.
```

List only files that exist. Each item is a link.

## Worked example

Source: the "Client Update on First Launch" use case and its six requirements (`REQ-ClientUpdate-01` to `-06`) from `use-case-requirements/references/format.md`. Stack chosen in Step 1: TypeScript, pnpm, a small mobile client and a platform API. The check commands are `pnpm check`, `pnpm lint`, and `pnpm test`. The platform API's bundle response is the only place a wrong version flag would silently strand users on an old build, so it is the protected path. The user chose to run to the end with automated checks, so `GATE_CHECKS` lists the three commands and `GATE_MODE` is `continue`.

### BUILD_STATE.md (excerpt)

```
STATUS: ready
NEXT: 0.1
BLOCKED_REASON:

| Id | Milestone | Task | Model | Effort | Status | Commit | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 0.1 | M0 Tooling | Scaffold the pnpm workspace with `apps/client` and `apps/platform` and a test runner per build plan section 1. `pnpm check` and `pnpm test` run and report zero tests | sonnet | | todo | | |
| 0.2 | M0 Tooling | Add lint and format config per build plan section 4. `pnpm lint` passes | haiku | | todo | | |
| 0.3 | M0 Tooling | Add the test-case coverage script: lists ids in planning/test-cases.md with no test. `pnpm check:coverage` runs | haiku | | todo | | |
| 0.4 | M0 Tooling | Confirm every check command passes on the empty project: `pnpm check`, `pnpm lint`, `pnpm test`, `pnpm check:coverage` each exit 0. Fix tooling config only | haiku | | todo | | |
| 1.1 | M1 Thin path | Platform: bundle endpoint returns the version flag and Upgrade prompt per REQ-ClientUpdate-02. `pnpm check` passes | opus | high | todo | | Protected: a wrong flag strands users |
| 1.2 | M1 Thin path | Client: request bundle info once per launch per REQ-ClientUpdate-01. `pnpm check` passes | sonnet | | todo | | |
| 1.3 | M1 Thin path | Client: show the required-update page with a working Upgrade link per REQ-ClientUpdate-03. `pnpm check` passes | sonnet | | todo | | |
| 1.4 | M1 Thin path | Write the M1 tests from TC-ClientUpdate-01 to TC-ClientUpdate-04 in planning/test-cases.md, each named with its TC id. `pnpm test` passes | sonnet | | todo | | |
| 1.5 | M1 Thin path | GATE! Decision for M2: the bundle response shape. In Notes say what was built, then open apps/platform/src/bundle.ts and the `pnpm test` output. A correct result is a response whose update-required flag matches the latest version in the test fixtures. If the shape is wrong, change it before M2 builds on it | | | todo | | |
| 2.1 | M2 Variations | Client: decline an update without persisting a declined state per REQ-ClientUpdate-04. `pnpm check` passes | sonnet | | todo | | |
| 2.2 | M2 Variations | Client: hand off the install to the device browser per REQ-ClientUpdate-05. `pnpm check` passes | sonnet | | todo | | |
| 2.3 | M2 Variations | Client: degrade gracefully when the platform is unreachable per REQ-ClientUpdate-06. `pnpm check` passes | sonnet | | todo | | |
| 2.4 | M2 Variations | Write the M2 tests from TC-ClientUpdate-05 to TC-ClientUpdate-07, each named with its TC id. `pnpm test` and `pnpm check:coverage` pass | sonnet | | todo | | |
| 2.5 | M2 Variations | GATE. Review point: the unreachable-platform screen. Open apps/client/src/screens/offline.tsx and the output of `pnpm test`. A correct result is a friendly message with a link to the content site. If it is wrong, note it and fix it after the build | | | todo | | |
```

### claude-build.conf (excerpt)

```bash
GATE_CHECKS=("pnpm check" "pnpm test" "pnpm lint")
GATE_MODE="continue"
ALLOWED_TOOLS=(
  "Read" "Edit" "Write" "Glob" "Grep"
  "Bash(ls:*)" "Bash(cat:*)" "Bash(mkdir:*)"
  "Bash(pnpm:*)"
  "Bash(git status:*)" "Bash(git diff:*)" "Bash(git add:*)" "Bash(git commit:*)" "Bash(git log:*)"
)
TASKS_PER_RUN=3
```

`Bash(pnpm:*)` covers all three `GATE_CHECKS` commands. `Agent` is absent because the plan uses no helper agents. `TASKS_PER_RUN` is 3 because 1.1 is on a protected path.

Note how the rows are ordered: 0.2 to 0.4 are scripted Haiku work and sit together after the Sonnet scaffold. 1.1 is Opus because it is the protected path, so the Sonnet rows that depend on it follow it. Rows 1.2 to 1.4 all name Sonnet, so one run does them. Each milestone ends with a test task, then a gate. 1.5 is `GATE!` because M2 builds on the bundle response, so it stops even in `continue` mode. 2.5 is a plain `GATE`, so in `continue` mode the build records it, finishes, and lists it in the report.

### Coverage list (shown to the user, kept in the build plan)

| Requirement | Task |
| --- | --- |
| REQ-ClientUpdate-01 | 1.2 |
| REQ-ClientUpdate-02 | 1.1 |
| REQ-ClientUpdate-03 | 1.3 |
| REQ-ClientUpdate-04 | 2.1 |
| REQ-ClientUpdate-05 | 2.2 |
| REQ-ClientUpdate-06 | 2.3 |

Any requirement without a row here is a gap to resolve before presenting.
