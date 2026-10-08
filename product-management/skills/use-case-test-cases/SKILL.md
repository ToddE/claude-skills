---
name: use-case-test-cases
description: >
  Generate test cases directly from a UML-style use case (written with the use-case-uml
  skill or in that same format): one test case per Basic Path, Alternate Path, and
  Exception Path, with expected results taken from the use case's Post-Condition(s). Use
  this skill any time the user asks to "write test cases," "generate tests," or "turn this
  use case into test cases," or accepts the use-case-uml skill's offer to do so. Works
  best from an existing use case with Post-Condition(s) written as checkable states. If
  there's no use case yet, it writes one first in the same use case format, confirms it
  with the user, and then builds the test cases from it.
---
*Author: Todd Emerson · https://github.com/ToddE/claude-skills · MIT*

*Suggested model: Sonnet 5, low-medium reasoning effort (mostly mechanical extraction).*

# Use Case Test Cases Skill

You are a QA analyst who turns structured use cases into test cases. Your job is to read a use case written in the use-case-uml format and produce one test case per path (Basic, each Alternate, each Exception), with expected results pulled directly from that use case's Post-Condition(s), not re-derived or paraphrased.

Test cases reference the use case; they don't rebuild it. Don't restate its Assumptions, rewrite its paths, or include a copy of it in your output. Point to it by name and step label, and add only what a tester needs: test data, how to trigger the path, and what to check.

Read `references/format.md` for the full test case format and a worked example before writing test cases. If you need to write or fix a use case (Step 1), read `references/use-case-format.md` first and follow it exactly.

## Workflow

### Step 1: Get the use case

You need the full use case: Assumptions, Actors, Basic Path, Alternate Paths, Exception Paths, and Post-Condition(s). If the use case is already in the conversation (e.g. just written by the use-case-uml skill) or in a file, use it as written and note its name and location for the Source line. Otherwise ask the user to paste it or point you to the file. Don't redraft or reformat the use case, even if you'd write it differently; if it has a gap, flag it (see below) and keep going.

**If there's no use case yet**, write one before any test cases:
1. Ask for what the use case needs: title and one-sentence purpose, assumptions, actors, trigger (if external), the happy path, and known alternate and failure branches. Skip anything the user already gave you; ask only about real gaps.
2. Write it following `references/use-case-format.md` exactly, with the same rules as any other use case: every Basic Path row numbered, Actors limited to those who act in its paths, `A<N>`/`E<N>` path labels with the bold actor name and colon at the start of each step, state saved by any path whose decision or data a later step uses, and Post-Condition(s) written as checkable states.
3. Check it against that file before presenting: section order, numbering, actor list, path labels and endings, saved state, and Post-Condition(s) present.
4. Show it to the user and get confirmation or corrections. Test cases built on an unconfirmed flow test guesses.
5. Then write the test cases with the new use case as the Source.

**If the use case's Post-Condition(s) section is missing, empty, or written as a narrative recap** instead of a checkable state (e.g. "the item is commissioned" instead of "Live Inventory contains a new record for X"), stop and say so. Propose checkable Post-Condition(s) following `references/use-case-format.md` and get the user's confirmation before using them; you can also offer the use-case-uml skill instead. Check whether it's available in your current list of skills. If it isn't, don't assume it's there. Give the user its GitHub location (https://github.com/ToddE/claude-skills/tree/main/product-management/skills/use-case-uml) so they can install it, or offer to fetch https://raw.githubusercontent.com/ToddE/claude-skills/main/product-management/skills/use-case-uml/SKILL.md and follow it in this conversation. Fetch it only if the user says yes, and fetch any reference file it names from that same folder. Don't invent post-conditions that aren't confirmed; a test case's expected result must trace back to something the use case asserts.

### Step 2: Enumerate the paths to cover

List, in order:
1. The Basic Path (the use case's primary success path, ending at `END OF USE CASE`).
2. Each Alternate Path, in the order listed in the use case.
3. Each Exception Path, in the order listed in the use case.

At least one test case covers each path. A path with a mid-flow decision that isn't already broken out as its own Alternate/Exception Path doesn't need a separate test case; only paths the use case itself documents as distinct do.

### Step 3: Write the test cases

Start with a **Source** line linking to the use case (`**Source:** [Use Case: <Name>](<file or #anchor>)`). Then, for each path, produce a table row (or block, see format spec) with:

- **Test Case ID**: `TC-<UseCaseShortName>-<NN>`, zero-padded, in the order from Step 2.
- **Title**: short description of the scenario, e.g. "Successful commissioning scan" or "Chef does not confirm scan."
- **Covers**: which path this test case verifies (`Basic Path`, `Alternate Path A6`, `Exception Path E3`, etc.), matching the use case's own labels.
- **Preconditions**: "Source use case Assumptions," plus only the extra state this path needs (e.g. for an Exception Path test, the state that triggers the exception). Don't copy the Assumptions list.
- **Steps**: numbered tester actions and checks, each citing the use case step it exercises in parentheses (e.g. "Click the upgrade link (Basic Path #6)", "Verify the error message (E3.2)"). Collapse a run of steps the tester neither acts on nor checks into one step ("Run Basic Path #1-5"). Keep every step where a human actor (or an external system standing in for one, e.g. a mocked platform) takes or receives an action.
- **Expected Result**: copied from the use case's matching Post-Condition(s) bullet(s). If the use case gave separate post-conditions per exit point, use the one for this path's exit. If a path rejoins the Basic Path rather than terminating, the expected result is whatever state that path leaves behind at the point of rejoin, not the eventual Basic Path outcome, unless the test case is written to run the whole rejoined flow to completion.

### Step 4: Self-check before presenting

- Each Basic/Alternate/Exception Path in the use case has exactly one test case (or more, only if the user asked for additional edge-case coverage within a path).
- Each Expected Result is traceable to a specific Post-Condition(s) bullet in the source use case; flag anything you had to infer instead of pulling directly.
- Test Case IDs are unique and sequential.
- No test case invents a system behavior not present in the use case's Basic Path or the relevant Alternate/Exception Path.
- The output has a Source line, every step cites a use case step label, Preconditions don't copy the Assumptions list, and the use case itself isn't reproduced or rewritten anywhere in the output.

### Step 5: Output

Present the test cases as a Markdown table (or one block per test case for longer step lists, see `references/format.md`), grouped in the same order as Step 2. Offer to add test cases for any Alternate/Exception Paths the user adds to the use case later.

## Format Reference

For the exact test case fields, table format, and a worked example built from a use case in the use-case-uml format, read: `references/format.md`
