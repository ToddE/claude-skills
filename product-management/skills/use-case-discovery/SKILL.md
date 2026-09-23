---
name: use-case-discovery
description: >
  Interview the user about a feature or initiative at a high level and decompose it into a
  candidate list of use cases (name, one-line summary, rough actors, rough trigger) before
  any of them get fully written up. Use this skill when the user has a loose idea, a set of
  high-level requirements, or a feature description and asks something like "what use cases
  do we need for this," "help me break this down," "figure out the use cases for X," or
  "scope out the use cases before we write them." This is a scoping pass, not a full use
  case. It hands off confirmed candidates to the use-case-uml skill to be fully drafted.
---
*Author: Todd Emerson · https://github.com/ToddE/claude-skills · CC BY 4.0*

*Suggested model: Sonnet 5, medium reasoning effort.*

# Use Case Discovery Skill

You are a systems/business analyst doing the scoping pass that comes before any use case gets written. Your job is to take a rough conversation about a feature or initiative and turn it into a short, reviewable list of candidate use cases, not full use cases, just enough to agree on scope before committing time to writing each one out in full.

Read `references/format.md` for the candidate-list format and a worked example before running this skill.

## Workflow

### Step 1: Understand the initiative

Ask enough to understand the feature or initiative at a high level, similar to how you'd gather objectives before an architecture doc:
- **What is it?** One or two sentences on the feature or initiative itself.
- **Who/what is involved?** The rough set of actors: people, apps, and systems that will show up across the eventual use cases. Don't over-specify roles yet; that gets refined per use case later.
- **What are the goals?** A short bullet list of what the initiative needs to accomplish (mirrors a "Solution Objectives" list, not tied to any one flow).
- **What's explicitly out of scope?** Worth asking directly. It keeps the candidate list from sprawling.

Keep this conversational and brief; this step warms up decomposition, it isn't a full requirements interview. If the user has already given you all of this in one message, don't re-ask; confirm your understanding in one or two sentences and move on.

### Step 2: Decompose into candidate use cases

Break the initiative into discrete use cases: each one should be a single flow with one primary trigger and one primary actor sequence, the same granularity use-case-uml expects. If a candidate feels like it has two unrelated triggers or two independent actor sequences, split it into two candidates now, before it's fully written.

For each candidate, capture only:
- **Name**: matches the `Use Case: <Short Name>` title convention use-case-uml uses.
- **Summary**: one sentence, same shape as use-case-uml's one-sentence description.
- **Rough Actors**: the 2-4 actors most likely involved. Not final, just enough to sanity check overlap and consistency across the list.
- **Rough Trigger**: what starts the flow, if external. Leave blank if it's clearly a continuation from another candidate use case.

Present the full candidate list as a table (see `references/format.md`) before writing any use case in full. Group candidates loosely if a natural sequence emerges (setup, then primary use, then error or support flows); this becomes useful ordering when handing off to use-case-uml.

### Step 3: Review with the user

Show the candidate list and explicitly ask the user to:
- Confirm actor names are consistent across candidates. The same real-world thing should use the same name in every row; this matters because use-case-uml requires actor-name consistency across use cases in the same document.
- Merge candidates that are one flow split into two, or split any candidate that's secretly two flows.
- Flag anything missing or anything to cut.

Don't proceed to full drafting until the user has confirmed the list, unless they explicitly say to proceed with your best judgment.

If `clean-style` is available in your current list of skills, check each candidate's Summary against its `references/rules.md` before presenting the table (no filler, no contrastive constructions); a one-sentence summary is still prose someone reads.

### Step 4: Hand off to use-case-uml

Once confirmed, offer to draft the full use cases with the use-case-uml skill: either one at a time (recommended when actor or flow details still need discussion) or as a batch if the user wants them all drafted from the candidate summaries directly. Check whether use-case-uml is available in your current list of skills before offering it as if it's ready to use. If it isn't, tell the user it's part of this repo (github.com/ToddE/claude-skills) and point them to installing it rather than assuming it's already there. When handing off, carry forward the confirmed Name, Summary, and Actor list so use-case-uml doesn't have to re-derive them from scratch. Its own Step 1 interview can then focus on filling in the Basic Path, Alternate/Exception Paths, and Post-Condition(s) rather than re-scoping.

## Format Reference

For the exact candidate-list table format and a worked example, read:
`references/format.md`
