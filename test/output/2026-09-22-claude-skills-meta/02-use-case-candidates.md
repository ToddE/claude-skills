# Initiative: Claude Skills Planning Pipeline

**What is it:** Claude Skills, a collection of skills for Claude AI that takes an idea
through a PR/FAQ, a set of use cases, test cases, functional requirements, and an
architecture recommendation, with each stage handing off to the next.

**Goals:**
- Let a user go from a rough idea to a PR/FAQ without a blank-page start.
- Break a PR/FAQ or feature idea into a scoped, reviewable list of use cases before any
  one of them gets fully written.
- Write each use case in one fixed, traceable format.
- Generate test cases and functional requirements directly from a use case, with every
  claim tracing back to a specific step.
- Give a structured, persona-specific architecture recommendation once enough of the
  pipeline exists to ground one.
- Support installing any single skill independently, not just the full pipeline.

**Out of scope (for this initiative):** actual code generation or implementation, project
management or tracking beyond exporting to an external tracker, multi-user real-time
collaboration.

## Candidate Use Cases

| Name | Summary | Rough Actors | Rough Trigger |
| --- | --- | --- | --- |
| Install a Skill | The user installs one skill, by file, by folder, or by trying it ad hoc for one session, without committing to the full pipeline. | User, Claude, Claude Code Settings | User wants to use a specific skill. |
| Draft a PR/FAQ for a New Initiative | The user works through a guided interview to produce an Amazon-style PR/FAQ for a new product or initiative. | User, Claude | User wants to define a new product or initiative. |
| Scope Use Cases from an Initiative | The user turns a PR/FAQ or a rough idea into a reviewable candidate list of use cases before any one is fully written. | User, Claude | |
| Draft a Full Use Case | The user works with Claude to write one confirmed candidate into a complete use case: actors, basic path, alternate and exception paths, post-conditions. | User, Claude | |
| Generate Test Cases from a Use Case | The user turns a completed use case's paths and post-conditions into a set of traceable test cases. | User, Claude | |
| Derive Requirements from a Use Case or an Interview | The user turns a completed use case, or a short interview when no use case exists, into functional requirements exportable to Jira or GitHub Issues. | User, Claude | |
| Request an Architecture Recommendation | The user asks for a structured build recommendation from one or more named architect personas, grounded in whatever pipeline artifacts exist. | User, Claude | |
| Apply Clean Style to External Writing | The user asks Claude to clean up or draft external-facing prose using the shared writing checklist, independent of the planning pipeline. | User, Claude | User is drafting or revising external-facing text. |

## Notes for review

- Actor names are consistent across every row: "User" and "Claude" always mean the same
  thing. No candidate introduces a differently-named version of either.
- "Apply Clean Style to External Writing" is the one candidate that doesn't chain from the
  others; it's a cross-cutting utility, not a pipeline stage. Confirm whether it belongs in
  this initiative's use case set at all, or whether it's really a separate initiative
  documented elsewhere.
- "Scope Use Cases," "Draft a Full Use Case," "Generate Test Cases," and "Derive
  Requirements" all have blank Rough Triggers because each one is a continuation of the
  use case before it, not an independently-triggered flow. Confirm that's intentional and
  not a sign two of these should be merged into one longer use case instead.
- "Request an Architecture Recommendation" can trigger from a description alone, without
  the earlier stages, so it isn't purely a continuation either; it sits closer to a
  standalone entry point once the initiative exists at all.
