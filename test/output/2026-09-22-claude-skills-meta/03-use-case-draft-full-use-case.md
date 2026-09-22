## Use Case: Draft a Full Use Case

The user and Claude turn one confirmed candidate from Use Case Discovery into a complete, fixed-format use case.

**Assumptions**
- A candidate use case (Name, Summary, Rough Actors) has been confirmed via Use Case Discovery, or the user has described the flow directly.
- The target document's existing Actor names, if any, are known.

**Actors**
- User: The person defining the flow, answering questions about the basic path and known variations.
- Claude: Follows the use-case-uml skill, gathers missing detail, drafts the use case, and self-checks it before presenting.

**Basic Path**

| Step | Actor | Action |
| --- | --- | --- |
| 1. | Claude | Checks whether a confirmed candidate (Name, Summary, Actors) exists from Use Case Discovery |
| 2. | Claude | Uses the candidate's Name, Summary, and Actors as the starting Title, description, and Actors if one exists; otherwise asks the user for them directly |
| 3. | Claude | Asks the user for the Basic Path, the ordered actor/action sequence from start to end |
| 4. | User | Describes the Basic Path |
| 5. | Claude | Asks whether any alternate or exception branches are already known |
| 6. | User | Describes known Alternate and Exception Paths, or says none are known yet |
| 7. | Claude | Drafts the use case following the exact section order and Basic Path table rules |
| 8. | Claude | Self-checks the draft against the format spec (actor consistency, unique step numbers, Post-Condition(s) present, no invented sections) |
| 9. | Claude | Presents the completed use case to the user |
| | | END OF USE CASE |

**Alternate Paths**

- Alternate Path (from Basic Path #6): User doesn't know any alternate or exception paths yet
  6. User: Says no alternate or exception paths are known yet.
  7. Claude: Writes TBD under Exception Paths rather than guessing or skipping the section.
  8. Use case continues at Basic Path #7.

**Exception Paths**

- Exception Path (from Basic Path #8): Self-check finds a violation (e.g. a missing actor, a duplicate consecutive step, a missing Post-Condition)
  8. Claude: Finds a violation during self-check.
  9. Claude: Fixes the draft directly rather than presenting it with the violation.
  10. Use case continues at Basic Path #8.

**Post-Condition(s)**
- A complete use case document exists in the fixed format: Assumptions, Actors, Trigger(s) if applicable, Basic Path, Alternate Paths, Exception Paths, Post-Condition(s), and Open Issues/Notes, in that order.
- The use case's Post-Condition(s) are phrased as checkable states, not a narrative recap, so use-case-test-cases and use-case-requirements can consume them directly.

**Open Issues/Notes**
- If the candidate list contains more than one confirmed candidate, should this use case also cover looping back to draft the next one, or is that out of scope for this use case and belongs to a higher-level "batch drafting" flow instead?
