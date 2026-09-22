# Architect Recommendation Format

## Header

- **Persona**: which persona produced this recommendation (e.g. The Pragmatic Modulith
  Architect).
- **Inputs considered**: which pipeline artifacts were available and used (PR/FAQ, use
  case(s), functional requirements), and what was missing. Partial input is fine; say so
  plainly rather than pretending the picture is complete.

## Sections, in order

**Recommended Approach** — the concrete recommendation: architecture shape, stack choices,
deployment target, and sequencing (what to build now vs. later). Specific to this
initiative, not a generic stack applied by rote.

**Key Tradeoffs** — for each major decision, what was gained and given up, handled the way
this persona's own file says to handle tradeoffs. For The Pragmatic Modulith Architect
specifically: name the risk, state the driver, propose the minimum mitigation, and say
plainly that it's a decision being made, not a gap being ignored.

**Risks / Open Questions** — anything not fully resolved, including product or business
unknowns that would change the architecture if answered differently (e.g. "if this needs
to be HIPAA compliant, the data layer recommendation changes").

**Alternatives Considered** — the paths not taken and briefly why not, so the reader sees
the option space, not just the winner.

## Conventions

- Every recommendation must trace to something in the input artifacts (a requirement, a
  use case behavior, a PR/FAQ constraint) or to the persona's own stated philosophy. Don't
  invent constraints the artifacts never raised.
- Once more than one persona exists and the user asks to compare, each persona's output is
  its own fully separate artifact (its own file, if you're saving to files), each with its
  own full header. Never blend two personas into one voice within a single recommendation.
- Bracket placeholders like `[SCALE_TARGET]` or `[COMPLIANCE_REQUIREMENT]` mark values the
  input artifacts didn't specify. Ask the user rather than guessing when a recommendation
  hinges on one.

## Persona Coverage

Every persona file must take a real, specific position on each topic below. Section
*names* can differ to match how that persona actually talks and what's actually true for
its philosophy (Toly's "API design and testing" vs. The Assembler's "Integration design
and testing" are both fine; they're the same topic answered two different ways). What
isn't fine is a topic going silently unaddressed just because a persona's default leanings
make it seem unimportant, since that's exactly the gap that shows up as a blind spot once
two personas are compared or debated against each other.

1. Core philosophy
2. Architecture pattern (its structural default)
3. API/integration design and testing
4. Data architecture: storage, sync/real-time where applicable, and privacy/compliance
5. Infrastructure and deployment
6. Observability and monitoring (alerting reaching someone, not just logs existing
   somewhere)
7. Developer experience and tooling
8. AI usage
9. Default technology leanings
10. What it pushes back on
11. How it handles tradeoffs
12. Voice

When adding a new persona or editing an existing one, check it against this list before
calling the file done. If a topic is missing, add it; don't assume a persona's overall
philosophy already implies an answer.

## Worked Example

**Persona**: The Pragmatic Modulith Architect

**Inputs considered**: functional requirements only (see `use-case-requirements`'s Mode B
worked example, "LoyaltyNudge": a push notification that alerts subscribers when they're
close to earning a loyalty reward). No PR/FAQ or use case exists yet for this initiative.

### Recommended Approach

Build this as a new module inside the existing notification service, not a new standalone
service. The requirements (trigger on threshold, respect preferences, cap frequency, fail
gracefully on invalid tokens) are all logic-and-data-shape problems, not scale or
team-boundary problems, so there's no present-tense reason to split it out.

Deploy on whatever platform the notification service already runs on. If that service
doesn't exist yet either, start it on fly.io: this feature has no scale requirements yet
that justify AWS's operational overhead, and fly.io gets a working, portable deployment
live fastest.

Write the trigger-evaluation logic in Go if the notification service is already Go, or
match whatever typed language it's already in rather than introducing a second language
for one small module.

### Key Tradeoffs

- **Risk**: running trigger evaluation inside the existing service instead of a dedicated
  job runner means a bug in threshold logic could affect the whole notification service's
  reliability, not just loyalty notifications.
  **Driver**: avoiding the operational cost of standing up and maintaining a second
  deployable for a feature this small.
  **Mitigation**: put the trigger logic behind its own internal module boundary with its
  own tests, so it can be pulled into a separate job runner later without touching the
  rest of the notification service.
  **Accepted**: yes. This is the right tradeoff for a feature at this scale; revisit if
  loyalty-related triggers grow to a meaningful share of total notification volume.

### Risks / Open Questions

- `[SCALE_TARGET]`: expected notification volume isn't specified in the requirements.
  If this is expected to run at very high volume from day one, the "inside the existing
  service" recommendation should be revisited.
- The frequency-cap requirement (one per subscriber per day) needs a shared state store
  the notification service can check cheaply. Not specified which one exists today; this
  changes the implementation detail, not the architecture recommendation.

### Alternatives Considered

- **Standalone loyalty-notification service**: rejected for now. No present-tense scaling
  or team-ownership reason to justify the operational cost of a second deployable.
- **AWS Lambda for trigger evaluation**: rejected for now. Introduces a provider-specific
  dependency and cold-start latency for a feature with no stated latency requirement,
  without a scale justification to offset that cost.

---

**Persona**: The Assembler

**Inputs considered**: same functional requirements as above (the "LoyaltyNudge" example).

### Recommended Approach

Use the existing backend-as-a-service platform's own scheduled-function feature to evaluate
thresholds and send the push, rather than adding trigger logic to a notification service,
existing or new. Threshold evaluation against subscriber progress is exactly the kind of
small, well-defined job a scheduled function handles well. Store subscriber progress and
preferences in the platform's existing database so the function can query it directly,
instead of standing up a second notification codebase for one feature.

### Key Tradeoffs

1. **Name the dependency**: the platform's scheduled-function feature, instead of a
   custom job runner.
2. **Switching cost today**: low. The trigger logic itself is small; porting it to a
   different scheduler later is a small rewrite, not a migration.
3. **What buying saves**: the operational cost of running and monitoring a background job
   system for one small feature, netted against the cost of one more thing to watch: this
   still needs to be wired into the same unified observability view as everything else,
   not left to the platform's own dashboard alone.
4. **Revisit trigger**: if notification volume grows enough that the platform's
   scheduled-function pricing or frequency limits become a genuine constraint.

### Risks / Open Questions

- `[SCALE_TARGET]`: same gap as above; expected notification volume isn't specified.
- The frequency-cap requirement needs a place to store "last sent" state; the platform's
  own database handles this natively if it's already the system of record.

### Alternatives Considered

- **Custom job runner inside an owned notification service**: rejected for now. Adds
  infrastructure to operate for logic this small.
- **A standalone microservice**: rejected. Unnecessary for this scope.

## Debate Format (opt-in, two or more personas)

### Header

- **Personas**: which two (or more) are debating.
- **Grounding**: a short summary of the product-manager intake answers this debate is
  built on (budget sensitivity, operational appetite, failure visibility, risk tolerance,
  timeline pressure). Later sections should each trace back to these, not restate generic
  persona philosophy.

### Sections, in order

**Opening Positions** — each persona states its recommendation in 2-3 sentences,
specifically informed by the grounding answers, not a generic restatement of its usual
leanings.

**Challenge** — each persona raises exactly one specific challenge to the other's opening
position, naming the exact point being challenged. Not a vague disagreement; it has to be
answerable.

**Response** — each persona responds directly to the challenge raised against it. A
response that doesn't address the specific challenge, and instead restates the opening
position, doesn't count.

**Take This Approach If...** — one closing decision rule per persona, grounded in the
intake answers: the specific situation where this persona's recommendation is the right
call. Written so the reader can match their own situation against it without re-reading
the whole debate.

### Conventions

- One round of Challenge and Response. Not open-ended; the goal is a sharper decision, not
  a transcript.
- The Challenge must engage a specific claim from the Opening Position, quoting or
  paraphrasing it precisely enough that the Response can address that exact claim.
- Never let one persona's voice drift into the other's reasoning style. Direct and
  opportunity-cost-minded stays direct and opportunity-cost-minded; named-risk-driver-
  mitigation stays named-risk-driver-mitigation.

## Worked Example: Debate

**Personas**: The Pragmatic Modulith Architect, The Assembler

**Grounding** (product-manager intake for the LoyaltyNudge feature): Budget is tight for
the next two quarters, expected to loosen once the loyalty program proves engagement lift.
The team is two backend engineers who'd rather not add new infrastructure to operate.
Today, failure visibility comes from a single Slack channel wired to the main app's error
tracker; nothing else is wired in. The team is more worried about a silent bug quietly
under-notifying subscribers than about vendor lock-in on something this small. The feature
should land within the current quarter, but isn't blocking a launch.

### Opening Positions

**The Pragmatic Modulith Architect**: Build the trigger logic as a module inside the
existing notification service, since that's already something the team owns and watches
through their one Slack-wired error tracker. Adding a new platform dependency for a
two-engineer team that wants less to operate, not more, cuts against the stated appetite.

**The Assembler**: Use the platform's scheduled-function feature instead. The team already
runs on this platform for other things, so this isn't a new dependency, it's using one
they've already accepted. For a budget-constrained team with two quarters of runway, the
engineering time saved matters more than owning one more small module.

### Challenge

**The Assembler, to the Pragmatic Modulith Architect**: You're treating this as "the team
already owns and watches" the notification service, but the intake says failure visibility
today is one Slack channel wired to the main app's error tracker specifically, not
necessarily the notification service. If the notification service isn't already in that
loop, building inside it doesn't automatically inherit visibility either.

**The Pragmatic Modulith Architect, to The Assembler**: You're calling the scheduled
function "not a new dependency" because the platform's already in use, but the intake
names silent under-notification as the team's specific fear, not vendor lock-in. A
scheduled function that fails silently on a platform the team didn't build introduces
exactly that risk, and being an existing dependency doesn't make its failure modes
existing knowledge.

### Response

**The Pragmatic Modulith Architect**: Fair. The recommendation should say explicitly that
the notification service needs to be wired into the same Slack-based error tracker before
this ships, not assumed to already be there. That's a one-line addition to Risks/Open
Questions, not a change to the core recommendation.

**The Assembler**: Also fair, and it's the same fix on my side: the scheduled function's
failures need to be wired into that one Slack channel too, not left to the platform's own
dashboard. That's consistent with treating observability as something to buy and wire in
deliberately, not something a vendor's existing use covers for free.

### Take This Approach If...

**The Pragmatic Modulith Architect's approach fits if**: the team expects to keep adding
notification-adjacent features over the next year and wants them all in one place they
already operate, and is willing to spend a small amount of engineering time now to keep
that consolidated.

**The Assembler's approach fits if**: this is a one-off feature without a clear roadmap of
similar features coming, and the two-engineer team's time is better spent on the loyalty
program's core mechanics than on a notification module, provided the failure-visibility
gap both sides identified gets closed before launch either way.
