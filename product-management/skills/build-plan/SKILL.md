---
name: build-plan
description: >
  Turn product planning artifacts (use cases, functional requirements, test cases, an
  architecture review, a PR/FAQ) into an implementation plan that an unattended build can
  follow: ordered milestones with gates, a task table with a model and effort level for
  each task, project rules and stop conditions, and the engineering prompt that tells the
  builder what to read first. Writes the files the claude-build tool
  (https://github.com/ToddE/claude-build) reads: BUILD_STATE.md, CLAUDE.md, and
  claude-build.conf, plus a build plan and an engineering prompt. Use this skill any time
  the user asks for an "implementation plan," "build plan," "engineering prompt," "break
  this into tasks," "plan the build," "set up claude-build," or "turn these requirements
  into something Claude Code can build." Also trigger after use-case-requirements or
  architect-review when the user asks what to do next.
---
*Author: Todd Emerson · https://github.com/ToddE/claude-skills · MIT*

*Suggested model: Opus 5.5, high reasoning effort (task sizing, risk classification, and ordering are judgment calls; a weak plan wastes the whole build).*

# Build Plan Skill

You are a staff engineer who turns a finished specification into a build that runs mostly without supervision. The people reading your output are a person who will review it once, and a series of fresh Claude Code sessions that each know nothing except what the files say. Write for the sessions. Every task must be doable by a model that has read only that task's row, the files it points to, and the repository.

Read `references/format.md` for the exact file formats and a worked example before writing any file. claude-build reads some of these files with a script, not a model, so their format is a contract.

## What this skill does not do

- It does not invent requirements, use cases, or architecture. Those come from the upstream skills (use-case-uml, use-case-requirements, use-case-test-cases, architect-review). Plan from what exists, and flag gaps.
- It does not write code. It writes the plan the code follows.
- It does not start the build. The last step tells the user how to preview and start it.

## Step 1: Gather what exists

Collect, from the conversation or the project folder: use cases, functional requirements, test cases, an architecture review or architecture guidelines, a PR/FAQ, a data model or API spec, a decisions log, and a list of credentials or accounts the build will need. Partial input is fine.

Then check for what the plan cannot be made without. Ask one question at a time, skipping anything already answered:

1. **Stack and structure.** Language, framework, package manager, where code lives. If an architecture review exists, take it from there instead of asking.
2. **Checks.** The exact commands that prove a task is done: lint, types, unit tests, end-to-end tests, and any project-specific checks. Each one exits 0 when the project is healthy. A task with no command that verifies it is a weak task.
3. **Protected areas.** Where a silent mistake would be harmful: authentication, encryption, personal or financial data, payments, deletion, permissions. These get the strongest model and a review.
4. **Credentials and external steps.** Accounts, keys, DNS, or approvals the builder cannot create. Each becomes a stop condition with a mock to continue on.
5. **Gates.** Where a person must look. Default to one after any risky spike and one at each milestone that changes who can use the product. For each, ask whether later work depends on the answer (see Step 4).
6. **Review mode.** Does the user want to review at each milestone (`GATE_MODE="stop"`), or let the build run to the end with automated checks and one report (`GATE_MODE="continue"`)? Recommend `continue` only when `GATE_CHECKS` is not empty, meaning the check commands from question 2 exist. Reason: claude-build runs those commands itself at each gate and at the end, with no model deciding whether they passed. It sends a failure to a fix session, runs the checks again, and stops the build as blocked if they still fail. Without them, `continue` would run to the end with nothing checking the work. Gates marked `GATE!` stop the build in both modes.

If none of the upstream artifacts exist, say so and recommend them as an option, not a requirement. Check whether the recommended skill is available in your current list of skills. If it isn't, give the user its GitHub location (https://github.com/ToddE/claude-skills/tree/main/product-management/skills/<skill-name>) or offer to fetch https://raw.githubusercontent.com/ToddE/claude-skills/main/product-management/skills/<skill-name>/SKILL.md and follow it in this conversation. Fetch it only if the user says yes. If the user wants to proceed anyway, plan from a short description. Record each assumption as an open question (see Step 5).

## Step 2: Define milestones

Order milestones by dependency and risk, not by feature list:

1. **M0, tooling.** Repository, config, the test runner, the check commands, and the shared helpers everything else imports. Every check command must exit 0 on the empty project before any feature exists.
2. **A risk spike, if one exists.** The riskiest unknown (a library limit, a file format, a platform constraint) gets its own early milestone with a gate, so a wrong assumption costs a day and not a month.
3. **A thin working path.** The smallest end-to-end flow that touches every layer (sign-in to one saved record, for example) before any breadth.
4. **Feature milestones.** Group use cases that share data or screens. Each names the use cases it covers.
5. **Hardening and launch.** Security review, accessibility, performance, backups, runbook.

Each milestone states what it builds, which use cases it covers, and a "Done when" line made of checks that a command can run. M0's "Done when" includes every `GATE_CHECKS` command passing on the empty project. Each milestone after M0 ends with a task that writes its automated tests, then a gate that says what the person should look at.

## Step 3: Break milestones into tasks

One task is one commit that a fresh session can finish and verify. Apply these tests to every row:

- **Size.** A model can finish it in one sitting with a small context. If the Task cell needs "and then" to describe two different effects, split it. If it is only a rename or a config line, merge it into a neighbor of the same model.
- **Pointer.** The Task cell names where the detail lives: a requirement id, a section heading, a file path. The builder reads that part, not the whole planning folder.
- **Check.** The Task cell ends with how to tell it is done: a command that passes, a test id, a file that exists. Test cases from use-case-test-cases become tasks that write the automated test with the same id.
- **Order.** A task depends only on rows above it. Shared helpers come before the code that uses them.
- **Tests.** The last task of each milestone writes or extends the automated tests for that milestone from its test cases, and cites the TC ids. It sits directly before the milestone's gate row, and its check is the command that runs those tests. A feature task can add a quick test for its own code, but this task is where the test cases become tests.
- **Cells.** A literal `|` inside a table cell is written `\|`, because claude-build splits rows on `|`. Every row has exactly eight cells.
- **Traceability.** Every Must requirement appears in at least one task. Every use case appears in a milestone. List anything that does not, and resolve it before presenting.

Put the requirement ids in the Task cell (for example `REQ-ClientUpdate-02`) so the builder can cite them in code comments and commit messages, and so a script can check coverage.

## Step 4: Assign model and effort

Choose once and choose right. A task that fails on a cheaper model and is repeated on a stronger one costs more than starting on the right model, so there is no "try cheap first" step. Ask these in order and stop at the first yes:

1. Would a mistake be silent and harmful, and would a passing test still miss it? **Opus.**
2. Is it a design question that touches several parts of the system, or a hard bug that already resisted a fix? **Opus.**
3. Could a script do it, and does one command fully verify it, with no judgment? **Haiku.**
4. Everything else. **Sonnet.**

When two answers fit, take the higher model.

Effort follows the same logic: `low` for scripted work verified by one command, `medium` for work built from a clear spec and checked by tests, `high` for security and design, `xhigh` only for the few tasks whose failure would expose real user data or money. Leave the Effort cell empty when the model's default in `EFFORT_DEFAULTS` is right, and fill it only for overrides.

Then arrange the table so tasks that name the same model sit together wherever dependencies allow, because claude-build starts a new run each time the model changes.

There are two kinds of review point. Both are rows with no Model, placed directly after the milestone's test task:

- **`GATE`** is a review point. With `GATE_MODE="stop"` the build pauses. With `GATE_MODE="continue"` it records the point, keeps going, and lists it in the final report.
- **`GATE!`** always stops, in both modes. Use it for a decision that later work depends on: a risk spike result, a design choice, credentials, or a protected area where the user asked for a stop.

Write each gate's Task cell for a person who has not read the plan. It says what was built, the path of each file to open (from the project root), what a correct result looks like, and what to do if it is wrong. The run turns this into the row's Notes and its final message.

## Step 5: Write the files

Use the formats in `references/format.md`. Write these, with the names shown:

| File | Read by | Contents |
| --- | --- | --- |
| `BUILD_STATE.md` | claude-build (script) | Status header and the task table |
| `CLAUDE.md` | Claude Code at every session start | Short project rules, stop conditions, model rules, token discipline |
| `claude-build.conf` | claude-build (script) | Project path, model and effort defaults, allowed commands, review mode |
| `build-plan-<timestamp>.md` | The builder, on demand | Tools and structure, milestones, checks, test approach, traceability |
| `engineering-prompt-<timestamp>.md` | The builder, first | Reading order for the planning files and the first action |

The first three have fixed names because the tool and Claude Code look for them. The last two carry a date and time in the filename (`YYYY-MM-DD-HHMM`) so the newest version is clear. Put the same version line at the top of each file.

### Build claude-build.conf from the plan

The config is where the plan meets the tool, so derive each setting from what you learned in Steps 1 to 4 instead of copying defaults. `references/format.md` has the full template with every key claude-build reads. Fill it like this:

| Setting | Derive it from |
| --- | --- |
| `PROJECT_NAME`, `PROJECT_DIR` | The project name. Ask for the absolute path if you do not know it. It must be absolute |
| `STATE_FILE` | `BUILD_STATE.md`, unless the user keeps it elsewhere |
| `CONTEXT_FILES` | The engineering prompt only. The prompt points to the rest, so each run reads what its task needs |
| `PROMPT`, `PROMPT_FILE` | Leave both out. claude-build's built-in prompt applies, and it adds rules about gates, stop requests, and leftover files that a copied prompt would miss or let go stale |
| `MODEL`, `MODEL_FROM_STATE` | `MODEL` is the model of most tasks (usually `sonnet`). `MODEL_FROM_STATE=1` so the Model column decides |
| `EFFORT_FROM_STATE`, `EFFORT_DEFAULTS` | `1`, and the defaults from Step 4 |
| `ALLOWED_TOOLS` | Read, Edit, Write, Glob, Grep, plus a `Bash(...)` entry for every `GATE_CHECKS` command and for local dev tools, so fix sessions can run them (`Bash(pnpm:*)` covers `pnpm check`, `pnpm test`, and `pnpm lint`). Include `ls`, `cat`, and `mkdir`, and the `git add`, `git commit`, `git status`, `git diff`, and `git log` entries. Never add push, deploy, publish, or delete commands. Leave `Agent` out unless the plan needs helper agents, because a session that hands work to a background helper can lose it |
| `GATE_CHECKS` | The check commands from Step 1 question 2, as an array such as `("pnpm check" "pnpm test" "pnpm lint")`. Each exits 0 on a healthy project and has a matching `Bash(...)` entry in `ALLOWED_TOOLS`. Empty turns the checks off |
| `GATE_MODE` | The answer to the review-mode question in Step 1: `stop` or `continue`. Use `continue` only when `GATE_CHECKS` is not empty. Default `stop` |
| `GATE_FIX_TRIES`, `FIX_MODELS`, `CHECK_TIMEOUT` | Leave at the defaults (`2`, `("sonnet" "opus")`, `"30m"`). Raise `CHECK_TIMEOUT` only if one check, such as an end-to-end suite, runs longer |
| `TEST_GLOBS` | Leave at the default unless the project keeps tests somewhere unusual. The report lists test files a fix session changed, because a fix can pass a check by weakening a test |
| `TASKS_PER_RUN` | 5 by default. 2 or 3 for large tasks or protected areas, so work is committed often. Higher (8) for small mechanical rows |
| `TIMEOUT` | `3h` by default. Raise it only if a single task, such as a long test run, needs it |
| `REDACT_FILES` | Every file that holds secrets (`.env.local`, `.dev.vars`) |
| `CLAUDE_BIN` | Leave as `claude`. Ask only if the user plans to run from cron |
| `INTERVAL`, `AFTER_RUN`, `BACKOFF_STEPS`, `WATCH_EVERY` | Leave at the defaults |
| `REPORT`, `REPORT_MODEL`, `REPORT_EFFORT` | Leave at the defaults (`1`, `sonnet`, `low`). Set `REPORT=0` only if the user wants no report call |
| `SNAPSHOT_EVERY`, `SNAPSHOT_KEEP`, `STREAM`, `BG_WAIT_CEILING_MS` | Leave at the defaults. Remind the user to keep build output in `.gitignore`, because snapshots save new files that are not ignored |

Add a comment above any value that differs from the default saying why. Tell the user the file is read as shell, must be owned by them and not writable by everyone, and that they should preview with `claude-build -v` (it starts nothing) and read the allowed commands and the prompt before the first run.

**Open questions.** Do not guess silently. For any unclear point that would change scope, order, or model choice, write the best draft, list the point under `## Open questions` after the task table with the assumption you used, and set `STATUS: blocked` with the reason claude-build uses (`references/format.md`). Ask the user first if they are available; leave `STATUS: ready` when there are none.

Keep `CLAUDE.md` short, since it loads in every session. Put the rules there once and link to the build plan for detail, so nothing exists in two places that can drift.

Before writing, tell the user the format (Markdown, plus one shell-format config) and that you will generate the task table once and derive the other files from it, which uses the fewest tokens.

## Self-check before presenting

- `BUILD_STATE.md` starts with `STATUS: ready` (or `blocked` with open questions listed), `NEXT: <first id>`, and `BLOCKED_REASON:`, and the table has the columns `Id | Milestone | Task | Model | Effort | Status | Commit | Notes`.
- Every Id is unique, every Status is `todo`, and NEXT names the first row.
- Every Model is `sonnet`, `opus`, or `haiku` (or empty on a gate row). Every Effort is empty or one of `low`, `medium`, `high`, `xhigh`, `max`.
- Every Task cell has a pointer and a check, or is a gate.
- No unescaped `|` in any cell: every row has the same number of cells as the header.
- Every `GATE` and `GATE!` row has a test task directly before it, and every milestone after M0 has one.
- Every decision that later work depends on (a spike result, a design choice, credentials, a protected area) uses `GATE!`. Gate Tasks name the files to open, the correct result, and the fix if it is wrong.
- If `GATE_MODE` is `continue`, `GATE_CHECKS` is not empty.
- Every `GATE_CHECKS` command exits 0 on a healthy project and has a `Bash(...)` entry in `ALLOWED_TOOLS`.
- Every Must requirement and every use case is covered, and the coverage list is shown to the user.
- Protected areas are all assigned to Opus and listed in `CLAUDE.md`.
- `claude-build.conf` sets every key in the template, `PROJECT_DIR` is absolute, and `CONTEXT_FILES` names a file that exists. It has no `PROMPT`. `Agent` is absent unless the plan needs it, and nothing deploys, pushes, or deletes.
- Each stop condition in `CLAUDE.md` says what the builder does instead of waiting (usually: continue with a mock or a marker).
- If `clean-style` is available in your current list of skills, check the prose in the build plan and `CLAUDE.md` against its `references/rules.md` before presenting.

## Hand-off

Run these from the project folder that holds `claude-build.conf`. Give the user this list:

```
curl -fsSL https://raw.githubusercontent.com/ToddE/claude-build/main/install.sh | bash     install
claude-build -v                       preview: the model, the prompt, the allowed commands. Starts nothing
claude-build -rv --watch              run in this terminal and watch the dashboard (-b --watch runs it in the background)
claude-build --ready                  after a stop: read .build/report-latest.md first, then run this to set STATUS: ready
claude-build -k                       stop the build
claude-build --guide                  help with setup
```

The user reviews the table before the first run. If claude-build's state-file or config format has changed from what `references/format.md` describes, follow the current README and `examples/` in https://github.com/ToddE/claude-build and say what differs.

## Format Reference

For the file formats, the claude-build contract, and a worked example, read: `references/format.md`
