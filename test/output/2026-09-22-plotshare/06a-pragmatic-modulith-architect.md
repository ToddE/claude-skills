# Architect Review: PlotShare

**Persona**: The Pragmatic Modulith Architect

**Inputs considered**: PR/FAQ (`01-prfaq.md`), one use case (`03b-claim-surplus-listing.md`, one of three now on file; this review predates the split into `03a`/`03b`/`03c` and only covers `03b`), four functional requirements (`05-requirements.md`).

## Recommended Approach

Build PlotShare as a single server-rendered Go application: HTMX and Tailwind for the member-facing schedule and surplus board, no separate frontend service. Deploy on fly.io; a city department's near-zero budget and low per-garden traffic don't justify anything heavier, and fly.io gets a working deployment live fastest. Generate the printed schedule as a server-rendered PDF or plain HTML print view from the same data the app already has. Food bank notification is a webhook or an email send from the same Go service when a listing's claim window expires, since there's exactly one downstream system to notify.

## Key Tradeoffs

- **Risk**: running the food bank notification logic inside the main app instead of a separate job queue puts the whole app's reliability at risk if expiration handling has a bug.
- **Driver**: avoiding the operational cost of a second deployable and a job queue for a feature this small, given the stated near-zero budget.
- **Mitigation**: put expiration-checking behind its own internal module boundary with its own tests, so it can be pulled into a scheduled job later without touching the rest of the app.
- **Accepted**: yes. Right-sized for a single-city pilot; revisit if the rollout to additional gardens meaningfully increases notification volume or failure surface.

## Risks / Open Questions

- `[CLAIM_WINDOW]`: the use case itself doesn't specify how long a listing stays open, which changes how expiration-checking gets triggered (a cron-style sweep vs. an on-access check). Needs an answer before this ships.
- The printed-schedule fallback needs an answer for how often it's regenerated and who's responsible for printing it at each garden; the PR/FAQ names the need but not the operational owner.

## Alternatives Considered

- **Separate PDF-generation service**: rejected. Adds an operational dependency for a feature (one printed sheet per garden) with no scale justification.
- **Third-party notification platform for the food bank alert**: rejected for now. A single email or webhook the department already controls is simpler and doesn't add a vendor dependency for one notification type.
