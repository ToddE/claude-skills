# Architect Review: PlotShare

**Persona**: The Assembler

**Inputs considered**: same as `06a-pragmatic-modulith-architect.md`.

## Recommended Approach

Build the member-facing app on a managed platform (Next.js on Vercel, or a comparable PaaS) with a backend-as-a-service (Supabase) handling the database, auth, and the scheduled function that checks for expired listings. Use the platform's built-in email sending (or a service like Resend) for the food bank notification rather than writing custom notification code. For the printed schedule, use the platform's server-rendered page output directly as a print view; no separate PDF pipeline. This gets a working pilot live with close to no backend code for the department to maintain long-term, which matters more than infrastructure ownership for a program this small and this budget-constrained.

## Key Tradeoffs

1. **Name the dependency**: a managed backend-as-a-service platform and its scheduled-function feature for expiration checks.
2. **Switching cost today**: low to moderate. Core logic (claim, list, expire) is simple enough to port to another backend if needed; the main cost is bounded to re-implementing auth and the scheduled job.
3. **What buying saves right now**: the department doesn't have to build or operate a scheduler, an auth system, or an email-sending pipeline for a pilot with one garden.
4. **Revisit trigger**: if the rollout expands well beyond the pilot and the platform's cost or limits (scheduled function frequency, email sending limits) start constraining the food bank notification reliability, revisit then.

## Risks / Open Questions

- `[CLAIM_WINDOW]`: same gap as above; it also determines how frequently the scheduled function needs to run, which affects the managed platform's pricing tier.
- `[PLATFORM_COST_AT_SCALE]`: the input artifacts don't say how many gardens the eventual rollout covers; the "runs on close to nothing" requirement should be re-checked against the specific platform's pricing once that's known.

## Alternatives Considered

- **Custom Go backend on owned infrastructure**: rejected for now. More control, but more for a city department to operate and maintain past the pilot, for a program without dedicated engineering headcount.
- **Generic no-code app builder for the whole thing**: rejected. The claim-race and expiration-to-food-bank logic are specific enough business rules that a general no-code tool would fight the requirements more than it would save time.
