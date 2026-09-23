# Architect Review: Claude Skills Planning Pipeline

Grounded question for both personas: the PR/FAQ's Internal FAQ names a top risk directly:
"Skills drift out of sync with each other as they're edited independently... cross-file
references get checked by hand after any structural change." Should that stay manual, or
get automated, and how?

---

## Persona: The Pragmatic Modulith Architect

**Inputs considered**: PR/FAQ (`01-prfaq.md`), one use case (`03-use-case-draft-full-use-case.md`), six functional requirements (`05-requirements.md`). No architecture-specific requirement exists yet beyond what the PR/FAQ's risk section implies.

### Recommended Approach

Build a small, dependency-free validation script that runs in CI on every pull request: parse each `SKILL.md`'s frontmatter and prose for cross-references (persona file paths, skill names mentioned in other files) and fail the build if a referenced file or skill name doesn't exist. Write it in Go, a single static binary with no external service dependency, so it stays portable regardless of which CI runner executes it. Scope it to one job: catch the exact drift the PR/FAQ named. No general-purpose linter, no plugin system.

### Key Tradeoffs

- **Risk**: hand-writing a cross-reference checker instead of using an existing generic markdown link checker means maintaining custom code for something that sounds like a solved problem.
- **Driver**: generic link checkers validate URLs and relative file links, not this repo's actual pattern, a persona or skill name mentioned in plain prose (e.g. "the-assembler" inside another file's description), never wrapped in markdown link syntax. The risk here is semantic, not a broken link.
- **Mitigation**: keep the script to the minimum needed for this one drift class, missing persona files, renamed skill folders, stale names in another file's frontmatter, not a general-purpose linter.
- **Accepted**: yes. This is contained, custom logic for a pattern no generic tool checks for in this repo.

### Risks / Open Questions

- `[CI_PLATFORM]`: the PR/FAQ doesn't say whether GitHub Actions stays the CI platform long term. The script should stay CI-platform-agnostic, invoked by any runner, regardless.
- The validator's own basic path needs a use case written before the tool gets built, per this repo's own convention for anything nontrivial.

### Alternatives Considered

- **Existing markdown-link-checker GitHub Action**: rejected. Doesn't catch a name mentioned in prose without link syntax, which is the specific pattern the PR/FAQ flagged.
- **Continue checking by hand**: rejected. The PR/FAQ already named this as a top risk. Leaving it manual after naming it is the same "compliance treated as an afterthought" pattern this persona pushes back on, applied to code correctness instead of data compliance.

---

## Persona: The Assembler

**Inputs considered**: same three artifacts.

### Recommended Approach

Don't build a custom validator yet. Add an existing, maintained GitHub Action from the marketplace, a generic markdown link and reference checker, to catch the easy, common cases (broken relative links, missing files) for close to no engineering time. Leave the harder semantic case, a persona name mentioned in prose across files, as a manual check for now. It hasn't caused an incident in this repo's history yet, only a close call worth naming, not solving with new infrastructure.

### Key Tradeoffs

1. **Name the dependency**: a third-party GitHub Action, maintained outside this repo.
2. **Switching cost today**: low. It's one line in a workflow file; removing or replacing it costs minutes.
3. **What buying saves right now**: the time to design, write, and maintain a custom cross-reference parser for a problem that hasn't shown up as an incident yet.
4. **Revisit trigger**: the first time a stale cross-reference actually ships to the public repo and gets noticed, by a user or a reviewer. Build the custom check then, informed by what specifically slipped through, not speculatively now.

### Risks / Open Questions

- `[ACTION_MAINTENANCE_STATUS]`: the input artifacts don't name a specific Action, so its maintenance status needs checking before adoption, per this persona's own stance that not every vendor carries equal risk.
- If stale cross-references turn out to be frequent rather than occasional, this recommendation should be revisited sooner than "the first time it ships."

### Alternatives Considered

- **Custom validation script**: rejected for now. Solves a problem the PR/FAQ names as a risk, not yet as an incident.
- **No check at all**: rejected. A generic link checker costs almost nothing to add, so skipping even that has no clear justification.

---

## Comparison

Both personas trace to the same PR/FAQ risk and use the same source material, and they land
in different places for reasons that follow directly from how each one is built to reason:
the Pragmatic Modulith Architect treats a named risk as something to close with owned,
purpose-built tooling now; The Assembler treats the same named risk as not yet an incident,
and defers custom tooling until it becomes one. Neither recommendation invents a constraint
the input artifacts didn't raise, and both apply their own file's stated tradeoff pattern
rather than a generic one.
