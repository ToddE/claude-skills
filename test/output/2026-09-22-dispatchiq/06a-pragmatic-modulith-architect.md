# Architect Review: DispatchIQ

**Persona**: The Pragmatic Modulith Architect

**Inputs considered**: PR/FAQ (`01-prfaq.md`), two use cases (`03a-auto-route-a-new-job.md`, `03b-notify-customer-of-technician-eta.md`), six functional requirements (`05a`, `05b`).

## Recommended Approach

Build DispatchIQ as a single Go modulith: the dispatcher dashboard and technician mobile view are server-rendered from the same app, no separate frontend service, right for a two-person team. Deploy on fly.io now, pre-revenue with a tight budget, with a clear path to EC2/Fargate behind an ALB once the pilot converts to paying accounts. Auto-routing (drive-time and job-load calculation) lives as its own internal module with a clean boundary, so it could be pulled out later if it needs to, but starts inside the modulith since there's no present-tense reason to split it. SMS sending goes through one narrow interface so the underlying provider stays swappable without touching the rest of the app.

The PR/FAQ names SMS failure going unnoticed as the single biggest risk, and today the team has no failure visibility at all, nothing until a customer emails support the next morning. This recommendation puts monitoring at the center instead of an afterthought: a hosted error tracker wired in from day one, with an explicit alert rule for SMS send failures specifically, not just generic errors, delivered to Slack. Since it's one deployable, this is a small, contained piece of setup, not a project.

## Key Tradeoffs

- **Risk**: building routing logic in-house means the two-person team owns correctness of the drive-time and job-load algorithm, a genuine engineering investment for a pre-revenue company.
- **Driver**: routing is close to DispatchIQ's actual differentiator against Housecall Pro, Jobber, and ServiceTitan per the PR/FAQ's positioning, not a place to hand judgment to a generic vendor.
- **Mitigation**: keep the algorithm as simple as the use case actually specifies for the pilot, nearest-available with a job-load tiebreak, not something more elaborate than what's needed yet.
- **Accepted**: yes. This is the product's differentiator, not a place to defer.

## Risks / Open Questions

- `[JOB_LOAD_LIMIT]` and `[RETRY_DELAY]`: both use cases flag these as unspecified, and both directly affect the routing and notification-retry logic this recommendation assumes exists.
- The PR/FAQ's own Internal FAQ names the team's current failure visibility as nonexistent until a customer emails support. The Sentry-plus-Slack addition here closes that named gap directly, not a hypothetical one.

## Alternatives Considered

- **Kubernetes or a microservices split for routing vs. notification**: rejected. No present-tense scaling or team-ownership reason for either; the team is two people.
- **A custom monitoring dashboard**: rejected. A hosted error tracker is the right buy-not-build call even inside an otherwise owned stack, since building monitoring tooling isn't DispatchIQ's differentiator.
