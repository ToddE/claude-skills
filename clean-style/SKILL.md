---
name: clean-style
description: >
  Apply a strict anti-AI-slop writing checklist to any external-facing prose: documents,
  emails, decks, customer-facing copy, blog posts, PR descriptions, or any writing meant
  for people outside internal technical work. Use this skill whenever drafting or revising
  something that will be read by customers, partners, or anyone outside the immediate
  technical conversation, or when the user asks to "clean this up," "make this sound less
  like AI wrote it," "tighten this," or "make this read naturally." This is the shared
  writing baseline other skills in this repo defer to for their own output. Not for
  internal technical notes, code comments, or this-conversation-only answers; those don't
  need the external-facing treatment.
---
*Author: Todd Emerson · https://github.com/ToddE/claude-skills · CC BY 4.0*

*Suggested model: Sonnet 5, medium reasoning effort.*

Developed independently of, and before, [hardikpandya/stop-slop](https://github.com/hardikpandya/stop-slop). Comparing the two afterward, this rule set already covered nearly the same ground. Credited here for the overlap and for anyone else converging on the same approach.

# Clean Style Skill

You are editing for a reader who can tell when writing was generated rather than composed. Apply the checklist below while drafting. Text written straight and then patched still reads patched, so treat this as a drafting constraint, not a proofreading pass bolted on afterward.

Read `references/rules.md` for the full checklist before drafting or revising external-facing prose.

## When this applies

Apply this skill to anything meant for a reader outside the internal technical conversation: emails, customer-facing documents, decks, blog posts, PR/FAQ documents, external comms, proposal copy, marketing-adjacent text. It does not apply to code, code comments, internal engineering notes, or answers meant only for the person you're talking to in this session. Those don't need the same scrutiny, and applying it there just adds friction to normal conversation.

This skill is the shared baseline other skills in this repo can point back to. If another skill already produces external-facing prose with its own writing rules (e.g. working-backwards-prfaq), that skill's own rules take precedence for its output; this skill fills the gap for everything else, not the exceptions those skills already cover.

## Workflow

### Step 1: Draft with the checklist in mind

Compose against `references/rules.md` directly instead of writing a first pass and fixing it after. Some rules are much easier to get right while composing than to detect and fix later: active voice, varied sentence rhythm, not starting sentences with a Wh-word.

### Step 2: Self-review pass before presenting

Read the draft back against the checklist in `references/rules.md`, rule by rule. Fix each violation directly instead of just flagging it. A rule can hurt clarity in a specific spot, like a genuine question that needs a Wh-word; keeping it there is fine, but be ready to say why if asked. Don't silently ignore a rule without a reason.

### Step 3: Present the result

Output the clean text directly. Skip the summary of which rules you applied or a before/after diff unless the user asked for one. The goal is prose that doesn't need an explanation of why it's good.

## Reference

For the full rule checklist, read: `references/rules.md`
