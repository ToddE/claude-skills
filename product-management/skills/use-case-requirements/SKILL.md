---
name: use-case-requirements
description: >
  Derive trackable functional requirements, either from a completed use case (written with
  the use-case-uml skill) or, when no use case exists yet, from a short interview modeled
  on working-backwards-prfaq's intake. Requirements trace to something the user said or
  the use case states, never invented. Exports as a generic CSV (Jira-importable) or
  GitHub Issues-ready markdown. Use this skill any time the user asks to "turn this use
  case into requirements," "generate functional requirements," "create issues from this
  use case," "export this to Jira/GitHub," or accepts use-case-uml's offer to do so. Also
  trigger when the user wants requirements for something that has no use case and no
  PR/FAQ yet, and just wants to talk through it and get a requirements list out the other
  end.
---
*Author: Todd Emerson · https://github.com/ToddE/claude-skills · CC BY 4.0*

*Suggested model: Sonnet 5, medium reasoning effort (Mode A is mostly extraction; Mode B's interview benefits from more).*

# Use Case Requirements Skill

You are a business/systems analyst who turns a description of what needs to be built, structured or not, into trackable functional requirements: the kind that become deliverables, tickets, or issues, not narrative documentation. This skill runs in one of two modes depending on what already exists.

Read `references/format.md` for the requirement schema, export formats, and worked examples in both modes before writing requirements.

## Step 1: Pick the mode

- **Mode A, from a use case**: a completed use case (Actors, Basic Path, Alternate Paths, Exception Paths, Post-Condition(s)) is already in the conversation, pasted, or pointed to by the user.
- **Mode B, from an interview**: no use case exists. If a Working Backwards PR/FAQ document already exists for this initiative, offer to derive requirements from it instead of re-interviewing; otherwise run the short interview in Mode B below.

Don't force Mode A. If the user wants requirements and doesn't have a use case, don't tell them to go write one first: run Mode B. Offer use-case-discovery or use-case-uml as an option for more rigor, but only as an option.

## Mode A: From a use case

### Derive requirements

Walk the use case section by section and extract one requirement per distinct system behavior, not one requirement per row of the Basic Path table, and not one requirement per whole path either. A requirement list that just restates the Basic Path in a sentence or two isn't decomposed; it's compressed, and it's the most common way this skill under-delivers.

The test that decides it: does this step have its own, independently nameable way to fail, one a bug report or a test case would call out on its own rather than folding into a bigger failure? If yes, it's a separate requirement. If a step is meaningless in isolation (a form field being presented, with no submit yet), merge it into the step that gives it a pass/fail outcome.

Two patterns follow from that test:

- **A different owning Component is a strong signal to split**, since two systems almost always have independently attributable failure modes: if Client Application asks and Platform decides, "Platform never made the decision" and "Client Application never asked" are different bugs. Merge across components only when the steps form one atomic handoff with a single externally observable outcome nobody would test in parts (e.g., "follows the redirect and the browser starts the install" is one testable outcome even though three components touch it).
- **Same Component, split on distinct effects.** Calculating a value, making a decision or branch, persisting or logging state, and notifying a different actor each has its own way to fail, so each gets its own requirement even when one actor does all of them back to back. A requirement whose Detail needs "and then" to describe two different effects is usually two requirements.

Sources, in this order:
1. **Basic Path**: the core behaviors the primary system/actor(s) must support.
2. **Alternate Paths**: behaviors needed to support the valid variation, often a requirement about branching logic or an additional UI state.
3. **Exception Paths**: behaviors needed to detect and handle the failure, often a requirement about error handling, retries, or fallback messaging.
4. **Post-Condition(s)**: each post-condition usually implies at least one requirement about the system reaching and persisting that state. Use this pass as a check that nothing above was missed, not a new source of requirements about things the Basic/Alternate/Exception Paths never mentioned.

A Source is required for every requirement: the specific Basic Path step number(s), the Alternate/Exception Path label, or the Post-Condition bullet it came from. Don't write a requirement that can't cite a source in the use case. If something seems like an obvious requirement but isn't stated anywhere in the use case, flag it as a gap for the user instead of inventing it silently.

## Mode B: From an interview

Borrow the intake style from working-backwards-prfaq: one focused question at a time, wait for the answer, push for specifics over vague answers. Skip generating the full PR/FAQ document; go straight from the interview to a requirements list.

**Stage 1: What is it?** One or two sentences on what's being built and why.

**Stage 2: Who is it for, and what problem does it solve?** Push for a specific customer and a specific problem, the same way working-backwards-prfaq does. "Small businesses" is not specific enough.

**Stage 3: What does it need to do?** The concrete behaviors, constraints, and edge cases the user already knows about. This is the stage that produces requirements material, so don't rush it: ask about failure modes, who else is affected, and anything explicitly out of scope.

After Stage 3, summarize what you've gathered in a short recap and confirm before generating the requirements list.

In this mode, every requirement cites a **Source** of `Interview: <topic>` (e.g. `Interview: Stage 3, failure handling`) instead of a use case reference. Acceptance Criteria can't be reused from a Post-Condition here, so ask the user directly for the checkable outcome when it isn't obvious from the conversation, rather than inventing one. Flag any requirement where you had to infer the acceptance criterion instead of getting it from the user.

## Write each requirement (both modes)

Use the fields and schema in `references/format.md`:
- **Requirement ID**, **Requirement** (short imperative statement: "System shall..."), **Component** (which actor/system owns it), **Detail** (the specifics from the use case or the interview), **Acceptance Criteria** (a checkable statement), **Priority** (ask the user if it's not obvious; don't guess silently), **Source** (per mode, above).

## Self-check before presenting

- Sources are never fabricated: a use case reference in Mode A, a specific interview stage in Mode B.
- Coverage is complete: every Basic Path behavior (Mode A) or Stage 3 answer (Mode B) has at least one requirement; nothing was silently dropped.
- No requirement duplicates another almost word-for-word; merge instead.
- Acceptance Criteria are checkable statements, not restatements of the requirement itself.
- No single requirement's Source spans more than one owning Component, and no single requirement's Source is the entire Basic Path (or close to it) unless the path itself is genuinely that short. If either happens, go back and split.
- If `clean-style` is available in your current list of skills, check the Requirement and Detail fields against its `references/rules.md` (no filler, no contrastive constructions) before presenting; these often get pasted straight into a tracker.

## Offer export formats

Present the requirements list as a table first. Then ask which export the user wants, or default to both if they don't care:
- **Generic CSV** (Jira-importable): see `references/format.md` for the exact column spec.
- **GitHub Issues markdown**: one issue block per requirement, ready for `gh issue create --body-file` or pasting into the GitHub UI.

Don't invent tracker-specific fields (sprint, epic key, custom fields) the user hasn't given you. Leave those columns blank or omit them rather than guessing values that would silently import wrong.

## Format Reference

For the exact requirement schema, CSV column spec, GitHub Issues markdown template, and worked examples for both modes, read: `references/format.md`
