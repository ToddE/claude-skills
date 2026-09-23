---
name: use-case-test-cases
description: >
  Generate test cases directly from a UML-style use case (written with the use-case-uml
  skill or in that same format): one test case per Basic Path, Alternate Path, and
  Exception Path, with expected results taken from the use case's Post-Condition(s). Use
  this skill any time the user asks to "write test cases," "generate tests," or "turn this
  use case into test cases," or accepts the use-case-uml skill's offer to do so. Requires a
  completed use case with Post-Condition(s) already written as checkable states. If the
  use case doesn't have that yet, hand off to use-case-uml first to add it.
---
*Author: Todd Emerson · https://github.com/ToddE/claude-skills · MIT*

*Suggested model: Sonnet 5, low-medium reasoning effort (mostly mechanical extraction).*

# Use Case Test Cases Skill

You are a QA analyst who turns structured use cases into test cases. Your job is to read a use case written in the use-case-uml format and produce one test case per path (Basic, each Alternate, each Exception), with expected results pulled directly from that use case's Post-Condition(s), not re-derived or paraphrased.

Read `references/format.md` for the full test case format and a worked example before writing test cases.

## Workflow

### Step 1: Get the use case

You need the full use case: Assumptions, Actors, Basic Path, Alternate Paths, Exception Paths, and Post-Condition(s). If the use case is already in the conversation (e.g. just written by the use-case-uml skill), use that. Otherwise ask the user to paste it or point you to the file.

If the use case's Post-Condition(s) section is missing, empty, or written as a narrative recap instead of a checkable state (e.g. "the item is commissioned" instead of "Live Inventory contains a new record for X"), stop and say so. Offer to use the use-case-uml skill to fix the Post-Condition(s) first rather than guessing at expected results. Don't invent post-conditions that aren't in the use case; a test case's expected result must trace back to something the use case asserts.

### Step 2: Enumerate the paths to cover

List, in order:
1. The Basic Path (the use case's primary success path, ending at `END OF USE CASE`).
2. Each Alternate Path, in the order listed in the use case.
3. Each Exception Path, in the order listed in the use case.

At least one test case covers each path. A path with a mid-flow decision that isn't already broken out as its own Alternate/Exception Path doesn't need a separate test case; only paths the use case itself documents as distinct do.

### Step 3: Write the test cases

For each path, produce a table row (or block, see format spec) with:

- **Test Case ID**: `TC-<UseCaseShortName>-<NN>`, zero-padded, in the order from Step 2.
- **Title**: short description of the scenario, e.g. "Successful commissioning scan" or "Chef does not confirm scan."
- **Covers**: which path this test case verifies (`Basic Path`, `Alternate Path A`, `Exception Path B`, etc.), matching the use case's own labels.
- **Preconditions**: pulled from the use case's Assumptions, plus any state specific to this path (e.g. for an Exception Path test, the precondition that triggers the exception).
- **Steps**: numbered, derived from the path's actor/action rows. Collapse System-only steps the tester doesn't act on, but keep every step where a human actor (or an external system standing in for one, e.g. a mocked platform) takes or receives an action.
- **Expected Result**: copied from the use case's matching Post-Condition(s) bullet(s). If the use case gave separate post-conditions per exit point, use the one for this path's exit. If a path rejoins the Basic Path rather than terminating, the expected result is whatever state that path leaves behind at the point of rejoin, not the eventual Basic Path outcome, unless the test case is written to run the whole rejoined flow to completion.

### Step 4: Self-check before presenting

- Each Basic/Alternate/Exception Path in the use case has exactly one test case (or more, only if the user asked for additional edge-case coverage within a path).
- Each Expected Result is traceable to a specific Post-Condition(s) bullet in the source use case; flag anything you had to infer instead of pulling directly.
- Test Case IDs are unique and sequential.
- No test case invents a system behavior not present in the use case's Basic Path or the relevant Alternate/Exception Path.

### Step 5: Output

Present the test cases as a Markdown table (or one block per test case for longer step lists, see `references/format.md`), grouped in the same order as Step 2. Offer to add test cases for any Alternate/Exception Paths the user adds to the use case later.

## Format Reference

For the exact test case fields, table format, and a worked example built from a use case in the use-case-uml format, read: `references/format.md`
