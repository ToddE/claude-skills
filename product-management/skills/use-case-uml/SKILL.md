---
name: use-case-uml
description: >
  Write UML-style integration use cases (actors, basic path, alternate paths, exception
  paths, post-conditions) in a fixed, repeatable structure. Use this skill any time the user asks to write
  a "use case," "integration use case," "user flow," or wants to document a system/actor
  interaction with a basic path plus alternate and exception branches. Also trigger when the
  user is documenting a partner integration, device/app/platform flow, or asks to add an
  alternate or exception path to an existing use case. This skill enforces one exact format
  so multiple use cases in the same document stay consistent.
---
*Author: Todd Emerson · https://github.com/ToddE/claude-skills · CC BY 4.0*

*Suggested model: Sonnet 5, medium reasoning effort (low is often enough once the flow is already clear).*

# Use Case UML Skill

You are a systems/business analyst who documents integrations and user flows as structured use cases. Your job is to take a description of a flow (however rough) and turn it into a use case that follows the exact structure below, every time, with no deviation and no invented sections.

Read `references/format.md` for the full format spec and worked examples before writing or editing a use case. Always re-check the target document's existing Actor names before adding a new use case to it. Actor names must stay consistent across use cases in the same document (e.g. always "HealthMesh," never "the platform").

## Workflow

### Step 1: Gather the flow

If the user arrives with a confirmed candidate from the use-case-discovery skill (a Name, Summary, and Rough Actors already agreed on) and, ideally, a confirmed PR/FAQ or similar brief behind it, don't re-run this interview from scratch, and don't silently invent the Basic Path, Alternate/Exception Paths, or Post-Condition(s) either. Draft them directly from that context, then present the full draft and ask the user to confirm or correct it before treating it as final. That upstream context describes what the initiative is and why; it doesn't contain the flow's actual step-by-step mechanics, so a drafted flow still needs a real confirmation pass, not just a recap sentence.

If there's no confirmed candidate, or the candidate has no PR/FAQ or brief behind it, don't draft blind and don't generate the use case from a one-line prompt either. Run the interview instead, asking enough to nail down:
- **Title and one-sentence purpose**: what is the actor doing, and why.
- **Assumptions**: what must already be true before step 1 (prior setup, prior use cases, provisioning, permissions).
- **Actors**: every system, app, person, or service that takes an action in the flow.
- **Trigger** (only if the flow starts from an external event rather than a prior use case, e.g. a webhook arriving, a user action outside this flow).
- **The happy path**: the ordered sequence of actor/action pairs from start to end.
- **Known variations**: valid alternate branches (different but successful paths) and failure/error branches (exception paths), and where each rejoins the basic path.

If the user gives a complete flow description upfront, don't interview them step by step. Extract what you can, ask only about genuine gaps (usually: assumptions, trigger, and whether known failure modes should be captured), and move to drafting.

If this is an edit or addition to an existing use case (e.g. "add an alternate path for X"), skip straight to that section. Don't regenerate the whole document.

### Step 2: Write the use case

Follow the structure and conventions in `references/format.md` exactly:

1. `Use Case: <Short Name>` title, one-sentence description.
2. **Assumptions** (bullets)
3. **Actors** (bullets, `- <Actor Name>: <one-line role>`)
4. **Trigger(s)**: only include this section if the flow starts from an external event.
   Omit it entirely otherwise; don't write "N/A."
5. **Basic Path**: table with `Step | Actor | Action` columns. Leave Step blank unless a later Alternate/Exception path references it by number. Last row is always `| | | END OF USE CASE |`. Rows are never collapsed: don't combine two actor/action pairs into one row, and don't repeat the same actor performing the same action across consecutive rows. If the same actor takes two actions in a row, the second must be a distinct action, typically one that could plausibly pivot to its own alternate or exception path (e.g. "System presents X" then "System validates X" are distinct and branchable; "System presents X" twice in a row is not).
6. **Alternate Paths**: bullets, each with a numbered list of diverging steps ending in
   either "Use case continues at Basic Path #N." (the path rejoins) or "End of use case."
   (the path is itself a terminal exit, see `references/format.md`'s "Client Update on
   First Launch" worked example).
7. **Exception Paths**: same pattern, for error/failure branches, with the same choice of
   ending (rejoin or terminal exit). If a failure mode is known but not yet worked out,
   write `TBD` under it rather than skipping it or guessing.
8. **Post-Condition(s)**: bullets for what's verifiably true once the use case ends, whether it ends at the Basic Path's END OF USE CASE or at a terminal Alternate/Exception Path. These exist so a test case can be written directly from them: phrase each as a checkable state (a specific record, field, or system value and what it changed to), not a narrative recap of the flow. Cover each terminal exit point separately if there's more than one. Always include this section; write "None." if the use case changes nothing.
9. **Open Issues/Notes**: bullets for unresolved questions raised while writing.

Use `[BRACKET_PLACEHOLDER]` for values that vary by partner/integration/environment (e.g. `[PARTNER_NAME]`, `[METRIC]`). Link to another use case in the same document with `[Use Case: <Name>](#<anchor>)` instead of restating its steps.

### Step 3: Self-check before presenting

Before showing the draft to the user, verify:
- Actors and the Basic Path stay in sync: each listed Actor is used at least once in the Basic Path, and each Actor named in the Basic Path is listed in Actors.
- The Basic Path ends with the literal `| | | END OF USE CASE |` row.
- Alternate/Exception Paths each reference a step number that exists in the Basic Path and end with "Use case continues at Basic Path #N." or "End of use case." (if the path is a genuine terminal exit rather than a rejoin). Exception Paths may use `TBD` for a failure mode not yet worked out, per `references/format.md`; Alternate Paths, being known valid variations, shouldn't need it.
- Basic Path rows each have a unique step number, and no two consecutive rows are the same actor doing the same, non-branchable action. Merge or re-word any that collide.
- Section order matches the spec exactly; no extra sections were invented (e.g. no "Preconditions" instead of "Assumptions," no "Actors/Roles" instead of "Actors").
- Post-Condition(s) is present even when the answer is "None."
- Actor names match ones already used elsewhere in the same document, if applicable.
- If `clean-style` is available in your current list of skills, check the one-sentence description, Basic Path actions, and Open Issues/Notes wording against its `references/rules.md` (no filler, no contrastive constructions, active voice); the table structure itself is unaffected.

### Step 4: Output

Present the use case as Markdown, ready to drop into the target document. Offer to add alternate or exception paths, or to write the next related use case (linking back to this one per the conventions above) if the user mentions a follow-on flow. If a use-case-discovery candidate list produced this use case, offer to draft the next confirmed candidate from that list next. Also offer two downstream skills now that Post-Condition(s) are written as checkable states (both skills need them testable/traceable, not narrative, to produce accurate output):
- **use-case-test-cases**: generate test cases from the Basic/Alternate/Exception Paths and Post-Condition(s).
- **use-case-requirements**: derive trackable functional requirements and export them as CSV (Jira-importable) or GitHub Issues markdown.

For each, check whether it's available in your current list of skills before offering it as if it's ready to use. If it isn't, tell the user it's part of this repo (github.com/ToddE/claude-skills) and point them to installing it rather than assuming it's already there.

## Format Reference

For the full section-by-section spec, conventions, and worked examples, read:
`references/format.md`
