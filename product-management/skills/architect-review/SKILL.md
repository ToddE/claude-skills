---
name: architect-review
description: >
  Produce a structured architectural recommendation for an initiative, from the
  perspective of a specific Sr. Architect persona, using whatever pipeline artifacts
  exist: PR/FAQ, use case(s), functional requirements, or just a description if that's all
  there is. Use this skill when the user asks for an architecture review, a technical
  recommendation, "how should we build this," or wants a specific architect's take (e.g.
  "what would the Pragmatic Modulith Architect say about this" or "what would the
  Assembler do here"). Built to support multiple personas, each with its
  own output; ships today with two (The Pragmatic Modulith Architect, The Assembler). Can
  also run an opt-in debate between two personas, grounded in a short product-manager
  intake, ending in a "take this approach if..." decision rule for each.
---
*Author: Todd Emerson · https://github.com/ToddE/claude-skills · CC BY 4.0*

*Suggested model: Sonnet 5, high reasoning effort (the most synthesis-heavy skill here).*

# Architect Review Skill

You are producing an architectural recommendation as a specific Sr. Architect would give it, not as a neutral summary of options. The persona is the point: two different personas reading the same requirements should be able to recommend different things, for reasons that trace back to how each one reasons, not just a different tone on the same generic advice.

Read `references/format.md` for the output structure and a worked example before drafting a recommendation.

## Step 1: Gather available artifacts

Collect whatever exists: a PR/FAQ (working-backwards-prfaq), a use case or several (use-case-uml), functional requirements (use-case-requirements). Partial input is fine; work with what's there. If nothing exists beyond a one-line idea, ask the user to describe it rather than requiring them to run the other skills first, but say plainly in the Inputs Considered header that the recommendation is less grounded as a result.

Don't invent artifacts that don't exist. If requirements would obviously sharpen the recommendation and don't exist yet, say so and offer to hand off to use-case-requirements first, but let the user decide whether to do that or proceed with what's available.

## Step 2: Pick the persona

List the personas available under `references/personas/*.md`. If only one exists, use it without asking. If more than one exists:
- Ask which persona the user wants, or
- If they ask to compare, run the same input through each requested persona, with each persona's recommendation its own separate artifact (its own file, if you're saving to files), never merged into one voice.

## Step 3: Read the persona file completely before drafting

Read the full persona file, not just its technology list. Apply its stated philosophy, its default leanings, what it pushes back on, and specifically how it handles tradeoffs (this varies by persona and is often the most distinctive part of how it reasons). A recommendation that just swaps in the persona's preferred stack onto generic advice isn't using the persona; it's decorating around it.

## Step 4: Draft the recommendation

Follow `references/format.md` exactly: Recommended Approach, Key Tradeoffs, Risks/Open Questions, Alternatives Considered, with the Persona and Inputs Considered header. Recommended Approach and Key Tradeoffs must each trace to something in the input artifacts or to the persona's own stated philosophy. Don't invent constraints, compliance requirements, or scale targets the input never raised; use a bracket placeholder and ask the user instead.

## Step 5: Self-check before presenting

- Check whether `clean-style` is available in your current list of skills. If it is, read its `references/rules.md` and check the draft against it before presenting; a persona's voice is still prose someone outside the conversation will read. If it isn't available, apply the same spirit from general judgment (direct, concrete, no filler, no dramatic language).
- Each major recommendation cites where it came from: an artifact or the persona's stated philosophy.
- Tradeoffs are handled the way this specific persona's file says to handle them, not generically.
- If multiple personas ran, their outputs are fully separate and clearly attributed, not merged into a single voice.
- Bracket placeholders exist for anything only the user can specify, rather than the recommendation silently assuming a value.

## Step 6: Present the result

Output each persona's recommendation as its own artifact, never merged. If the user is early in the pipeline (little or no input beyond a description), offer to revisit this recommendation once use cases or requirements exist, since the picture will sharpen.

If two or more personas ran, offer the debate (Step 7) as an option. Don't run it automatically; it's opt-in.

## Step 7: The debate (opt-in, two or more personas only)

Only run this if the user asks for it after seeing the standalone recommendations. It exists because two static write-ups can each look individually reasonable while hiding a tradeoff that only shows up when they're forced to respond to each other directly, and because a generic version of this debate is nearly worthless: it needs to be grounded in what this specific initiative's decision-maker cares about, not an abstract philosophical disagreement.

### Step 7a: A short intake, as the product manager

Before drafting the debate, ask the user a handful of grounding questions, framed as the product manager whose call this ultimately is. One at a time, push for a specific answer the same way working-backwards-prfaq does:

1. **Budget sensitivity**: how tight is it, and is that constraint permanent or temporary (e.g., "until we prove this out")?
2. **Operational appetite**: does the team want to run infrastructure themselves, or is minimizing that a priority?
3. **Failure visibility**: if one of these systems breaks at 2am, who finds out today, and how fast?
4. **Risk tolerance**: which hurts more, being locked into a vendor, or your own system breaking in a way only your team can fix?
5. **Timeline pressure**: how urgent is going live, and what's riding on that date?

This intake exists because of a specific, recurring failure mode: a product manager says "it's fine that it costs $X per service" and happily takes the buy-everything approach, only to discover later that assembling several disparate vendor systems with no unified monitoring or orchestration causes death by a thousand cuts once something breaks. Question 3 exists specifically to surface that blind spot before it becomes the reason a decision looks wrong in hindsight, not just a hypothetical to raise in the debate itself.

Don't skip this intake to save time. A debate grounded in someone's actual constraints is worth having; a generic one isn't, and running it without the intake produces the generic version.

### Step 7b: Draft the debate

Follow `references/format.md`'s debate structure exactly: Opening Positions (informed by the intake, not generic), one direct challenge each (each persona challenges a specific point the other made, not a vague disagreement), one response each, then a closing "Take this approach if..." decision rule per persona, grounded in the intake answers. Keep it bounded: one round of challenge and response, not an open-ended back-and-forth. The goal is a sharper decision, not a transcript.

If saving output to files alongside the persona recommendations, name the debate's file `<fileid>-architect-debate.md` (e.g. if the personas were saved as `06a-<persona-slug>.md` and `06b-<persona-slug>.md`, the debate is `06c-architect-debate.md`), never merged into either persona's own file.

## Format Reference

For the exact section structure, header fields, and a worked example, read:
`references/format.md`

## Personas

Current personas live under `references/personas/`. A file per persona holds a standalone voice: its philosophy, its default leanings, what it pushes back on, and how it handles tradeoffs. Adding a new persona means adding a new file there in the same shape; nothing else in this skill needs to change to pick it up.

- **The Pragmatic Modulith Architect**: cloud-agnostic, scale-aware, ship-first, builds a modulith and owns his stack. See `references/personas/the-pragmatic-modulith-architect.md`.
- **The Assembler**: buys over builds, composes best-in-class vendor services, treats velocity as the primary risk to manage. See `references/personas/the-assembler.md`.
