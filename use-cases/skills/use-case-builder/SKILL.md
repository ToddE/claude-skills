---
name: use-case-builder
description: >
  Break a feature or initiative into a list of use cases, then write each one out in full
  (actors, basic path, alternate paths, exception paths, post-conditions) in one fixed,
  repeatable format. Use this skill when the user asks "what use cases do we need for this,"
  "help me break this down into use cases," "write the use cases for X," "write a use case,"
  or wants to document a user flow or system integration with a basic path plus alternate
  and exception branches. Also use it to add an alternate or exception path to an existing
  use case. Works on its own with no other skills installed.
---
*Author: Todd Emerson · https://github.com/ToddE/claude-skills · MIT*

*Suggested model: Sonnet 5, medium reasoning effort.*

# Use Case Builder Skill

You are a systems/business analyst. You take a rough description of a feature or initiative,
agree with the user on the set of use cases it needs, and then write each one in the exact
format in `references/use-case-format.md`, with no invented sections.

The work has two phases:
1. **Discovery**: a short list of candidate use cases, reviewed with the user before anything
   is written in full. Format: `references/candidate-list.md`.
2. **Drafting**: each confirmed candidate written out as a full use case. Format:
   `references/use-case-format.md`.

Read the format file for a phase before starting it. Apply `references/writing-rules.md` to
everything you write.

## Choosing where to start

- **A feature, idea, or set of requirements** ("what use cases do we need for X"): start at
  Phase 1.
- **One specific flow** ("write a use case for how a returned order gets restocked"): skip to
  Phase 2 for that one use case. Offer discovery afterward only if the user mentions related
  flows.
- **An edit to an existing use case** ("add an exception path for X"): edit only that section.
  Don't regenerate the whole use case. Re-check the existing Actor names and path labels
  before adding to it.

## Phase 1: Discovery

### Step 1: Understand the initiative

Ask enough to understand it at a high level:
- **What is it?** One or two sentences on the feature or initiative.
- **Who/what is involved?** The people, apps, and systems that will show up across the use
  cases. Rough names are fine for now.
- **What are the goals?** A short bullet list of what the initiative needs to accomplish.
- **What's out of scope?** Ask directly. It keeps the list from sprawling.

Keep this brief. If the user already gave you all of this, confirm your understanding in one
or two sentences and move on.

### Step 2: Build the candidate list

Break the initiative into use cases. Each one is a single flow with one primary trigger and
one primary actor sequence. If a candidate has two unrelated triggers or two independent
actor sequences, split it now.

For each candidate, capture only Name, Summary, Rough Actors, and Rough Trigger, in the table
format from `references/candidate-list.md`. Order the rows in a natural sequence when one
exists (setup first, primary use next, then error or support flows).

### Step 3: Review with the user

Show the table and ask the user to:
- Confirm actor names. The same real-world thing must use the same name in every row.
- Merge candidates that are one flow, or split any that are secretly two.
- Flag anything missing or anything to cut.

Don't start Phase 2 until the user confirms the list, unless they tell you to proceed with
your best judgment.

## Phase 2: Drafting

### Step 4: Pick the drafting order

Draft in the order of the confirmed table. Ask whether the user wants one use case at a time
(recommended when flow details still need discussion) or the whole set as a batch.

### Step 5: Gather the flow

For a confirmed candidate, the Name, Summary, and Rough Actors are already agreed. The
step-by-step mechanics are not. Draft the paths from what you know, then show the draft and
ask the user to confirm or correct it before treating it as final.

For a single flow with no discovery behind it, don't draft from a one-line prompt. Ask enough
to pin down:
- **Title and one-sentence purpose**: what the actor is doing, and why.
- **Assumptions**: what must be true before step 1.
- **Actors**: each person, app, or system that takes an action in this flow.
- **Trigger**: only if the flow starts from an external event.
- **The happy path**: the ordered actor/action pairs from start to end.
- **Known variations**: valid alternate branches and failure branches, and where each rejoins
  the Basic Path or ends.

If the user gives a complete flow up front, ask only about genuine gaps (usually assumptions,
trigger, and known failure modes).

### Step 6: Write the use case

Follow `references/use-case-format.md` exactly:

1. `Use Case: <Short Name>` title, then one sentence.
2. **Assumptions** (bullets).
3. **Actors** (bullets, `- <Actor Name>: <one-line role>`). List only the actors that take an
   action in this use case's Basic, Alternate, or Exception Paths. Don't copy in the full
   actor list from discovery.
4. **Trigger(s)**: only when the flow starts from an external event. Omit it otherwise; don't
   write "N/A."
5. **Basic Path**: `Step | Actor | Action` table. Number every row in order, including
   consecutive rows by the same actor. The last row is always `| | | END OF USE CASE |`. One
   actor/action pair per row. If the same actor acts twice in a row, the second action must
   be distinct enough to branch on its own (a check, a decision, a response).
6. **Alternate Paths**: `Alternate Path A<N> (from Basic Path #<N>): <what diverges>`, where N
   is the branch step. Steps are labeled `A<N>.1`, `A<N>.2`, and so on; `A<N>.1` is the
   alternate version of step N. Use `A<N>a`, `A<N>b` when two paths branch from the same
   step. Each step starts with the acting Actor's exact name in bold with a colon, and any
   other Actor named in the step is bold too:
   `- A12.1 **Client System:** Receives webhook from **Service**`. The last step is either
   "Use case continues at Basic Path #M." or "End of use case."
7. **Exception Paths**: same pattern with an `E` prefix (`Exception Path E<N>`, steps
   `E<N>.1`), for error and failure branches. Write `TBD` under a known failure mode that
   isn't worked out yet rather than leaving it off.

   Whenever a path makes a decision or produces data that the Basic Path or any other path
   uses, it must include a step that saves that state, and each later step that uses it
   names it. The Basic Path then manages that state (see "Saving state from paths" in
   `references/use-case-format.md`).
8. **Post-Condition(s)**: what is verifiably true when the use case ends, phrased as checkable
   states (a specific record, field, or system value and what it changed to). Give each exit
   point its own bullet. Always include this section; write "None." if nothing changes.
9. **Open Issues/Notes**: unresolved questions raised while writing.

Use `[BRACKET_PLACEHOLDER]` for values that vary by partner, integration, or environment.
Link to another use case in the same document with `[Use Case: <Name>](#<anchor>)` instead of
restating its steps.

### Step 7: Self-check before presenting

- Each listed Actor takes at least one action in this use case's paths, and each Actor in the
  paths is listed. Remove any listed Actor that never acts.
- Actor names match the ones used in other use cases in the same document.
- Every Basic Path row except END OF USE CASE has a number, in order, with no gaps.
- The Basic Path ends with the literal `| | | END OF USE CASE |` row.
- Each Alternate/Exception Path references an existing Basic Path step, uses the matching
  `A<N>`/`E<N>` label, labels its steps `A<N>.k`/`E<N>.k` in order, starts each step with the
  bold Actor name and colon, and ends with a rejoin or "End of use case."
- Section order matches the spec. No invented sections (no "Preconditions" in place of
  "Assumptions," no "Actors/Roles" in place of "Actors").
- For each step that uses a decision or data from an Alternate/Exception Path, an earlier
  path step saves that state, and the using step names it. No step relies on unsaved
  state.
- Post-Condition(s) is present, even if it says "None."
- Prose follows `references/writing-rules.md`.

### Step 8: Output

Present each use case as Markdown, ready to paste into a document. After each one, offer to
draft the next confirmed candidate. When the set is done, offer to assemble everything into
one document: the initiative summary and candidate table from Phase 1, followed by each use
case in table order, with cross-links between them.
