# Build Plan Format

These formats match claude-build as documented in its README and script (https://github.com/ToddE/claude-build, checked against main, commit 4369f84, 2026-10-08). Its reference examples are `examples/BUILD_STATE.md`, `examples/PLAN.md`, and `examples/claude-build.conf`. The script reads `BUILD_STATE.md` and `claude-build.conf` without a model, so those two are a contract. The other three files are read by Claude Code sessions and can be adapted.

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
- **Task** is the instruction. It names where the detail lives and how to check it. A row whose Task starts with `GATE` stops the build for a person.
- **Model** is `sonnet`, `opus`, or `haiku`. Empty on a gate row, or to use `MODEL` from the config.
- **Effort** is empty (use the model's default), or `low`, `medium`, `high`, `xhigh`, `max`.
- **Status** is `todo`, `doing`, or `done`. A new plan has only `todo`.
- **Commit** and **Notes** start empty. Runs fill them. A task that fails twice gets a diagnosis in Notes, Model set to `opus`, Effort set to `high`, and stays `todo`.
- Never delete a row. A redone task keeps its row with a note.

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

### Gate rows

```
| 1.5 | M1 Spike | GATE. Stop after 1.4. Review spike/report.md: do the timing and memory numbers fit the platform limits? | | | todo | | |
```

State in the row what the person should look at and what decision they are making. The run sets the row `done`, sets `STATUS: gate`, and stops. The person sets `STATUS: ready` to continue.

## CLAUDE.md

Short. It loads in every session. Sections, in order:

1. **First step.** Read `BUILD_STATE.md`, do the NEXT task, update it, commit. Set `STATUS: blocked` with a reason at a stop condition, `STATUS: gate` at a gate.
2. **Where the plan is.** One line pointing to the engineering prompt and the build plan.
3. **Rules.** Numbered, one line each: the architecture and security rules that every task must follow, plus "requirements are edited only in `<file>`" and "each test case becomes one automated test with the same id."
4. **Stop only for.** The credentials or external steps, text assigned to a person, a test still failing after three fix attempts, a change that would weaken a security rule, and each milestone gate. Each item says what to do in place of waiting (continue with a mock, write a marker, and so on).
5. **Which model does what.** A short summary of the routing rule, and that the Model and Effort columns decide.
6. **Token discipline.** Read only what the task needs; narrowest check first; edit lines, not whole files; after two failed attempts write a three-line diagnosis in Notes, set Model to `opus` and Effort to `high`, leave the task `todo`, and stop.

## claude-build.conf

Shell syntax, run by claude-build, so it must be owned by the user and not writable by everyone (`chmod o-w`); claude-build refuses to use it otherwise. Every key claude-build reads is below. Keys left at the default are still written, so the file documents itself. Add a comment above any value that differs from the default.

```bash
# <project> build config. Version YYYY-MM-DD HH:MM.

# Identity and paths. PROJECT_DIR must be absolute. Other paths are relative to it.
PROJECT_NAME="<name>"
PROJECT_DIR="<absolute path to the project>"
STATE_FILE="BUILD_STATE.md"
LOG_DIR=".build"

# What each run is told. {state_file}, {context}, {tasks_per_run}, {model_rule} are filled in
# by claude-build. PROMPT_FILE, if set, wins over PROMPT.
PROMPT='Read {state_file}. {context} Continue the build at the NEXT task. Do up to {tasks_per_run} tasks, or stop earlier at a gate or a stop condition. {model_rule} After each task, update {state_file} and commit. If a stop condition applies, set STATUS to blocked with the reason and stop. Do not deploy and do not push.'
PROMPT_FILE=""
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
TASKS_PER_RUN=5
TIMEOUT="3h"
INTERVAL=1200
AFTER_RUN=30
BACKOFF_STEPS=(3600 7200 14400 21600)

# Safety.
REQUIRE_GIT=1
REDACT_FILES=(".env.local")
```

How to set the values that vary by project is in SKILL.md, "Build claude-build.conf from the plan". Other recipes (documentation project, overnight, two builds in one project) are in claude-build's `examples/claude-build.conf`. The prompt does not tell the run to read CLAUDE.md, because Claude Code loads it at the start of every session.

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

Source: the "Client Update on First Launch" use case and its six requirements (`REQ-ClientUpdate-01` to `-06`) from `use-case-requirements/references/format.md`. Stack chosen in Step 1: TypeScript, pnpm, a small mobile client and a platform API. The platform API's bundle response is the only place a wrong version flag would silently strand users on an old build, so it is the protected path.

### BUILD_STATE.md (excerpt)

```
STATUS: ready
NEXT: 0.1
BLOCKED_REASON:

| Id | Milestone | Task | Model | Effort | Status | Commit | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 0.1 | M0 Tooling | Scaffold the pnpm workspace with `apps/client` and `apps/platform` per build plan section 1. `pnpm check` and `pnpm test` run and report zero tests | sonnet | | todo | | |
| 0.2 | M0 Tooling | Add lint and format config per build plan section 4. `pnpm lint` passes | haiku | | todo | | |
| 0.3 | M0 Tooling | Add the test-case coverage script: lists ids in planning/test-cases.md with no test. `pnpm check:coverage` runs | haiku | | todo | | |
| 1.1 | M1 Thin path | Platform: bundle endpoint returns the version flag and Upgrade prompt per REQ-ClientUpdate-02. Tests TC-ClientUpdate-02 and TC-ClientUpdate-03 pass | opus | high | todo | | Protected: a wrong flag strands users |
| 1.2 | M1 Thin path | Client: request bundle info once per launch per REQ-ClientUpdate-01. Test TC-ClientUpdate-01 passes | sonnet | | todo | | |
| 1.3 | M1 Thin path | Client: show the required-update page with a working Upgrade link per REQ-ClientUpdate-03. Test TC-ClientUpdate-04 passes | sonnet | | todo | | |
| 1.4 | M1 Thin path | GATE. Stop after 1.3. Run the client against the local platform and confirm a required update shows the page and link | | | todo | | |
| 2.1 | M2 Variations | Client: decline an update without persisting a declined state per REQ-ClientUpdate-04. Test TC-ClientUpdate-05 passes | sonnet | | todo | | |
| 2.2 | M2 Variations | Client: hand off the install to the device browser per REQ-ClientUpdate-05. Test TC-ClientUpdate-06 passes | sonnet | | todo | | |
| 2.3 | M2 Variations | Client: degrade gracefully when the platform is unreachable per REQ-ClientUpdate-06. Test TC-ClientUpdate-07 passes | sonnet | | todo | | |
| 2.4 | M2 Variations | GATE. Stop after 2.3. Review the diff of 1.1 and the full test run | | | todo | | |
```

Note how the rows are ordered: 0.2 and 0.3 are scripted Haiku work and sit together after the Sonnet scaffold. 1.1 is Opus because it is the protected path, so the Sonnet rows that depend on it follow it. Rows 1.2 and 1.3 both name Sonnet, so one run does both.

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
