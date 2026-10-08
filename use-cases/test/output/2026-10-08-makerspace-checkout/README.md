# Test Run: Foundry Makerspace Tool Checkout (2026-10-08)

First run of the standalone `use-case-builder` skill. It ran cold, starting from a one-line
request with no PR/FAQ and no other skills. The skill was followed by hand from its
`SKILL.md` and `references/`, with the user's side simulated.

## Files

- `dialogue.md`: the full run, turn by turn.
- `01-use-case-candidates.md`: the confirmed candidate list (Phase 1).
- `02a-member-tool-checkout.md`, `02b-overdue-tool-reminder.md`: two full use cases
  (Phase 2), cross-linked.

## What this run tested

The format rules changed on 2026-10-08, so the scenario was picked to exercise each one:

| Rule | Where it was exercised | Result |
| --- | --- | --- |
| Every Basic Path row numbered, including runs by the same actor | 02a steps 4-5 and 9-11 (Kiosk ×3) | Pass |
| Actors limited to those who act in this use case | 02a drops Notification Service from the discovery actors; 02b leaves out Member Database | Pass |
| An actor who acts only in an Exception Path is still listed | Shop Staff in 02a (E10) and 02b (E5) | Pass |
| `A<N>` / `E<N>` labels, with a letter for two paths from one step | 02a A6a / A6b; 02b A4 and E4 from the same step | Pass |
| Bold actor name and colon at the start of each path step | All path steps in both files | Pass |
| `TBD` for a known but unresolved failure mode | 02a E9, 02b E4 | Pass |
| Discovery review before drafting; one-at-a-time drafting | `dialogue.md` | Pass |
| Confirmation pass on drafted mechanics, not just a recap | `dialogue.md` (staff override and paper-log fallback came from this) | Pass |

Both use cases also passed a script that checks section order, step numbering, path label
and branch-step matching, bold actor names, and that the listed actors match the actors in
the paths.

## Findings

1. **The self-check caught a two-action step.** The first draft of 02a step 9 checked both
   tool availability and training, and two exception paths branched from it. The writing
   rule "one action per step" flagged it, and the step was split into steps 9 and 10. The
   skill worked as designed. No change needed.
2. **The rough-actor limit was too tight.** The candidate-list format said "2-4 actors,"
   and Member Tool Checkout needed five. **Fixed:** the format now says "usually 2-6" with no
   hard limit. It also says a single-actor flow in an internal system should list the
   system's modules as actors.
3. **Saving state from paths wasn't specified.** 02a E10 (staff override) rejoins the
   Basic Path with a new piece of data, the approver's staff ID. **Fixed:** whenever a path's decision or data is used by the Basic Path or another path,
   the format now requires a path step that saves that state (E10.7) and a Basic Path step that names it
   (step 14 records the override approver ID if one was set). The Basic Path then manages it,
   and its exit Post-Condition(s) cover it. 02b E5 needs nothing extra, since the escalation
   alert lives in Notification Service's log and the Basic Path doesn't use it.
4. **Writing-rule wording vs. the example actor "System."** `writing-rules.md` warns against
   vague subjects like "the system" when more than one could apply, while the format's worked
   examples use an actor named "System." The rule is qualified, so the two don't conflict,
   but a reader could trip on it. Low priority.

## Not covered

- Tool Return and Training Record Update weren't drafted.
- Editing an existing use case (the "add an exception path" entry point) wasn't exercised.
- This run followed the skill by hand. It didn't install the plugin and invoke it with the
  `Skill` tool.
